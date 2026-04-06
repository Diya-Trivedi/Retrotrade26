package Retrotrade.controller;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import Retrotrade.entity.CategoryEntity;
import Retrotrade.entity.ListingEntity;
import Retrotrade.entity.OfferEntity;
import Retrotrade.entity.SubCategoryEntity;
import Retrotrade.entity.UserEntity;
import Retrotrade.repository.CategoryRepository;
import Retrotrade.repository.ListingRepository;
import Retrotrade.repository.OfferRepository;
import Retrotrade.repository.SubCategoryRepository;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/listings")
public class ListingController {
    
    @Autowired
    private ListingRepository listingRepository;
    
    @Autowired
    private CategoryRepository categoryRepository;
    
    @Autowired
    private SubCategoryRepository subCategoryRepository;
    
    @Autowired
    private OfferRepository offerRepository;
    
    // ==================== PUBLIC LISTINGS PAGE ====================
    
    @GetMapping
    public String getAllListings(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "12") int size,
            @RequestParam(required = false) Integer categoryId,
            @RequestParam(required = false) Integer subCategoryId,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) BigDecimal minPrice,
            @RequestParam(required = false) BigDecimal maxPrice,
            @RequestParam(defaultValue = "newest") String sort,
            Model model) {
        
        Pageable pageable = createPageable(page, size, sort);
        Page<ListingEntity> listingsPage;
        
        // Apply filters based on parameters
        if (subCategoryId != null) {
            listingsPage = listingRepository.findBySubCategorySubCategoryIdAndStatus(
                subCategoryId, "ACTIVE", pageable);
        } else if (categoryId != null) {
            listingsPage = listingRepository.findByCategoryCategoryIdAndStatus(
                categoryId, "ACTIVE", pageable);
        } else if (search != null && !search.isEmpty()) {
            // For search, we need custom implementation
            List<ListingEntity> listings = listingRepository.searchListings(search);
            
            // Apply price filter if specified
            if (minPrice != null) {
                listings = listings.stream()
                        .filter(l -> l.getPrice().compareTo(minPrice) >= 0)
                        .toList();
            }
            if (maxPrice != null) {
                listings = listings.stream()
                        .filter(l -> l.getPrice().compareTo(maxPrice) <= 0)
                        .toList();
            }
            
            // Manual pagination for search results
            int start = Math.min(page * size, listings.size());
            int end = Math.min(start + size, listings.size());
            List<ListingEntity> paginatedList = listings.subList(start, end);
            
            listingsPage = new PageImpl<>(paginatedList, pageable, listings.size());
        } else {
            listingsPage = listingRepository.findByStatus("ACTIVE", pageable);
        }
        
        // Get categories for filter sidebar
        List<CategoryEntity> categories = categoryRepository.findByActiveTrue();
        
        model.addAttribute("listings", listingsPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", listingsPage.getTotalPages());
        model.addAttribute("totalItems", listingsPage.getTotalElements());
        model.addAttribute("categories", categories);
        model.addAttribute("selectedCategory", categoryId);
        model.addAttribute("selectedSubCategory", subCategoryId);
        model.addAttribute("searchKeyword", search);
        model.addAttribute("minPrice", minPrice);
        model.addAttribute("maxPrice", maxPrice);
        model.addAttribute("sort", sort);
        
        return "listings/list";
    }
    
    // ==================== VIEW SINGLE LISTING ====================

    @GetMapping("/{id}")
    public String viewListing(@PathVariable Integer id, 
                              HttpSession session,
                              Model model, 
                              RedirectAttributes redirectAttributes) {
        
        Optional<ListingEntity> listingOpt = listingRepository.findListingWithImages(id);
        if (listingOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Listing not found!");
            return "redirect:/listings";
        }
        
        ListingEntity listing = listingOpt.get();
        
        // Increment view count
        listing.setViewCount(listing.getViewCount() + 1);
        listingRepository.save(listing);
        
        // Get related listings (same category, exclude current listing)
        List<ListingEntity> relatedListings = new ArrayList<>();
        try {
            relatedListings = listingRepository
                    .findTop4ByCategoryCategoryIdAndStatusAndListingIdNotOrderByCreatedAtDesc(
                        listing.getCategory().getCategoryId(), "ACTIVE", id);
        } catch (Exception e) {
            // Fallback to old method if the new one fails
            relatedListings = listingRepository
                    .findTop4ByCategoryCategoryIdAndStatusOrderByCreatedAtDesc(
                        listing.getCategory().getCategoryId(), "ACTIVE");
        }
        
        model.addAttribute("listing", listing);
        model.addAttribute("relatedListings", relatedListings);
        
        return "listings/view";
    }
    
    // ==================== MY LISTINGS (SELLER) ====================
    
    @GetMapping("/my-listings")
    public String getMyListings(HttpSession session,
                                Model model,
                                RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to view your listings!");
            return "redirect:/login";
        }
        
        List<ListingEntity> listings = listingRepository.findBySeller(currentUser);
        model.addAttribute("listings", listings);
        
        return "listings/my-listings";
    }
    
    // ==================== EDIT LISTING ====================
    
    @GetMapping("/edit/{id}")
    public String editListing(@PathVariable Integer id,
                              HttpSession session,
                              Model model,
                              RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to edit listings!");
            return "redirect:/login";
        }
        
        Optional<ListingEntity> listingOpt = listingRepository.findById(id);
        if (listingOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Listing not found!");
            return "redirect:/listings/my-listings";
        }
        
        ListingEntity listing = listingOpt.get();
        
        // Check if user is the seller
        if (!listing.getSeller().getUserId().equals(currentUser.getUserId())) {
            redirectAttributes.addFlashAttribute("error", "You don't have permission to edit this listing!");
            return "redirect:/listings/my-listings";
        }
        
        // Check if listing can be edited (only pending or active)
        if (!"PENDING".equals(listing.getStatus()) && !"ACTIVE".equals(listing.getStatus())) {
            redirectAttributes.addFlashAttribute("error", "This listing cannot be edited in its current state!");
            return "redirect:/listings/my-listings";
        }
        
        // Get categories and subcategories for dropdown
        List<CategoryEntity> categories = categoryRepository.findByActiveTrue();
        model.addAttribute("categories", categories);
        model.addAttribute("subcategories", subCategoryRepository.findByActiveTrue());
        model.addAttribute("listing", listing);
        
        return "listings/edit";
    }
    
    // ==================== UPDATE LISTING ====================
    
    @PostMapping("/update/{id}")
    public String updateListing(@PathVariable Integer id,
                                @RequestParam("listingName") String listingName,
                                @RequestParam("description") String description,
                                @RequestParam(value = "brand", required = false) String brand,
                                @RequestParam("price") BigDecimal price,
                                @RequestParam("categoryId") Integer categoryId,
                                @RequestParam("subCategoryId") Integer subCategoryId,
                                @RequestParam("condition") String condition,
                                @RequestParam("location") String location,
                                @RequestParam(value = "negotiable", required = false) Boolean negotiable,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {

        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please login!");
            return "redirect:/login";
        }

        Optional<ListingEntity> listingOpt = listingRepository.findById(id);
        if (listingOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Listing not found!");
            return "redirect:/listings/my-listings";
        }

        ListingEntity listing = listingOpt.get();
        if (!listing.getSeller().getUserId().equals(currentUser.getUserId())) {
            redirectAttributes.addFlashAttribute("error", "You can only edit your own listings!");
            return "redirect:/listings/my-listings";
        }

        // Only allow editing if status is PENDING or ACTIVE
        if (!"PENDING".equals(listing.getStatus()) && !"ACTIVE".equals(listing.getStatus())) {
            redirectAttributes.addFlashAttribute("error", "This listing cannot be edited in its current state.");
            return "redirect:/listings/my-listings";
        }

        // Update fields
        listing.setListingName(listingName);
        listing.setDescription(description);
        listing.setBrand(brand);
        listing.setPrice(price);
        listing.setCondition(ListingEntity.Condition.valueOf(condition));
        listing.setLocation(location);
        listing.setNegotiable(negotiable != null && negotiable);

        // Update category and subcategory
        CategoryEntity category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new RuntimeException("Category not found"));
        SubCategoryEntity subCategory = subCategoryRepository.findById(subCategoryId)
                .orElseThrow(() -> new RuntimeException("Subcategory not found"));
        listing.setCategory(category);
        listing.setSubCategory(subCategory);

        listingRepository.save(listing);

        redirectAttributes.addFlashAttribute("success", "Listing updated successfully!");
        return "redirect:/listings/my-listings";
    }
    
    // ==================== DELETE LISTING ====================
    
    @GetMapping("/delete/{id}")
    public String deleteListing(@PathVariable Integer id,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to delete listings!");
            return "redirect:/login";
        }
        
        Optional<ListingEntity> listingOpt = listingRepository.findById(id);
        if (listingOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Listing not found!");
            return "redirect:/listings/my-listings";
        }
        
        ListingEntity listing = listingOpt.get();
        
        // Check if user is the seller or admin
        if (!listing.getSeller().getUserId().equals(currentUser.getUserId()) && !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "You don't have permission to delete this listing!");
            return "redirect:/listings/my-listings";
        }
        
        listingRepository.deleteById(id);
        redirectAttributes.addFlashAttribute("success", "Listing deleted successfully!");
        
        if ("ADMIN".equals(currentUser.getRole())) {
            return "redirect:/admin/listings";
        }
        return "redirect:/listings/my-listings";
    }
    
    // ==================== SELLER DASHBOARD ====================
    
    @GetMapping("/seller/dashboard")
    public String sellerDashboard(HttpSession session,
                                  Model model,
                                  RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to view your dashboard!");
            return "redirect:/login";
        }
        
        List<ListingEntity> activeListings = listingRepository.findBySellerAndStatus(currentUser, "ACTIVE");
        List<ListingEntity> soldListings = listingRepository.findBySellerAndStatus(currentUser, "SOLD");
        List<ListingEntity> pendingListings = listingRepository.findBySellerAndStatus(currentUser, "PENDING");
        
        // Get recent offers received - FIXED: Use the correct method
        List<OfferEntity> recentOffers = offerRepository.findRecentOffersForSeller(
                currentUser.getUserId(), PageRequest.of(0, 5, Sort.by("createdAt").descending()));
        
        model.addAttribute("activeListings", activeListings);
        model.addAttribute("soldListings", soldListings);
        model.addAttribute("pendingListings", pendingListings);
        model.addAttribute("activeCount", activeListings.size());
        model.addAttribute("soldCount", soldListings.size());
        model.addAttribute("pendingCount", pendingListings.size());
        model.addAttribute("recentOffers", recentOffers);
        
        return "listings/seller-dashboard";
    }
    
    // Helper method to create Pageable based on sort parameter
    private Pageable createPageable(int page, int size, String sort) {
        Sort sortBy;
        switch (sort) {
            case "price_low":
                sortBy = Sort.by("price").ascending();
                break;
            case "price_high":
                sortBy = Sort.by("price").descending();
                break;
            case "oldest":
                sortBy = Sort.by("createdAt").ascending();
                break;
            default: // newest
                sortBy = Sort.by("createdAt").descending();
                break;
        }
        
        return PageRequest.of(page, size, sortBy);
    }
}
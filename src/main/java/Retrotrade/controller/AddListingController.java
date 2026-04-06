package Retrotrade.controller;

import Retrotrade.entity.CategoryEntity;
import Retrotrade.entity.ListingEntity;
import Retrotrade.entity.ListingImageEntity;
import Retrotrade.entity.SubCategoryEntity;
import Retrotrade.entity.UserEntity;
import Retrotrade.repository.CategoryRepository;
import Retrotrade.repository.ListingRepository;
import Retrotrade.repository.SubCategoryRepository;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/listings")
public class AddListingController {
    
    @Autowired
    private CategoryRepository categoryRepository;
    
    @Autowired
    private SubCategoryRepository subCategoryRepository;
    
    @Autowired
    private ListingRepository listingRepository;
    
    @Autowired
    private Cloudinary cloudinary;
    
    @GetMapping("/add")
    public String showAddListingForm(Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        // Check if user is logged in
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to add a listing!");
            return "redirect:/login";
        }
        
        // Get all active categories for dropdown
        List<CategoryEntity> categories = categoryRepository.findByActiveTrue();
        model.addAttribute("categories", categories);
        
        // Get all active subcategories for dropdown
        List<SubCategoryEntity> subcategories = subCategoryRepository.findByActiveTrue();
        model.addAttribute("subcategories", subcategories);
        
        return "listings/add";
    }
    
    @PostMapping("/add")
    public String addListing(
            @RequestParam("listingName") String listingName,
            @RequestParam("description") String description,
            @RequestParam(value = "brand", required = false) String brand,
            @RequestParam("price") BigDecimal price,
            @RequestParam("categoryId") Integer categoryId,
            @RequestParam("subCategoryId") Integer subCategoryId,
            @RequestParam("condition") String condition,
            @RequestParam("location") String location,
            @RequestParam(value = "negotiable", required = false) Boolean negotiable,
            @RequestParam("images") List<MultipartFile> images,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        // Check if user is logged in
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to add a listing!");
            return "redirect:/login";
        }
        
        try {
            // Validate required fields
            if (listingName == null || listingName.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Product name is required!");
                return "redirect:/listings/add";
            }
            
            if (price == null || price.compareTo(BigDecimal.ZERO) <= 0) {
                redirectAttributes.addFlashAttribute("error", "Please enter a valid price!");
                return "redirect:/listings/add";
            }
            
            if (categoryId == null) {
                redirectAttributes.addFlashAttribute("error", "Please select a category!");
                return "redirect:/listings/add";
            }
            
            if (subCategoryId == null) {
                redirectAttributes.addFlashAttribute("error", "Please select a subcategory!");
                return "redirect:/listings/add";
            }
            
            if (images == null || images.isEmpty() || images.get(0).isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Please upload at least one image!");
                return "redirect:/listings/add";
            }
            
            // Create new listing
            ListingEntity listing = new ListingEntity();
            listing.setListingName(listingName);
            listing.setDescription(description);
            listing.setBrand(brand);
            listing.setPrice(price);
            listing.setLocation(location);
            listing.setNegotiable(negotiable != null ? negotiable : false);
            listing.setSeller(currentUser);
            listing.setStatus("PENDING");
            
            // Set condition
            listing.setCondition(ListingEntity.Condition.valueOf(condition));
            
            // Set category
            CategoryEntity category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new RuntimeException("Category not found"));
            listing.setCategory(category);
            
            // Set subcategory
            SubCategoryEntity subCategory = subCategoryRepository.findById(subCategoryId)
                .orElseThrow(() -> new RuntimeException("Subcategory not found"));
            listing.setSubCategory(subCategory);
            
            // Save listing first to get ID
            ListingEntity savedListing = listingRepository.save(listing);
            
            // Upload images to Cloudinary
            boolean isFirstImage = true;
            int imageCount = 0;
            
            for (MultipartFile image : images) {
                if (!image.isEmpty() && imageCount < 5) {
                    try {
                        // Upload to Cloudinary
                        Map uploadResult = cloudinary.uploader().upload(image.getBytes(),
                            ObjectUtils.asMap(
                                "folder", "retrotrade/listings",
                                "public_id", "listing_" + savedListing.getListingId() + "_" + System.currentTimeMillis(),
                                "resource_type", "auto"
                            ));
                        
                        String imageUrl = uploadResult.get("url").toString();
                        
                        // Create image entity
                        ListingImageEntity imageEntity = new ListingImageEntity();
                        imageEntity.setImageUrl(imageUrl);
                        imageEntity.setIsPrimary(isFirstImage);
                        imageEntity.setListing(savedListing);
                        
                        savedListing.addImage(imageEntity);
                        isFirstImage = false;
                        imageCount++;
                        
                    } catch (IOException e) {
                        e.printStackTrace();
                        // Continue with other images even if one fails
                    }
                }
            }
            
            // Save listing with images
            listingRepository.save(savedListing);
            
            redirectAttributes.addFlashAttribute("success", "Listing added successfully! It's pending admin approval.");
            return "redirect:/listings/my-listings";
            
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Error adding listing: " + e.getMessage());
            return "redirect:/listings/add";
        }
    }
}
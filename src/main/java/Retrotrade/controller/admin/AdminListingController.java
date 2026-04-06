package Retrotrade.controller.admin;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

// import com.cloudinary.Cloudinary; // Comment out if not configured

import Retrotrade.entity.CategoryEntity;
import Retrotrade.entity.ListingEntity;
import Retrotrade.entity.UserEntity;
import Retrotrade.repository.CategoryRepository;
import Retrotrade.repository.ListingRepository;
import Retrotrade.repository.UserRepository;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin/listings")
public class AdminListingController {
    
    @Autowired
    private ListingRepository listingRepository;
    
    @Autowired
    private CategoryRepository categoryRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    // @Autowired // Comment out if not configured
    // private Cloudinary cloudinary;
    
    // ==================== LIST ALL LISTINGS ====================
    
    @GetMapping
    public String listListings(@RequestParam(required = false) String status,
                               @RequestParam(required = false) Integer categoryId,
                               Model model,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        List<ListingEntity> listings;
        if (status != null && !status.isEmpty()) {
            listings = listingRepository.findByStatus(status);
        } else if (categoryId != null) {
            listings = listingRepository.findByCategoryCategoryId(categoryId);
        } else {
            listings = listingRepository.findAll();
        }
        
        // Statistics
        long activeCount = listingRepository.countByStatus("ACTIVE");
        long soldCount = listingRepository.countByStatus("SOLD");
        long rejectedCount = listingRepository.countByStatus("REJECTED");
        long pendingCount = listingRepository.countByStatus("PENDING");
        
        List<CategoryEntity> categories = categoryRepository.findAll();
        
        model.addAttribute("listings", listings);
        model.addAttribute("activeCount", activeCount);
        model.addAttribute("soldCount", soldCount);
        model.addAttribute("rejectedCount", rejectedCount);
        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("categories", categories);
        model.addAttribute("selectedStatus", status);
        model.addAttribute("selectedCategory", categoryId);
        
        return "admin/listing/list";
    }
    
    // ==================== VIEW LISTING ====================
    
    @GetMapping("/view/{id}")
    public String viewListing(@PathVariable Integer id,
                              Model model,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        Optional<ListingEntity> listing = listingRepository.findListingWithImages(id);
        if (listing.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Listing not found!");
            return "redirect:/admin/listings";
        }
        
        model.addAttribute("listing", listing.get());
        return "admin/listing/view";
    }
    
    // ==================== APPROVE/REJECT LISTING ====================
    
    @GetMapping("/approve/{id}")
    public String approveListing(@PathVariable Integer id,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        Optional<ListingEntity> listing = listingRepository.findById(id);
        if (listing.isPresent()) {
            ListingEntity l = listing.get();
            l.setStatus("ACTIVE");
            listingRepository.save(l);
            redirectAttributes.addFlashAttribute("success", "Listing approved successfully!");
        }
        
        return "redirect:/admin/listings/view/" + id;
    }
    
    @GetMapping("/reject/{id}")
    public String rejectListing(@PathVariable Integer id,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        Optional<ListingEntity> listing = listingRepository.findById(id);
        if (listing.isPresent()) {
            ListingEntity l = listing.get();
            l.setStatus("REJECTED");
            listingRepository.save(l);
            redirectAttributes.addFlashAttribute("success", "Listing rejected!");
        }
        
        return "redirect:/admin/listings/view/" + id;
    }
    
    @GetMapping("/mark-sold/{id}")
    public String markAsSold(@PathVariable Integer id,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        Optional<ListingEntity> listing = listingRepository.findById(id);
        if (listing.isPresent()) {
            ListingEntity l = listing.get();
            l.setStatus("SOLD");
            listingRepository.save(l);
            redirectAttributes.addFlashAttribute("success", "Listing marked as sold!");
        }
        
        return "redirect:/admin/listings/view/" + id;
    }
    
    // ==================== DELETE LISTING ====================
    
    @GetMapping("/delete/{id}")
    public String deleteListing(@PathVariable Integer id,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        Optional<ListingEntity> listing = listingRepository.findById(id);
        if (listing.isPresent()) {
            listingRepository.deleteById(id);
            redirectAttributes.addFlashAttribute("success", "Listing deleted successfully!");
        }
        
        return "redirect:/admin/listings";
    }
}
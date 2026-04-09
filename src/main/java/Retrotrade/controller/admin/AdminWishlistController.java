package Retrotrade.controller.admin;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import Retrotrade.entity.SavedListingEntity;
import Retrotrade.entity.UserEntity;
import Retrotrade.repository.SavedListingRepository;
import Retrotrade.repository.UserRepository;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin/wishlist")
public class AdminWishlistController {

    @Autowired
    private SavedListingRepository savedListingRepository;

    @Autowired
    private UserRepository userRepository;

    // ==================== LIST ALL WISHLIST ITEMS ====================
    @GetMapping
    public String listAllWishlists(@RequestParam(defaultValue = "0") int page,
                                    @RequestParam(defaultValue = "10") int size,
                                    @RequestParam(required = false) Integer userId,
                                    @RequestParam(required = false) String search,
                                    HttpSession session,
                                    Model model,
                                    RedirectAttributes redirectAttributes) {

        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }

        Pageable pageable = PageRequest.of(page, size, Sort.by("addedAt").descending());
        Page<SavedListingEntity> wishlistPage;

        if (userId != null && userId > 0) {
            wishlistPage = savedListingRepository.findByUserUserId(userId, pageable);
        } else if (search != null && !search.isEmpty()) {
            wishlistPage = savedListingRepository.findByListingListingNameContainingIgnoreCase(search, pageable);
        } else {
            wishlistPage = savedListingRepository.findAll(pageable);
        }

        // Statistics
        long totalWishlistItems = savedListingRepository.count();
        long totalUsersWithWishlist = savedListingRepository.countDistinctUsers();
        long mostSavedListingId = savedListingRepository.findMostSavedListingId();
        
        // Get top 5 users with most wishlist items
        List<Object[]> topUsers = savedListingRepository.findTopUsersByWishlistCount(PageRequest.of(0, 5));
        
        // Get top 5 most saved listings
        List<Object[]> topListings = savedListingRepository.findTopListingsBySaveCount(PageRequest.of(0, 5));

        model.addAttribute("wishlistItems", wishlistPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", wishlistPage.getTotalPages());
        model.addAttribute("totalItems", wishlistPage.getTotalElements());
        
        model.addAttribute("totalWishlistItems", totalWishlistItems);
        model.addAttribute("totalUsersWithWishlist", totalUsersWithWishlist);
        model.addAttribute("mostSavedListingId", mostSavedListingId);
        model.addAttribute("topUsers", topUsers);
        model.addAttribute("topListings", topListings);
        
        model.addAttribute("selectedUserId", userId);
        model.addAttribute("searchKeyword", search);

        return "admin/wishlist/list";
    }

    // ==================== VIEW USER WISHLIST ====================
    @GetMapping("/user/{userId}")
    public String viewUserWishlist(@PathVariable Integer userId,
                                    @RequestParam(defaultValue = "0") int page,
                                    @RequestParam(defaultValue = "10") int size,
                                    HttpSession session,
                                    Model model,
                                    RedirectAttributes redirectAttributes) {

        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }

        Optional<UserEntity> userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "User not found!");
            return "redirect:/admin/wishlist";
        }

        Pageable pageable = PageRequest.of(page, size, Sort.by("addedAt").descending());
        Page<SavedListingEntity> wishlistPage = savedListingRepository.findByUserUserId(userId, pageable);

        model.addAttribute("user", userOpt.get());
        model.addAttribute("wishlistItems", wishlistPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", wishlistPage.getTotalPages());
        model.addAttribute("totalItems", wishlistPage.getTotalElements());

        return "admin/wishlist/user-wishlist";
    }

    // ==================== REMOVE ITEM FROM WISHLIST ====================
    @GetMapping("/remove/{wishlistId}")
    public String removeWishlistItem(@PathVariable Integer wishlistId,
                                      HttpSession session,
                                      RedirectAttributes redirectAttributes) {

        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }

        Optional<SavedListingEntity> wishlistOpt = savedListingRepository.findById(wishlistId);
        if (wishlistOpt.isPresent()) {
            SavedListingEntity item = wishlistOpt.get();
            Integer userId = item.getUser().getUserId();
            savedListingRepository.deleteById(wishlistId);
            redirectAttributes.addFlashAttribute("success", "Item removed from user's wishlist successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Wishlist item not found!");
        }

        return "redirect:/admin/wishlist";
    }

    // ==================== REMOVE ALL ITEMS FROM USER WISHLIST ====================
    @GetMapping("/clear-user/{userId}")
    public String clearUserWishlist(@PathVariable Integer userId,
                                     HttpSession session,
                                     RedirectAttributes redirectAttributes) {

        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }

        Optional<UserEntity> userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "User not found!");
            return "redirect:/admin/wishlist";
        }

        savedListingRepository.deleteByUserUserId(userId);
        redirectAttributes.addFlashAttribute("success", "All wishlist items removed for user: " + userOpt.get().getFirstName() + " " + userOpt.get().getLastName());

        return "redirect:/admin/wishlist";
    }
}
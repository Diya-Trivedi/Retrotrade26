package Retrotrade.controller;

import Retrotrade.entity.*;
import Retrotrade.repository.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/wishlist")
public class WishlistController {

    @Autowired
    private SavedListingRepository savedListingRepository;
    @Autowired
    private ListingRepository listingRepository;

    // Add to wishlist
    @PostMapping("/add")
    public String addToWishlist(@RequestParam Integer listingId,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to add to wishlist.");
            return "redirect:/login";
        }

        Optional<ListingEntity> listingOpt = listingRepository.findById(listingId);
        if (listingOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Listing not found.");
            return "redirect:/listings";
        }
        ListingEntity listing = listingOpt.get();

        if (savedListingRepository.existsByUserUserIdAndListingListingId(currentUser.getUserId(), listingId)) {
            redirectAttributes.addFlashAttribute("info", "Item already in your wishlist.");
        } else {
            SavedListingEntity saved = new SavedListingEntity(currentUser, listing);
            savedListingRepository.save(saved);
            redirectAttributes.addFlashAttribute("success", "Added to wishlist.");
        }
        return "redirect:/listings/" + listingId;
    }

    // View wishlist
    @GetMapping
    public String viewWishlist(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }

        List<SavedListingEntity> wishlist = savedListingRepository.findByUserUserId(currentUser.getUserId());
        model.addAttribute("wishlist", wishlist);
        return "wishlist/list";
    }

    // Remove from wishlist
    @GetMapping("/remove/{listingId}")
    public String removeFromWishlist(@PathVariable Integer listingId,
                                     HttpSession session,
                                     RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }

        savedListingRepository.deleteByUserUserIdAndListingListingId(currentUser.getUserId(), listingId);
        redirectAttributes.addFlashAttribute("success", "Removed from wishlist.");
        return "redirect:/wishlist";
    }
}
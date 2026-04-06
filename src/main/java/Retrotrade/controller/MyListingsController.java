package Retrotrade.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import Retrotrade.entity.ListingEntity;
import Retrotrade.entity.UserEntity;
import Retrotrade.repository.ListingRepository;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/my-listings")
public class MyListingsController {
    
    @Autowired
    private ListingRepository listingRepository;
    
    @GetMapping
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
}
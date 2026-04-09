package Retrotrade.controller.admin;

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

import Retrotrade.entity.ReviewEntity;
import Retrotrade.entity.UserEntity;
import Retrotrade.repository.ReviewRepository;
import Retrotrade.repository.UserRepository;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin/reviews")
public class AdminReviewController {

    @Autowired
    private ReviewRepository reviewRepository;

    @Autowired
    private UserRepository userRepository;

    // ==================== LIST ALL REVIEWS ====================
    @GetMapping
    public String listReviews(@RequestParam(defaultValue = "0") int page,
                              @RequestParam(defaultValue = "10") int size,
                              @RequestParam(required = false) Integer rating,
                              @RequestParam(required = false) Integer sellerId,  // Changed from Long to Integer
                              HttpSession session,
                              Model model,
                              RedirectAttributes redirectAttributes) {

        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }

        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        Page<ReviewEntity> reviewsPage;

        if (rating != null && rating > 0) {
            reviewsPage = reviewRepository.findByRating(rating, pageable);
        } else if (sellerId != null) {
            reviewsPage = reviewRepository.findBySellerUserId(sellerId, pageable);  // Now works with Integer
        } else {
            reviewsPage = reviewRepository.findAll(pageable);
        }

        // Statistics
        long totalReviews = reviewRepository.count();
        long rating5Count = reviewRepository.countByRating(5);
        long rating4Count = reviewRepository.countByRating(4);
        long rating3Count = reviewRepository.countByRating(3);
        long rating2Count = reviewRepository.countByRating(2);
        long rating1Count = reviewRepository.countByRating(1);
        
        double averageRating = reviewRepository.getAverageRating();

        model.addAttribute("reviews", reviewsPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", reviewsPage.getTotalPages());
        model.addAttribute("totalItems", reviewsPage.getTotalElements());
        
        model.addAttribute("totalReviews", totalReviews);
        model.addAttribute("rating5Count", rating5Count);
        model.addAttribute("rating4Count", rating4Count);
        model.addAttribute("rating3Count", rating3Count);
        model.addAttribute("rating2Count", rating2Count);
        model.addAttribute("rating1Count", rating1Count);
        model.addAttribute("averageRating", averageRating);
        
        model.addAttribute("selectedRating", rating);
        model.addAttribute("selectedSellerId", sellerId);

        return "admin/review/list";
    }

    // ==================== VIEW REVIEW DETAILS ====================
    @GetMapping("/view/{reviewId}")
    public String viewReview(@PathVariable Integer reviewId,
                             HttpSession session,
                             Model model,
                             RedirectAttributes redirectAttributes) {

        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }

        Optional<ReviewEntity> reviewOpt = reviewRepository.findById(reviewId);
        if (reviewOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Review not found!");
            return "redirect:/admin/reviews";
        }

        model.addAttribute("review", reviewOpt.get());
        return "admin/review/view";
    }

    // ==================== DELETE REVIEW ====================
    @GetMapping("/delete/{reviewId}")
    public String deleteReview(@PathVariable Integer reviewId,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {

        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }

        if (reviewRepository.existsById(reviewId)) {
            reviewRepository.deleteById(reviewId);
            redirectAttributes.addFlashAttribute("success", "Review deleted successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Review not found!");
        }

        return "redirect:/admin/reviews";
    }
}
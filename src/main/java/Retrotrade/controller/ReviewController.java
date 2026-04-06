package Retrotrade.controller;

import Retrotrade.entity.*;
import Retrotrade.repository.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/reviews")
public class ReviewController {

    @Autowired
    private ReviewRepository reviewRepository;
    @Autowired
    private TransactionRepository transactionRepository;
    @Autowired
    private UserRepository userRepository;

    // Show form to submit review for a seller (after transaction)
    @GetMapping("/submit/{sellerId}")
    public String showReviewForm(@PathVariable Integer sellerId,
                                 HttpSession session,
                                 Model model,
                                 RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }

        // Check if the user has completed a transaction with this seller
        boolean hasTransaction = transactionRepository.existsByBuyerUserIdAndSellerUserIdAndTransactionStatus(
                currentUser.getUserId(), sellerId, TransactionEntity.TransactionStatus.COMPLETED);
        if (!hasTransaction) {
            redirectAttributes.addFlashAttribute("error", "You can only review sellers you have purchased from.");
            return "redirect:/profile";
        }

        // Check if already reviewed
        boolean alreadyReviewed = reviewRepository.existsByBuyerUserIdAndSellerUserId(currentUser.getUserId(), sellerId);
        if (alreadyReviewed) {
            redirectAttributes.addFlashAttribute("error", "You have already reviewed this seller.");
            return "redirect:/profile";
        }

        Optional<UserEntity> sellerOpt = userRepository.findById(sellerId);
        if (sellerOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Seller not found.");
            return "redirect:/profile";
        }

        model.addAttribute("seller", sellerOpt.get());
        return "reviews/submit";
    }

    @PostMapping("/save")
    public String saveReview(@RequestParam Integer sellerId,
                             @RequestParam Integer rating,
                             @RequestParam String comment,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }

        Optional<UserEntity> sellerOpt = userRepository.findById(sellerId);
        if (sellerOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Seller not found.");
            return "redirect:/profile";
        }

        ReviewEntity review = new ReviewEntity(sellerOpt.get(), currentUser, rating, comment);
        reviewRepository.save(review);
        redirectAttributes.addFlashAttribute("success", "Thank you for your review!");
        return "redirect:/transactions/my-purchases";  // Changed from /profile
    }

    // View reviews for a seller (public)
    @GetMapping("/seller/{sellerId}")
    public String viewSellerReviews(@PathVariable Integer sellerId,
                                    @RequestParam(defaultValue = "0") int page,
                                    Model model,
                                    RedirectAttributes redirectAttributes) {
        Optional<UserEntity> sellerOpt = userRepository.findById(sellerId);
        if (sellerOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Seller not found.");
            return "redirect:/";
        }

        Page<ReviewEntity> reviews = reviewRepository.findBySellerUserId(sellerId, PageRequest.of(page, 10));
        double averageRating = reviewRepository.getAverageRatingBySeller(sellerId);
        long totalReviews = reviewRepository.countBySellerUserId(sellerId);

        model.addAttribute("seller", sellerOpt.get());
        model.addAttribute("reviews", reviews);
        model.addAttribute("averageRating", averageRating);
        model.addAttribute("totalReviews", totalReviews);
        return "reviews/seller-reviews";
    }
    @GetMapping("/my-reviews")
    public String getMyReviews(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to view your reviews.");
            return "redirect:/login";
        }
        List<ReviewEntity> reviews = reviewRepository.findByBuyer(currentUser);
        model.addAttribute("reviews", reviews);
        return "reviews/my-reviews";
    }
}
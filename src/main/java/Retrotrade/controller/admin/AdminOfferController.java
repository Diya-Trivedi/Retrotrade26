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
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import Retrotrade.entity.OfferEntity;
import Retrotrade.entity.OfferEntity.OfferStatus;
import Retrotrade.entity.UserEntity;
import Retrotrade.repository.OfferRepository;
import Retrotrade.repository.UserRepository;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin/offers")
public class AdminOfferController {
    
    @Autowired
    private OfferRepository offerRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    // ==================== LIST ALL OFFERS ====================
    
    @GetMapping
    public String listAllOffers(@RequestParam(defaultValue = "0") int page,
                               @RequestParam(defaultValue = "10") int size,
                               @RequestParam(required = false) String status,
                               @RequestParam(required = false) Integer listingId,
                               @RequestParam(required = false) Integer buyerId,
                               HttpSession session,
                               Model model,
                               RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        Page<OfferEntity> offersPage;
        
        if (status != null && !status.isEmpty()) {
            offersPage = offerRepository.findByOfferStatus(OfferStatus.valueOf(status), pageable);
        } else if (listingId != null) {
            offersPage = offerRepository.findByListingListingId(listingId, pageable);
        } else if (buyerId != null) {
            offersPage = offerRepository.findByBuyerUserId(buyerId, pageable);
        } else {
            offersPage = offerRepository.findAll(pageable);
        }
        
        // Statistics
        long pendingCount = offerRepository.countByOfferStatus(OfferStatus.PENDING);
        long acceptedCount = offerRepository.countByOfferStatus(OfferStatus.ACCEPTED);
        long rejectedCount = offerRepository.countByOfferStatus(OfferStatus.REJECTED);
        long counteredCount = offerRepository.countByOfferStatus(OfferStatus.COUNTERED);
        long expiredCount = offerRepository.countByOfferStatus(OfferStatus.EXPIRED);
        long withdrawnCount = offerRepository.countByOfferStatus(OfferStatus.WITHDRAWN);
        
        model.addAttribute("offers", offersPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", offersPage.getTotalPages());
        model.addAttribute("totalItems", offersPage.getTotalElements());
        
        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("acceptedCount", acceptedCount);
        model.addAttribute("rejectedCount", rejectedCount);
        model.addAttribute("counteredCount", counteredCount);
        model.addAttribute("expiredCount", expiredCount);
        model.addAttribute("withdrawnCount", withdrawnCount);
        
        model.addAttribute("selectedStatus", status);
        model.addAttribute("selectedListingId", listingId);
        model.addAttribute("selectedBuyerId", buyerId);
        
        return "admin/offer/list";
    }
    
    // ==================== VIEW OFFER DETAILS ====================
    
    @GetMapping("/view/{offerId}")
    public String viewOffer(@PathVariable Integer offerId,
                           HttpSession session,
                           Model model,
                           RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        Optional<OfferEntity> offerOpt = offerRepository.findById(offerId);
        if (offerOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Offer not found!");
            return "redirect:/admin/offers";
        }
        
        model.addAttribute("offer", offerOpt.get());
        return "admin/offer/view";
    }
    
    // ==================== UPDATE OFFER STATUS (ADMIN) ====================
    
    @PostMapping("/update-status/{offerId}")
    public String updateOfferStatus(@PathVariable Integer offerId,
                                   @RequestParam OfferStatus status,
                                   @RequestParam(required = false) String adminNote,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        Optional<OfferEntity> offerOpt = offerRepository.findById(offerId);
        if (offerOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Offer not found!");
            return "redirect:/admin/offers";
        }
        
        OfferEntity offer = offerOpt.get();
        offer.setOfferStatus(status);
        // You might want to add an adminNotes field to track admin actions
        
        offerRepository.save(offer);
        
        redirectAttributes.addFlashAttribute("success", "Offer status updated successfully!");
        return "redirect:/admin/offers/view/" + offerId;
    }
    
    // ==================== DELETE OFFER ====================
    
    @GetMapping("/delete/{offerId}")
    public String deleteOffer(@PathVariable Integer offerId,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        Optional<OfferEntity> offerOpt = offerRepository.findById(offerId);
        if (offerOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Offer not found!");
            return "redirect:/admin/offers";
        }
        
        offerRepository.deleteById(offerId);
        redirectAttributes.addFlashAttribute("success", "Offer deleted successfully!");
        return "redirect:/admin/offers";
    }
}
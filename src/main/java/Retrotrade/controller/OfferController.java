package Retrotrade.controller;

import java.math.BigDecimal;
import java.time.LocalDateTime;
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

import Retrotrade.entity.ListingEntity;
import Retrotrade.entity.OfferEntity;
import Retrotrade.entity.OfferEntity.OfferStatus;
import Retrotrade.entity.UserEntity;
import Retrotrade.repository.ListingRepository;
import Retrotrade.repository.OfferRepository;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/offers")
public class OfferController {
    
    @Autowired
    private OfferRepository offerRepository;
    
    @Autowired
    private ListingRepository listingRepository;
    
    // ==================== MAKE AN OFFER ====================
    
    @GetMapping("/make/{listingId}")
    public String showMakeOfferForm(@PathVariable Integer listingId,
                                    HttpSession session,
                                    Model model,
                                    RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to make an offer!");
            return "redirect:/login";
        }
        
        Optional<ListingEntity> listingOpt = listingRepository.findListingWithImages(listingId);
        if (listingOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Listing not found!");
            return "redirect:/listings";
        }
        
        ListingEntity listing = listingOpt.get();
        
        // Check if user is trying to make offer on their own listing
        if (listing.getSeller().getUserId().equals(currentUser.getUserId())) {
            redirectAttributes.addFlashAttribute("error", "You cannot make an offer on your own listing!");
            return "redirect:/listings/" + listingId;
        }
        
        // Check if listing is still active
        if (!"ACTIVE".equals(listing.getStatus())) {
            redirectAttributes.addFlashAttribute("error", "This listing is no longer active!");
            return "redirect:/listings/" + listingId;
        }
        
        model.addAttribute("listing", listing);
        model.addAttribute("offer", new OfferEntity());
        
        return "offers/make";
    }
    
    @PostMapping("/make")
    public String makeOffer(@RequestParam Integer listingId,
                           @RequestParam BigDecimal offeredPrice,
                           @RequestParam(required = false) String message,
                           HttpSession session,
                           RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to make an offer!");
            return "redirect:/login";
        }
        
        Optional<ListingEntity> listingOpt = listingRepository.findById(listingId);
        if (listingOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Listing not found!");
            return "redirect:/listings";
        }
        
        ListingEntity listing = listingOpt.get();
        
        // Check if user already has a pending offer on this listing
        if (offerRepository.existsByListingListingIdAndBuyerUserIdAndOfferStatus(
                listingId, currentUser.getUserId(), OfferStatus.PENDING)) {
            redirectAttributes.addFlashAttribute("error", "You already have a pending offer on this listing!");
            return "redirect:/listings/" + listingId;
        }
        
        // Validate offer price
        if (offeredPrice.compareTo(BigDecimal.ZERO) <= 0) {
            redirectAttributes.addFlashAttribute("error", "Please enter a valid offer price!");
            return "redirect:/offers/make/" + listingId;
        }
        
        // Optional: Validate minimum price (e.g., can't be lower than 10% of listing price)
        BigDecimal minPrice = listing.getPrice().multiply(new BigDecimal("0.1"));
        if (offeredPrice.compareTo(minPrice) < 0) {
            redirectAttributes.addFlashAttribute("error", "Offer price cannot be less than 10% of listing price!");
            return "redirect:/offers/make/" + listingId;
        }
        
        // Validate offer price not exceeding listing price
        if (offeredPrice.compareTo(listing.getPrice()) > 0) {
            redirectAttributes.addFlashAttribute("error", "Offer price cannot exceed the listing price!");
            return "redirect:/offers/make/" + listingId;
        }
        
        OfferEntity offer = new OfferEntity();
        offer.setListing(listing);
        offer.setBuyer(currentUser);
        offer.setOfferedPrice(offeredPrice);
        offer.setMessage(message);
        offer.setOfferStatus(OfferStatus.PENDING);
        offer.setExpiryDate(LocalDateTime.now().plusDays(7));
        
        offerRepository.save(offer);
        
        redirectAttributes.addFlashAttribute("success", "Your offer has been submitted successfully! The seller will respond within 7 days.");
        return "redirect:/offers/my-offers";
    }
    
    // ==================== VIEW MY OFFERS (AS BUYER) ====================
    
    @GetMapping("/my-offers")
    public String getMyOffers(@RequestParam(defaultValue = "0") int page,
                             @RequestParam(defaultValue = "10") int size,
                             @RequestParam(required = false) String status,
                             HttpSession session,
                             Model model,
                             RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to view your offers!");
            return "redirect:/login";
        }
        
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        Page<OfferEntity> offersPage;
        
        if (status != null && !status.isEmpty()) {
            try {
                OfferStatus offerStatus = OfferStatus.valueOf(status);
                offersPage = offerRepository.findByBuyerUserIdAndOfferStatus(
                    currentUser.getUserId(), offerStatus, pageable);
            } catch (IllegalArgumentException e) {
                offersPage = offerRepository.findByBuyerUserId(currentUser.getUserId(), pageable);
            }
        } else {
            offersPage = offerRepository.findByBuyerUserId(currentUser.getUserId(), pageable);
        }
        
        // Count offers by status
        long pendingCount = offerRepository.countByBuyerUserIdAndOfferStatus(
            currentUser.getUserId(), OfferStatus.PENDING);
        long acceptedCount = offerRepository.countByBuyerUserIdAndOfferStatus(
            currentUser.getUserId(), OfferStatus.ACCEPTED);
        long rejectedCount = offerRepository.countByBuyerUserIdAndOfferStatus(
            currentUser.getUserId(), OfferStatus.REJECTED);
        
        model.addAttribute("offers", offersPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", offersPage.getTotalPages());
        model.addAttribute("totalItems", offersPage.getTotalElements());
        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("acceptedCount", acceptedCount);
        model.addAttribute("rejectedCount", rejectedCount);
        model.addAttribute("selectedStatus", status);
        
        return "offers/my-offers";
    }
    
    // ==================== VIEW OFFERS RECEIVED (AS SELLER) ====================
    
    @GetMapping("/received")
    public String getReceivedOffers(@RequestParam(defaultValue = "0") int page,
                                   @RequestParam(defaultValue = "10") int size,
                                   @RequestParam(required = false) String status,
                                   HttpSession session,
                                   Model model,
                                   RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to view received offers!");
            return "redirect:/login";
        }
        
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        
        // Get all offers for this seller
        List<OfferEntity> allOffers = offerRepository.findBySellerId(currentUser.getUserId());
        
        // Filter by status if specified
        if (status != null && !status.isEmpty()) {
            try {
                OfferStatus offerStatus = OfferStatus.valueOf(status);
                allOffers = allOffers.stream()
                        .filter(o -> o.getOfferStatus() == offerStatus)
                        .toList();
            } catch (IllegalArgumentException e) {
                // Ignore invalid status
            }
        }
        
        // Manual pagination
        int start = Math.min(page * size, allOffers.size());
        int end = Math.min(start + size, allOffers.size());
        List<OfferEntity> paginatedOffers = allOffers.isEmpty() ? List.of() : allOffers.subList(start, end);
        
        // Create page object
        Page<OfferEntity> offersPage = new org.springframework.data.domain.PageImpl<>(
            paginatedOffers, pageable, allOffers.size());
        
        model.addAttribute("offers", offersPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", offersPage.getTotalPages());
        model.addAttribute("totalItems", offersPage.getTotalElements());
        model.addAttribute("selectedStatus", status);
        
        return "offers/received";
    }
    
    // ==================== VIEW OFFER DETAILS ====================
    
    @GetMapping("/view/{offerId}")
    public String viewOffer(@PathVariable Integer offerId,
                           HttpSession session,
                           Model model,
                           RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to view offer details!");
            return "redirect:/login";
        }
        
        Optional<OfferEntity> offerOpt = offerRepository.findById(offerId);
        if (offerOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Offer not found!");
            return "redirect:/offers/my-offers";
        }
        
        OfferEntity offer = offerOpt.get();
        
        // Check if user is authorized to view this offer (buyer or seller)
        boolean isBuyer = offer.getBuyer().getUserId().equals(currentUser.getUserId());
        boolean isSeller = offer.getListing().getSeller().getUserId().equals(currentUser.getUserId());
        
        if (!isBuyer && !isSeller) {
            redirectAttributes.addFlashAttribute("error", "You don't have permission to view this offer!");
            return "redirect:/offers/my-offers";
        }
        
        model.addAttribute("offer", offer);
        model.addAttribute("isBuyer", isBuyer);
        model.addAttribute("isSeller", isSeller);
        
        return "offers/view";
    }
    
    // ==================== RESPOND TO OFFER (SELLER ONLY) ====================
    
    @PostMapping("/respond/{offerId}")
    public String respondToOffer(@PathVariable Integer offerId,
                                @RequestParam String action,
                                @RequestParam(required = false) BigDecimal counterPrice,
                                @RequestParam(required = false) String message,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to respond to offers!");
            return "redirect:/login";
        }
        
        Optional<OfferEntity> offerOpt = offerRepository.findById(offerId);
        if (offerOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Offer not found!");
            return "redirect:/offers/received";
        }
        
        OfferEntity offer = offerOpt.get();
        
        // Check if user is the seller
        if (!offer.getListing().getSeller().getUserId().equals(currentUser.getUserId())) {
            redirectAttributes.addFlashAttribute("error", "You don't have permission to respond to this offer!");
            return "redirect:/offers/received";
        }
        
        // Check if offer is still pending
        if (offer.getOfferStatus() != OfferStatus.PENDING) {
            redirectAttributes.addFlashAttribute("error", "This offer is no longer pending!");
            return "redirect:/offers/view/" + offerId;
        }
        
        // Check if offer is expired
        if (offer.isExpired()) {
            offer.setOfferStatus(OfferStatus.EXPIRED);
            offerRepository.save(offer);
            redirectAttributes.addFlashAttribute("error", "This offer has expired!");
            return "redirect:/offers/view/" + offerId;
        }
        
        switch (action) {
            case "accept":
                offer.setOfferStatus(OfferStatus.ACCEPTED);
                redirectAttributes.addFlashAttribute("success", "Offer accepted successfully! You can now proceed with the transaction.");
                break;
                
            case "reject":
                offer.setOfferStatus(OfferStatus.REJECTED);
                offer.setMessage(message);
                redirectAttributes.addFlashAttribute("success", "Offer rejected successfully!");
                break;
                
            case "counter":
                if (counterPrice == null || counterPrice.compareTo(BigDecimal.ZERO) <= 0) {
                    redirectAttributes.addFlashAttribute("error", "Please enter a valid counter price!");
                    return "redirect:/offers/view/" + offerId;
                }
                if (counterPrice.compareTo(offer.getListing().getPrice()) > 0) {
                    redirectAttributes.addFlashAttribute("error", "Counter price cannot exceed the listing price!");
                    return "redirect:/offers/view/" + offerId;
                }
                offer.setOfferStatus(OfferStatus.COUNTERED);
                offer.setCounterPrice(counterPrice);
                offer.setMessage(message);
                redirectAttributes.addFlashAttribute("success", "Counter offer sent successfully!");
                break;
                
            default:
                redirectAttributes.addFlashAttribute("error", "Invalid action!");
                return "redirect:/offers/view/" + offerId;
        }
        
        offerRepository.save(offer);
        
        return "redirect:/offers/view/" + offerId;
    }
    
    // ==================== WITHDRAW OFFER (BUYER ONLY) ====================
    
    @PostMapping("/withdraw/{offerId}")
    public String withdrawOffer(@PathVariable Integer offerId,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to withdraw offers!");
            return "redirect:/login";
        }
        
        Optional<OfferEntity> offerOpt = offerRepository.findById(offerId);
        if (offerOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Offer not found!");
            return "redirect:/offers/my-offers";
        }
        
        OfferEntity offer = offerOpt.get();
        
        // Check if user is the buyer
        if (!offer.getBuyer().getUserId().equals(currentUser.getUserId())) {
            redirectAttributes.addFlashAttribute("error", "You don't have permission to withdraw this offer!");
            return "redirect:/offers/my-offers";
        }
        
        // Check if offer can be withdrawn (only pending offers)
        if (offer.getOfferStatus() != OfferStatus.PENDING) {
            redirectAttributes.addFlashAttribute("error", "Only pending offers can be withdrawn!");
            return "redirect:/offers/view/" + offerId;
        }
        
        offer.setOfferStatus(OfferStatus.WITHDRAWN);
        offerRepository.save(offer);
        
        redirectAttributes.addFlashAttribute("success", "Offer withdrawn successfully!");
        return "redirect:/offers/my-offers";
    }
}
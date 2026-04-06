package Retrotrade.controller;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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

import Retrotrade.entity.AddressEntity;
import Retrotrade.entity.ListingEntity;
import Retrotrade.entity.OfferEntity;
import Retrotrade.entity.TransactionEntity;
import Retrotrade.entity.TransactionEntity.PaymentMode;
import Retrotrade.entity.TransactionEntity.TransactionStatus;
import Retrotrade.entity.UserEntity;
import Retrotrade.repository.ListingRepository;
import Retrotrade.repository.OfferRepository;
import Retrotrade.repository.ReviewRepository;
import Retrotrade.repository.TransactionRepository;
import Retrotrade.repository.UserRepository;
import Retrotrade.service.PaymentService;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/transactions")
public class TransactionController {

    @Autowired
    private TransactionRepository transactionRepository;

    @Autowired
    private ListingRepository listingRepository;

    @Autowired
    private OfferRepository offerRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ReviewRepository reviewRepository;

    @Autowired
    private Retrotrade.repository.AddressRepository addressRepository;

    @Autowired
    private PaymentService paymentService;   // <-- Integrated payment service

    // ==================== INITIATE PURCHASE ====================

    @GetMapping("/buy/{listingId}")
    public String showBuyPage(@PathVariable Integer listingId,
                              @RequestParam(required = false) Integer offerId,
                              HttpSession session,
                              Model model,
                              RedirectAttributes redirectAttributes) {

        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to make a purchase!");
            return "redirect:/login";
        }

        Optional<ListingEntity> listingOpt = listingRepository.findListingWithImages(listingId);
        if (listingOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Listing not found!");
            return "redirect:/listings";
        }

        ListingEntity listing = listingOpt.get();

        // Check if user is trying to buy their own listing
        if (listing.getSeller().getUserId().equals(currentUser.getUserId())) {
            redirectAttributes.addFlashAttribute("error", "You cannot purchase your own listing!");
            return "redirect:/listings/" + listingId;
        }

        // Check if listing is still active
        if (!"ACTIVE".equals(listing.getStatus())) {
            redirectAttributes.addFlashAttribute("error", "This listing is no longer available!");
            return "redirect:/listings/" + listingId;
        }

        BigDecimal price = listing.getPrice();
        String paymentMethod = "CARD";

        // Check if buying through an accepted offer
        if (offerId != null) {
            Optional<OfferEntity> offerOpt = offerRepository.findById(offerId);
            if (offerOpt.isPresent() && offerOpt.get().getListing().getListingId().equals(listingId)) {
                OfferEntity offer = offerOpt.get();
                if (offer.getOfferStatus() == OfferEntity.OfferStatus.ACCEPTED) {
                    price = offer.getOfferedPrice();
                    paymentMethod = "CARD";
                    model.addAttribute("acceptedOffer", offer);
                }
            }
        }

        // Get user's default address
        Optional<AddressEntity> defaultAddress = addressRepository.findByUserIdAndIsDefaultTrue(currentUser.getUserId());

        model.addAttribute("listing", listing);
        model.addAttribute("price", price);
        model.addAttribute("paymentMethod", paymentMethod);
        model.addAttribute("defaultAddress", defaultAddress.orElse(null));
        model.addAttribute("paymentModes", PaymentMode.values());

        return "transactions/buy";
    }

    // ==================== PROCESS PAYMENT & CREATE TRANSACTION ====================

    @PostMapping("/process")
    public String processTransaction(@RequestParam Integer listingId,
                                     @RequestParam(required = false) Integer offerId,
                                     @RequestParam BigDecimal finalPrice,
                                     @RequestParam PaymentMode paymentMode,
                                     @RequestParam(required = false) String shippingAddress,
                                     @RequestParam(required = false) String cardNumber,
                                     @RequestParam(required = false) String cardName,
                                     @RequestParam(required = false) String cardExpiry,
                                     @RequestParam(required = false) String cardCvv,
                                     HttpSession session,
                                     RedirectAttributes redirectAttributes) {

        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to make a purchase!");
            return "redirect:/login";
        }

        Optional<ListingEntity> listingOpt = listingRepository.findById(listingId);
        if (listingOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Listing not found!");
            return "redirect:/listings";
        }
        ListingEntity listing = listingOpt.get();

        // Validate listing availability
        if (!"ACTIVE".equals(listing.getStatus())) {
            redirectAttributes.addFlashAttribute("error", "This listing is no longer available!");
            return "redirect:/listings/" + listingId;
        }

        // ----- INTEGRATED PAYMENT PROCESSING -----
        String paymentGatewayId;

        if (paymentMode == PaymentMode.CARD) {
            // Validate card details
            if (cardNumber == null || cardNumber.trim().isEmpty() ||
                cardExpiry == null || cardExpiry.trim().isEmpty() ||
                cardCvv == null || cardCvv.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Please fill in all card details.");
                return "redirect:/transactions/buy/" + listingId + (offerId != null ? "?offerId=" + offerId : "");
            }

            // Format expiry date for Authorize.net (YYYY-MM)
            String expiryFormatted = formatExpiryDate(cardExpiry);

            // Call payment gateway
            PaymentService.PaymentResult paymentResult = paymentService.processCreditCardPayment(
                    currentUser.getEmail(),
                    cardNumber,
                    expiryFormatted,
                    cardCvv,
                    finalPrice
            );

            if (!paymentResult.isSuccess()) {
                redirectAttributes.addFlashAttribute("error", "Payment failed: " + paymentResult.getErrorMessage());
                return "redirect:/transactions/buy/" + listingId + (offerId != null ? "?offerId=" + offerId : "");
            }

            paymentGatewayId = paymentResult.getTransactionId();
        } else {
            // For non-card payments (UPI, NetBanking, Wallet, Cash) we generate a mock ID
            // (In a real application, integrate with respective gateways)
            paymentGatewayId = "MOCK" + System.currentTimeMillis();
        }

        // Create transaction
        TransactionEntity transaction = new TransactionEntity(
                listing, currentUser, listing.getSeller(), finalPrice, paymentMode
        );
        transaction.setPaymentId(paymentGatewayId);
        transaction.setShippingAddress(shippingAddress);
        transaction.setTransactionStatus(TransactionStatus.COMPLETED);
        transaction.setEstimatedDelivery(LocalDateTime.now().plusDays(7));

        // If using an accepted offer, mark it as used
        if (offerId != null) {
            Optional<OfferEntity> offerOpt = offerRepository.findById(offerId);
            if (offerOpt.isPresent()) {
                OfferEntity offer = offerOpt.get();
                offer.setOfferStatus(OfferEntity.OfferStatus.ACCEPTED);
                offerRepository.save(offer);
            }
        }

        // Mark listing as sold
        listing.setStatus("SOLD");
        listingRepository.save(listing);

        // Save transaction
        transactionRepository.save(transaction);

        redirectAttributes.addFlashAttribute("success", "Purchase completed successfully! Your order has been placed.");
        return "redirect:/transactions/confirmation/" + transaction.getTransactionId();
    }

    // ==================== TRANSACTION CONFIRMATION ====================

    @GetMapping("/confirmation/{transactionId}")
    public String showConfirmation(@PathVariable Integer transactionId,
                                   HttpSession session,
                                   Model model,
                                   RedirectAttributes redirectAttributes) {

        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }

        Optional<TransactionEntity> transactionOpt = transactionRepository.findById(transactionId);
        if (transactionOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Transaction not found!");
            return "redirect:/transactions/my-purchases";
        }

        TransactionEntity transaction = transactionOpt.get();

        // Verify user is either buyer or seller
        if (!transaction.getBuyer().getUserId().equals(currentUser.getUserId()) &&
            !transaction.getSeller().getUserId().equals(currentUser.getUserId())) {
            redirectAttributes.addFlashAttribute("error", "You don't have permission to view this transaction!");
            return "redirect:/transactions/my-purchases";
        }

        model.addAttribute("transaction", transaction);

        return "transactions/confirmation";
    }

    // ==================== MY PURCHASES (AS BUYER) ====================

    @GetMapping("/my-purchases")
    public String getMyPurchases(@RequestParam(defaultValue = "0") int page,
                                 @RequestParam(defaultValue = "10") int size,
                                 @RequestParam(required = false) String status,
                                 HttpSession session,
                                 Model model,
                                 RedirectAttributes redirectAttributes) {

        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to view your purchases!");
            return "redirect:/login";
        }

        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        Page<TransactionEntity> transactionsPage;

        if (status != null && !status.isEmpty()) {
            transactionsPage = transactionRepository.findByBuyerUserIdAndTransactionStatus(
                currentUser.getUserId(), TransactionStatus.valueOf(status), pageable);
        } else {
            transactionsPage = transactionRepository.findByBuyerUserId(currentUser.getUserId(), pageable);
        }

        // Map to track if a review already exists for each transaction
        Map<Integer, Boolean> reviewExistsMap = new HashMap<>();
        for (TransactionEntity txn : transactionsPage.getContent()) {
            boolean reviewed = reviewRepository.existsByBuyerUserIdAndSellerUserId(
                txn.getBuyer().getUserId(), txn.getSeller().getUserId());
            reviewExistsMap.put(txn.getTransactionId(), reviewed);
        }

        // Calculate total spent
        BigDecimal totalSpent = BigDecimal.ZERO;
        List<TransactionEntity> allBuyerTransactions = transactionRepository.findByBuyerUserId(currentUser.getUserId());
        for (TransactionEntity t : allBuyerTransactions) {
            if (t.getTransactionStatus() == TransactionStatus.COMPLETED ||
                t.getTransactionStatus() == TransactionStatus.DELIVERED) {
                totalSpent = totalSpent.add(t.getFinalPrice());
            }
        }

        model.addAttribute("transactions", transactionsPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", transactionsPage.getTotalPages());
        model.addAttribute("totalItems", transactionsPage.getTotalElements());
        model.addAttribute("totalSpent", totalSpent);
        model.addAttribute("selectedStatus", status);
        model.addAttribute("reviewExistsMap", reviewExistsMap);

        return "transactions/my-purchases";
    }

    // ==================== MY SALES (AS SELLER) ====================

    @GetMapping("/my-sales")
    public String getMySales(@RequestParam(defaultValue = "0") int page,
                             @RequestParam(defaultValue = "10") int size,
                             @RequestParam(required = false) String status,
                             HttpSession session,
                             Model model,
                             RedirectAttributes redirectAttributes) {

        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to view your sales!");
            return "redirect:/login";
        }

        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        Page<TransactionEntity> transactionsPage;

        if (status != null && !status.isEmpty()) {
            transactionsPage = transactionRepository.findBySellerUserIdAndTransactionStatus(
                currentUser.getUserId(), TransactionStatus.valueOf(status), pageable);
        } else {
            transactionsPage = transactionRepository.findBySellerUserId(currentUser.getUserId(), pageable);
        }

        // Calculate total earnings
        BigDecimal totalEarnings = transactionRepository.getTotalRevenueBySeller(currentUser.getUserId());

        model.addAttribute("transactions", transactionsPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", transactionsPage.getTotalPages());
        model.addAttribute("totalItems", transactionsPage.getTotalElements());
        model.addAttribute("totalEarnings", totalEarnings != null ? totalEarnings : BigDecimal.ZERO);
        model.addAttribute("selectedStatus", status);

        return "transactions/my-sales";
    }

    // ==================== VIEW TRANSACTION DETAILS ====================

    @GetMapping("/view/{transactionId}")
    public String viewTransaction(@PathVariable Integer transactionId,
                                  HttpSession session,
                                  Model model,
                                  RedirectAttributes redirectAttributes) {

        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }

        Optional<TransactionEntity> transactionOpt = transactionRepository.findById(transactionId);
        if (transactionOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Transaction not found!");
            return "redirect:/transactions/my-purchases";
        }

        TransactionEntity transaction = transactionOpt.get();

        // Check permission
        boolean isBuyer = transaction.getBuyer().getUserId().equals(currentUser.getUserId());
        boolean isSeller = transaction.getSeller().getUserId().equals(currentUser.getUserId());

        if (!isBuyer && !isSeller) {
            redirectAttributes.addFlashAttribute("error", "You don't have permission to view this transaction!");
            return "redirect:/transactions/my-purchases";
        }

        // Check if review already exists (for buyer)
        boolean alreadyReviewed = false;
        if (isBuyer) {
            alreadyReviewed = reviewRepository.existsByBuyerUserIdAndSellerUserId(
                currentUser.getUserId(), transaction.getSeller().getUserId());
        }

        model.addAttribute("transaction", transaction);
        model.addAttribute("isBuyer", isBuyer);
        model.addAttribute("isSeller", isSeller);
        model.addAttribute("alreadyReviewed", alreadyReviewed);

        return "transactions/view";
    }

    // ==================== UPDATE DELIVERY STATUS (SELLER ONLY) ====================

    @PostMapping("/update-delivery/{transactionId}")
    public String updateDeliveryStatus(@PathVariable Integer transactionId,
                                       @RequestParam String deliveryStatus,
                                       HttpSession session,
                                       RedirectAttributes redirectAttributes) {

        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }

        Optional<TransactionEntity> transactionOpt = transactionRepository.findById(transactionId);
        if (transactionOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Transaction not found!");
            return "redirect:/transactions/my-sales";
        }

        TransactionEntity transaction = transactionOpt.get();

        // Verify seller
        if (!transaction.getSeller().getUserId().equals(currentUser.getUserId())) {
            redirectAttributes.addFlashAttribute("error", "You don't have permission to update this transaction!");
            return "redirect:/transactions/my-sales";
        }

        transaction.setDeliveryStatus(deliveryStatus);
        if ("DELIVERED".equals(deliveryStatus)) {
            transaction.setTransactionStatus(TransactionStatus.DELIVERED);
            transaction.setDeliveredAt(LocalDateTime.now());
        }

        transactionRepository.save(transaction);

        redirectAttributes.addFlashAttribute("success", "Delivery status updated successfully!");
        return "redirect:/transactions/view/" + transactionId;
    }

    // ==================== HELPER: FORMAT EXPIRY DATE ====================

    /**
     * Converts expiry from "MM/YY" or "MM-YY" to "YYYY-MM" (Authorize.net format).
     */
    private String formatExpiryDate(String expiry) {
        if (expiry == null) return null;
        String cleaned = expiry.replace("/", "-");
        String[] parts = cleaned.split("-");
        if (parts.length == 2) {
            try {
                int month = Integer.parseInt(parts[0]);
                int year = Integer.parseInt(parts[1]);
                // Assume 20xx for years 00-99
                int fullYear = 2000 + year;
                return fullYear + "-" + String.format("%02d", month);
            } catch (NumberFormatException e) {
                return expiry;
            }
        }
        return expiry;
    }
}
package Retrotrade.controller.admin;

import java.math.BigDecimal;
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

import Retrotrade.entity.TransactionEntity;
import Retrotrade.entity.TransactionEntity.TransactionStatus;
import Retrotrade.entity.UserEntity;
import Retrotrade.repository.TransactionRepository;
import Retrotrade.repository.UserRepository;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin/transactions")
public class AdminTransactionController {
    
    @Autowired
    private TransactionRepository transactionRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    // ==================== LIST ALL TRANSACTIONS ====================
    
    @GetMapping
    public String listAllTransactions(@RequestParam(defaultValue = "0") int page,
                                      @RequestParam(defaultValue = "10") int size,
                                      @RequestParam(required = false) String status,
                                      @RequestParam(required = false) Integer buyerId,
                                      @RequestParam(required = false) Integer sellerId,
                                      HttpSession session,
                                      Model model,
                                      RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        Page<TransactionEntity> transactionsPage;
        
        if (status != null && !status.isEmpty()) {
            transactionsPage = transactionRepository.findByTransactionStatus(
                TransactionStatus.valueOf(status), pageable);
        } else if (buyerId != null) {
            transactionsPage = transactionRepository.findByBuyerUserId(buyerId, pageable);
        } else if (sellerId != null) {
            transactionsPage = transactionRepository.findBySellerUserId(sellerId, pageable);
        } else {
            transactionsPage = transactionRepository.findAll(pageable);
        }
        
        // Statistics
        long totalTransactions = transactionRepository.count();
        long completedCount = transactionRepository.countByTransactionStatus(TransactionStatus.COMPLETED);
        long pendingCount = transactionRepository.countByTransactionStatus(TransactionStatus.PENDING);
        long cancelledCount = transactionRepository.countByTransactionStatus(TransactionStatus.CANCELLED);
        long deliveredCount = transactionRepository.countByTransactionStatus(TransactionStatus.DELIVERED);
        long disputedCount = transactionRepository.countByTransactionStatus(TransactionStatus.DISPUTED);
        
        BigDecimal totalRevenue = transactionRepository.getTotalPlatformFees();
        Object[] stats = transactionRepository.getTransactionStatistics();
        
        model.addAttribute("transactions", transactionsPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", transactionsPage.getTotalPages());
        model.addAttribute("totalItems", transactionsPage.getTotalElements());
        
        model.addAttribute("totalTransactions", totalTransactions);
        model.addAttribute("completedCount", completedCount);
        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("cancelledCount", cancelledCount);
        model.addAttribute("deliveredCount", deliveredCount);
        model.addAttribute("disputedCount", disputedCount);
        model.addAttribute("totalRevenue", totalRevenue != null ? totalRevenue : BigDecimal.ZERO);
        model.addAttribute("stats", stats);
        
        model.addAttribute("selectedStatus", status);
        model.addAttribute("selectedBuyerId", buyerId);
        model.addAttribute("selectedSellerId", sellerId);
        
        return "admin/transaction/list";
    }
    
    // ==================== VIEW TRANSACTION DETAILS ====================
    
    @GetMapping("/view/{transactionId}")
    public String viewTransaction(@PathVariable Integer transactionId,
                                  HttpSession session,
                                  Model model,
                                  RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        Optional<TransactionEntity> transactionOpt = transactionRepository.findById(transactionId);
        if (transactionOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Transaction not found!");
            return "redirect:/admin/transactions";
        }
        
        model.addAttribute("transaction", transactionOpt.get());
        
        return "admin/transaction/view";
    }
    
    // ==================== UPDATE TRANSACTION STATUS ====================
    
    @PostMapping("/update-status/{transactionId}")
    public String updateTransactionStatus(@PathVariable Integer transactionId,
                                          @RequestParam TransactionStatus status,
                                          HttpSession session,
                                          RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        Optional<TransactionEntity> transactionOpt = transactionRepository.findById(transactionId);
        if (transactionOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Transaction not found!");
            return "redirect:/admin/transactions";
        }
        
        TransactionEntity transaction = transactionOpt.get();
        transaction.setTransactionStatus(status);
        
        if (status == TransactionStatus.COMPLETED || status == TransactionStatus.DELIVERED) {
            // Update listing status if needed
        }
        
        transactionRepository.save(transaction);
        
        redirectAttributes.addFlashAttribute("success", "Transaction status updated successfully!");
        return "redirect:/admin/transactions/view/" + transactionId;
    }
    
    // ==================== DELETE TRANSACTION ====================
    
    @GetMapping("/delete/{transactionId}")
    public String deleteTransaction(@PathVariable Integer transactionId,
                                    HttpSession session,
                                    RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        Optional<TransactionEntity> transactionOpt = transactionRepository.findById(transactionId);
        if (transactionOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Transaction not found!");
            return "redirect:/admin/transactions";
        }
        
        transactionRepository.deleteById(transactionId);
        redirectAttributes.addFlashAttribute("success", "Transaction deleted successfully!");
        return "redirect:/admin/transactions";
    }
    
    // ==================== REVENUE REPORT ====================
    
    @GetMapping("/revenue")
    public String revenueReport(HttpSession session,
                                Model model,
                                RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        List<Object[]> monthlyRevenue = transactionRepository.getMonthlyRevenue();
        List<Object[]> pendingPayouts = transactionRepository.getPendingPayouts();
        Object[] stats = transactionRepository.getTransactionStatistics();
        
        model.addAttribute("monthlyRevenue", monthlyRevenue);
        model.addAttribute("pendingPayouts", pendingPayouts);
        model.addAttribute("stats", stats);
        
        return "admin/transaction/revenue";
    }
}
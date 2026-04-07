package Retrotrade.controller;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import Retrotrade.entity.CategoryEntity;
import Retrotrade.entity.ListingEntity;
import Retrotrade.entity.OfferEntity;
import Retrotrade.entity.ReportEntity;
import Retrotrade.entity.SubCategoryEntity;
import Retrotrade.entity.TransactionEntity;
import Retrotrade.entity.UserEntity;
import Retrotrade.repository.CategoryRepository;
import Retrotrade.repository.ListingRepository;
import Retrotrade.repository.OfferRepository;
import Retrotrade.repository.ReportRepository;
import Retrotrade.repository.SubCategoryRepository;
import Retrotrade.repository.TransactionRepository;
import Retrotrade.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
public class SessionController {
    
    private static final Logger logger = LoggerFactory.getLogger(SessionController.class);

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private SubCategoryRepository subCategoryRepository;

    @Autowired
    private ListingRepository listingRepository;
    
    @Autowired
    private OfferRepository offerRepository;
    
    @Autowired
    private TransactionRepository transactionRepository;
    
    @Autowired
    private ReportRepository reportRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    // ========================= ADMIN DASHBOARD =========================
    @GetMapping("/admin/dashboard")
    public String adminDashboard(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to access admin dashboard");
            return "redirect:/login";
        }
        
        if (!"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied! Admin only.");
            return "redirect:/index";
        }

        try {
            // Load admin dashboard data
            List<UserEntity> userList = userRepository.findAll();
            List<CategoryEntity> categoryList = categoryRepository.findAll();
            List<ListingEntity> listingList = listingRepository.findAll();
            List<OfferEntity> offerList = offerRepository.findAll();
            List<TransactionEntity> transactionList = transactionRepository.findAll();
            List<ReportEntity> reportList = reportRepository.findAll();
            
            // Admin statistics
            long totalUsers = userList.size();
            long totalCategories = categoryList.size();
            long totalSubcategories = subCategoryRepository.count();
            long totalListings = listingList.size();
            long totalOffers = offerList.size();
            long totalTransactions = transactionList.size();
            long totalReports = reportList.size();
            
            long activeListings = listingRepository.countByStatus("ACTIVE");
            long pendingListings = listingRepository.countByStatus("PENDING");
            long soldListings = listingRepository.countByStatus("SOLD");
            long rejectedListings = listingRepository.countByStatus("REJECTED");
            
            // Total platform revenue
            BigDecimal totalRevenue = transactionRepository.getTotalPlatformFees();
            if (totalRevenue == null) {
                totalRevenue = BigDecimal.ZERO;
            }
            
            // Recent listings (show all recent, not just pending)
            List<ListingEntity> recentListings = listingRepository.findTop10ByStatusOrderByCreatedAtDesc("ACTIVE");
            if (recentListings.size() < 5) {
                // Add pending listings if not enough active ones
                List<ListingEntity> pendingListingsForRecent = listingRepository.findTop10ByStatusOrderByCreatedAtDesc("PENDING");
                for (ListingEntity pendingListing : pendingListingsForRecent) {
                    if (recentListings.size() < 10 && !recentListings.contains(pendingListing)) {
                        recentListings.add(pendingListing);
                    }
                }
            }
            
            // Recent offers
            List<OfferEntity> recentOffers = offerRepository.findTop10ByOrderByCreatedAtDesc();
            
            // Recent transactions
            List<TransactionEntity> recentTransactions = transactionRepository.findAll(
                org.springframework.data.domain.PageRequest.of(0, 10, 
                    org.springframework.data.domain.Sort.by("createdAt").descending())
            ).getContent();
            
            // Recent reports
            List<ReportEntity> recentReports = reportRepository.findAll(
                org.springframework.data.domain.PageRequest.of(0, 10, 
                    org.springframework.data.domain.Sort.by("createdAt").descending())
            ).getContent();
            
            // Monthly revenue data for chart
            List<Object[]> monthlyRevenue = transactionRepository.getMonthlyRevenue();
            
            // Create a map of category names to their listing counts
            Map<Integer, Integer> categoryListingCounts = new HashMap<>();
            for (CategoryEntity category : categoryList) {
                int count = 0;
                for (SubCategoryEntity sub : category.getSubCategories()) {
                    count += sub.getListings().size();
                }
                categoryListingCounts.put(category.getCategoryId(), count);
            }

            model.addAttribute("userList", userList);
            model.addAttribute("categoryList", categoryList);
            model.addAttribute("listingList", listingList);
            model.addAttribute("offerList", offerList);
            model.addAttribute("transactionList", transactionList);
            model.addAttribute("reportList", reportList);
            model.addAttribute("currentUser", currentUser);
            model.addAttribute("categoryListingCounts", categoryListingCounts);
            
            // Statistics
            model.addAttribute("totalUsers", totalUsers);
            model.addAttribute("totalCategories", totalCategories);
            model.addAttribute("totalSubcategories", totalSubcategories);
            model.addAttribute("totalListings", totalListings);
            model.addAttribute("totalOffers", totalOffers);
            model.addAttribute("totalTransactions", totalTransactions);
            model.addAttribute("totalReports", totalReports);
            model.addAttribute("totalRevenue", totalRevenue);
            
            model.addAttribute("activeListings", activeListings);
            model.addAttribute("pendingListings", pendingListings);
            model.addAttribute("soldListings", soldListings);
            model.addAttribute("rejectedListings", rejectedListings);
            
            // Recent data
            model.addAttribute("recentListings", recentListings);
            model.addAttribute("recentOffers", recentOffers);
            model.addAttribute("recentTransactions", recentTransactions);
            model.addAttribute("recentReports", recentReports);
            
            // Chart data
            model.addAttribute("monthlyRevenue", monthlyRevenue);

        } catch (Exception e) {
            logger.error("Error loading admin dashboard: {}", e.getMessage(), e);
            model.addAttribute("error", "Unable to load dashboard data: " + e.getMessage());
        }

        return "admin/dashboard";
    }
    
    // ========================= HOME PAGE (FOR ALL USERS) =========================
    @GetMapping(value = {"/", "/home", "/index"})
    public String homePage(Model model, HttpSession session) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        
        try {
            // Load public data
            List<CategoryEntity> categoryList = categoryRepository.findByActiveTrue();
            List<ListingEntity> featuredListings = listingRepository.findTop10ByStatusOrderByCreatedAtDesc("ACTIVE");
            
            logger.debug("Home page loaded - Categories: {}, Listings: {}", 
                categoryList.size(), featuredListings.size());
            
            model.addAttribute("categoryList", categoryList);
            model.addAttribute("featuredListings", featuredListings);
            
            // Statistics for home page
            long totalListings = listingRepository.countByStatus("ACTIVE");
            long totalUsers = userRepository.count();
            long totalCategories = categoryRepository.count();
            long totalTransactions = transactionRepository.count();
            
            model.addAttribute("totalListings", totalListings);
            model.addAttribute("totalUsers", totalUsers);
            model.addAttribute("totalCategories", totalCategories);
            model.addAttribute("totalTransactions", totalTransactions);
            
        } catch (Exception e) {
            logger.error("Error loading home page data: {}", e.getMessage());
            model.addAttribute("categoryList", List.of());
            model.addAttribute("featuredListings", List.of());
        }
        
        model.addAttribute("currentUser", currentUser);
        
        // Redirect based on role if user is logged in
        if (currentUser != null) {
            if ("ADMIN".equals(currentUser.getRole())) {
                return "redirect:/admin/dashboard";
            }
        }
        
        return "index";
    }

    // ========================= AUTHENTICATION PAGES =========================
    @GetMapping("/signup")
    public String signupPage(HttpSession session) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser != null) {
            return "redirect:/index";
        }
        return "signup";
    }

    @GetMapping("/login")
    public String loginPage(HttpSession session) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser != null) {
            if ("ADMIN".equals(currentUser.getRole())) {
                return "redirect:/admin/dashboard";
            } else {
                return "redirect:/index";
            }
        }
        return "login";
    }

    @GetMapping("/forgotPassword")
    public String forgotPasswordPage(HttpSession session) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser != null) {
            return "redirect:/index";
        }
        return "forgotPassword";
    }

    @GetMapping("/verifyOtp")
    public String verifyOtpPage(@RequestParam String email, Model model) {
        model.addAttribute("email", email);
        return "verifyOtp";
    }

    @GetMapping("/resetPassword")
    public String resetPasswordPage(@RequestParam String email, Model model) {
        model.addAttribute("email", email);
        return "resetPassword";
    }

    // ========================= AUTHENTICATION =========================
    @PostMapping("/login")
    public String authenticate(@RequestParam("email") String email,
                               @RequestParam("password") String password,
                               Model model,
                               HttpSession session) {

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            model.addAttribute("error", "Email and password are required");
            return "login";
        }

        Optional<UserEntity> optionalUser = userRepository.findByEmail(email.trim());

        if (optionalUser.isEmpty()) {
            logger.warn("Failed login attempt for email: {}", email);
            model.addAttribute("error", "Invalid Credentials");
            return "login";
        }

        UserEntity dbUser = optionalUser.get();

        if (!dbUser.getActive()) {
            logger.warn("Inactive account login attempt: {}", email);
            model.addAttribute("error", "Your account is deactivated. Please contact support.");
            return "login";
        }

        if (!passwordEncoder.matches(password, dbUser.getPassword())) {
            logger.warn("Invalid password for email: {}", email);
            model.addAttribute("error", "Invalid Credentials");
            return "login";
        }

        // Successful login
        session.setAttribute("user", dbUser);
        session.setAttribute("userId", dbUser.getUserId());
        session.setAttribute("userRole", dbUser.getRole());
        session.setAttribute("lastLoginTime", new java.util.Date());
        
        logger.info("User logged in successfully: {}", email);

        if ("ADMIN".equals(dbUser.getRole())) {
            return "redirect:/admin/dashboard";
        } else {
            return "redirect:/index";
        }
    }

    // ========================= LOGOUT =========================
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user != null) {
            logger.info("User logged out: {}", user.getEmail());
        }
        session.invalidate();
        return "redirect:/login?logout=true";
    }
}
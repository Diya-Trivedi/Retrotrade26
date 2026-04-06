package Retrotrade.controller;

import Retrotrade.entity.*;
import Retrotrade.repository.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/reports")
public class ReportController {

    @Autowired
    private ReportRepository reportRepository;
    @Autowired
    private ListingRepository listingRepository;
    @Autowired
    private UserRepository userRepository;

    // ==================== REDIRECT FOR GENERAL /reports ====================
    @GetMapping
    public String redirectToReportListings(RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("info",
            "To report a listing, please go to the listing page and click 'Report'.");
        return "redirect:/listings";
    }

    // ==================== SHOW REPORT FORM ====================
    @GetMapping("/submit/{listingId}")
    public String showReportForm(@PathVariable Integer listingId,
                                 HttpSession session,
                                 Model model,
                                 RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to report a listing.");
            return "redirect:/login";
        }

        Optional<ListingEntity> listingOpt = listingRepository.findById(listingId);
        if (listingOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Listing not found.");
            return "redirect:/listings";
        }
        ListingEntity listing = listingOpt.get();

        model.addAttribute("listing", listing);
        model.addAttribute("reasons", ReportEntity.Reason.values());
        return "reports/submit";
    }

    // ==================== SAVE REPORT ====================
    @PostMapping("/save")
    public String saveReport(@RequestParam Integer listingId,
                             @RequestParam ReportEntity.Reason reason,
                             @RequestParam(required = false) String comment,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }

        Optional<ListingEntity> listingOpt = listingRepository.findById(listingId);
        if (listingOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Listing not found.");
            return "redirect:/listings";
        }
        ListingEntity listing = listingOpt.get();

        ReportEntity report = new ReportEntity(listing.getSeller(), listing, currentUser, reason);
        report.setComment(comment);
        reportRepository.save(report);
        redirectAttributes.addFlashAttribute("success", "Report submitted. Our team will review it.");
        return "redirect:/listings/" + listingId;
    }

    // ==================== MY REPORTS (USER'S OWN REPORTS) ====================
    @GetMapping("/my-reports")
    public String myReports(@RequestParam(defaultValue = "0") int page,
                            @RequestParam(defaultValue = "10") int size,
                            HttpSession session,
                            Model model,
                            RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please login to view your reports.");
            return "redirect:/login";
        }

        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        Page<ReportEntity> reportsPage = reportRepository.findByReportedByUserId(currentUser.getUserId(), pageable);

        // Convert LocalDateTime to formatted string for each report
        java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss");
        for (ReportEntity report : reportsPage.getContent()) {
            // You can add a transient field or use a wrapper; simplest: store formatted date in model as separate list.
            // Alternative: create a DTO. For quick fix, we'll pass both original and formatted.
        }
        
        // Better: create a list of maps or a wrapper class. 
        // But for simplicity, we'll add a separate attribute "formattedDates" map.
        Map<Integer, String> formattedDates = new HashMap<>();
        for (ReportEntity report : reportsPage.getContent()) {
            formattedDates.put(report.getReportId(), report.getCreatedAt().format(formatter));
        }
        
        model.addAttribute("reports", reportsPage.getContent());
        model.addAttribute("formattedDates", formattedDates);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", reportsPage.getTotalPages());
        model.addAttribute("totalItems", reportsPage.getTotalElements());

        return "reports/my-reports";
    }
}
package Retrotrade.controller.admin;

import Retrotrade.entity.ReportEntity;
import Retrotrade.entity.UserEntity;
import Retrotrade.repository.ReportRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Optional;

@Controller
@RequestMapping("/admin/reports")
public class AdminReportController {

    @Autowired
    private ReportRepository reportRepository;

    @GetMapping
    public String listReports(@RequestParam(defaultValue = "0") int page,
                              @RequestParam(required = false) String status,
                              HttpSession session,
                              Model model,
                              RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied.");
            return "redirect:/login";
        }

        Page<ReportEntity> reports;
        if (status != null && !status.isEmpty()) {
            reports = reportRepository.findByStatus(ReportEntity.Status.valueOf(status), PageRequest.of(page, 20));
        } else {
            reports = reportRepository.findAll(PageRequest.of(page, 20));
        }

        model.addAttribute("reports", reports);
        model.addAttribute("selectedStatus", status);
        return "admin/reports/list";
    }

    @GetMapping("/view/{id}")
    public String viewReport(@PathVariable Integer id,
                             HttpSession session,
                             Model model,
                             RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied.");
            return "redirect:/login";
        }

        Optional<ReportEntity> reportOpt = reportRepository.findById(id);
        if (reportOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Report not found.");
            return "redirect:/admin/reports";
        }

        model.addAttribute("report", reportOpt.get());
        return "admin/reports/view";
    }

    @PostMapping("/update-status/{id}")
    public String updateStatus(@PathVariable Integer id,
                               @RequestParam ReportEntity.Status status,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied.");
            return "redirect:/login";
        }

        Optional<ReportEntity> reportOpt = reportRepository.findById(id);
        if (reportOpt.isPresent()) {
            ReportEntity report = reportOpt.get();
            report.setStatus(status);
            reportRepository.save(report);
            redirectAttributes.addFlashAttribute("success", "Report status updated.");
        } else {
            redirectAttributes.addFlashAttribute("error", "Report not found.");
        }
        return "redirect:/admin/reports/view/" + id;
    }

    @GetMapping("/delete/{id}")
    public String deleteReport(@PathVariable Integer id,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied.");
            return "redirect:/login";
        }

        if (reportRepository.existsById(id)) {
            reportRepository.deleteById(id);
            redirectAttributes.addFlashAttribute("success", "Report deleted.");
        } else {
            redirectAttributes.addFlashAttribute("error", "Report not found.");
        }
        return "redirect:/admin/reports";
    }
}
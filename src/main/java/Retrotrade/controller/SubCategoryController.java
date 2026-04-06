package Retrotrade.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import Retrotrade.entity.CategoryEntity;
import Retrotrade.entity.SubCategoryEntity;
import Retrotrade.entity.UserEntity;
import Retrotrade.repository.CategoryRepository;
import Retrotrade.repository.SubCategoryRepository;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/subcategory")
public class SubCategoryController {
    
    @Autowired
    private SubCategoryRepository subCategoryRepository;
    
    @Autowired
    private CategoryRepository categoryRepository;
    
    // ========================= LIST ALL SUBCATEGORIES (PUBLIC) =========================
    
    @GetMapping("/list")
    public String listSubCategories(Model model) {
        List<SubCategoryEntity> subCategories = subCategoryRepository.findAllWithCategory();
        model.addAttribute("subCategories", subCategories);
        return "subcategory/list";
    }
    
    // ========================= LIST SUBCATEGORIES BY CATEGORY (PUBLIC) =========================
    
//    @GetMapping("/by-category/{categoryId}")
//    public String listByCategory(@PathVariable("categoryId") Integer categoryId,
//                                 Model model,
//                                 RedirectAttributes redirectAttributes) {
//        
//        Optional<CategoryEntity> categoryOpt = categoryRepository.findById(categoryId);
//        if (categoryOpt.isEmpty()) {
//            redirectAttributes.addFlashAttribute("error", "Category not found!");
//            return "redirect:/category/list";
//        }
//        
//        List<SubCategoryEntity> subCategories = subCategoryRepository.findByCategoryCategoryId(categoryId);
//        model.addAttribute("subCategories", subCategories);
//        model.addAttribute("category", categoryOpt.get());
//        return "subcategory/list-by-category";
//    }
    
    // ========================= SHOW ADD SUBCATEGORY FORM (ADMIN ONLY) =========================
    
    @GetMapping("/add")
    public String showAddForm(HttpSession session,
                              @RequestParam(required = false) Integer categoryId,
                              Model model,
                              RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied! Admin only.");
            return "redirect:/login";
        }
        
        List<CategoryEntity> categories = categoryRepository.findByActiveTrue();
        model.addAttribute("categories", categories);
        model.addAttribute("subCategory", new SubCategoryEntity());
        
        if (categoryId != null) {
            model.addAttribute("selectedCategoryId", categoryId);
        }
        
        return "subcategory/add";
    }
    
    // ========================= ADD NEW SUBCATEGORY (ADMIN ONLY) =========================
    
    @PostMapping("/save")
    public String saveSubCategory(SubCategoryEntity subCategoryEntity,
                                   @RequestParam("categoryId") Integer categoryId,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied! Admin only.");
            return "redirect:/login";
        }
        
        Optional<CategoryEntity> categoryOpt = categoryRepository.findById(categoryId);
        if (categoryOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Category not found!");
            return "redirect:/subcategory/add";
        }
        
        // Check if subcategory name already exists in this category
        if (subCategoryRepository.existsBySubCategoryNameAndCategoryCategoryId(
                subCategoryEntity.getSubCategoryName(), categoryId)) {
            redirectAttributes.addFlashAttribute("error", "Subcategory name already exists in this category!");
            return "redirect:/subcategory/add?categoryId=" + categoryId;
        }
        
        subCategoryEntity.setCategory(categoryOpt.get());
        
        // Set default active status if not set
        if (subCategoryEntity.getActive() == null) {
            subCategoryEntity.setActive(true);
        }
        
        subCategoryRepository.save(subCategoryEntity);
        redirectAttributes.addFlashAttribute("success", "Subcategory added successfully!");
        
        return "redirect:/subcategory/list";
    }
    
    // ========================= VIEW SUBCATEGORY DETAILS =========================
    
    @GetMapping("/view/{id}")
    public String viewSubCategory(@PathVariable("id") Integer subCategoryId,
                                   Model model,
                                   RedirectAttributes redirectAttributes) {
        
        Optional<SubCategoryEntity> subCategoryOpt = subCategoryRepository.findById(subCategoryId);
        if (subCategoryOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Subcategory not found!");
            return "redirect:/subcategory/list";
        }
        
        model.addAttribute("subCategory", subCategoryOpt.get());
        return "subcategory/view";
    }
    
    // ========================= SHOW EDIT SUBCATEGORY FORM (ADMIN ONLY) =========================
    
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Integer subCategoryId,
                               HttpSession session,
                               Model model,
                               RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied! Admin only.");
            return "redirect:/login";
        }
        
        Optional<SubCategoryEntity> subCategoryOpt = subCategoryRepository.findById(subCategoryId);
        if (subCategoryOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Subcategory not found!");
            return "redirect:/subcategory/list";
        }
        
        List<CategoryEntity> categories = categoryRepository.findByActiveTrue();
        model.addAttribute("categories", categories);
        model.addAttribute("subCategory", subCategoryOpt.get());
        
        return "subcategory/edit";
    }
    
    // ========================= UPDATE SUBCATEGORY (ADMIN ONLY) =========================
    
    @PostMapping("/update")
    public String updateSubCategory(SubCategoryEntity subCategoryEntity,
                                     @RequestParam("categoryId") Integer categoryId,
                                     HttpSession session,
                                     RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied! Admin only.");
            return "redirect:/login";
        }
        
        Optional<SubCategoryEntity> existingSubCategoryOpt = subCategoryRepository.findById(subCategoryEntity.getSubCategoryId());
        if (existingSubCategoryOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Subcategory not found!");
            return "redirect:/subcategory/list";
        }
        
        Optional<CategoryEntity> categoryOpt = categoryRepository.findById(categoryId);
        if (categoryOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Category not found!");
            return "redirect:/subcategory/edit/" + subCategoryEntity.getSubCategoryId();
        }
        
        SubCategoryEntity existingSubCategory = existingSubCategoryOpt.get();
        
        // Check if new name already exists in this category (and it's not the same subcategory)
        if (!existingSubCategory.getSubCategoryName().equals(subCategoryEntity.getSubCategoryName()) &&
            subCategoryRepository.existsBySubCategoryNameAndCategoryCategoryId(
                    subCategoryEntity.getSubCategoryName(), categoryId)) {
            redirectAttributes.addFlashAttribute("error", "Subcategory name already exists in this category!");
            return "redirect:/subcategory/edit/" + subCategoryEntity.getSubCategoryId();
        }
        
        // Update fields
        existingSubCategory.setSubCategoryName(subCategoryEntity.getSubCategoryName());
        existingSubCategory.setCategory(categoryOpt.get());
        existingSubCategory.setActive(subCategoryEntity.getActive());
        
        subCategoryRepository.save(existingSubCategory);
        redirectAttributes.addFlashAttribute("success", "Subcategory updated successfully!");
        
        return "redirect:/subcategory/list";
    }
    
    // ========================= DELETE SUBCATEGORY (ADMIN ONLY) =========================
    
    @GetMapping("/delete/{id}")
    public String deleteSubCategory(@PathVariable("id") Integer subCategoryId,
                                     HttpSession session,
                                     RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied! Admin only.");
            return "redirect:/login";
        }
        
        Optional<SubCategoryEntity> subCategoryOpt = subCategoryRepository.findById(subCategoryId);
        if (subCategoryOpt.isPresent()) {
            SubCategoryEntity subCategory = subCategoryOpt.get();
            
            // Check if subcategory has listings
            if (!subCategory.getListings().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Cannot delete subcategory with listings! Delete listings first.");
                return "redirect:/subcategory/list";
            }
            
            subCategoryRepository.delete(subCategory);
            redirectAttributes.addFlashAttribute("success", "Subcategory deleted successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Subcategory not found!");
        }
        
        return "redirect:/subcategory/list";
    }
    
    // ========================= TOGGLE SUBCATEGORY STATUS (ADMIN ONLY) =========================
    
    @GetMapping("/toggle-status/{id}")
    public String toggleStatus(@PathVariable("id") Integer subCategoryId,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied! Admin only.");
            return "redirect:/login";
        }
        
        Optional<SubCategoryEntity> subCategoryOpt = subCategoryRepository.findById(subCategoryId);
        if (subCategoryOpt.isPresent()) {
            SubCategoryEntity subCategory = subCategoryOpt.get();
            subCategory.setActive(!subCategory.getActive());
            subCategoryRepository.save(subCategory);
            
            String status = subCategory.getActive() ? "activated" : "deactivated";
            redirectAttributes.addFlashAttribute("success", "Subcategory " + status + " successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Subcategory not found!");
        }
        
        return "redirect:/subcategory/list";
    }
}
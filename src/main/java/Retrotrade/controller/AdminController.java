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
import Retrotrade.repository.UserRepository;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminController {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private CategoryRepository categoryRepository;
    
    @Autowired
    private SubCategoryRepository subCategoryRepository;
    
    // ==================== CATEGORY MANAGEMENT ====================
    
    @GetMapping("/category/list")
    public String listCategories(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        List<CategoryEntity> categories = categoryRepository.findAll();
        model.addAttribute("categories", categories);
        return "admin/category/list";
    }
    
    @GetMapping("/category/add")
    public String addCategoryForm(HttpSession session, RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        return "admin/category/add";
    }
    
    @PostMapping("/category/save")
    public String saveCategory(CategoryEntity category, HttpSession session, RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        if (categoryRepository.existsByCategoryName(category.getCategoryName())) {
            redirectAttributes.addFlashAttribute("error", "Category name already exists!");
            return "redirect:/admin/category/add";
        }
        
        if (category.getActive() == null) {
            category.setActive(true);
        }
        
        categoryRepository.save(category);
        redirectAttributes.addFlashAttribute("success", "Category added successfully!");
        return "redirect:/admin/category/list";
    }
    
    @GetMapping("/category/view/{id}")
    public String viewCategory(@PathVariable Integer id, HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        Optional<CategoryEntity> category = categoryRepository.findById(id);
        if (category.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Category not found!");
            return "redirect:/admin/category/list";
        }
        
        model.addAttribute("category", category.get());
        return "admin/category/view";
    }
    
    @GetMapping("/category/edit/{id}")
    public String editCategoryForm(@PathVariable Integer id, HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        Optional<CategoryEntity> category = categoryRepository.findById(id);
        if (category.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Category not found!");
            return "redirect:/admin/category/list";
        }
        
        model.addAttribute("category", category.get());
        return "admin/category/edit";
    }
    
    @PostMapping("/category/update")
    public String updateCategory(CategoryEntity category, HttpSession session, RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        Optional<CategoryEntity> existing = categoryRepository.findById(category.getCategoryId());
        if (existing.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Category not found!");
            return "redirect:/admin/category/list";
        }
        
        if (!existing.get().getCategoryName().equals(category.getCategoryName()) &&
            categoryRepository.existsByCategoryName(category.getCategoryName())) {
            redirectAttributes.addFlashAttribute("error", "Category name already exists!");
            return "redirect:/admin/category/edit/" + category.getCategoryId();
        }
        
        CategoryEntity existingCategory = existing.get();
        existingCategory.setCategoryName(category.getCategoryName());
        existingCategory.setActive(category.getActive());
        
        categoryRepository.save(existingCategory);
        redirectAttributes.addFlashAttribute("success", "Category updated successfully!");
        return "redirect:/admin/category/list";
    }
    
    @GetMapping("/category/toggle-status/{id}")
    public String toggleCategoryStatus(@PathVariable Integer id, HttpSession session, RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        Optional<CategoryEntity> category = categoryRepository.findById(id);
        if (category.isPresent()) {
            CategoryEntity c = category.get();
            c.setActive(!c.getActive());
            categoryRepository.save(c);
            redirectAttributes.addFlashAttribute("success", "Category " + (c.getActive() ? "activated" : "deactivated") + " successfully!");
        }
        return "redirect:/admin/category/list";
    }
    
    @GetMapping("/category/delete/{id}")
    public String deleteCategory(@PathVariable Integer id, HttpSession session, RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        Optional<CategoryEntity> category = categoryRepository.findById(id);
        if (category.isPresent()) {
            if (!category.get().getSubCategories().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Cannot delete category with subcategories! Delete subcategories first.");
                return "redirect:/admin/category/list";
            }
            categoryRepository.deleteById(id);
            redirectAttributes.addFlashAttribute("success", "Category deleted successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Category not found!");
        }
        return "redirect:/admin/category/list";
    }
    
    // ==================== SUBCATEGORY MANAGEMENT ====================
    
    @GetMapping("/subcategory/list")
    public String listSubcategories(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        List<SubCategoryEntity> subcategories = subCategoryRepository.findAllWithCategory();
        model.addAttribute("subcategories", subcategories);
        return "admin/subcategory/list";
    }
    
    @GetMapping("/subcategory/add")
    public String addSubcategoryForm(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        model.addAttribute("categories", categoryRepository.findByActiveTrue());
        model.addAttribute("subcategory", new SubCategoryEntity());
        return "admin/subcategory/add";
    }
    
    @PostMapping("/subcategory/save")
    public String saveSubcategory(SubCategoryEntity subcategory, 
                                  @RequestParam("categoryId") Integer categoryId,
                                  HttpSession session, 
                                  RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        Optional<CategoryEntity> category = categoryRepository.findById(categoryId);
        if (category.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Category not found!");
            return "redirect:/admin/subcategory/add";
        }
        
        if (subCategoryRepository.existsBySubCategoryNameAndCategoryCategoryId(
                subcategory.getSubCategoryName(), categoryId)) {
            redirectAttributes.addFlashAttribute("error", "Subcategory name already exists in this category!");
            return "redirect:/admin/subcategory/add";
        }
        
        subcategory.setCategory(category.get());
        if (subcategory.getActive() == null) {
            subcategory.setActive(true);
        }
        
        subCategoryRepository.save(subcategory);
        redirectAttributes.addFlashAttribute("success", "Subcategory added successfully!");
        return "redirect:/admin/subcategory/list";
    }
    
    @GetMapping("/subcategory/view/{id}")
    public String viewSubcategory(@PathVariable Integer id, HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        Optional<SubCategoryEntity> subcategory = subCategoryRepository.findById(id);
        if (subcategory.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Subcategory not found!");
            return "redirect:/admin/subcategory/list";
        }
        
        model.addAttribute("subcategory", subcategory.get());
        return "admin/subcategory/view";
    }
    
    @GetMapping("/subcategory/edit/{id}")
    public String editSubcategoryForm(@PathVariable Integer id, HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        Optional<SubCategoryEntity> subcategory = subCategoryRepository.findById(id);
        if (subcategory.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Subcategory not found!");
            return "redirect:/admin/subcategory/list";
        }
        
        model.addAttribute("categories", categoryRepository.findByActiveTrue());
        model.addAttribute("subcategory", subcategory.get());
        return "admin/subcategory/edit";
    }
    
    @PostMapping("/subcategory/update")
    public String updateSubcategory(SubCategoryEntity subcategory,
                                    @RequestParam("categoryId") Integer categoryId,
                                    HttpSession session, 
                                    RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        Optional<SubCategoryEntity> existing = subCategoryRepository.findById(subcategory.getSubCategoryId());
        if (existing.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Subcategory not found!");
            return "redirect:/admin/subcategory/list";
        }
        
        Optional<CategoryEntity> category = categoryRepository.findById(categoryId);
        if (category.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Category not found!");
            return "redirect:/admin/subcategory/edit/" + subcategory.getSubCategoryId();
        }
        
        SubCategoryEntity existingSubcategory = existing.get();
        
        // Check if name already exists in this category (and it's not the same subcategory)
        if (!existingSubcategory.getSubCategoryName().equals(subcategory.getSubCategoryName()) &&
            subCategoryRepository.existsBySubCategoryNameAndCategoryCategoryId(
                    subcategory.getSubCategoryName(), categoryId)) {
            redirectAttributes.addFlashAttribute("error", "Subcategory name already exists in this category!");
            return "redirect:/admin/subcategory/edit/" + subcategory.getSubCategoryId();
        }
        
        existingSubcategory.setSubCategoryName(subcategory.getSubCategoryName());
        existingSubcategory.setCategory(category.get());
        existingSubcategory.setActive(subcategory.getActive());
        
        subCategoryRepository.save(existingSubcategory);
        redirectAttributes.addFlashAttribute("success", "Subcategory updated successfully!");
        return "redirect:/admin/subcategory/list";
    }
    
    @GetMapping("/subcategory/toggle-status/{id}")
    public String toggleSubcategoryStatus(@PathVariable Integer id, HttpSession session, RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        Optional<SubCategoryEntity> subcategory = subCategoryRepository.findById(id);
        if (subcategory.isPresent()) {
            SubCategoryEntity s = subcategory.get();
            s.setActive(!s.getActive());
            subCategoryRepository.save(s);
            redirectAttributes.addFlashAttribute("success", "Subcategory " + (s.getActive() ? "activated" : "deactivated") + " successfully!");
        }
        return "redirect:/admin/subcategory/list";
    }
    
    @GetMapping("/subcategory/delete/{id}")
    public String deleteSubcategory(@PathVariable Integer id, HttpSession session, RedirectAttributes redirectAttributes) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied!");
            return "redirect:/login";
        }
        
        Optional<SubCategoryEntity> subcategory = subCategoryRepository.findById(id);
        if (subcategory.isPresent()) {
            if (!subcategory.get().getListings().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Cannot delete subcategory with products! Delete products first.");
                return "redirect:/admin/subcategory/list";
            }
            subCategoryRepository.deleteById(id);
            redirectAttributes.addFlashAttribute("success", "Subcategory deleted successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Subcategory not found!");
        }
        return "redirect:/admin/subcategory/list";
    }
}
package Retrotrade.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import Retrotrade.entity.CategoryEntity;
import Retrotrade.entity.UserEntity;
import Retrotrade.repository.CategoryRepository;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/category")
public class CategoryController {
    
    @Autowired
    private CategoryRepository categoryRepository;
    
    // ========================= LIST ALL CATEGORIES (PUBLIC) =========================
    
    @GetMapping("/list")
    public String listCategories(Model model) {
        List<CategoryEntity> categories = categoryRepository.findAll();
        model.addAttribute("categories", categories);
        return "category/list";
    }
    
    // ========================= SHOW ADD CATEGORY FORM (ADMIN ONLY) =========================
    
    @GetMapping("/add")
    public String showAddForm(HttpSession session, 
                              Model model, 
                              RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied! Admin only.");
            return "redirect:/login";
        }
        
        model.addAttribute("category", new CategoryEntity());
        return "category/add";
    }
    
    // ========================= ADD NEW CATEGORY (ADMIN ONLY) =========================
    
    @PostMapping("/save")
    public String saveCategory(CategoryEntity categoryEntity,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied! Admin only.");
            return "redirect:/login";
        }
        
        // Check if category name already exists
        if (categoryRepository.existsByCategoryName(categoryEntity.getCategoryName())) {
            redirectAttributes.addFlashAttribute("error", "Category name already exists!");
            return "redirect:/category/add";
        }
        
        // Set default active status if not set
        if (categoryEntity.getActive() == null) {
            categoryEntity.setActive(true);
        }
        
        categoryRepository.save(categoryEntity);
        redirectAttributes.addFlashAttribute("success", "Category added successfully!");
        
        return "redirect:/category/list";
    }
    
    // ========================= VIEW CATEGORY DETAILS =========================
    
    @GetMapping("/view/{id}")
    public String viewCategory(@PathVariable("id") Integer categoryId,
                               Model model,
                               RedirectAttributes redirectAttributes) {
        
        Optional<CategoryEntity> categoryOpt = categoryRepository.findById(categoryId);
        if (categoryOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Category not found!");
            return "redirect:/category/list";
        }
        
        model.addAttribute("category", categoryOpt.get());
        return "category/view";
    }
    
    // ========================= SHOW EDIT CATEGORY FORM (ADMIN ONLY) =========================
    
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Integer categoryId,
                               HttpSession session,
                               Model model,
                               RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied! Admin only.");
            return "redirect:/login";
        }
        
        Optional<CategoryEntity> categoryOpt = categoryRepository.findById(categoryId);
        if (categoryOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Category not found!");
            return "redirect:/category/list";
        }
        
        model.addAttribute("category", categoryOpt.get());
        return "category/edit";
    }
    
    // ========================= UPDATE CATEGORY (ADMIN ONLY) =========================
    
    @PostMapping("/update")
    public String updateCategory(CategoryEntity categoryEntity,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied! Admin only.");
            return "redirect:/login";
        }
        
        Optional<CategoryEntity> existingCategoryOpt = categoryRepository.findById(categoryEntity.getCategoryId());
        if (existingCategoryOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Category not found!");
            return "redirect:/category/list";
        }
        
        CategoryEntity existingCategory = existingCategoryOpt.get();
        
        // Check if new name already exists (and it's not the same category)
        if (!existingCategory.getCategoryName().equals(categoryEntity.getCategoryName()) &&
            categoryRepository.existsByCategoryName(categoryEntity.getCategoryName())) {
            redirectAttributes.addFlashAttribute("error", "Category name already exists!");
            return "redirect:/category/edit/" + categoryEntity.getCategoryId();
        }
        
        // Update fields
        existingCategory.setCategoryName(categoryEntity.getCategoryName());
        existingCategory.setActive(categoryEntity.getActive());
        
        categoryRepository.save(existingCategory);
        redirectAttributes.addFlashAttribute("success", "Category updated successfully!");
        
        return "redirect:/category/list";
    }
    
    // ========================= DELETE CATEGORY (ADMIN ONLY) =========================
    
    @GetMapping("/delete/{id}")
    public String deleteCategory(@PathVariable("id") Integer categoryId,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied! Admin only.");
            return "redirect:/login";
        }
        
        Optional<CategoryEntity> categoryOpt = categoryRepository.findById(categoryId);
        if (categoryOpt.isPresent()) {
            CategoryEntity category = categoryOpt.get();
            
            // Check if category has subcategories
            if (!category.getSubCategories().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Cannot delete category with subcategories! Delete subcategories first.");
                return "redirect:/category/list";
            }
            
            categoryRepository.delete(category);
            redirectAttributes.addFlashAttribute("success", "Category deleted successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Category not found!");
        }
        
        return "redirect:/category/list";
    }
    
    // ========================= TOGGLE CATEGORY STATUS (ADMIN ONLY) =========================
    
    @GetMapping("/toggle-status/{id}")
    public String toggleStatus(@PathVariable("id") Integer categoryId,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied! Admin only.");
            return "redirect:/login";
        }
        
        Optional<CategoryEntity> categoryOpt = categoryRepository.findById(categoryId);
        if (categoryOpt.isPresent()) {
            CategoryEntity category = categoryOpt.get();
            category.setActive(!category.getActive());
            categoryRepository.save(category);
            
            String status = category.getActive() ? "activated" : "deactivated";
            redirectAttributes.addFlashAttribute("success", "Category " + status + " successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Category not found!");
        }
        
        return "redirect:/category/list";
    }
 // ========================= ADMIN CATEGORY LIST =========================

    @GetMapping("/admin/list")
    public String adminListCategories(Model model, 
                                      @RequestParam(defaultValue = "1") int page,
                                      HttpSession session,
                                      RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied! Admin only.");
            return "redirect:/login";
        }
        
        // Pagination logic
        int pageSize = 10;
        List<CategoryEntity> allCategories = categoryRepository.findAll();
        int totalCategories = allCategories.size();
        int totalPages = (int) Math.ceil((double) totalCategories / pageSize);
        
        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, totalCategories);
        List<CategoryEntity> categories = allCategories.subList(start, end);
        
        // Calculate statistics
        long activeCategories = categoryRepository.findByActiveTrue().size();
        CrudRepository<CategoryEntity, Integer> subCategoryRepository = null;
		long totalSubcategories = subCategoryRepository.count();
        
        model.addAttribute("categories", categories);
        model.addAttribute("totalCategories", totalCategories);
        model.addAttribute("activeCategories", activeCategories);
        model.addAttribute("totalSubcategories", totalSubcategories);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        
        return "admin/category/list";
    }

    // ========================= ADMIN ADD CATEGORY PAGE =========================

    @GetMapping("/admin/add")
    public String adminShowAddForm(HttpSession session,
                                   Model model,
                                   RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied! Admin only.");
            return "redirect:/login";
        }
        
        model.addAttribute("category", new CategoryEntity());
        return "admin/category/add";
    }

    // ========================= ADMIN EDIT CATEGORY PAGE =========================

    @GetMapping("/admin/edit/{id}")
    public String adminShowEditForm(@PathVariable("id") Integer categoryId,
                                    HttpSession session,
                                    Model model,
                                    RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied! Admin only.");
            return "redirect:/login";
        }
        
        Optional<CategoryEntity> categoryOpt = categoryRepository.findById(categoryId);
        if (categoryOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Category not found!");
            return "redirect:/category/admin/list";
        }
        
        model.addAttribute("category", categoryOpt.get());
        return "admin/category/edit";
    }

    // ========================= ADMIN VIEW CATEGORY =========================

    @GetMapping("/admin/view/{id}")
    public String adminViewCategory(@PathVariable("id") Integer categoryId,
                                    HttpSession session,
                                    Model model,
                                    RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Access denied! Admin only.");
            return "redirect:/login";
        }
        
        Optional<CategoryEntity> categoryOpt = categoryRepository.findById(categoryId);
        if (categoryOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Category not found!");
            return "redirect:/category/admin/list";
        }
        
        CategoryEntity category = categoryOpt.get();
        
        // Calculate total products in this category
        int totalProducts = category.getSubCategories().stream()
                .mapToInt(sub -> sub.getListings().size())
                .sum();
        
        model.addAttribute("category", category);
        model.addAttribute("totalProducts", totalProducts);
        
        return "admin/category/view";
    }
}
package Retrotrade.controller;

import Retrotrade.entity.CategoryEntity;
import Retrotrade.entity.SubCategoryEntity;
import Retrotrade.repository.CategoryRepository;
import Retrotrade.repository.SubCategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class TestController {
    
    @Autowired
    private CategoryRepository categoryRepository;
    
    @Autowired
    private SubCategoryRepository subCategoryRepository;
    
    @GetMapping("/test/categories")
    @ResponseBody
    public Map<String, Object> testCategories() {
        Map<String, Object> result = new HashMap<>();
        
        List<CategoryEntity> categories = categoryRepository.findByActiveTrue();
        result.put("categories", categories);
        result.put("categoriesCount", categories.size());
        
        Map<Integer, Integer> subcategoryCounts = new HashMap<>();
        for (CategoryEntity cat : categories) {
            int count = subCategoryRepository.findByCategoryCategoryIdAndActiveTrue(cat.getCategoryId()).size();
            subcategoryCounts.put(cat.getCategoryId(), count);
        }
        result.put("subcategoryCounts", subcategoryCounts);
        
        return result;
    }
    
    @GetMapping("/test/subcategories/6")
    @ResponseBody
    public Object testSubcategories() {
        try {
            List<SubCategoryEntity> subs = subCategoryRepository.findByCategoryCategoryIdAndActiveTrue(6);
            if (subs.isEmpty()) {
                return "No subcategories found for category 6. Please add some subcategories in the admin panel.";
            }
            return subs;
        } catch (Exception e) {
            return "Error: " + e.getMessage();
        }
    }
}
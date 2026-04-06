package Retrotrade.controller;

import Retrotrade.entity.SubCategoryEntity;
import Retrotrade.repository.SubCategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
public class SubCategoryApiController {
    
    @Autowired
    private SubCategoryRepository subCategoryRepository;
    
    @GetMapping("/subcategories/{categoryId}")
    public List<SubCategoryEntity> getSubCategoriesByCategory(@PathVariable Integer categoryId) {
        System.out.println("Fetching subcategories for category ID: " + categoryId);
        List<SubCategoryEntity> subCategories = subCategoryRepository.findByCategoryCategoryIdAndActiveTrue(categoryId);
        System.out.println("Found: " + subCategories.size() + " subcategories");
        return subCategories;
    }
}
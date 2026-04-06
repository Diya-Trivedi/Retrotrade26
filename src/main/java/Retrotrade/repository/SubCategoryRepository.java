package Retrotrade.repository;

import Retrotrade.entity.SubCategoryEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface SubCategoryRepository extends JpaRepository<SubCategoryEntity, Integer> {
    
    // Find subcategories by category ID
    List<SubCategoryEntity> findByCategoryCategoryId(Integer categoryId);
    
    // Find active subcategories by category ID
    List<SubCategoryEntity> findByCategoryCategoryIdAndActiveTrue(Integer categoryId);
    
    // Find subcategory by name and category
    Optional<SubCategoryEntity> findBySubCategoryNameAndCategoryCategoryId(String subCategoryName, Integer categoryId);
    
    // Check if subcategory exists in a category
    boolean existsBySubCategoryNameAndCategoryCategoryId(String subCategoryName, Integer categoryId);
    
    // Find active subcategories
    List<SubCategoryEntity> findByActiveTrue();
    
    // Find all subcategories with category details
    @Query("SELECT s FROM SubCategoryEntity s JOIN FETCH s.category")
    List<SubCategoryEntity> findAllWithCategory();
    
    // Find subcategories by category ID with listings count
    @Query("SELECT s, COUNT(l) FROM SubCategoryEntity s LEFT JOIN s.listings l WHERE s.category.categoryId = :categoryId GROUP BY s")
    List<Object[]> findSubCategoriesWithListingCount(@Param("categoryId") Integer categoryId);
    
    // Search subcategories by name
    List<SubCategoryEntity> findBySubCategoryNameContainingIgnoreCase(String keyword);
    
    // Count subcategories in a category
    long countByCategoryCategoryId(Integer categoryId);
}
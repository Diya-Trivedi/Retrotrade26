package Retrotrade.repository;

import Retrotrade.entity.CategoryEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface CategoryRepository extends JpaRepository<CategoryEntity, Integer> {
    
    // Find category by name
    Optional<CategoryEntity> findByCategoryName(String categoryName);
    
    // Find active categories
    List<CategoryEntity> findByActiveTrue();
    
    // Find inactive categories
    List<CategoryEntity> findByActiveFalse();
    
    // Check if category name exists
    boolean existsByCategoryName(String categoryName);
    
    // Find categories with their subcategories
    @Query("SELECT c FROM CategoryEntity c LEFT JOIN FETCH c.subCategories WHERE c.categoryId = :categoryId")
    Optional<CategoryEntity> findCategoryWithSubCategories(@Param("categoryId") Integer categoryId);
    
    // Find all categories with subcategory count
    @Query("SELECT c, COUNT(s) FROM CategoryEntity c LEFT JOIN c.subCategories s GROUP BY c")
    List<Object[]> findAllCategoriesWithSubCategoryCount();
    
    // Search categories by name
    List<CategoryEntity> findByCategoryNameContainingIgnoreCase(String keyword);
}
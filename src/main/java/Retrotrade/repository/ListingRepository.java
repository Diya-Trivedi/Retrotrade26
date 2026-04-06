package Retrotrade.repository;

import Retrotrade.entity.ListingEntity;
import Retrotrade.entity.UserEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Repository
public interface ListingRepository extends JpaRepository<ListingEntity, Integer> {
    
    // Find listings by seller
    List<ListingEntity> findBySeller(UserEntity seller);
    
    // Find listings by seller ID
    List<ListingEntity> findBySellerUserId(Integer userId);
    
    // Find listings by category with pagination
    Page<ListingEntity> findByCategoryCategoryId(Integer categoryId, Pageable pageable);
    
    // Find listings by subcategory with pagination
    Page<ListingEntity> findBySubCategorySubCategoryId(Integer subCategoryId, Pageable pageable);
    
    // Find active listings with pagination
    Page<ListingEntity> findByStatus(String status, Pageable pageable);
    
    // Find listings by category and status with pagination - FIXED: Added missing method
    Page<ListingEntity> findByCategoryCategoryIdAndStatus(Integer categoryId, String status, Pageable pageable);
    
    // Find listings by subcategory and status with pagination - NEW METHOD
    Page<ListingEntity> findBySubCategorySubCategoryIdAndStatus(Integer subCategoryId, String status, Pageable pageable);
    
    // Find listings by category and status (without pagination)
    List<ListingEntity> findByCategoryCategoryIdAndStatus(Integer categoryId, String status);
    
    // Find listings by category and status with limit - FIXED: Added missing method with listingId not equal
    @Query("SELECT l FROM ListingEntity l WHERE l.category.categoryId = :categoryId AND l.status = :status AND l.listingId != :listingId ORDER BY l.createdAt DESC")
    List<ListingEntity> findTop4ByCategoryCategoryIdAndStatusAndListingIdNotOrderByCreatedAtDesc(
            @Param("categoryId") Integer categoryId, @Param("status") String status, @Param("listingId") Integer listingId);
    
    // Original method for backward compatibility
    List<ListingEntity> findTop4ByCategoryCategoryIdAndStatusOrderByCreatedAtDesc(Integer categoryId, String status);
    
    // Find listings by price range
    List<ListingEntity> findByPriceBetween(BigDecimal minPrice, BigDecimal maxPrice);
    
    // Search listings by name or description
    @Query("SELECT l FROM ListingEntity l WHERE l.status = 'ACTIVE' AND " +
           "(LOWER(l.listingName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(l.description) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    List<ListingEntity> searchListings(@Param("keyword") String keyword);
    
    // Find listings by category and subcategory
    List<ListingEntity> findByCategoryCategoryIdAndSubCategorySubCategoryId(
            Integer categoryId, Integer subCategoryId);
    
    // Find recent listings
    List<ListingEntity> findTop10ByStatusOrderByCreatedAtDesc(String status);
    
    // Count listings by status
    long countByStatus(String status);
    
    // Find listings with offers
    @Query("SELECT l FROM ListingEntity l WHERE SIZE(l.offers) > 0")
    List<ListingEntity> findListingsWithOffers();
    
    // Find popular listings (most viewed)
    List<ListingEntity> findTop10ByOrderByViewCountDesc();
    
    // Find listings by seller and status
    List<ListingEntity> findBySellerAndStatus(UserEntity seller, String status);
    
    // Custom query to get listing with images
    @Query("SELECT l FROM ListingEntity l LEFT JOIN FETCH l.images WHERE l.listingId = :listingId")
    Optional<ListingEntity> findListingWithImages(@Param("listingId") Integer listingId);
    
    // Find all listings by category (without pagination)
    List<ListingEntity> findAllByCategoryCategoryId(Integer categoryId);

    List<ListingEntity> findByStatus(String status);

    List<ListingEntity> findByCategoryCategoryId(Integer categoryId);
}
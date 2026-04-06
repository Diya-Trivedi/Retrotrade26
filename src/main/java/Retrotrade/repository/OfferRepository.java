package Retrotrade.repository;

import Retrotrade.entity.OfferEntity;
import Retrotrade.entity.OfferEntity.OfferStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface OfferRepository extends JpaRepository<OfferEntity, Integer> {
    
    // Find offers by listing
    List<OfferEntity> findByListingListingId(Integer listingId);
    
    // Find offers by listing with pagination
    Page<OfferEntity> findByListingListingId(Integer listingId, Pageable pageable);
    
    // Find offers by buyer
    List<OfferEntity> findByBuyerUserId(Integer buyerId);
    
    // Find offers by buyer with pagination
    Page<OfferEntity> findByBuyerUserId(Integer buyerId, Pageable pageable);
    
    // Find offers by seller (through listing) - FIXED: Using @Query instead of method name
    @Query("SELECT o FROM OfferEntity o WHERE o.listing.seller.userId = :sellerId")
    List<OfferEntity> findBySellerId(@Param("sellerId") Integer sellerId);
    
    // Find offers by seller with pagination - FIXED: Using @Query
    @Query("SELECT o FROM OfferEntity o WHERE o.listing.seller.userId = :sellerId ORDER BY o.createdAt DESC")
    List<OfferEntity> findBySellerIdWithPagination(@Param("sellerId") Integer sellerId, Pageable pageable);
    
    // Find recent offers for a seller with pagination - FIXED: For seller dashboard
    @Query("SELECT o FROM OfferEntity o WHERE o.listing.seller.userId = :sellerId ORDER BY o.createdAt DESC")
    List<OfferEntity> findRecentOffersForSeller(@Param("sellerId") Integer sellerId, Pageable pageable);
    
    // Find offers by status
    List<OfferEntity> findByOfferStatus(OfferStatus status);
    
    // Find offers by listing and status
    List<OfferEntity> findByListingListingIdAndOfferStatus(Integer listingId, OfferStatus status);
    
    // Find pending offers for a listing
    List<OfferEntity> findByListingListingIdAndOfferStatusOrderByOfferedPriceDesc(Integer listingId, OfferStatus status);
    
    // Find highest offer for a listing
    @Query("SELECT o FROM OfferEntity o WHERE o.listing.listingId = :listingId AND o.offerStatus = 'PENDING' ORDER BY o.offeredPrice DESC")
    List<OfferEntity> findHighestOffer(@Param("listingId") Integer listingId, Pageable pageable);
    
    // Count offers by listing and status
    long countByListingListingIdAndOfferStatus(Integer listingId, OfferStatus status);
    
    // Check if buyer has already made an offer on a listing
    boolean existsByListingListingIdAndBuyerUserIdAndOfferStatus(
            Integer listingId, Integer buyerId, OfferStatus status);
    
    // Find expired offers
    @Query("SELECT o FROM OfferEntity o WHERE o.expiryDate < :currentDate AND o.offerStatus = 'PENDING'")
    List<OfferEntity> findExpiredOffers(@Param("currentDate") LocalDateTime currentDate);
    
    // Update expired offers status
    @Modifying
    @Transactional
    @Query("UPDATE OfferEntity o SET o.offerStatus = 'EXPIRED' WHERE o.expiryDate < :currentDate AND o.offerStatus = 'PENDING'")
    int updateExpiredOffers(@Param("currentDate") LocalDateTime currentDate);
    
    // Find offers by price range
    List<OfferEntity> findByOfferedPriceBetween(BigDecimal minPrice, BigDecimal maxPrice);
    
    // Get average offer price for a listing
    @Query("SELECT AVG(o.offeredPrice) FROM OfferEntity o WHERE o.listing.listingId = :listingId AND o.offerStatus = 'PENDING'")
    BigDecimal getAverageOfferPrice(@Param("listingId") Integer listingId);
    
    // Count offers by buyer and status
    long countByBuyerUserIdAndOfferStatus(Integer userId, OfferStatus status);

    // Find offers by buyer and status with pagination
    Page<OfferEntity> findByBuyerUserIdAndOfferStatus(Integer userId, OfferStatus offerStatus, Pageable pageable);

    // Find offers by status with pagination
    Page<OfferEntity> findByOfferStatus(OfferStatus offerStatus, Pageable pageable);

    // Count offers by status
    long countByOfferStatus(OfferStatus status);
    
    // Find top 10 recent offers
    @Query("SELECT o FROM OfferEntity o ORDER BY o.createdAt DESC")
    List<OfferEntity> findTop10ByOrderByCreatedAtDesc(Pageable pageable);

    default List<OfferEntity> findTop10ByOrderByCreatedAtDesc() {
        return findTop10ByOrderByCreatedAtDesc(PageRequest.of(0, 10));
    }
}
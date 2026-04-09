package Retrotrade.repository;

import Retrotrade.entity.ReviewEntity;
import Retrotrade.entity.UserEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface ReviewRepository extends JpaRepository<ReviewEntity, Integer> {
    
    // Existing methods
    List<ReviewEntity> findBySeller(UserEntity seller);
    Page<ReviewEntity> findBySellerUserId(Integer sellerId, Pageable pageable);  // Integer, not Long
    List<ReviewEntity> findByBuyer(UserEntity buyer);
    boolean existsByBuyerUserIdAndSellerUserId(Integer buyerId, Integer sellerId);
    
    @Query("SELECT AVG(r.rating) FROM ReviewEntity r WHERE r.seller.userId = :sellerId")
    Double getAverageRatingBySeller(@Param("sellerId") Integer sellerId);
    
    long countBySellerUserId(Integer sellerId);
    
    // Admin methods
    Page<ReviewEntity> findByRating(Integer rating, Pageable pageable);
    
    long countByRating(Integer rating);
    
    @Query("SELECT AVG(r.rating) FROM ReviewEntity r")
    double getAverageRating();
    
    Page<ReviewEntity> findAll(Pageable pageable);
    
    @Query("SELECT r FROM ReviewEntity r JOIN FETCH r.listing l LEFT JOIN FETCH l.images WHERE r.reviewId = :reviewId")
    Optional<ReviewEntity> findReviewWithDetails(@Param("reviewId") Integer reviewId);
}
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

@Repository
public interface ReviewRepository extends JpaRepository<ReviewEntity, Integer> {
    List<ReviewEntity> findBySeller(UserEntity seller);
    Page<ReviewEntity> findBySellerUserId(Integer sellerId, Pageable pageable);
    List<ReviewEntity> findByBuyer(UserEntity buyer);
    boolean existsByBuyerUserIdAndSellerUserId(Integer buyerId, Integer sellerId);
    @Query("SELECT AVG(r.rating) FROM ReviewEntity r WHERE r.seller.userId = :sellerId")
    Double getAverageRatingBySeller(@Param("sellerId") Integer sellerId);
    long countBySellerUserId(Integer sellerId);
}
package Retrotrade.repository;

import Retrotrade.entity.TransactionEntity;
import Retrotrade.entity.TransactionEntity.PaymentMode;
import Retrotrade.entity.TransactionEntity.TransactionStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface TransactionRepository extends JpaRepository<TransactionEntity, Integer> {
    
    // Find transactions by buyer
    List<TransactionEntity> findByBuyerUserId(Integer buyerId);
    
    // Find transactions by buyer with pagination
    Page<TransactionEntity> findByBuyerUserId(Integer buyerId, Pageable pageable);
    
    // Find transactions by seller
    List<TransactionEntity> findBySellerUserId(Integer sellerId);
    
    // Find transactions by seller with pagination
    Page<TransactionEntity> findBySellerUserId(Integer sellerId, Pageable pageable);
    
    // Find transactions by listing
    List<TransactionEntity> findByListingListingId(Integer listingId);
    
    // Find transactions by status
    List<TransactionEntity> findByTransactionStatus(TransactionStatus status);
    
    // Find transactions by status with pagination
    Page<TransactionEntity> findByTransactionStatus(TransactionStatus status, Pageable pageable);
    
    // Find transactions by payment mode
    List<TransactionEntity> findByPaymentMode(PaymentMode paymentMode);
    
    // Find transactions by date range
    List<TransactionEntity> findByCreatedAtBetween(LocalDateTime startDate, LocalDateTime endDate);
    
    // Find completed transactions by seller
    List<TransactionEntity> findBySellerUserIdAndTransactionStatus(Integer sellerId, TransactionStatus status);
    
    // Find transactions by buyer and status
    List<TransactionEntity> findByBuyerUserIdAndTransactionStatus(Integer buyerId, TransactionStatus status);
    
    boolean existsByBuyerUserIdAndSellerUserIdAndTransactionStatus(Integer buyerId, Integer sellerId, TransactionStatus status);
    
    // Get total revenue by seller
    @Query("SELECT SUM(t.finalPrice) FROM TransactionEntity t WHERE t.seller.userId = :sellerId AND t.transactionStatus = 'COMPLETED'")
    BigDecimal getTotalRevenueBySeller(@Param("sellerId") Integer sellerId);
    
    // Get total platform fees
    @Query("SELECT SUM(t.transactionFee) FROM TransactionEntity t WHERE t.transactionStatus = 'COMPLETED'")
    BigDecimal getTotalPlatformFees();
    
    // Get monthly revenue
    @Query("SELECT MONTH(t.completedAt), YEAR(t.completedAt), SUM(t.finalPrice) " +
           "FROM TransactionEntity t WHERE t.transactionStatus = 'COMPLETED' " +
           "GROUP BY YEAR(t.completedAt), MONTH(t.completedAt) ORDER BY YEAR(t.completedAt) DESC, MONTH(t.completedAt) DESC")
    List<Object[]> getMonthlyRevenue();
    
    // Count transactions by status
    long countByTransactionStatus(TransactionStatus status);
    
    // Get recent transactions for a user (as buyer or seller)
    @Query("SELECT t FROM TransactionEntity t WHERE t.buyer.userId = :userId OR t.seller.userId = :userId ORDER BY t.createdAt DESC")
    List<TransactionEntity> findRecentTransactionsByUser(@Param("userId") Integer userId, Pageable pageable);
    
    // Check if a listing has been purchased
    boolean existsByListingListingIdAndTransactionStatus(Integer listingId, TransactionStatus status);
    
    // Get transaction statistics
    @Query("SELECT COUNT(t), SUM(t.finalPrice), AVG(t.finalPrice) FROM TransactionEntity t WHERE t.transactionStatus = 'COMPLETED'")
    Object[] getTransactionStatistics();
    
    // Find pending payouts for sellers
    @Query("SELECT t.seller.userId, SUM(t.sellerPayout) FROM TransactionEntity t " +
           "WHERE t.transactionStatus = 'COMPLETED' AND t.sellerPayout IS NOT NULL " +
           "GROUP BY t.seller.userId")
    List<Object[]> getPendingPayouts();

	Page<TransactionEntity> findByBuyerUserIdAndTransactionStatus(Integer userId, TransactionStatus valueOf,
			Pageable pageable);

	Page<TransactionEntity> findBySellerUserIdAndTransactionStatus(Integer userId, TransactionStatus valueOf,
			Pageable pageable);
}
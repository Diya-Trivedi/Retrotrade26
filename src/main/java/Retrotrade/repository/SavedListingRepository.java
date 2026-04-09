package Retrotrade.repository;

import Retrotrade.entity.SavedListingEntity;
import Retrotrade.entity.UserEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface SavedListingRepository extends JpaRepository<SavedListingEntity, Integer> {
    
    List<SavedListingEntity> findByUser(UserEntity user);
    
    List<SavedListingEntity> findByUserUserId(Integer userId);
    
    Page<SavedListingEntity> findByUserUserId(Integer userId, Pageable pageable);
    
    Optional<SavedListingEntity> findByUserUserIdAndListingListingId(Integer userId, Integer listingId);
    
    boolean existsByUserUserIdAndListingListingId(Integer userId, Integer listingId);
    
    void deleteByUserUserIdAndListingListingId(Integer userId, Integer listingId);
    
    void deleteByUserUserId(Integer userId);
    
    // ==================== ADMIN METHODS ====================
    
    @Query("SELECT COUNT(DISTINCT s.user.userId) FROM SavedListingEntity s")
    long countDistinctUsers();
    
    @Query("SELECT s.listing.listingId, COUNT(s) as saveCount FROM SavedListingEntity s GROUP BY s.listing.listingId ORDER BY saveCount DESC")
    List<Object[]> findTopListingsBySaveCount(Pageable pageable);
    
    @Query("SELECT s.user.userId, COUNT(s) as wishlistCount FROM SavedListingEntity s GROUP BY s.user.userId ORDER BY wishlistCount DESC")
    List<Object[]> findTopUsersByWishlistCount(Pageable pageable);
    
    @Query("SELECT s.listing.listingId FROM SavedListingEntity s GROUP BY s.listing.listingId ORDER BY COUNT(s) DESC")
    List<Integer> findMostSavedListingId(Pageable pageable);
    
    default long findMostSavedListingId() {
        List<Integer> result = findMostSavedListingId(PageRequest.of(0, 1));
        return result.isEmpty() ? 0 : result.get(0);
    }
    
    Page<SavedListingEntity> findByListingListingNameContainingIgnoreCase(String listingName, Pageable pageable);
    
    @Query("SELECT s FROM SavedListingEntity s JOIN FETCH s.user JOIN FETCH s.listing l LEFT JOIN FETCH l.images")
    List<SavedListingEntity> findAllWithDetails();
}
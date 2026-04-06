package Retrotrade.repository;

import Retrotrade.entity.SavedListingEntity;
import Retrotrade.entity.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface SavedListingRepository extends JpaRepository<SavedListingEntity, Integer> {
    List<SavedListingEntity> findByUser(UserEntity user);
    List<SavedListingEntity> findByUserUserId(Integer userId);
    Optional<SavedListingEntity> findByUserUserIdAndListingListingId(Integer userId, Integer listingId);
    boolean existsByUserUserIdAndListingListingId(Integer userId, Integer listingId);
    void deleteByUserUserIdAndListingListingId(Integer userId, Integer listingId);
}
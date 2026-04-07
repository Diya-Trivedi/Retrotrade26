package Retrotrade.repository;

import Retrotrade.entity.ListingImageEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

@Repository
public interface ListingImageRepository extends JpaRepository<ListingImageEntity, Integer> {
    
    List<ListingImageEntity> findByListingListingId(Integer listingId);
    
    Optional<ListingImageEntity> findByListingListingIdAndIsPrimaryTrue(Integer listingId);
    
    void deleteByListingListingId(Integer listingId);
    
    // ADD THESE METHODS:
    long countByListingListingId(Integer listingId);
    
    boolean existsByListingListingIdAndIsPrimaryTrue(Integer listingId);
    
    @Modifying
    @Transactional
    @Query("UPDATE ListingImageEntity i SET i.isPrimary = false WHERE i.listing.listingId = :listingId")
    void resetPrimaryImages(@Param("listingId") Integer listingId);
}
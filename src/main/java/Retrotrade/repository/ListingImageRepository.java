package Retrotrade.repository;

import Retrotrade.entity.ListingImageEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface ListingImageRepository extends JpaRepository<ListingImageEntity, Integer> {
    
    // Find images by listing
    List<ListingImageEntity> findByListingListingId(Integer listingId);
    
    // Find primary image by listing
    Optional<ListingImageEntity> findByListingListingIdAndIsPrimaryTrue(Integer listingId);
    
    // Delete images by listing
    void deleteByListingListingId(Integer listingId);
}
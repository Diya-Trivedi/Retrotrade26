package Retrotrade.repository;

import Retrotrade.entity.ReportEntity;
import Retrotrade.entity.ReportEntity.Status;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ReportRepository extends JpaRepository<ReportEntity, Integer> {
    List<ReportEntity> findByStatus(Status status);
    Page<ReportEntity> findByStatus(Status status, Pageable pageable);
    List<ReportEntity> findByListingListingId(Integer listingId);
    long countByStatus(Status status);
    
    // NEW: Find reports submitted by a specific user
    List<ReportEntity> findByReportedByUserId(Integer userId);
    Page<ReportEntity> findByReportedByUserId(Integer userId, Pageable pageable);
}
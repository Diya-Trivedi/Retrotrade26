package Retrotrade.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "reports")
public class ReportEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "report_id")
    private Integer reportId;

    @ManyToOne
    @JoinColumn(name = "seller_id", nullable = false)
    private UserEntity seller; // the reported seller (user)

    @ManyToOne
    @JoinColumn(name = "listing_id", nullable = false)
    private ListingEntity listing;

    @ManyToOne
    @JoinColumn(name = "reported_by", nullable = false)
    private UserEntity reportedBy; // the reporter

    @Enumerated(EnumType.STRING)
    @Column(name = "reason", nullable = false)
    private Reason reason;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private Status status = Status.OPEN;

    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "comment", length = 500)
    private String comment;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }

    public enum Reason {
        SCAM, FAKE_ITEM, ABUSE, OTHER
    }

    public enum Status {
        OPEN, RESOLVED, REJECTED
    }

    // Constructors
    public ReportEntity() {}

    public ReportEntity(UserEntity seller, ListingEntity listing, UserEntity reportedBy, Reason reason) {
        this.seller = seller;
        this.listing = listing;
        this.reportedBy = reportedBy;
        this.reason = reason;
    }

    // Getters and Setters
    public Integer getReportId() { return reportId; }
    public void setReportId(Integer reportId) { this.reportId = reportId; }
    public UserEntity getSeller() { return seller; }
    public void setSeller(UserEntity seller) { this.seller = seller; }
    public ListingEntity getListing() { return listing; }
    public void setListing(ListingEntity listing) { this.listing = listing; }
    public UserEntity getReportedBy() { return reportedBy; }
    public void setReportedBy(UserEntity reportedBy) { this.reportedBy = reportedBy; }
    public Reason getReason() { return reason; }
    public void setReason(Reason reason) { this.reason = reason; }
    public Status getStatus() { return status; }
    public void setStatus(Status status) { this.status = status; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public String getComment() { return comment; }
	public void setComment(String comment) { this.comment = comment; }
      
}
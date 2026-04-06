package Retrotrade.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "offer")
public class OfferEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "offer_id")
    private Integer offerId;
    
    @ManyToOne
    @JoinColumn(name = "listing_id", nullable = false)
    private ListingEntity listing;
    
    @ManyToOne
    @JoinColumn(name = "buyer_id", nullable = false)
    private UserEntity buyer;
    
    @Column(name = "offered_price", nullable = false, precision = 10, scale = 2)
    private BigDecimal offeredPrice;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "offer_status", nullable = false)
    private OfferStatus offerStatus;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @Column(name = "message", length = 500)
    private String message;
    
    @Column(name = "counter_price", precision = 10, scale = 2)
    private BigDecimal counterPrice;
    
    @Column(name = "expiry_date")
    private LocalDateTime expiryDate;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        if (offerStatus == null) {
            offerStatus = OfferStatus.PENDING;
        }
        // Set default expiry to 7 days from now
        if (expiryDate == null) {
            expiryDate = LocalDateTime.now().plusDays(7);
        }
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
    
    // Enum for offer status
    public enum OfferStatus {
        PENDING, ACCEPTED, REJECTED, COUNTERED, EXPIRED, WITHDRAWN
    }
    
    // Constructors
    public OfferEntity() {
        super();
    }
    
    public OfferEntity(ListingEntity listing, UserEntity buyer, BigDecimal offeredPrice) {
        this.listing = listing;
        this.buyer = buyer;
        this.offeredPrice = offeredPrice;
        this.offerStatus = OfferStatus.PENDING;
    }
    
    // Getters and Setters
    public Integer getOfferId() {
        return offerId;
    }

    public void setOfferId(Integer offerId) {
        this.offerId = offerId;
    }

    public ListingEntity getListing() {
        return listing;
    }

    public void setListing(ListingEntity listing) {
        this.listing = listing;
    }

    public UserEntity getBuyer() {
        return buyer;
    }

    public void setBuyer(UserEntity buyer) {
        this.buyer = buyer;
    }

    public BigDecimal getOfferedPrice() {
        return offeredPrice;
    }

    public void setOfferedPrice(BigDecimal offeredPrice) {
        this.offeredPrice = offeredPrice;
    }

    public OfferStatus getOfferStatus() {
        return offerStatus;
    }

    public void setOfferStatus(OfferStatus offerStatus) {
        this.offerStatus = offerStatus;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public BigDecimal getCounterPrice() {
        return counterPrice;
    }

    public void setCounterPrice(BigDecimal counterPrice) {
        this.counterPrice = counterPrice;
    }

    public LocalDateTime getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(LocalDateTime expiryDate) {
        this.expiryDate = expiryDate;
    }
    
    // Helper method to check if offer is expired
    public boolean isExpired() {
        return expiryDate != null && LocalDateTime.now().isAfter(expiryDate);
    }
    
    @Override
    public String toString() {
        return "OfferEntity{" +
                "offerId=" + offerId +
                ", offeredPrice=" + offeredPrice +
                ", offerStatus=" + offerStatus +
                ", createdAt=" + createdAt +
                '}';
    }
}
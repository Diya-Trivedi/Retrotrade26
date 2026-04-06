package Retrotrade.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "listing")
public class ListingEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "listing_id")
    private Integer listingId;
    
    @ManyToOne
    @JoinColumn(name = "category_id", nullable = false)
    private CategoryEntity category;
    
    @ManyToOne
    @JoinColumn(name = "subcategory_id", nullable = false)
    private SubCategoryEntity subCategory;
    
    @Column(name = "listing_name", nullable = false)
    private String listingName;
    
    @Column(name = "description", length = 1000)
    private String description;
    
    @Column(name = "brand")
    private String brand;
    
    @Column(name = "price", nullable = false, precision = 10, scale = 2)
    private BigDecimal price;
    
    @Column(name = "status", nullable = false)
    private String status; // ACTIVE, SOLD, REJECTED, PENDING
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @ManyToOne
    @JoinColumn(name = "seller_id", nullable = false)
    private UserEntity seller;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "condition_type", nullable = false)
    private Condition condition;
    
    @Column(name = "location")
    private String location;
    
    @Column(name = "negotiable")
    private Boolean negotiable = false;
    
    @Column(name = "view_count")
    private Integer viewCount = 0;
    
    // One-to-many relationship with images
    @OneToMany(mappedBy = "listing", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<ListingImageEntity> images = new ArrayList<>();
    
    // One-to-many relationship with offers
    @OneToMany(mappedBy = "listing", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<OfferEntity> offers = new ArrayList<>();
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        if (status == null) {
            status = "PENDING"; // Default to pending for admin approval
        }
    }
    
    // Enum for condition
    public enum Condition {
        NEW, LIKE_NEW, GOOD, FAIR, OLD
    }
    
    // Constructors
    public ListingEntity() {
        super();
    }
    
    public ListingEntity(String listingName, String description, BigDecimal price, 
                        CategoryEntity category, SubCategoryEntity subCategory, 
                        UserEntity seller, Condition condition) {
        this.listingName = listingName;
        this.description = description;
        this.price = price;
        this.category = category;
        this.subCategory = subCategory;
        this.seller = seller;
        this.condition = condition;
        this.status = "PENDING";
        this.negotiable = false;
        this.viewCount = 0;
    }
    
    // Helper methods
    public void addImage(ListingImageEntity image) {
        images.add(image);
        image.setListing(this);
    }
    
    public void removeImage(ListingImageEntity image) {
        images.remove(image);
        image.setListing(null);
    }
    
    public void addOffer(OfferEntity offer) {
        offers.add(offer);
        offer.setListing(this);
    }
    
    public void removeOffer(OfferEntity offer) {
        offers.remove(offer);
        offer.setListing(null);
    }
    
    // Getters and Setters
    public Integer getListingId() {
        return listingId;
    }

    public void setListingId(Integer listingId) {
        this.listingId = listingId;
    }

    public CategoryEntity getCategory() {
        return category;
    }

    public void setCategory(CategoryEntity category) {
        this.category = category;
    }

    public SubCategoryEntity getSubCategory() {
        return subCategory;
    }

    public void setSubCategory(SubCategoryEntity subCategory) {
        this.subCategory = subCategory;
    }

    public String getListingName() {
        return listingName;
    }

    public void setListingName(String listingName) {
        this.listingName = listingName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public UserEntity getSeller() {
        return seller;
    }

    public void setSeller(UserEntity seller) {
        this.seller = seller;
    }

    public Condition getCondition() {
        return condition;
    }

    public void setCondition(Condition condition) {
        this.condition = condition;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public Boolean getNegotiable() {
        return negotiable;
    }

    public void setNegotiable(Boolean negotiable) {
        this.negotiable = negotiable;
    }

    public Integer getViewCount() {
        return viewCount;
    }

    public void setViewCount(Integer viewCount) {
        this.viewCount = viewCount;
    }

    public List<ListingImageEntity> getImages() {
        return images;
    }

    public void setImages(List<ListingImageEntity> images) {
        this.images = images;
    }

    public List<OfferEntity> getOffers() {
        return offers;
    }

    public void setOffers(List<OfferEntity> offers) {
        this.offers = offers;
    }
    
    @Override
    public String toString() {
        return "ListingEntity{" +
                "listingId=" + listingId +
                ", listingName='" + listingName + '\'' +
                ", price=" + price +
                ", status='" + status + '\'' +
                ", condition=" + condition +
                '}';
    }
}
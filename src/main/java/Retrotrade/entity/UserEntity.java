package Retrotrade.entity;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "users")
public class UserEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Integer userId;
    
    @Column(name = "first_name", nullable = false)
    private String firstName;
    
    @Column(name = "last_name", nullable = false)
    private String lastName;
    
    @Column(name = "email", nullable = false, unique = true)
    private String email;
    
    @Column(name = "password", nullable = false)
    private String password;
    
    @Column(name = "created_at")
    private LocalDate createdAt;
    
    @Column(name = "role", nullable = false)
    private String role; // USER, ADMIN
    
    @Column(name = "gender")
    private String gender;
    
    @Column(name = "contact_num")
    private String contactNum;
    
    @Column(name = "profile_pic_url")
    private String profilePicURL;
    
    @Column(name = "otp")
    private String otp;
    
    @Column(name = "active")
    private Boolean active = false;
    
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<AddressEntity> addresses = new ArrayList<>();
    
    // ==================== FIXED REVIEW RELATIONSHIPS ====================
    
    // Reviews GIVEN by this user (as buyer)
    @OneToMany(mappedBy = "buyer", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ReviewEntity> reviewsGiven = new ArrayList<>();
    
    // Reviews RECEIVED by this user (as seller)
    @OneToMany(mappedBy = "seller", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ReviewEntity> reviewsReceived = new ArrayList<>();
    
    // Listings sold by this user
    @OneToMany(mappedBy = "seller", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ListingEntity> listings = new ArrayList<>();
    
    // Offers made by this user (as buyer)
    @OneToMany(mappedBy = "buyer", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<OfferEntity> offersMade = new ArrayList<>();
    
    // Transactions as buyer
    @OneToMany(mappedBy = "buyer", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<TransactionEntity> purchases = new ArrayList<>();
    
    // Transactions as seller
    @OneToMany(mappedBy = "seller", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<TransactionEntity> sales = new ArrayList<>();
    
    // Wishlist items
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<SavedListingEntity> wishlist = new ArrayList<>();
    
    // Reports filed by this user
    @OneToMany(mappedBy = "reportedBy", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ReportEntity> reportsFiled = new ArrayList<>();
    
    // Reports received against this user (as seller)
    @OneToMany(mappedBy = "seller", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ReportEntity> reportsReceived = new ArrayList<>();
    
    // Helper method to get full name
    public String getName() {
        return firstName + " " + lastName;
    }
    
    // Constructors
    public UserEntity() {
        super();
    }
    
    public UserEntity(String firstName, String lastName, String email, String password, String role, String gender, String contactNum) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.password = password;
        this.role = role;
        this.gender = gender;
        this.contactNum = contactNum;
        this.active = false;
        this.createdAt = LocalDate.now();
    }
    
    // Getters and Setters
    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public LocalDate getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDate createdAt) {
        this.createdAt = createdAt;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getContactNum() {
        return contactNum;
    }

    public void setContactNum(String contactNum) {
        this.contactNum = contactNum;
    }

    public String getProfilePicURL() {
        return profilePicURL;
    }

    public void setProfilePicURL(String profilePicURL) {
        this.profilePicURL = profilePicURL;
    }

    public String getOtp() {
        return otp;
    }

    public void setOtp(String otp) {
        this.otp = otp;
    }

    public Boolean getActive() {
        return active;
    }

    public void setActive(Boolean active) {
        this.active = active;
    }

    public List<AddressEntity> getAddresses() {
        return addresses;
    }

    public void setAddresses(List<AddressEntity> addresses) {
        this.addresses = addresses;
    }
    
    public List<ReviewEntity> getReviewsGiven() {
        return reviewsGiven;
    }

    public void setReviewsGiven(List<ReviewEntity> reviewsGiven) {
        this.reviewsGiven = reviewsGiven;
    }

    public List<ReviewEntity> getReviewsReceived() {
        return reviewsReceived;
    }

    public void setReviewsReceived(List<ReviewEntity> reviewsReceived) {
        this.reviewsReceived = reviewsReceived;
    }

    public List<ListingEntity> getListings() {
        return listings;
    }

    public void setListings(List<ListingEntity> listings) {
        this.listings = listings;
    }

    public List<OfferEntity> getOffersMade() {
        return offersMade;
    }

    public void setOffersMade(List<OfferEntity> offersMade) {
        this.offersMade = offersMade;
    }

    public List<TransactionEntity> getPurchases() {
        return purchases;
    }

    public void setPurchases(List<TransactionEntity> purchases) {
        this.purchases = purchases;
    }

    public List<TransactionEntity> getSales() {
        return sales;
    }

    public void setSales(List<TransactionEntity> sales) {
        this.sales = sales;
    }

    public List<SavedListingEntity> getWishlist() {
        return wishlist;
    }

    public void setWishlist(List<SavedListingEntity> wishlist) {
        this.wishlist = wishlist;
    }

    public List<ReportEntity> getReportsFiled() {
        return reportsFiled;
    }

    public void setReportsFiled(List<ReportEntity> reportsFiled) {
        this.reportsFiled = reportsFiled;
    }

    public List<ReportEntity> getReportsReceived() {
        return reportsReceived;
    }

    public void setReportsReceived(List<ReportEntity> reportsReceived) {
        this.reportsReceived = reportsReceived;
    }
    
    @Override
    public String toString() {
        return "UserEntity{" +
                "userId=" + userId +
                ", firstName='" + firstName + '\'' +
                ", lastName='" + lastName + '\'' +
                ", email='" + email + '\'' +
                ", role='" + role + '\'' +
                ", active=" + active +
                '}';
    }
}
package Retrotrade.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

import Retrotrade.entity.UserEntity;

@Entity
@Table(name = "address")
public class AddressEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "address_id")
    private Integer addressId;
    
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false, insertable = false, updatable = false)
    private UserEntity user;
    
    @Column(name = "user_id", nullable = false)
    private Integer userId;
    
    @Column(name = "full_name", nullable = false)
    private String fullName;
    
    @Column(name = "mobile_no", nullable = false)
    private String mobileNo;
    
    @Column(name = "address_line1", nullable = false)
    private String addressLine1;
    
    @Column(name = "city", nullable = false)
    private String city;
    
    @Column(name = "state", nullable = false)
    private String state;
    
    @Column(name = "pincode", nullable = false)
    private String pincode;
    
    @Column(name = "address_type", nullable = false)
    private String addressType; // HOME, OFFICE
    
    @Column(name = "is_default")
    private Boolean isDefault = false;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
    
    // Constructors
    public AddressEntity() {
        super();
    }
    
    public AddressEntity(Integer userId, String fullName, String mobileNo, String addressLine1, 
                         String city, String state, String pincode, String addressType, Boolean isDefault) {
        this.userId = userId;
        this.fullName = fullName;
        this.mobileNo = mobileNo;
        this.addressLine1 = addressLine1;
        this.city = city;
        this.state = state;
        this.pincode = pincode;
        this.addressType = addressType;
        this.isDefault = isDefault;
    }
    
    // Getters and Setters
    public Integer getAddressId() {
        return addressId;
    }

    public void setAddressId(Integer addressId) {
        this.addressId = addressId;
    }

    public UserEntity getUser() {
        return user;
    }

    public void setUser(UserEntity user) {
        this.user = user;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getMobileNo() {
        return mobileNo;
    }

    public void setMobileNo(String mobileNo) {
        this.mobileNo = mobileNo;
    }

    public String getAddressLine1() {
        return addressLine1;
    }

    public void setAddressLine1(String addressLine1) {
        this.addressLine1 = addressLine1;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getPincode() {
        return pincode;
    }

    public void setPincode(String pincode) {
        this.pincode = pincode;
    }

    public String getAddressType() {
        return addressType;
    }

    public void setAddressType(String addressType) {
        this.addressType = addressType;
    }

    public Boolean getIsDefault() {
        return isDefault;
    }

    public void setIsDefault(Boolean isDefault) {
        this.isDefault = isDefault;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    @Override
    public String toString() {
        return "AddressEntity{" +
                "addressId=" + addressId +
                ", userId=" + userId +
                ", fullName='" + fullName + '\'' +
                ", city='" + city + '\'' +
                ", state='" + state + '\'' +
                ", pincode='" + pincode + '\'' +
                ", addressType='" + addressType + '\'' +
                ", isDefault=" + isDefault +
                '}';
    }
}
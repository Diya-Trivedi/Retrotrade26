package Retrotrade.repository;

import Retrotrade.entity.AddressEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

@Repository
public interface AddressRepository extends JpaRepository<AddressEntity, Integer> {
    
    // Find all addresses by user ID
    List<AddressEntity> findByUserId(Integer userId);
    
    // Find default address for a user
    Optional<AddressEntity> findByUserIdAndIsDefaultTrue(Integer userId);
    
    // Find addresses by user and address type
    List<AddressEntity> findByUserIdAndAddressType(Integer userId, String addressType);
    
    // Reset default address for a user (set all to false)
    @Modifying
    @Transactional
    @Query("UPDATE AddressEntity a SET a.isDefault = false WHERE a.userId = :userId")
    void resetDefaultAddress(@Param("userId") Integer userId);
    
    // Set specific address as default
    @Modifying
    @Transactional
    @Query("UPDATE AddressEntity a SET a.isDefault = true WHERE a.addressId = :addressId AND a.userId = :userId")
    void setAsDefaultAddress(@Param("addressId") Integer addressId, @Param("userId") Integer userId);
    
    // Check if user has any default address
    boolean existsByUserIdAndIsDefaultTrue(Integer userId);
    
    // Count addresses for a user
    long countByUserId(Integer userId);
    
    // Delete all addresses by user ID
    void deleteByUserId(Integer userId);
}
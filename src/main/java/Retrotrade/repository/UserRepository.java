package Retrotrade.repository;

import Retrotrade.entity.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<UserEntity, Integer> {
    
    // Find user by email
    Optional<UserEntity> findByEmail(String email);
    
    // Check if email exists
    boolean existsByEmail(String email);
    
    // Find users by role
    List<UserEntity> findByRole(String role);
    
    // Find active users
    List<UserEntity> findByActiveTrue();
    
    // Find users by contact number
    Optional<UserEntity> findByContactNum(String contactNum);
    
    // Custom query to find users with addresses
    @Query("SELECT u FROM UserEntity u LEFT JOIN FETCH u.addresses WHERE u.userId = :userId")
    Optional<UserEntity> findUserWithAddresses(@Param("userId") Integer userId);
    
    // Find users by name containing keyword
    List<UserEntity> findByFirstNameContainingOrLastNameContaining(String firstName, String lastName);
}
package Retrotrade.controller;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.cloudinary.Cloudinary;

import Retrotrade.entity.AddressEntity;
import Retrotrade.entity.UserEntity;
import Retrotrade.repository.AddressRepository;
import Retrotrade.repository.UserRepository;
import Retrotrade.service.MailerService;
import jakarta.servlet.http.HttpSession;

@Controller
public class UserController {

    @Autowired
    private MailerService mailerService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AddressRepository addressRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private Cloudinary cloudinary;

    // ========================= USER REGISTRATION =========================
    @PostMapping("/register")
    public String userRegistration(UserEntity userEntity,
                                   AddressEntity addressEntity,
                                   @RequestParam("confirmPassword") String confirmPassword,
                                   @RequestParam(value = "profilePic", required = false) MultipartFile profilePic,
                                   RedirectAttributes redirectAttributes) {

        // Validate passwords match
        if (!userEntity.getPassword().equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("error", "Passwords do not match!");
            return "redirect:/signup";
        }

        try {
            Optional<UserEntity> existingUser = userRepository.findByEmail(userEntity.getEmail());
            if (existingUser.isPresent()) {
                redirectAttributes.addFlashAttribute("error", "Email already registered!");
                return "redirect:/signup";
            }

            if (profilePic != null && !profilePic.isEmpty()) {
                Map<?, ?> uploadResult =
                        cloudinary.uploader().upload(profilePic.getBytes(), 
                                com.cloudinary.utils.ObjectUtils.asMap(
                                    "folder", "retrotrade/profiles",
                                    "resource_type", "auto"
                                ));
                userEntity.setProfilePicURL(
                        uploadResult.get("secure_url").toString());
            }

        } catch (IOException e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Error uploading profile picture!");
            return "redirect:/signup";
        }

        userEntity.setRole("USER");
        userEntity.setActive(true);
        userEntity.setCreatedAt(LocalDate.now());
        userEntity.setPassword(passwordEncoder.encode(userEntity.getPassword()));

        UserEntity savedUser = userRepository.save(userEntity);

        addressEntity.setIsDefault(true);
        addressEntity.setFullName(userEntity.getFirstName() + " " + userEntity.getLastName());
        addressEntity.setMobileNo(userEntity.getContactNum());
        addressEntity.setUserId(savedUser.getUserId());

        addressRepository.save(addressEntity);

        // Send welcome mail
        mailerService.sendWelcomeMail(userEntity);

        redirectAttributes.addFlashAttribute("success", "Registration successful! Please login.");
        return "redirect:/login";
    }

    // ========================= SEND OTP FOR FORGOT PASSWORD =========================
    @PostMapping("/send-otp")
    public String sendOtp(@RequestParam String email, RedirectAttributes redirectAttributes) {
        
        Optional<UserEntity> userOpt = userRepository.findByEmail(email);
        
        if (userOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Email not registered!");
            return "redirect:/forgotPassword";
        }
        
        UserEntity user = userOpt.get();
        
        // Generate 6-digit OTP
        String otp = String.format("%06d", new Random().nextInt(999999));
        user.setOtp(otp);
        userRepository.save(user);
        
        // Send OTP email
        mailerService.sendOtpMail(email, otp);
        
        redirectAttributes.addFlashAttribute("success", "OTP sent to your email!");
        return "redirect:/verifyOtp?email=" + email;
    }

    // ========================= VERIFY OTP =========================
    @PostMapping("/verify-otp")
    public String verifyOtp(@RequestParam String email, @RequestParam String otp, 
                            RedirectAttributes redirectAttributes) {
        
        Optional<UserEntity> userOpt = userRepository.findByEmail(email);
        
        if (userOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "User not found!");
            return "redirect:/forgotPassword";
        }
        
        UserEntity user = userOpt.get();
        
        if (user.getOtp() == null || !user.getOtp().equals(otp)) {
            redirectAttributes.addFlashAttribute("error", "Invalid OTP!");
            return "redirect:/verifyOtp?email=" + email;
        }
        
        redirectAttributes.addFlashAttribute("success", "OTP verified successfully!");
        return "redirect:/resetPassword?email=" + email;
    }

    // ========================= UPDATE PASSWORD =========================
    @PostMapping("/update-password")
    public String updatePassword(@RequestParam String email, 
                                 @RequestParam String password,
                                 @RequestParam String confirmPassword,
                                 RedirectAttributes redirectAttributes) {
        
        if (!password.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("error", "Passwords do not match!");
            return "redirect:/resetPassword?email=" + email;
        }
        
        Optional<UserEntity> userOpt = userRepository.findByEmail(email);
        
        if (userOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "User not found!");
            return "redirect:/forgotPassword";
        }
        
        UserEntity user = userOpt.get();
        user.setPassword(passwordEncoder.encode(password));
        user.setOtp(null); // Clear OTP after use
        userRepository.save(user);
        
        redirectAttributes.addFlashAttribute("success", "Password updated successfully! Please login.");
        return "redirect:/login";
    }

    // ========================= LIST USERS (ADMIN ONLY) =========================
    @GetMapping("/listUser")
    public String listUserDetails(HttpSession session, 
                                  Model model,
                                  RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }
        
        if (!"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "You don't have permission to access this page!");
            return "redirect:/index";
        }

        List<UserEntity> userList = userRepository.findAll();
        model.addAttribute("userList", userList);

        return "admin/listUser";
    }

    // ========================= VIEW USER =========================
    @GetMapping("/viewUser")
    public String viewUserDetails(@RequestParam Integer userId, 
                                  HttpSession session,
                                  Model model,
                                  RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }
        
        Optional<UserEntity> optionalUser = userRepository.findById(userId);
        if (optionalUser.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "User not found!");
            return "redirect:/index";
        }
        
        UserEntity userEntity = optionalUser.get();
        
        if (!"ADMIN".equals(currentUser.getRole()) && !currentUser.getUserId().equals(userId)) {
            redirectAttributes.addFlashAttribute("error", "You don't have permission to view this profile!");
            return "redirect:/index";
        }
        
        List<AddressEntity> addressList = addressRepository.findByUserId(userId);
        
        AddressEntity defaultAddress = addressList.stream()
                .filter(addr -> addr.getIsDefault() != null && addr.getIsDefault())
                .findFirst()
                .orElse(null);

        model.addAttribute("userEntity", userEntity);
        model.addAttribute("addressList", addressList);
        model.addAttribute("defaultAddress", defaultAddress);
        model.addAttribute("address", defaultAddress);

        return "admin/viewUser";
    }

    // ========================= DELETE USER (ADMIN ONLY) =========================
    @GetMapping("/deleteUser")
    public String deleteUser(@RequestParam Integer userId,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }
        
        if (!"ADMIN".equals(currentUser.getRole())) {
            redirectAttributes.addFlashAttribute("error", "You don't have permission to delete users!");
            return "redirect:/index";
        }
        
        if (currentUser.getUserId().equals(userId)) {
            redirectAttributes.addFlashAttribute("error", "You cannot delete your own account!");
            return "redirect:/listUser";
        }

        if (userRepository.existsById(userId)) {

            List<AddressEntity> addressList = addressRepository.findByUserId(userId);
            for (AddressEntity address : addressList) {
                addressRepository.deleteById(address.getAddressId());
            }

            userRepository.deleteById(userId);
            redirectAttributes.addFlashAttribute("success", "User deleted successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "User not found!");
        }

        return "redirect:/listUser";
    }

    // ========================= EDIT USER =========================
    @GetMapping("/editUser")
    public String editUser(@RequestParam Integer userId, 
                           HttpSession session,
                           Model model,
                           RedirectAttributes redirectAttributes) {

        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }
        
        Optional<UserEntity> optionalUser = userRepository.findById(userId);
        if (optionalUser.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "User not found!");
            return "redirect:/index";
        }
        
        UserEntity userEntity = optionalUser.get();
        
        if (!"ADMIN".equals(currentUser.getRole()) && !currentUser.getUserId().equals(userId)) {
            redirectAttributes.addFlashAttribute("error", "You don't have permission to edit this profile!");
            return "redirect:/index";
        }
        
        List<AddressEntity> addressList = addressRepository.findByUserId(userId);
        
        AddressEntity defaultAddress = addressList.stream()
                .filter(addr -> addr.getIsDefault() != null && addr.getIsDefault())
                .findFirst()
                .orElse(null);
        
        if (addressList.isEmpty()) {
            AddressEntity newAddress = new AddressEntity();
            newAddress.setUserId(userId);
            newAddress.setFullName(userEntity.getFirstName() + " " + userEntity.getLastName());
            newAddress.setMobileNo(userEntity.getContactNum());
            model.addAttribute("address", newAddress);
        } else {
            model.addAttribute("address", defaultAddress != null ? defaultAddress : addressList.get(0));
        }

        model.addAttribute("userEntity", userEntity);
        model.addAttribute("addressList", addressList);

        return "editUser";
    }

    // ========================= UPDATE USER =========================
    @PostMapping("/updateUser")
    public String updateUser(UserEntity userEntity,
                             AddressEntity addressEntity,
                             @RequestParam(required = false) MultipartFile profilePic,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {

        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) return "redirect:/login";

        Optional<UserEntity> optionalUser = userRepository.findById(userEntity.getUserId());
        if (optionalUser.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "User not found!");
            return "redirect:/index";
        }

        UserEntity existingUser = optionalUser.get();
        if (!"ADMIN".equals(currentUser.getRole()) && !currentUser.getUserId().equals(userEntity.getUserId())) {
            redirectAttributes.addFlashAttribute("error", "Permission denied!");
            return "redirect:/index";
        }

        // Handle profile picture upload
        if (profilePic != null && !profilePic.isEmpty()) {
            try {
                Map<?, ?> uploadResult = cloudinary.uploader().upload(profilePic.getBytes(),
                    com.cloudinary.utils.ObjectUtils.asMap("folder", "retrotrade/profiles", "resource_type", "auto"));
                userEntity.setProfilePicURL(uploadResult.get("secure_url").toString());
            } catch (IOException e) {
                redirectAttributes.addFlashAttribute("error", "Error uploading profile picture!");
            }
        } else {
            userEntity.setProfilePicURL(existingUser.getProfilePicURL());
        }

        // Preserve sensitive fields
        userEntity.setCreatedAt(existingUser.getCreatedAt());
        userEntity.setPassword(existingUser.getPassword());
        userEntity.setRole(existingUser.getRole());
        userEntity.setActive(existingUser.getActive());
        userEntity.setOtp(existingUser.getOtp());
     // Preserve existing email (since it's not editable in the form)
        userEntity.setEmail(existingUser.getEmail());

        userRepository.save(userEntity);

        // Update session
        if (currentUser.getUserId().equals(userEntity.getUserId())) {
            session.setAttribute("user", userEntity);
        }

        redirectAttributes.addFlashAttribute("success", "Profile updated successfully!");
        return "redirect:/viewUser?userId=" + userEntity.getUserId();
    }
    // ========================= MY PROFILE (SHORTCUT) =========================
    @GetMapping("/profile")
    public String myProfile(HttpSession session,
                            RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }
        
        return "redirect:/viewUser?userId=" + currentUser.getUserId();
    }
}
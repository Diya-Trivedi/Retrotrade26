package Retrotrade.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import Retrotrade.entity.AddressEntity;
import Retrotrade.entity.UserEntity;
import Retrotrade.repository.AddressRepository;
import Retrotrade.repository.UserRepository;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/address")
public class AddressController {
    
    @Autowired
    private AddressRepository addressRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    // ========================= LIST ALL ADDRESSES =========================
    
    @GetMapping("/list")
    public String listAddresses(HttpSession session, 
                                Model model, 
                                RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }
        
        List<AddressEntity> addressList = addressRepository.findByUserId(currentUser.getUserId());
        model.addAttribute("addressList", addressList);
        
        return "address/list";
    }
    
    // ========================= SHOW ADD ADDRESS FORM =========================
    
    @GetMapping("/add")
    public String showAddForm(HttpSession session, 
                              Model model, 
                              RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }
        
        model.addAttribute("address", new AddressEntity());
        return "address/add";
    }
    
    // ========================= ADD NEW ADDRESS =========================
    
    @PostMapping("/save")
    public String saveAddress(AddressEntity addressEntity,
                              @RequestParam(value = "setAsDefault", required = false) boolean setAsDefault,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }
        
        Optional<UserEntity> userOpt = userRepository.findById(currentUser.getUserId());
        if (userOpt.isPresent()) {
            addressEntity.setUserId(currentUser.getUserId());
            
            // Check if this is the first address
            long addressCount = addressRepository.countByUserId(currentUser.getUserId());
            
            if (addressCount == 0) {
                // First address, automatically set as default
                addressEntity.setIsDefault(true);
            } else if (setAsDefault) {
                // Reset other defaults
                addressRepository.resetDefaultAddress(currentUser.getUserId());
                addressEntity.setIsDefault(true);
            } else {
                addressEntity.setIsDefault(false);
            }
            
            addressRepository.save(addressEntity);
            redirectAttributes.addFlashAttribute("success", "Address added successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "User not found!");
        }
        
        return "redirect:/address/list";
    }
    
    // ========================= SHOW EDIT ADDRESS FORM =========================
    
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Integer addressId,
                               HttpSession session,
                               Model model,
                               RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }
        
        Optional<AddressEntity> addressOpt = addressRepository.findById(addressId);
        if (addressOpt.isPresent()) {
            AddressEntity address = addressOpt.get();
            
            // Verify ownership
            if (!address.getUserId().equals(currentUser.getUserId())) {
                redirectAttributes.addFlashAttribute("error", "You don't have permission to edit this address!");
                return "redirect:/address/list";
            }
            
            model.addAttribute("address", address);
            return "address/edit";
        } else {
            redirectAttributes.addFlashAttribute("error", "Address not found!");
            return "redirect:/address/list";
        }
    }
    
    // ========================= UPDATE ADDRESS =========================
    
    @PostMapping("/update")
    public String updateAddress(AddressEntity addressEntity,
                                @RequestParam(value = "setAsDefault", required = false) boolean setAsDefault,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }
        
        Optional<AddressEntity> existingAddressOpt = addressRepository.findById(addressEntity.getAddressId());
        if (existingAddressOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Address not found!");
            return "redirect:/address/list";
        }
        
        AddressEntity existingAddress = existingAddressOpt.get();
        
        // Verify ownership
        if (!existingAddress.getUserId().equals(currentUser.getUserId())) {
            redirectAttributes.addFlashAttribute("error", "You don't have permission to update this address!");
            return "redirect:/address/list";
        }
        
        // Update fields
        existingAddress.setFullName(addressEntity.getFullName());
        existingAddress.setMobileNo(addressEntity.getMobileNo());
        existingAddress.setAddressLine1(addressEntity.getAddressLine1());
        existingAddress.setCity(addressEntity.getCity());
        existingAddress.setState(addressEntity.getState());
        existingAddress.setPincode(addressEntity.getPincode());
        existingAddress.setAddressType(addressEntity.getAddressType());
        
        // Handle default status
        if (setAsDefault && !existingAddress.getIsDefault()) {
            addressRepository.resetDefaultAddress(currentUser.getUserId());
            existingAddress.setIsDefault(true);
        } else if (!setAsDefault && existingAddress.getIsDefault()) {
            // Check if this is the only address
            long addressCount = addressRepository.countByUserId(currentUser.getUserId());
            if (addressCount > 1) {
                existingAddress.setIsDefault(false);
            } else {
                redirectAttributes.addFlashAttribute("error", "Cannot remove default status from the only address!");
                return "redirect:/address/edit/" + addressEntity.getAddressId();
            }
        }
        
        addressRepository.save(existingAddress);
        redirectAttributes.addFlashAttribute("success", "Address updated successfully!");
        
        return "redirect:/address/list";
    }
    
    // ========================= DELETE ADDRESS =========================
    
    @GetMapping("/delete/{id}")
    public String deleteAddress(@PathVariable("id") Integer addressId,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }
        
        Optional<AddressEntity> addressOpt = addressRepository.findById(addressId);
        if (addressOpt.isPresent()) {
            AddressEntity address = addressOpt.get();
            
            // Verify ownership
            if (!address.getUserId().equals(currentUser.getUserId())) {
                redirectAttributes.addFlashAttribute("error", "You don't have permission to delete this address!");
                return "redirect:/address/list";
            }
            
            // Check if this is the default address
            boolean wasDefault = address.getIsDefault();
            
            addressRepository.delete(address);
            
            // If we deleted the default address, set another one as default
            if (wasDefault) {
                List<AddressEntity> remainingAddresses = addressRepository.findByUserId(currentUser.getUserId());
                if (!remainingAddresses.isEmpty()) {
                    AddressEntity newDefault = remainingAddresses.get(0);
                    newDefault.setIsDefault(true);
                    addressRepository.save(newDefault);
                }
            }
            
            redirectAttributes.addFlashAttribute("success", "Address deleted successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Address not found!");
        }
        
        return "redirect:/address/list";
    }
    
    // ========================= SET ADDRESS AS DEFAULT =========================
    
    @GetMapping("/set-default/{id}")
    public String setDefaultAddress(@PathVariable("id") Integer addressId,
                                    HttpSession session,
                                    RedirectAttributes redirectAttributes) {
        
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }
        
        Optional<AddressEntity> addressOpt = addressRepository.findById(addressId);
        if (addressOpt.isPresent()) {
            AddressEntity address = addressOpt.get();
            
            // Verify ownership
            if (!address.getUserId().equals(currentUser.getUserId())) {
                redirectAttributes.addFlashAttribute("error", "You don't have permission to modify this address!");
                return "redirect:/address/list";
            }
            
            // Reset all defaults for this user
            addressRepository.resetDefaultAddress(currentUser.getUserId());
            
            // Set this address as default
            address.setIsDefault(true);
            addressRepository.save(address);
            
            redirectAttributes.addFlashAttribute("success", "Default address updated!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Address not found!");
        }
        
        return "redirect:/address/list";
    }
}
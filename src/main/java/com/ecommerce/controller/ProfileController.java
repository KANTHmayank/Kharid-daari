package com.ecommerce.controller;

import com.ecommerce.model.Address;
import com.ecommerce.model.Order;
import com.ecommerce.model.User;
import com.ecommerce.service.AddressService;
import com.ecommerce.service.OrderService;
import com.ecommerce.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/profile")
public class ProfileController {

    @Autowired
    private UserService userService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private AddressService addressService;

    @GetMapping
    public String viewProfile(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        
        if (userId == null) {
            return "redirect:/login";
        }

        User user = userService.findById(userId);
        model.addAttribute("user", user);

        return "profile";
    }

    @GetMapping("/orders")
    public String viewOrders(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        
        if (userId == null) {
            return "redirect:/login";
        }

        List<Order> orders = orderService.getUserOrders(userId);
        model.addAttribute("orders", orders);

        return "orders";
    }

    @PostMapping("/update")
    public String updateProfile(@RequestParam String firstName,
                               @RequestParam String lastName,
                               @RequestParam String email,
                               @RequestParam String phone,
                               HttpSession session,
                               Model model) {
        Long userId = (Long) session.getAttribute("userId");
        
        if (userId == null) {
            return "redirect:/login";
        }

        try {
            String fullName = firstName.trim() + " " + lastName.trim();
            userService.updateProfile(userId, fullName, email, phone);
            session.setAttribute("userName", fullName);
            model.addAttribute("success", "Profile updated successfully!");
            
            User user = userService.findById(userId);
            model.addAttribute("user", user);
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            User user = userService.findById(userId);
            model.addAttribute("user", user);
        }

        return "profile";
    }

    @PostMapping("/change-password")
    public String changePassword(@RequestParam String currentPassword,
                                @RequestParam String newPassword,
                                @RequestParam String confirmPassword,
                                HttpSession session,
                                Model model) {
        Long userId = (Long) session.getAttribute("userId");
        
        if (userId == null) {
            return "redirect:/login";
        }

        try {
            // Validate new password matches confirmation
            if (!newPassword.equals(confirmPassword)) {
                throw new RuntimeException("New passwords do not match");
            }

            // Validate password strength
            if (!newPassword.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$")) {
                throw new RuntimeException("Password must be at least 8 characters with uppercase, lowercase, number, and special character");
            }

            userService.updatePassword(userId, currentPassword, newPassword);
            model.addAttribute("success", "Password changed successfully!");
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
        }

        User user = userService.findById(userId);
        model.addAttribute("user", user);

        return "profile";
    }

    @GetMapping("/addresses")
    public String viewAddresses(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        
        if (userId == null) {
            return "redirect:/login";
        }

        List<Address> addresses = addressService.getUserAddresses(userId);
        model.addAttribute("addresses", addresses);

        return "addresses";
    }

    @PostMapping("/address/add")
    public String addAddress(@RequestParam String line1,
                            @RequestParam(required = false) String line2,
                            @RequestParam String city,
                            @RequestParam(required = false) String state,
                            @RequestParam(required = false) String postalCode,
                            @RequestParam String country,
                            @RequestParam(required = false, defaultValue = "false") boolean isDefault,
                            HttpSession session,
                            Model model) {
        Long userId = (Long) session.getAttribute("userId");
        
        if (userId == null) {
            return "redirect:/login";
        }

        try {
            Address address = new Address(userId, line1, line2, city, state, postalCode, country, isDefault);
            addressService.addAddress(address);
            model.addAttribute("success", "Address added successfully!");
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
        }

        List<Address> addresses = addressService.getUserAddresses(userId);
        model.addAttribute("addresses", addresses);

        return "addresses";
    }

    @PostMapping("/address/update")
    public String updateAddress(@RequestParam Long id,
                               @RequestParam String line1,
                               @RequestParam(required = false) String line2,
                               @RequestParam String city,
                               @RequestParam(required = false) String state,
                               @RequestParam(required = false) String postalCode,
                               @RequestParam String country,
                               @RequestParam(required = false, defaultValue = "false") boolean isDefault,
                               HttpSession session,
                               Model model) {
        Long userId = (Long) session.getAttribute("userId");
        
        if (userId == null) {
            return "redirect:/login";
        }

        try {
            Address address = new Address(userId, line1, line2, city, state, postalCode, country, isDefault);
            address.setId(id);
            addressService.updateAddress(address);
            model.addAttribute("success", "Address updated successfully!");
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
        }

        List<Address> addresses = addressService.getUserAddresses(userId);
        model.addAttribute("addresses", addresses);

        return "addresses";
    }

    @PostMapping("/address/delete")
    public String deleteAddress(@RequestParam Long id,
                               HttpSession session,
                               Model model) {
        Long userId = (Long) session.getAttribute("userId");
        
        if (userId == null) {
            return "redirect:/login";
        }

        try {
            addressService.deleteAddress(id, userId);
            model.addAttribute("success", "Address deleted successfully!");
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
        }

        List<Address> addresses = addressService.getUserAddresses(userId);
        model.addAttribute("addresses", addresses);

        return "addresses";
    }

    @PostMapping("/address/set-default")
    public String setDefaultAddress(@RequestParam Long id,
                                   HttpSession session,
                                   Model model) {
        Long userId = (Long) session.getAttribute("userId");
        
        if (userId == null) {
            return "redirect:/login";
        }

        try {
            addressService.setDefaultAddress(id, userId);
            model.addAttribute("success", "Default address updated!");
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
        }

        List<Address> addresses = addressService.getUserAddresses(userId);
        model.addAttribute("addresses", addresses);

        return "addresses";
    }}
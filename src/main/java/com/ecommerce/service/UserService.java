package com.ecommerce.service;

import com.ecommerce.model.User;
import com.ecommerce.repository.UserRepository;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;    
    public User register(User user) {
        // Check if email already exists
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new RuntimeException("Email already registered");
        }

        // Validate phone number format (exactly 10 digits)
        if (user.getPhone() == null || !user.getPhone().matches("^[0-9]{10}$")) {
            throw new RuntimeException("Phone number must be exactly 10 digits");
        }

        // Hash the password
        String hashedPassword = BCrypt.hashpw(user.getPasswordHash(), BCrypt.gensalt());
        user.setPasswordHash(hashedPassword);

        // Save user
        return userRepository.save(user);
    }

    public User login(String email, String password) {
        User user = userRepository.findByEmail(email);
        
        if (user == null) {
            return null; // User not found
        }

        // Verify password
        if (BCrypt.checkpw(password, user.getPasswordHash())) {
            return user;
        }

        return null; // Invalid password
    }

    public User findById(Long id) {
        return userRepository.findById(id);
    }

    public User findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    public void updateProfile(Long userId, String name, String email, String phone) {
        // Validate email format
        if (email == null || !email.matches("^[a-zA-Z0-9][a-zA-Z0-9._%+\\-]*@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}$")) {
            throw new RuntimeException("Invalid email format");
        }
        
        // Check if email is already used by another user
        if (userRepository.existsByEmailExcludingUserId(email, userId)) {
            throw new RuntimeException("Email is already in use by another account");
        }
        
        // Validate phone number format
        if (phone != null && !phone.matches("^[0-9]{10}$")) {
            throw new RuntimeException("Phone number must be exactly 10 digits");
        }
        userRepository.updateProfile(userId, name, email, phone);
    }

    public void updatePassword(Long userId, String currentPassword, String newPassword) {
        User user = userRepository.findById(userId);
        
        if (user == null) {
            throw new RuntimeException("User not found");
        }

        // Verify current password
        if (!BCrypt.checkpw(currentPassword, user.getPasswordHash())) {
            throw new RuntimeException("Current password is incorrect");
        }

        // Hash new password
        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        userRepository.updatePassword(userId, hashedPassword);
    }
}

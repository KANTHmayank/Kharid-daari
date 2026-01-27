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
        // Login only allowed with primary email, not recovery email
        User user = userRepository.findByEmailForLogin(email);
        
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

    public void updateProfile(Long userId, String name, String email, String recoveryEmail, String phone) {
        // Validate email format
        if (email == null || !email.matches("^[a-zA-Z0-9][a-zA-Z0-9._%+\\-]*@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}$")) {
            throw new RuntimeException("Invalid email format");
        }
        
        // Validate recovery email format if provided
        if (recoveryEmail != null && !recoveryEmail.isEmpty()) {
            if (!recoveryEmail.matches("^[a-zA-Z0-9][a-zA-Z0-9._%+\\-]*@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}$")) {
                throw new RuntimeException("Invalid recovery email format");
            }
            if (recoveryEmail.equals(email)) {
                throw new RuntimeException("Recovery email cannot be the same as primary email");
            }
        } else {
             recoveryEmail = null; // Ensure empty string becomes null
        }
        
        // Check if email is already used by another user
        if (userRepository.existsByEmailExcludingUserId(email, userId)) {
            throw new RuntimeException("Email is already in use by another account");
        }
        
        // Check if recovery email is already used by another user (optional, but good practice)
        if (recoveryEmail != null && userRepository.existsByEmailExcludingUserId(recoveryEmail, userId)) {
            throw new RuntimeException("Recovery email is already in use by another account");
        }
        
        // Validate phone number format
        if (phone != null && !phone.matches("^[0-9]{10}$")) {
            throw new RuntimeException("Phone number must be exactly 10 digits");
        }
        userRepository.updateProfile(userId, name, email, recoveryEmail, phone);
    }

    public boolean verifyPassword(Long userId, String password) {
        User user = userRepository.findById(userId);
        if (user == null) {
            return false;
        }
        return BCrypt.checkpw(password, user.getPasswordHash());
    }

    public void updatePassword(Long userId, String currentPassword, String newPassword) {
        if (!verifyPassword(userId, currentPassword)) {
            throw new RuntimeException("Current password is incorrect");
        }

        // Hash new password
        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        userRepository.updatePassword(userId, hashedPassword);
    }

    public void swapEmails(Long userId) {
        User user = userRepository.findById(userId);
        if (user == null) {
            throw new RuntimeException("User not found");
        }
        
        String backup = user.getRecoveryEmail();
        if (backup == null || backup.isEmpty()) {
            throw new RuntimeException("No recovery email to swap with");
        }
        
        String primary = user.getEmail();
        
        // Check if new primary (old recovery) is in use by someone else
        if (userRepository.existsByEmailExcludingUserId(backup, userId)) {
            throw new RuntimeException("Recovery email is already associated with another account");
        }
        
        updateProfile(userId, user.getName(), backup, primary, user.getPhone());
    }
}

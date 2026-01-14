<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Kharid-daari</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <jsp:include page="includes/header.jsp" />

    <div class="auth-container">
        <div class="auth-card">
            <h2>Create Account</h2>
            
            <c:if test="${not empty error}">
                <div class="alert alert-error">${error}</div>
            </c:if>            <form action="${pageContext.request.contextPath}/register" method="post" onsubmit="return validateRegistration()">
                <div class="form-group">
                    <label for="firstName">First Name</label>
                    <input type="text" id="firstName" name="firstName" required placeholder="Enter your first name" pattern="[A-Z][a-zA-Z]{1,49}" minlength="2" maxlength="50" title="First name must start with a capital letter and contain only letters (2-50 characters)">
                    <small class="form-text">Must start with capital letter, only letters allowed (2-50 characters)</small>
                </div>

                <div class="form-group">
                    <label for="lastName">Last Name</label>
                    <input type="text" id="lastName" name="lastName" required placeholder="Enter your last name" pattern="[A-Z][a-zA-Z]{1,49}" minlength="2" maxlength="50" title="Last name must start with a capital letter and contain only letters (2-50 characters)">
                    <small class="form-text">Must start with capital letter, only letters allowed (2-50 characters)</small>
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" required placeholder="Enter your email" pattern="[a-zA-Z0-9][a-zA-Z0-9._%+\-]*@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}" title="Email must start with a letter or number, followed by valid characters (e.g., user@example.com)">
                    <small class="form-text">Must be a valid email address (e.g., user@example.com)</small>
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="tel" id="phone" name="phone" required placeholder="Enter 10-digit phone number" pattern="[0-9]{10}" title="Phone number must be exactly 10 digits">
                    <small class="form-text">Must be exactly 10 digits</small>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required placeholder="Create a password" minlength="8" oninput="checkPasswordMatch()">
                    <small class="form-text">At least 8 characters with uppercase, lowercase, number, and special character</small>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required placeholder="Re-enter your password" minlength="8" oninput="checkPasswordMatch()">
                    <small id="passwordMatchMessage" class="form-text"></small>
                </div>

                <button type="submit" class="btn btn-primary btn-block">Register</button>
            </form>

            <script>
                function checkPasswordMatch() {
                    const password = document.getElementById('password').value;
                    const confirmPassword = document.getElementById('confirmPassword').value;
                    const messageElement = document.getElementById('passwordMatchMessage');
                    const confirmPasswordInput = document.getElementById('confirmPassword');

                    if (confirmPassword === '') {
                        messageElement.textContent = '';
                        messageElement.style.color = '';
                        confirmPasswordInput.style.borderColor = '';
                        return;
                    }

                    if (password === confirmPassword) {
                        messageElement.textContent = '✓ Passwords match';
                        messageElement.style.color = '#28a745';
                        confirmPasswordInput.style.borderColor = '#28a745';
                    } else {
                        messageElement.textContent = '✗ Passwords do not match';
                        messageElement.style.color = '#dc3545';
                        confirmPasswordInput.style.borderColor = '#dc3545';
                    }
                }

                function validateRegistration() {
                    // Get form values
                    const firstName = document.getElementById('firstName').value;
                    const lastName = document.getElementById('lastName').value;
                    const email = document.getElementById('email').value;
                    const phone = document.getElementById('phone').value;
                    const password = document.getElementById('password').value;
                    const confirmPassword = document.getElementById('confirmPassword').value;

                    // Validate first name
                    const namePattern = /^[A-Z][a-zA-Z]{1,49}$/;
                    if (!namePattern.test(firstName)) {
                        alert('First name must:\n- Start with a capital letter\n- Contain only letters (no numbers or special characters)\n- Be between 2-50 characters');
                        return false;
                    }

                    // Validate last name
                    if (!namePattern.test(lastName)) {
                        alert('Last name must:\n- Start with a capital letter\n- Contain only letters (no numbers or special characters)\n- Be between 2-50 characters');
                        return false;
                    }

                    // Validate email format
                    const emailPattern = /^[a-zA-Z0-9][a-zA-Z0-9._%+\-]*@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$/;
                    if (!emailPattern.test(email)) {
                        alert('Email must start with a letter or number and be a valid email address (e.g., user@example.com)');
                        return false;
                    }

                    // Validate phone number (exactly 10 digits)
                    const phonePattern = /^[0-9]{10}$/;
                    if (!phonePattern.test(phone)) {
                        alert('Phone number must be exactly 10 digits');
                        return false;
                    }

                    // Validate password strength
                    const passwordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
                    if (!passwordPattern.test(password)) {
                        alert('Password must be at least 8 characters and contain:\n- At least one uppercase letter\n- At least one lowercase letter\n- At least one number\n- At least one special character (@$!%*?&)');
                        return false;
                    }

                    // Check if passwords match
                    if (password !== confirmPassword) {
                        alert('Passwords do not match. Please try again.');
                        return false;
                    }

                    return true;
                }
            </script>

            <p class="auth-footer">
                Already have an account? <a href="${pageContext.request.contextPath}/login">Login here</a>
            </p>
        </div>
    </div>

    <jsp:include page="includes/footer.jsp" />
</body>
</html>

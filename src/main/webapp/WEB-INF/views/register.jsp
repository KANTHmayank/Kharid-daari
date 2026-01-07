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
                    <input type="text" id="firstName" name="firstName" required placeholder="Enter your first name">
                </div>

                <div class="form-group">
                    <label for="lastName">Last Name</label>
                    <input type="text" id="lastName" name="lastName" required placeholder="Enter your last name">
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" required placeholder="Enter your email">
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="tel" id="phone" name="phone" required placeholder="Enter 10-digit phone number" pattern="[0-9]{10}" title="Phone number must be exactly 10 digits">
                    <small class="form-text">Must be exactly 10 digits</small>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required placeholder="Create a password" minlength="8">
                    <small class="form-text">At least 8 characters with uppercase, lowercase, number, and special character</small>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required placeholder="Re-enter your password" minlength="8">
                </div>

                <button type="submit" class="btn btn-primary btn-block">Register</button>
            </form>

            <script>
                function validateRegistration() {
                    // Get form values
                    const phone = document.getElementById('phone').value;
                    const password = document.getElementById('password').value;
                    const confirmPassword = document.getElementById('confirmPassword').value;

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

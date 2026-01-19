<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>My Profile - Kharid-daari</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                <style>
                    .profile-container {
                        max-width: 1200px;
                        margin: 2rem auto;
                        padding: 2rem;
                    }

                    .profile-tabs {
                        display: flex;
                        gap: 1rem;
                        margin-bottom: 2rem;
                        border-bottom: 2px solid #eee;
                    }

                    .profile-tab {
                        padding: 1rem 2rem;
                        background: none;
                        border: none;
                        border-bottom: 3px solid transparent;
                        cursor: pointer;
                        font-size: 1.1rem;
                        font-weight: 600;
                        color: #666;
                        transition: all 0.3s;
                    }

                    .profile-tab.active {
                        color: #667eea;
                        border-bottom-color: #667eea;
                    }

                    .tab-content {
                        display: none;
                    }

                    .tab-content.active {
                        display: block;
                    }

                    .profile-card {
                        background: white;
                        border-radius: 10px;
                        padding: 2rem;
                        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                        margin-bottom: 2rem;
                    }

                    .profile-card h3 {
                        color: #667eea;
                        margin-bottom: 1.5rem;
                    }

                    .profile-info {
                        display: grid;
                        gap: 1rem;
                    }

                    .info-row {
                        display: flex;
                        justify-content: space-between;
                        padding: 1rem;
                        border-bottom: 1px solid #eee;
                    }

                    .info-label {
                        font-weight: 600;
                        color: #666;
                    }

                    .info-value {
                        color: #333;
                    }

                    /* Override default valid style if present */
                    #currentPassword:valid {
                        border-color: #ddd;
                    }

                    #currentPassword:focus {
                        border-color: #667eea;
                    }

                    #currentPassword.valid-pass {
                        border-color: #28a745 !important;
                        background-color: #f8fff9;
                    }

                    #currentPassword.invalid-pass {
                        border-color: #dc3545 !important;
                        background-color: #fff8f8;
                    }
                </style>
            </head>

            <body>
                <jsp:include page="includes/header.jsp" />

                <div class="profile-container">
                    <h2>My Profile</h2>

                    <c:if test="${not empty success}">
                        <div class="alert alert-success"
                            style="background: #d4edda; color: #155724; padding: 1rem; border-radius: 5px; margin-bottom: 1rem;">
                            ${success}
                        </div>
                    </c:if>

                    <c:if test="${not empty error}">
                        <div class="alert alert-error"
                            style="background: #f8d7da; color: #721c24; padding: 1rem; border-radius: 5px; margin-bottom: 1rem;">
                            ${error}
                        </div>
                    </c:if>

                    <div class="profile-tabs">
                        <button class="profile-tab" id="tab-details" onclick="showTab('details')">Profile
                            Details</button>
                        <button class="profile-tab" id="tab-edit" onclick="showTab('edit')">Edit Profile</button>
                        <button class="profile-tab" id="tab-password" onclick="showTab('password')">Change
                            Password</button>
                        <button class="profile-tab"
                            onclick="window.location.href='${pageContext.request.contextPath}/profile/addresses'">Addresses</button>
                        <button class="profile-tab"
                            onclick="window.location.href='${pageContext.request.contextPath}/profile/orders'">Order
                            History</button>
                    </div>

                    <!-- Profile Details Tab -->
                    <div id="details-tab" class="tab-content active">
                        <div class="profile-card">
                            <h3>Account Information</h3>
                            <div class="profile-info">
                                <div class="info-row">
                                    <span class="info-label">Name:</span>
                                    <span class="info-value">${user.name}</span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Email:</span>
                                    <span class="info-value">${user.email}</span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Phone:</span>
                                    <span class="info-value">${user.phone}</span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Member Since:</span>
                                    <span class="info-value">
                                        <fmt:formatDate value="${user.createdAt}" pattern="MMM dd, yyyy" />
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Edit Profile Tab -->
                    <div id="edit-tab" class="tab-content">
                        <div class="profile-card">
                            <h3>Edit Profile Information</h3>
                            <form action="${pageContext.request.contextPath}/profile/update" method="post"
                                onsubmit="return validateProfileUpdate()">
                                <div class="form-group">
                                    <label for="firstName">First Name</label>
                                    <input type="text" id="firstName" name="firstName" required
                                        pattern="[A-Z][a-zA-Z]{1,49}"
                                        title="First name must start with capital letter and be 2-50 characters">
                                    <small class="form-text">2-50 characters, must start with a capital letter</small>
                                </div>

                                <div class="form-group">
                                    <label for="lastName">Last Name</label>
                                    <input type="text" id="lastName" name="lastName" required
                                        pattern="[A-Z][a-zA-Z]{1,49}"
                                        title="Last name must start with capital letter and be 2-50 characters">
                                    <small class="form-text">2-50 characters, must start with a capital letter</small>
                                </div>

                                <div class="form-group">
                                    <label for="phone">Phone Number</label>
                                    <input type="tel" id="phone" name="phone" value="${user.phone}" required
                                        pattern="[0-9]{10}" title="Phone must be exactly 10 digits">
                                    <small class="form-text">Must be exactly 10 digits</small>
                                </div>

                                <div class="form-group">
                                    <label for="email">Primary Email</label>
                                    <input type="email" id="email" name="email" value="${user.email}" readonly
                                        style="background-color: #e9ecef;">
                                    <small class="form-text">Primary email cannot be changed directly.</small>
                                </div>

                                <div class="form-group">
                                    <label for="backupEmail">Backup Email</label>
                                    <input type="email" id="backupEmail" name="backupEmail" value="${user.backupEmail}"
                                        pattern="[a-zA-Z0-9][a-zA-Z0-9._%+\-]*@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}"
                                        title="Enter a valid email address">
                                    <small class="form-text">Optional. Valid email address required.</small>
                                    <c:if test="${not empty user.backupEmail}">
                                        <div style="margin-top: 0.5rem;">
                                            <button type="button" class="btn btn-secondary"
                                                onclick="document.getElementById('swap-email-form').submit();">Make
                                                Primary</button>
                                        </div>
                                    </c:if>
                                </div>

                                <button type="submit" class="btn btn-primary btn-block">Update Profile</button>
                            </form>

                            <form id="swap-email-form" action="${pageContext.request.contextPath}/profile/swap-emails"
                                method="post" style="display: none;">
                            </form>
                        </div>
                    </div>

                    <!-- Change Password Tab -->
                    <div id="password-tab" class="tab-content">
                        <div class="profile-card">
                            <h3>Change Password</h3>
                            <form action="${pageContext.request.contextPath}/profile/change-password" method="post"
                                onsubmit="return validatePasswordChange()" id="changePasswordForm">
                                <div class="form-group">
                                    <label for="currentPassword">Current Password</label>
                                    <input type="password" id="currentPassword" name="currentPassword" required
                                        oninput="debouncedValidateCurrentPassword()">
                                    <small id="currentPasswordMsg" class="form-text"></small>
                                </div>

                                <div class="form-group">
                                    <label for="newPassword">New Password</label>
                                    <input type="password" id="newPassword" name="newPassword" required minlength="8"
                                        oninput="checkNewPasswordMatch()" disabled>
                                    <small class="form-text">At least 8 characters with uppercase, lowercase, number,
                                        and special character</small>
                                </div>

                                <div class="form-group">
                                    <label for="confirmPassword">Confirm New Password</label>
                                    <input type="password" id="confirmPassword" name="confirmPassword" required
                                        minlength="8" oninput="checkNewPasswordMatch()" disabled>
                                    <small id="passwordMatchMsg" class="form-text"></small>
                                </div>

                                <button type="submit" id="changePasswordBtn" class="btn btn-primary btn-block"
                                    disabled>Change Password</button>
                            </form>
                        </div>
                    </div>
                </div>

                <script>
                    // Split the full name into first and last name on page load
                    window.onload = function () {
                        const fullName = '${user.name}';
                        const nameParts = fullName.trim().split(' ');

                        if (nameParts.length >= 2) {
                            document.getElementById('firstName').value = nameParts[0];
                            document.getElementById('lastName').value = nameParts.slice(1).join(' ');
                        } else if (nameParts.length === 1) {
                            document.getElementById('firstName').value = nameParts[0];
                            document.getElementById('lastName').value = '';
                        }
                    };

                    function showTab(tabName) {
                        // Hide all tabs
                        document.querySelectorAll('.tab-content').forEach(tab => {
                            tab.classList.remove('active');
                        });
                        document.querySelectorAll('.profile-tab').forEach(tab => {
                            tab.classList.remove('active');
                        });

                        // Show selected tab
                        document.getElementById(tabName + '-tab').classList.add('active');
                        document.getElementById('tab-' + tabName).classList.add('active');

                        // Update URL hash
                        window.location.hash = tabName;
                    }

                    // Handle initial page load and hash changes
                    function loadTabFromHash() {
                        let hash = window.location.hash.substring(1); // Remove the '#'
                        if (hash && ['details', 'edit', 'password'].includes(hash)) {
                            showTab(hash);
                        } else {
                            // Default to details tab
                            showTab('details');
                        }
                    }

                    // Load correct tab on page load
                    window.addEventListener('DOMContentLoaded', loadTabFromHash);

                    // Handle browser back/forward buttons
                    window.addEventListener('hashchange', loadTabFromHash);

                    function validateProfileUpdate() {
                        const firstName = document.getElementById('firstName').value;
                        const lastName = document.getElementById('lastName').value;
                        const phone = document.getElementById('phone').value;
                        const backupEmail = document.getElementById('backupEmail').value;

                        if (!firstName.match(/^[A-Z][a-zA-Z]{1,49}$/)) {
                            alert('First name must start with a capital letter and be 2-50 characters');
                            return false;
                        }

                        if (!lastName.match(/^[A-Z][a-zA-Z]{1,49}$/)) {
                            alert('Last name must start with a capital letter and be 2-50 characters');
                            return false;
                        }

                        const emailPattern = /^[a-zA-Z0-9][a-zA-Z0-9._%+\-]*@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$/;
                        if (backupEmail && !emailPattern.test(backupEmail)) {
                            alert('Backup email must be a valid email address');
                            return false;
                        }

                        if (!phone.match(/^[0-9]{10}$/)) {
                            alert('Phone must be exactly 10 digits');
                            return false;
                        }

                        return true;
                    }

                    function checkNewPasswordMatch() {
                        const newPassword = document.getElementById('newPassword').value;
                        const confirmPassword = document.getElementById('confirmPassword').value;
                        const messageElement = document.getElementById('passwordMatchMsg');

                        if (confirmPassword === '') {
                            messageElement.textContent = '';
                            messageElement.style.color = '';
                            return;
                        }

                        if (newPassword === confirmPassword) {
                            messageElement.textContent = '✓ Passwords match';
                            messageElement.style.color = '#28a745';
                        } else {
                            messageElement.textContent = '✗ Passwords do not match';
                            messageElement.style.color = '#dc3545';
                        }
                    }

                    function validatePasswordChange() {
                        const newPassword = document.getElementById('newPassword').value;
                        const confirmPassword = document.getElementById('confirmPassword').value;

                        if (newPassword !== confirmPassword) {
                            alert('New passwords do not match');
                            return false;
                        }

                        const passwordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
                        if (!passwordPattern.test(newPassword)) {
                            alert('Password must be at least 8 characters and contain:\\n- At least one uppercase letter\\n- At least one lowercase letter\\n- At least one number\\n- At least one special character (@$!%*?&)');
                            return false;
                        }

                        return true;
                    }

                    // Debounce function to limit API calls
                    function debounce(func, wait) {
                        let timeout;
                        return function () {
                            const context = this;
                            const args = arguments;
                            clearTimeout(timeout);
                            timeout = setTimeout(() => func.apply(context, args), wait);
                        };
                    }

                    const debouncedValidateCurrentPassword = debounce(validateCurrentPassword, 500);

                    function validateCurrentPassword() {
                        const currentPasswordInput = document.getElementById('currentPassword');
                        const currentPassword = currentPasswordInput.value;
                        const msgElement = document.getElementById('currentPasswordMsg');
                        const newPasswordInput = document.getElementById('newPassword');
                        const confirmPasswordInput = document.getElementById('confirmPassword');
                        const submitBtn = document.getElementById('changePasswordBtn');

                        if (!currentPassword) {
                            msgElement.textContent = '';
                            currentPasswordInput.classList.remove('valid-pass', 'invalid-pass');
                            return;
                        }

                        fetch('${pageContext.request.contextPath}/profile/validate-password', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                            },
                            body: 'currentPassword=' + encodeURIComponent(currentPassword)
                        })
                            .then(response => {
                                if (!response.ok) {
                                    throw new Error('Network response was not ok');
                                }
                                return response.json();
                            })
                            .then(data => {
                                if (data.valid) {
                                    msgElement.textContent = '✓ Correct password';
                                    msgElement.style.color = '#28a745';
                                    currentPasswordInput.classList.remove('invalid-pass');
                                    currentPasswordInput.classList.add('valid-pass');
                                    newPasswordInput.disabled = false;
                                    confirmPasswordInput.disabled = false;
                                    submitBtn.disabled = false;
                                } else {
                                    msgElement.textContent = '✗ Incorrect password';
                                    msgElement.style.color = '#dc3545';
                                    currentPasswordInput.classList.remove('valid-pass');
                                    currentPasswordInput.classList.add('invalid-pass');
                                    newPasswordInput.disabled = true;
                                    confirmPasswordInput.disabled = true;
                                    submitBtn.disabled = true;
                                }
                            })
                            .catch(error => {
                                console.error('Error validating password:', error);
                                msgElement.textContent = '⚠️ Error validating password. Please try again.';
                                msgElement.style.color = '#e4620e';
                                currentPasswordInput.classList.remove('valid-pass');
                                currentPasswordInput.classList.add('invalid-pass');
                                newPasswordInput.disabled = true;
                                confirmPasswordInput.disabled = true;
                                submitBtn.disabled = true;
                            });
                    }
                </script>

                <jsp:include page="includes/footer.jsp" />
            </body>

            </html>
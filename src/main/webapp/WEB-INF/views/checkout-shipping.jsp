<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout - Shipping</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .checkout-container { max-width: 800px; margin: 2rem auto; padding: 2rem; background: #fff; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        .address-card { border: 2px solid #ddd; padding: 1.5rem; margin-bottom: 1rem; border-radius: 8px; cursor: pointer; transition: all 0.3s ease; }
        .address-card:hover { border-color: #667eea; background: #f8f9fa; }
        .address-card label { display: flex; width: 100%; cursor: pointer; align-items: flex-start; }
        .address-card input[type="radio"] { margin-right: 1rem; margin-top: 0.3rem; }
        .btn-proceed { background: #667eea; color: white; padding: 1rem 2rem; border: none; border-radius: 5px; font-size: 1.1rem; cursor: pointer; width: 100%; margin-top: 2rem; }
        .btn-add-address { background: #28a745; color: white; padding: 0.8rem 1.5rem; border: none; border-radius: 5px; font-size: 1rem; cursor: pointer; width: 100%; margin-bottom: 1rem; text-decoration: none; display: inline-block; text-align: center; }
        .btn-add-address:hover { background: #218838; }
        .steps { display: flex; justify-content: space-between; margin-bottom: 2rem; border-bottom: 1px solid #eee; padding-bottom: 1rem; }
        .step { color: #ccc; font-weight: bold; padding: 0.5rem 1rem; border-radius: 5px; text-decoration: none; transition: all 0.3s ease; }
        .step.active { color: #667eea; background: rgba(102, 126, 234, 0.1); }
        .step.disabled { cursor: default; }
        .form-group { margin-bottom: 1.5rem; }
        .form-group label { display: block; margin-bottom: 0.5rem; font-weight: 600; }
        .form-group input[type="text"], .form-group input[type="tel"] { width: 100%; padding: 0.8rem; border: 1px solid #ddd; border-radius: 5px; transition: border-color 0.3s; }
        .form-group input.valid { border-color: #28a745; }
        .form-group input.invalid { border-color: #dc3545; }
        .form-group small.error-msg { color: #dc3545; font-size: 0.875rem; margin-top: 0.25rem; display: block; }
        .mobile-section { background: #f8f9fa; padding: 1.5rem; border-radius: 8px; margin-bottom: 1.5rem; }
        .checkbox-wrapper { display: flex; align-items: center; margin-top: 1rem; }
        .checkbox-wrapper input { width: auto; margin-right: 0.5rem; }
        .checkbox-wrapper label { margin-bottom: 0; }
        #alternateContactSection { margin-top: 1rem; padding: 1rem; background: #fff; border: 1px solid #ddd; border-radius: 5px; }
    </style>
</head>
<body>
    <jsp:include page="includes/header.jsp" />

    <div class="checkout-container">
        <div class="steps">
            <span class="step active">1. Shipping</span>
            <span class="step disabled">2. Billing</span>
            <span class="step disabled">3. Review</span>
        </div>

        <h2>Select Shipping Address</h2>
        
        <a href="${pageContext.request.contextPath}/profile/addresses" class="btn-add-address">+ Add New Address</a>
        
        <form action="${pageContext.request.contextPath}/checkout/shipping" method="post">
            <c:if test="${empty addresses}">
                <p>No addresses found. Please <a href="${pageContext.request.contextPath}/profile/addresses">add an address</a>.</p>
            </c:if>
            
            <c:forEach items="${addresses}" var="addr">
                <div class="address-card">
                    <label>
                        <input type="radio" name="addressId" value="${addr.id}" required 
                            ${(not empty selectedAddressId and selectedAddressId eq addr.id) or (empty selectedAddressId and addr.isDefault) ? 'checked' : ''}>
                        <div class="address-details">
                            <strong>${addr.line1}</strong><br>
                            <c:if test="${not empty addr.line2}">${addr.line2}<br></c:if>
                            ${addr.city}, ${addr.state} ${addr.postalCode}<br>
                            ${addr.country}
                        </div>
                    </label>
                </div>
            </c:forEach>

            <div class="mobile-section">
                <h3>Contact Information</h3>
                <div class="form-group">
                    <label for="primaryMobile">Your Mobile Number *</label>
                    <input type="tel" id="primaryMobile" name="primaryMobile" placeholder="Enter 10-digit mobile number" 
                           maxlength="10" required value="${primaryMobile}" readonly style="background-color: #f8f9fa;">
                    <small style="color: #666; font-size: 0.875rem; margin-top: 0.25rem; display: block;">
                        This is your registered mobile number from your profile
                    </small>
                    <small id="primaryMobileError" class="error-msg" style="display: none;">Please enter a valid 10-digit mobile number</small>
                </div>

                <div class="checkbox-wrapper">
                    <input type="checkbox" id="showAlternateContact" name="showAlternateContact" ${not empty alternateMobile ? 'checked' : ''}>
                    <label for="showAlternateContact">Order is for someone else? Add their contact details</label>
                </div>

                <div id="alternateContactSection" style="display: ${not empty alternateMobile ? 'block' : 'none'};">
                    <div class="form-group">
                        <label for="alternateMobile">Recipient's Mobile Number *</label>
                        <input type="tel" id="alternateMobile" name="alternateMobile" placeholder="Enter 10-digit mobile number" 
                               maxlength="10" value="${alternateMobile}">
                        <small id="alternateMobileError" class="error-msg" style="display: none;">Please enter a valid 10-digit mobile number</small>
                    </div>
                    <div class="form-group">
                        <label for="alternateContactName">Recipient's Name *</label>
                        <input type="text" id="alternateContactName" name="alternateContactName" 
                               placeholder="Name of person receiving the order" maxlength="50" value="${alternateContactName}">
                        <small id="alternateNameError" class="error-msg" style="display: none;">Please enter recipient's name</small>
                    </div>
                </div>
            </div>

            <button type="submit" class="btn-proceed" ${empty addresses ? 'disabled' : ''}>Continue to Billing</button>
        </form>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const primaryMobile = document.getElementById('primaryMobile');
            const alternateMobile = document.getElementById('alternateMobile');
            const alternateContactName = document.getElementById('alternateContactName');
            const showAlternateContact = document.getElementById('showAlternateContact');
            const alternateContactSection = document.getElementById('alternateContactSection');
            const primaryMobileError = document.getElementById('primaryMobileError');
            const alternateMobileError = document.getElementById('alternateMobileError');
            const alternateNameError = document.getElementById('alternateNameError');

            // Toggle alternate contact section
            showAlternateContact.addEventListener('change', function() {
                alternateContactSection.style.display = this.checked ? 'block' : 'none';
                if (!this.checked) {
                    alternateMobile.value = '';
                    alternateContactName.value = '';
                    alternateMobile.classList.remove('valid', 'invalid');
                    alternateContactName.classList.remove('valid', 'invalid');
                    alternateMobileError.style.display = 'none';
                    alternateNameError.style.display = 'none';
                    // Remove required attribute
                    alternateMobile.removeAttribute('required');
                    alternateContactName.removeAttribute('required');
                } else {
                    // Add required attribute
                    alternateMobile.setAttribute('required', 'required');
                    alternateContactName.setAttribute('required', 'required');
                }
            });

            // Validate mobile number
            function validateMobile(input, errorElement) {
                input.addEventListener('input', function(e) {
                    // Only allow digits
                    e.target.value = e.target.value.replace(/\D/g, '').slice(0, 10);
                    
                    const value = e.target.value;
                    if (value.length === 0) {
                        e.target.classList.remove('valid', 'invalid');
                        errorElement.style.display = 'none';
                    } else if (value.length === 10 && /^[6-9]\d{9}$/.test(value)) {
                        e.target.classList.remove('invalid');
                        e.target.classList.add('valid');
                        errorElement.style.display = 'none';
                    } else {
                        e.target.classList.remove('valid');
                        e.target.classList.add('invalid');
                        errorElement.style.display = 'block';
                    }
                });
            }

            // Validate alternate mobile (primary is readonly)
            validateMobile(alternateMobile, alternateMobileError);

            // Validate alternate contact name
            alternateContactName.addEventListener('input', function(e) {
                const value = e.target.value.trim();
                if (value.length === 0) {
                    e.target.classList.remove('valid', 'invalid');
                    alternateNameError.style.display = 'none';
                } else if (value.length >= 2) {
                    e.target.classList.remove('invalid');
                    e.target.classList.add('valid');
                    alternateNameError.style.display = 'none';
                } else {
                    e.target.classList.remove('valid');
                    e.target.classList.add('invalid');
                    alternateNameError.style.display = 'block';
                }
            });

            // Form validation
            document.querySelector('form').addEventListener('submit', function(e) {
                let isValid = true;

                // Primary mobile is pre-filled from profile, so always valid
                const primaryValue = primaryMobile.value;
                if (!/^[6-9]\d{9}$/.test(primaryValue)) {
                    e.preventDefault();
                    primaryMobileError.style.display = 'block';
                    primaryMobile.classList.add('invalid');
                    isValid = false;
                }

                // Validate alternate details if checkbox is checked
                if (showAlternateContact.checked) {
                    const alternateValue = alternateMobile.value;
                    if (!alternateValue || !/^[6-9]\d{9}$/.test(alternateValue)) {
                        e.preventDefault();
                        alternateMobileError.style.display = 'block';
                        alternateMobile.classList.add('invalid');
                        if (isValid) alternateMobile.focus();
                        isValid = false;
                    }

                    const nameValue = alternateContactName.value.trim();
                    if (!nameValue || nameValue.length < 2) {
                        e.preventDefault();
                        alternateNameError.style.display = 'block';
                        alternateNameError.textContent = 'Please enter recipient\'s name';
                        alternateContactName.classList.add('invalid');
                        if (isValid) alternateContactName.focus();
                        isValid = false;
                    }
                }
            });

            // Set initial required state
            if (showAlternateContact.checked) {
                alternateMobile.setAttribute('required', 'required');
                alternateContactName.setAttribute('required', 'required');
            }
        });
    </script>

    <jsp:include page="includes/footer.jsp" />
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout - Billing</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .checkout-container { max-width: 800px; margin: 2rem auto; padding: 2rem; background: #fff; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        .steps { display: flex; justify-content: space-between; margin-bottom: 2rem; border-bottom: 1px solid #eee; padding-bottom: 1rem; }
        .step { color: #ccc; font-weight: bold; padding: 0.5rem 1rem; border-radius: 5px; text-decoration: none; transition: all 0.3s ease; }
        .step.active { color: #667eea; background: rgba(102, 126, 234, 0.1); }
        .step:not(.active):not(.disabled):hover { color: #667eea; background: #f0f0f0; cursor: pointer; }
        a.step { display: inline-block; }
        .billing-form { margin-top: 2rem; padding: 1.5rem; background: #f8f9fa; border-radius: 8px; }
        .form-group { margin-bottom: 1rem; }
        .form-group label { display: block; margin-bottom: 0.5rem; font-weight: 600; }
        .form-group input { width: 100%; padding: 0.8rem; border: 1px solid #ddd; border-radius: 5px; transition: border-color 0.3s; }
        .form-group input.valid { border-color: #28a745; }
        .form-group input.invalid { border-color: #dc3545; }
        .form-group small.error-msg { color: #dc3545; font-size: 0.875rem; margin-top: 0.25rem; display: block; }
        .order-summary { margin-top: 2rem; border-top: 1px solid #eee; padding-top: 1rem; }
        .summary-row { display: flex; justify-content: space-between; margin-bottom: 0.5rem; }
        .total-row { font-weight: bold; font-size: 1.2rem; margin-top: 1rem; border-top: 2px solid #ddd; padding-top: 1rem; }
        .btn-proceed { background: #667eea; color: white; padding: 1rem 2rem; border: none; border-radius: 5px; font-size: 1.1rem; cursor: pointer; width: 100%; margin-top: 2rem; text-decoration: none; text-align: center; }
        .btn-back { background: #6c757d; color: white; padding: 1rem 2rem; border: none; border-radius: 5px; font-size: 1.1rem; cursor: pointer; width: 100%; margin-top: 2rem; text-decoration: none; text-align: center; }
        
        .address-card { border: 2px solid #ddd; padding: 1rem; margin-bottom: 0.5rem; border-radius: 8px; cursor: pointer; transition: all 0.3s ease; }
        .address-card:hover { border-color: #667eea; background: #fff; }
        .address-card label { display: flex; width: 100%; cursor: pointer; align-items: flex-start; margin-bottom: 0; }
        .address-card input[type="radio"] { margin-right: 1rem; margin-top: 0.3rem; width: auto; }
        .billing-address-section { margin-bottom: 2rem; border-bottom: 1px solid #ddd; padding-bottom: 1rem; }
        .checkbox-wrapper { display: flex; align-items: center; margin-bottom: 1rem; }
        .checkbox-wrapper input { width: auto; margin-right: 0.5rem; }
        .checkbox-wrapper label { margin-bottom: 0; }
        .optional-section { background: #f0f8ff; padding: 1rem; border-radius: 5px; margin-top: 1rem; border-left: 3px solid #667eea; }
        .optional-label { color: #666; font-size: 0.9rem; font-style: italic; }
    </style>
</head>
<body>
    <jsp:include page="includes/header.jsp" />

    <div class="checkout-container">
        <div class="steps">
            <a href="${pageContext.request.contextPath}/checkout/shipping" class="step">1. Shipping</a>
            <span class="step active">2. Billing</span>
            <span class="step disabled">3. Payment</span>
        </div>

        <div class="order-summary">
            <h3>Order Summary</h3>
            <c:forEach items="${cart.items}" var="item">
                <div class="summary-row">
                    <span>${item.productName} x ${item.quantity}</span>
                    <span>₹ ${item.subtotal}</span>
                </div>
            </c:forEach>
            <div class="summary-row total-row">
                <span>Total</span>
                <span>₹ ${cart.total}</span>
            </div>
        </div>

        <div class="billing-form">
            <form action="${pageContext.request.contextPath}/checkout/billing" method="post" id="billingForm">
                
                <div class="billing-address-section">
                    <h3>Billing Address</h3>
                    <div class="checkbox-wrapper">
                        <input type="checkbox" id="sameAsShipping" name="sameAsShipping" value="true" ${sameAsShipping ? 'checked' : ''}>
                        <label for="sameAsShipping">Same as shipping address</label>
                    </div>

                    <div id="billingAddressesList" style="${sameAsShipping ? 'display: none;' : ''}">
                        <c:forEach items="${addresses}" var="addr">
                            <div class="address-card">
                                <label>
                                    <input type="radio" name="addressId" value="${addr.id}" 
                                        ${(not empty selectedBillingAddressId and selectedBillingAddressId eq addr.id) ? 'checked' : ''}>
                                    <div class="address-details">
                                        <strong>${addr.line1}</strong>, ${addr.city}, ${addr.state} ${addr.postalCode}
                                    </div>
                                </label>
                            </div>
                        </c:forEach>
                        <c:if test="${empty addresses}">
                            <p>No addresses available. <a href="${pageContext.request.contextPath}/profile">Add one</a></p>
                        </c:if>
                    </div>
                </div>

                <h3>Billing Information (Optional)</h3>
                <div class="optional-section">
                    <div class="form-group">
                        <label>GST Number <span class="optional-label">(Optional - for B2B)</span></label>
                        <input type="text" id="gstNumber" name="gstNumber" placeholder="e.g., 22AAAAA0000A1Z5" 
                               maxlength="15" value="${billingInfo.gstNumber}">
                        <small id="gstError" class="error-msg" style="display: none;">Invalid GST format (15 alphanumeric characters)</small>
                    </div>
                    
                    <div class="form-group">
                        <label>Company Name <span class="optional-label">(Optional)</span></label>
                        <input type="text" id="companyName" name="companyName" placeholder="Company or Business Name" 
                               maxlength="100" value="${billingInfo.companyName}">
                    </div>
                    
                    <div class="form-group">
                        <label>Email for Invoice <span class="optional-label">(Optional - if different from account email)</span></label>
                        <input type="email" id="invoiceEmail" name="invoiceEmail" placeholder="invoice@company.com" 
                               maxlength="100" value="${billingInfo.invoiceEmail}">
                        <small id="emailError" class="error-msg" style="display: none;">Please enter a valid email address</small>
                    </div>
                </div>
                
                <div style="display: flex; gap: 1rem;">
                    <button type="submit" name="navigation" value="back" class="btn-back" formnovalidate>Back</button>
                    <button type="submit" name="navigation" value="next" class="btn-proceed">Continue to Payment</button>
                </div>
            </form>
        </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('billingForm');
            const sameAsShipping = document.getElementById('sameAsShipping');
            const billingAddressesList = document.getElementById('billingAddressesList');
            const gstNumber = document.getElementById('gstNumber');
            const gstError = document.getElementById('gstError');
            const invoiceEmail = document.getElementById('invoiceEmail');
            const emailError = document.getElementById('emailError');

            // Toggle Billing Address
            if (sameAsShipping) {
                sameAsShipping.addEventListener('change', function() {
                    billingAddressesList.style.display = this.checked ? 'none' : 'block';
                    
                    const radioButtons = billingAddressesList.querySelectorAll('input[type="radio"]');
                    radioButtons.forEach(radio => {
                        if (this.checked) {
                            radio.removeAttribute('required');
                        } else {
                            radio.setAttribute('required', 'required');
                        }
                    });
                });
            }

            // GST Number Validation (15 alphanumeric characters)
            // Format: 2 digits (State) + 10 chars (PAN) + 1 char (Entity: 1-9/A-Z) + Z + 1 char (Checksum)
            gstNumber.addEventListener('input', function(e) {
                e.target.value = e.target.value.toUpperCase().replace(/[^A-Z0-9]/g, '').slice(0, 15);
                
                const value = e.target.value;
                if (value.length === 0) {
                    e.target.classList.remove('valid', 'invalid');
                    gstError.style.display = 'none';
                } else if (value.length === 15 && /^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$/.test(value)) {
                    e.target.classList.remove('invalid');
                    e.target.classList.add('valid');
                    gstError.style.display = 'none';
                } else if (value.length === 15) {
                    e.target.classList.remove('valid');
                    e.target.classList.add('invalid');
                    gstError.style.display = 'block';
                }
            });

            // Email Validation
            invoiceEmail.addEventListener('input', function(e) {
                const value = e.target.value.trim();
                if (value.length === 0) {
                    e.target.classList.remove('valid', 'invalid');
                    emailError.style.display = 'none';
                } else if (/^[a-zA-Z0-9][a-zA-Z0-9._%+\-]*@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$/.test(value)) {
                    e.target.classList.remove('invalid');
                    e.target.classList.add('valid');
                    emailError.style.display = 'none';
                } else {
                    e.target.classList.remove('valid');
                    e.target.classList.add('invalid');
                    emailError.style.display = 'block';
                }
            });

            // Form Validation on Submit
            form.addEventListener('submit', function(e) {
                // If clicking back, skip validation
                if (e.submitter && e.submitter.value === 'back') {
                    return;
                }

                let isValid = true;

                // Validate GST if provided
                const gstValue = gstNumber.value.trim();
                if (gstValue.length > 0 && (gstValue.length !== 15 || !/^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$/.test(gstValue))) {
                    e.preventDefault();
                    gstError.style.display = 'block';
                    gstNumber.classList.add('invalid');
                    gstNumber.focus();
                    isValid = false;
                }

                // Validate email if provided
                const emailValue = invoiceEmail.value.trim();
                if (emailValue.length > 0 && !/^[a-zA-Z0-9][a-zA-Z0-9._%+\-]*@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$/.test(emailValue)) {
                    e.preventDefault();
                    emailError.style.display = 'block';
                    invoiceEmail.classList.add('invalid');
                    if (isValid) invoiceEmail.focus();
                    isValid = false;
                }
            });
        });
    </script>
    </div>

    <jsp:include page="includes/footer.jsp" />
</body>
</html>

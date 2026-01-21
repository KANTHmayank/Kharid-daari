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
        .form-group input { width: 100%; padding: 0.8rem; border: 1px solid #ddd; border-radius: 5px; }
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
    </style>
</head>
<body>
    <jsp:include page="includes/header.jsp" />

    <div class="checkout-container">
        <div class="steps">
            <a href="${pageContext.request.contextPath}/checkout/shipping" class="step">1. Shipping</a>
            <span class="step active">2. Billing</span>
            <span class="step disabled">3. Review</span>
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

                <h3>Payment Details</h3>
                <div class="form-group">
                    <label>Card Number</label>
                    <input type="text" id="cardNumber" name="cardNumber" placeholder="XXXX XXXX XXXX XXXX" maxlength="19" required value="${billingInfo.cardNumber}">
                    <small id="cardError" style="color: red; display: none; margin-top: 5px;">Card number must be 16 digits</small>
                </div>
                <div class="form-group">
                    <label>Name on Card</label>
                    <input type="text" id="cardName" name="cardName" placeholder="John Doe" required value="${billingInfo.cardName}">
                </div>
                <div class="form-group" style="display: flex; gap: 1rem;">
                    <div style="flex: 1;">
                        <label>Expiry Date</label>
                        <input type="text" id="expiryDate" name="expiryDate" placeholder="MM/YY" maxlength="5" required value="${billingInfo.expiryDate}">
                    </div>
                    <div style="flex: 1;">
                        <label>CVV</label>
                        <input type="text" id="cvv" name="cvv" placeholder="123" maxlength="4" required value="${billingInfo.cvv}">
                    </div>
                </div>
                <div style="display: flex; gap: 1rem;">
                    <button type="submit" name="navigation" value="back" class="btn-back" formnovalidate>Back</button>
                    <button type="submit" name="navigation" value="next" class="btn-proceed">Continue to Review</button>
                </div>
            </form>
        </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const cardNumber = document.getElementById('cardNumber');
            const expiryDate = document.getElementById('expiryDate');
            const cvv = document.getElementById('cvv');
            const form = document.getElementById('billingForm');
            const cardError = document.getElementById('cardError');
            const sameAsShipping = document.getElementById('sameAsShipping');
            const billingAddressesList = document.getElementById('billingAddressesList');

            // Toggle Billing Address
            if (sameAsShipping) {
                sameAsShipping.addEventListener('change', function() {
                    billingAddressesList.style.display = this.checked ? 'none' : 'block';
                    
                    // Toggle required attribute for radio buttons
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

            // Card Number Formatting
            cardNumber.addEventListener('input', function(e) {
                let value = e.target.value.replace(/\D/g, '');
                if (value.length > 16) value = value.slice(0, 16);
                
                let formattedValue = '';
                for (let i = 0; i < value.length; i++) {
                    if (i > 0 && i % 4 === 0) formattedValue += ' ';
                    formattedValue += value[i];
                }
                e.target.value = formattedValue;
            });

            // Expiry Date Formatting
            expiryDate.addEventListener('input', function(e) {
                let input = e.target.value;
                let clean = input.replace(/\D/g, '');
                if (clean.length > 4) clean = clean.slice(0, 4);

                if (clean.length > 2) {
                    e.target.value = clean.slice(0, 2) + '/' + clean.slice(2);
                } else if (clean.length === 2 && e.inputType !== 'deleteContentBackward' && input.indexOf('/') === -1) {
                    e.target.value = clean + '/';
                }
            });

            // CVV
            cvv.addEventListener('input', function(e) {
                e.target.value = e.target.value.replace(/\D/g, '').slice(0, 4);
            });

            // Validation
            form.addEventListener('submit', function(e) {
                // If clicking back, skip validation
                if (e.submitter && e.submitter.value === 'back') {
                    return;
                }

                const rawCard = cardNumber.value.replace(/\D/g, '');
                if (rawCard.length !== 16) {
                    e.preventDefault();
                    cardError.style.display = 'block';
                    cardNumber.focus();
                } else {
                    cardError.style.display = 'none';
                }
            });
        });
    </script>
    </div>

    <jsp:include page="includes/footer.jsp" />
</body>
</html>

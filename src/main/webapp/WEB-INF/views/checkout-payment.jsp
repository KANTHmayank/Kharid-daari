<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout - Payment</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .checkout-container { max-width: 800px; margin: 2rem auto; padding: 2rem; background: #fff; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        .steps { display: flex; justify-content: space-between; margin-bottom: 2rem; border-bottom: 1px solid #eee; padding-bottom: 1rem; }
        .step { color: #ccc; font-weight: bold; padding: 0.5rem 1rem; border-radius: 5px; text-decoration: none; transition: all 0.3s ease; }
        .step.active { color: #667eea; background: rgba(102, 126, 234, 0.1); }
        .step:not(.active):not(.disabled):hover { color: #667eea; background: #f0f0f0; cursor: pointer; }
        a.step { display: inline-block; }
        .payment-section { margin-bottom: 2rem; padding: 1.5rem; border: 1px solid #eee; border-radius: 8px; }
        .payment-section h3 { margin-bottom: 1rem; color: #333; }
        .payment-methods { display: flex; gap: 1rem; margin-bottom: 2rem; }
        .payment-method { flex: 1; padding: 1rem; border: 2px solid #ddd; border-radius: 8px; cursor: pointer; text-align: center; transition: all 0.3s; }
        .payment-method:hover { border-color: #667eea; }
        .payment-method.selected { border-color: #667eea; background: rgba(102, 126, 234, 0.1); }
        .payment-method input[type="radio"] { display: none; }
        .payment-details { background: #f8f9fa; padding: 1.5rem; border-radius: 8px; margin-top: 1rem; border: 1px solid #ddd; }
        .payment-details h4 { margin-bottom: 1rem; color: #333; }
        .form-group { margin-bottom: 1rem; }
        .form-group label { display: block; margin-bottom: 0.5rem; font-weight: 600; }
        .form-group input { width: 100%; padding: 0.8rem; border: 1px solid #ddd; border-radius: 5px; transition: border-color 0.3s; }
        .form-group input.valid { border-color: #28a745; }
        .form-group input.invalid { border-color: #dc3545; }
        .form-group small.error-msg { color: #dc3545; font-size: 0.875rem; margin-top: 0.25rem; display: block; }
        .order-summary { background: #f8f9fa; padding: 1.5rem; border-radius: 8px; margin-bottom: 2rem; }
        .summary-row { display: flex; justify-content: space-between; margin-bottom: 0.5rem; }
        .total-row { font-weight: bold; font-size: 1.3rem; margin-top: 1rem; border-top: 2px solid #ddd; padding-top: 1rem; color: #667eea; }
        .btn-place-order { background: #28a745; color: white; padding: 1rem 2rem; border: none; border-radius: 5px; font-size: 1.2rem; cursor: pointer; width: 100%; transition: background 0.3s ease; }
        .btn-place-order:hover { background: #218838; }
        .btn-back { background: #6c757d; color: white; padding: 1rem 2rem; border: none; border-radius: 5px; font-size: 1.2rem; cursor: pointer; width: 100%; text-decoration: none; text-align: center; display: inline-block; }
        .alert-error { color: #dc3545; background-color: #f8d7da; border: 1px solid #f5c6cb; padding: 1rem; margin-bottom: 1rem; border-radius: 5px; }
        .payment-info { background: #e7f3ff; padding: 1rem; border-radius: 5px; margin-bottom: 1rem; border-left: 4px solid #667eea; }
    </style>
</head>
<body>
    <jsp:include page="includes/header.jsp" />

    <div class="checkout-container">
        <div class="steps">
            <a href="${pageContext.request.contextPath}/checkout/shipping" class="step">1. Shipping</a>
            <a href="${pageContext.request.contextPath}/checkout/billing" class="step">2. Billing</a>
            <span class="step active">3. Payment</span>
        </div>

        <c:if test="${not empty error}">
            <div class="alert-error">${error}</div>
        </c:if>

        <h2>Payment</h2>

        <div class="order-summary">
            <h3>Order Summary</h3>
            <c:forEach items="${cart.items}" var="item">
                <div class="summary-row">
                    <span>${item.productName} x ${item.quantity}</span>
                    <span>₹ <fmt:formatNumber value="${item.subtotal}" type="number" minFractionDigits="2" maxFractionDigits="2" /></span>
                </div>
            </c:forEach>
            <div class="summary-row total-row">
                <span>Total Amount</span>
                <span>₹ <fmt:formatNumber value="${cart.total}" type="number" minFractionDigits="2" maxFractionDigits="2" /></span>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/checkout/place-order" method="post" id="paymentForm">
            <div class="payment-section">
                <h3>Select Payment Method</h3>
                <div class="payment-methods">
                    <label class="payment-method selected" id="card-payment">
                        <input type="radio" name="paymentMethod" value="card" checked>
                        <div>
                            <strong>💳 Credit/Debit Card</strong>
                            <p style="font-size: 0.9rem; color: #666; margin-top: 0.5rem;">Secure card payment</p>
                        </div>
                    </label>
                    <label class="payment-method" id="upi-payment">
                        <input type="radio" name="paymentMethod" value="upi">
                        <div>
                            <strong>📱 UPI</strong>
                            <p style="font-size: 0.9rem; color: #666; margin-top: 0.5rem;">Pay using UPI</p>
                        </div>
                    </label>
                    <label class="payment-method" id="cod-payment">
                        <input type="radio" name="paymentMethod" value="cod">
                        <div>
                            <strong>💵 Cash on Delivery</strong>
                            <p style="font-size: 0.9rem; color: #666; margin-top: 0.5rem;">Pay when you receive</p>
                        </div>
                    </label>
                </div>

                <!-- Card Payment Section -->
                <div class="payment-details" id="card-details">
                    <h4>Card Details</h4>
                    <div class="form-group">
                        <label>Card Number *</label>
                        <input type="text" id="cardNumber" name="cardNumber" placeholder="XXXX XXXX XXXX XXXX" maxlength="19">
                        <small id="cardError" class="error-msg" style="display: none;">Card number must be 16 digits</small>
                    </div>
                    <div class="form-group">
                        <label>Name on Card *</label>
                        <input type="text" id="cardName" name="cardName" placeholder="John Doe" maxlength="50">
                        <small id="cardNameError" class="error-msg" style="display: none;">Enter valid name (alphabets and spaces only, 2-50 characters)</small>
                    </div>
                    <div class="form-group" style="display: flex; gap: 1rem;">
                        <div style="flex: 1;">
                            <label>Expiry Date *</label>
                            <input type="text" id="expiryDate" name="expiryDate" placeholder="MM/YY" maxlength="5">
                            <small id="expiryError" class="error-msg" style="display: none;">Enter valid expiry date (MM/YY)</small>
                        </div>
                        <div style="flex: 1;">
                            <label>CVV *</label>
                            <input type="text" id="cvv" name="cvv" placeholder="123" maxlength="3">
                            <small id="cvvError" class="error-msg" style="display: none;">CVV must be exactly 3 digits</small>
                        </div>
                    </div>
                </div>

                <!-- UPI Payment Section -->
                <div class="payment-details" id="upi-details" style="display: none;">
                    <h4>UPI Payment</h4>
                    <div class="form-group">
                        <label>UPI ID *</label>
                        <input type="text" id="upiId" name="upiId" placeholder="username@paytm" maxlength="50">
                        <small id="upiError" class="error-msg" style="display: none;">Enter valid UPI ID (e.g., username@paytm, minimum 4 characters after @)</small>
                    </div>
                    <div style="text-align: center; margin-top: 1.5rem;">
                        <p style="font-weight: bold; margin-bottom: 1rem;">OR</p>
                        <p style="margin-bottom: 1rem;">Scan QR Code to Pay</p>
                        <div style="background: white; padding: 1rem; border-radius: 8px; display: inline-block; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                            <svg xmlns="http://www.w3.org/2000/svg" width="200" height="200" viewBox="0 0 200 200">
                                <!-- Background -->
                                <rect width="200" height="200" fill="white"/>
                                
                                <!-- Top-left finder pattern -->
                                <rect x="10" y="10" width="50" height="50" fill="black"/>
                                <rect x="15" y="15" width="40" height="40" fill="white"/>
                                <rect x="20" y="20" width="30" height="30" fill="black"/>
                                
                                <!-- Top-right finder pattern -->
                                <rect x="140" y="10" width="50" height="50" fill="black"/>
                                <rect x="145" y="15" width="40" height="40" fill="white"/>
                                <rect x="150" y="20" width="30" height="30" fill="black"/>
                                
                                <!-- Bottom-left finder pattern -->
                                <rect x="10" y="140" width="50" height="50" fill="black"/>
                                <rect x="15" y="145" width="40" height="40" fill="white"/>
                                <rect x="20" y="150" width="30" height="30" fill="black"/>
                                
                                <!-- Timing patterns -->
                                <rect x="65" y="30" width="5" height="5" fill="black"/>
                                <rect x="75" y="30" width="5" height="5" fill="black"/>
                                <rect x="85" y="30" width="5" height="5" fill="black"/>
                                <rect x="95" y="30" width="5" height="5" fill="black"/>
                                <rect x="105" y="30" width="5" height="5" fill="black"/>
                                <rect x="115" y="30" width="5" height="5" fill="black"/>
                                <rect x="125" y="30" width="5" height="5" fill="black"/>
                                
                                <rect x="30" y="65" width="5" height="5" fill="black"/>
                                <rect x="30" y="75" width="5" height="5" fill="black"/>
                                <rect x="30" y="85" width="5" height="5" fill="black"/>
                                <rect x="30" y="95" width="5" height="5" fill="black"/>
                                <rect x="30" y="105" width="5" height="5" fill="black"/>
                                <rect x="30" y="115" width="5" height="5" fill="black"/>
                                <rect x="30" y="125" width="5" height="5" fill="black"/>
                                
                                <!-- Data modules (random pattern) -->
                                <rect x="70" y="70" width="5" height="5" fill="black"/>
                                <rect x="80" y="70" width="5" height="5" fill="black"/>
                                <rect x="85" y="75" width="5" height="5" fill="black"/>
                                <rect x="90" y="70" width="5" height="5" fill="black"/>
                                <rect x="95" y="75" width="5" height="5" fill="black"/>
                                <rect x="100" y="70" width="5" height="5" fill="black"/>
                                <rect x="105" y="75" width="5" height="5" fill="black"/>
                                <rect x="110" y="70" width="5" height="5" fill="black"/>
                                <rect x="115" y="75" width="5" height="5" fill="black"/>
                                <rect x="120" y="70" width="5" height="5" fill="black"/>
                                
                                <rect x="70" y="80" width="5" height="5" fill="black"/>
                                <rect x="75" y="85" width="5" height="5" fill="black"/>
                                <rect x="80" y="80" width="5" height="5" fill="black"/>
                                <rect x="90" y="85" width="5" height="5" fill="black"/>
                                <rect x="95" y="80" width="5" height="5" fill="black"/>
                                <rect x="100" y="85" width="5" height="5" fill="black"/>
                                <rect x="110" y="80" width="5" height="5" fill="black"/>
                                <rect x="115" y="85" width="5" height="5" fill="black"/>
                                <rect x="120" y="80" width="5" height="5" fill="black"/>
                                
                                <rect x="70" y="95" width="5" height="5" fill="black"/>
                                <rect x="75" y="90" width="5" height="5" fill="black"/>
                                <rect x="85" y="95" width="5" height="5" fill="black"/>
                                <rect x="90" y="90" width="5" height="5" fill="black"/>
                                <rect x="100" y="95" width="5" height="5" fill="black"/>
                                <rect x="105" y="90" width="5" height="5" fill="black"/>
                                <rect x="115" y="95" width="5" height="5" fill="black"/>
                                <rect x="120" y="90" width="5" height="5" fill="black"/>
                                
                                <rect x="70" y="105" width="5" height="5" fill="black"/>
                                <rect x="80" y="105" width="5" height="5" fill="black"/>
                                <rect x="85" y="100" width="5" height="5" fill="black"/>
                                <rect x="95" y="105" width="5" height="5" fill="black"/>
                                <rect x="100" y="100" width="5" height="5" fill="black"/>
                                <rect x="110" y="105" width="5" height="5" fill="black"/>
                                <rect x="115" y="100" width="5" height="5" fill="black"/>
                                <rect x="125" y="105" width="5" height="5" fill="black"/>
                                
                                <rect x="75" y="115" width="5" height="5" fill="black"/>
                                <rect x="80" y="110" width="5" height="5" fill="black"/>
                                <rect x="90" y="115" width="5" height="5" fill="black"/>
                                <rect x="95" y="110" width="5" height="5" fill="black"/>
                                <rect x="105" y="115" width="5" height="5" fill="black"/>
                                <rect x="110" y="110" width="5" height="5" fill="black"/>
                                <rect x="120" y="115" width="5" height="5" fill="black"/>
                                
                                <rect x="70" y="125" width="5" height="5" fill="black"/>
                                <rect x="85" y="125" width="5" height="5" fill="black"/>
                                <rect x="90" y="120" width="5" height="5" fill="black"/>
                                <rect x="100" y="125" width="5" height="5" fill="black"/>
                                <rect x="115" y="125" width="5" height="5" fill="black"/>
                                <rect x="120" y="120" width="5" height="5" fill="black"/>
                                
                                <!-- Bottom patterns -->
                                <rect x="140" y="70" width="5" height="5" fill="black"/>
                                <rect x="145" y="75" width="5" height="5" fill="black"/>
                                <rect x="150" y="70" width="5" height="5" fill="black"/>
                                <rect x="155" y="75" width="5" height="5" fill="black"/>
                                <rect x="160" y="70" width="5" height="5" fill="black"/>
                                <rect x="165" y="75" width="5" height="5" fill="black"/>
                                <rect x="170" y="70" width="5" height="5" fill="black"/>
                                
                                <rect x="140" y="85" width="5" height="5" fill="black"/>
                                <rect x="150" y="85" width="5" height="5" fill="black"/>
                                <rect x="155" y="80" width="5" height="5" fill="black"/>
                                <rect x="165" y="85" width="5" height="5" fill="black"/>
                                <rect x="170" y="80" width="5" height="5" fill="black"/>
                                
                                <rect x="145" y="95" width="5" height="5" fill="black"/>
                                <rect x="150" y="90" width="5" height="5" fill="black"/>
                                <rect x="160" y="95" width="5" height="5" fill="black"/>
                                <rect x="165" y="90" width="5" height="5" fill="black"/>
                                <rect x="175" y="95" width="5" height="5" fill="black"/>
                                
                                <rect x="140" y="105" width="5" height="5" fill="black"/>
                                <rect x="150" y="105" width="5" height="5" fill="black"/>
                                <rect x="155" y="100" width="5" height="5" fill="black"/>
                                <rect x="165" y="105" width="5" height="5" fill="black"/>
                                <rect x="170" y="100" width="5" height="5" fill="black"/>
                                
                                <rect x="145" y="115" width="5" height="5" fill="black"/>
                                <rect x="155" y="115" width="5" height="5" fill="black"/>
                                <rect x="160" y="110" width="5" height="5" fill="black"/>
                                <rect x="170" y="115" width="5" height="5" fill="black"/>
                                <rect x="175" y="110" width="5" height="5" fill="black"/>
                                
                                <rect x="140" y="125" width="5" height="5" fill="black"/>
                                <rect x="150" y="125" width="5" height="5" fill="black"/>
                                <rect x="160" y="125" width="5" height="5" fill="black"/>
                                <rect x="165" y="120" width="5" height="5" fill="black"/>
                                <rect x="175" y="125" width="5" height="5" fill="black"/>
                                
                                <rect x="70" y="145" width="5" height="5" fill="black"/>
                                <rect x="75" y="150" width="5" height="5" fill="black"/>
                                <rect x="80" y="145" width="5" height="5" fill="black"/>
                                <rect x="85" y="150" width="5" height="5" fill="black"/>
                                <rect x="90" y="145" width="5" height="5" fill="black"/>
                                <rect x="95" y="150" width="5" height="5" fill="black"/>
                                <rect x="100" y="145" width="5" height="5" fill="black"/>
                                
                                <rect x="70" y="160" width="5" height="5" fill="black"/>
                                <rect x="80" y="160" width="5" height="5" fill="black"/>
                                <rect x="85" y="155" width="5" height="5" fill="black"/>
                                <rect x="95" y="160" width="5" height="5" fill="black"/>
                                <rect x="100" y="155" width="5" height="5" fill="black"/>
                                
                                <rect x="75" y="170" width="5" height="5" fill="black"/>
                                <rect x="80" y="165" width="5" height="5" fill="black"/>
                                <rect x="90" y="170" width="5" height="5" fill="black"/>
                                <rect x="95" y="165" width="5" height="5" fill="black"/>
                                <rect x="105" y="170" width="5" height="5" fill="black"/>
                                
                                <rect x="70" y="180" width="5" height="5" fill="black"/>
                                <rect x="80" y="180" width="5" height="5" fill="black"/>
                                <rect x="90" y="180" width="5" height="5" fill="black"/>
                                <rect x="100" y="180" width="5" height="5" fill="black"/>
                            </svg>
                            <div style="margin-top: 0.5rem; display: flex; justify-content: center; gap: 1rem;">
                                <span style="font-size: 0.9rem; color: #666;">📱 GPay</span>
                                <span style="font-size: 0.9rem; color: #666;">📱 PhonePe</span>
                                <span style="font-size: 0.9rem; color: #666;">📱 Paytm</span>
                            </div>
                        </div>
                        <p style="font-size: 0.9rem; color: #666; margin-top: 1rem;">Scan this QR code using any UPI app</p>
                    </div>
                </div>

                <!-- COD Payment Section -->
                <div class="payment-details" id="cod-details" style="display: none;">
                    <div class="payment-info" style="background: #fff3cd; border-left: 4px solid #ffc107;">
                        <strong>💵 Cash on Delivery</strong>
                        <p style="margin-top: 0.5rem;">You will pay cash when your order is delivered to your doorstep.</p>
                        <ul style="margin-top: 1rem; padding-left: 1.5rem; font-size: 0.95rem; color: #666;">
                            <li>Keep exact change ready for faster delivery</li>
                            <li>Payment receipt will be provided by delivery agent</li>
                            <li>COD charges may apply for orders above certain amount</li>
                        </ul>
                    </div>
                </div>
            </div>

            <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                <a href="${pageContext.request.contextPath}/checkout/billing" class="btn-back">Back</a>
                <button type="submit" class="btn-place-order" id="placeOrderBtn" disabled>Place Order</button>
            </div>
        </form>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const paymentMethods = document.querySelectorAll('.payment-method');
            const cardDetails = document.getElementById('card-details');
            const upiDetails = document.getElementById('upi-details');
            const codDetails = document.getElementById('cod-details');
            const placeOrderBtn = document.getElementById('placeOrderBtn');
            const form = document.getElementById('paymentForm');

            // Card fields
            const cardNumber = document.getElementById('cardNumber');
            const cardName = document.getElementById('cardName');
            const expiryDate = document.getElementById('expiryDate');
            const cvv = document.getElementById('cvv');
            const cardError = document.getElementById('cardError');
            const cardNameError = document.getElementById('cardNameError');
            const expiryError = document.getElementById('expiryError');
            const cvvError = document.getElementById('cvvError');

            // UPI fields
            const upiId = document.getElementById('upiId');
            const upiError = document.getElementById('upiError');

            let currentPaymentMethod = 'card';

            // Payment method selection
            paymentMethods.forEach(method => {
                method.addEventListener('click', function() {
                    paymentMethods.forEach(m => m.classList.remove('selected'));
                    this.classList.add('selected');
                    const radio = this.querySelector('input[type="radio"]');
                    radio.checked = true;
                    
                    currentPaymentMethod = radio.value;

                    // Hide all payment details
                    cardDetails.style.display = 'none';
                    upiDetails.style.display = 'none';
                    codDetails.style.display = 'none';

                    // Show selected payment details
                    if (currentPaymentMethod === 'card') {
                        cardDetails.style.display = 'block';
                    } else if (currentPaymentMethod === 'upi') {
                        upiDetails.style.display = 'block';
                    } else if (currentPaymentMethod === 'cod') {
                        codDetails.style.display = 'block';
                    }

                    validateForm();
                });
            });

            // Card Number Formatting and Validation
            cardNumber.addEventListener('input', function(e) {
                let value = e.target.value.replace(/\D/g, '');
                if (value.length > 16) value = value.slice(0, 16);
                
                let formattedValue = '';
                for (let i = 0; i < value.length; i++) {
                    if (i > 0 && i % 4 === 0) formattedValue += ' ';
                    formattedValue += value[i];
                }
                e.target.value = formattedValue;

                const rawCard = value;
                if (rawCard.length === 0) {
                    e.target.classList.remove('valid', 'invalid');
                    cardError.style.display = 'none';
                } else if (rawCard.length === 16) {
                    e.target.classList.remove('invalid');
                    e.target.classList.add('valid');
                    cardError.style.display = 'none';
                } else {
                    e.target.classList.remove('valid');
                    e.target.classList.add('invalid');
                    cardError.style.display = 'block';
                }
                validateForm();
            });

            // Card Name Validation
            cardName.addEventListener('input', function(e) {
                let value = e.target.value;
                value = value.replace(/[^a-zA-Z\s]/g, '');
                value = value.replace(/\b\w/g, char => char.toUpperCase());
                e.target.value = value;

                const trimmedValue = value.trim();
                if (trimmedValue.length === 0) {
                    e.target.classList.remove('valid', 'invalid');
                    cardNameError.style.display = 'none';
                } else if (trimmedValue.length >= 2 && trimmedValue.length <= 50 && /^[A-Za-z\s]+$/.test(trimmedValue)) {
                    e.target.classList.remove('invalid');
                    e.target.classList.add('valid');
                    cardNameError.style.display = 'none';
                } else {
                    e.target.classList.remove('valid');
                    e.target.classList.add('invalid');
                    cardNameError.style.display = 'block';
                }
                validateForm();
            });

            // Expiry Date Formatting and Validation
            expiryDate.addEventListener('input', function(e) {
                let input = e.target.value;
                let clean = input.replace(/\D/g, '');
                
                if (clean.length > 4) clean = clean.slice(0, 4);

                if (clean.length >= 3) {
                    e.target.value = clean.slice(0, 2) + '/' + clean.slice(2);
                } else {
                    e.target.value = clean;
                }

                const rawExpiry = clean;
                if (rawExpiry.length === 0) {
                    e.target.classList.remove('valid', 'invalid');
                    expiryError.style.display = 'none';
                } else if (rawExpiry.length === 4) {
                    const month = parseInt(rawExpiry.slice(0, 2));
                    const year = parseInt(rawExpiry.slice(2, 4));
                    const currentYear = new Date().getFullYear() % 100;
                    const currentMonth = new Date().getMonth() + 1;
                    
                    if (month >= 1 && month <= 12 && year >= currentYear && 
                        !(year === currentYear && month < currentMonth)) {
                        e.target.classList.remove('invalid');
                        e.target.classList.add('valid');
                        expiryError.style.display = 'none';
                    } else {
                        e.target.classList.remove('valid');
                        e.target.classList.add('invalid');
                        expiryError.style.display = 'block';
                    }
                } else {
                    e.target.classList.remove('valid');
                    e.target.classList.add('invalid');
                    expiryError.style.display = 'block';
                }
                validateForm();
            });

            // CVV Validation
            cvv.addEventListener('input', function(e) {
                e.target.value = e.target.value.replace(/\D/g, '').slice(0, 3);

                const rawCvv = e.target.value;
                if (rawCvv.length === 0) {
                    e.target.classList.remove('valid', 'invalid');
                    cvvError.style.display = 'none';
                } else if (rawCvv.length === 3) {
                    e.target.classList.remove('invalid');
                    e.target.classList.add('valid');
                    cvvError.style.display = 'none';
                } else {
                    e.target.classList.remove('valid');
                    e.target.classList.add('invalid');
                    cvvError.style.display = 'block';
                }
                validateForm();
            });

            // UPI ID Validation
            upiId.addEventListener('input', function(e) {
                const value = e.target.value.trim().toLowerCase();
                e.target.value = value;

                if (value.length === 0) {
                    e.target.classList.remove('valid', 'invalid');
                    upiError.style.display = 'none';
                } else if (/^[\w.-]+@[\w.-]{4,}$/.test(value)) {
                    e.target.classList.remove('invalid');
                    e.target.classList.add('valid');
                    upiError.style.display = 'none';
                } else {
                    e.target.classList.remove('valid');
                    e.target.classList.add('invalid');
                    upiError.style.display = 'block';
                }
                validateForm();
            });

            // Validate form and enable/disable Place Order button
            function validateForm() {
                let isValid = false;

                if (currentPaymentMethod === 'card') {
                    const rawCard = cardNumber.value.replace(/\D/g, '');
                    const trimmedName = cardName.value.trim();
                    const rawExpiry = expiryDate.value.replace(/\D/g, '');
                    const rawCvv = cvv.value.replace(/\D/g, '');

                    if (rawCard.length === 16 && 
                        trimmedName.length >= 2 && trimmedName.length <= 50 && /^[A-Za-z\s]+$/.test(trimmedName) &&
                        rawExpiry.length === 4 && 
                        rawCvv.length === 3) {
                        
                        const month = parseInt(rawExpiry.slice(0, 2));
                        const year = parseInt(rawExpiry.slice(2, 4));
                        const currentYear = new Date().getFullYear() % 100;
                        const currentMonth = new Date().getMonth() + 1;
                        
                        if (month >= 1 && month <= 12 && year >= currentYear && 
                            !(year === currentYear && month < currentMonth)) {
                            isValid = true;
                        }
                    }
                } else if (currentPaymentMethod === 'upi') {
                    const upiValue = upiId.value.trim();
                    // UPI is valid if either UPI ID is entered with proper format OR they can scan QR
                    // For simplicity, we'll allow proceeding if UPI is selected (QR scan option available)
                    isValid = upiValue.length === 0 || /^[\w.-]+@[\w.-]{4,}$/.test(upiValue);
                } else if (currentPaymentMethod === 'cod') {
                    // COD is always valid
                    isValid = true;
                }

                placeOrderBtn.disabled = !isValid;
                if (isValid) {
                    placeOrderBtn.style.opacity = '1';
                    placeOrderBtn.style.cursor = 'pointer';
                } else {
                    placeOrderBtn.style.opacity = '0.6';
                    placeOrderBtn.style.cursor = 'not-allowed';
                }
            }

            // Form submission validation
            form.addEventListener('submit', function(e) {
                if (currentPaymentMethod === 'card') {
                    let isValid = true;

                    const rawCard = cardNumber.value.replace(/\D/g, '');
                    if (rawCard.length !== 16) {
                        e.preventDefault();
                        cardError.style.display = 'block';
                        cardNumber.classList.add('invalid');
                        cardNumber.focus();
                        isValid = false;
                    }

                    const trimmedName = cardName.value.trim();
                    if (trimmedName.length < 2 || trimmedName.length > 50 || !/^[A-Za-z\s]+$/.test(trimmedName)) {
                        e.preventDefault();
                        cardNameError.style.display = 'block';
                        cardName.classList.add('invalid');
                        if (isValid) cardName.focus();
                        isValid = false;
                    }

                    const rawExpiry = expiryDate.value.replace(/\D/g, '');
                    if (rawExpiry.length !== 4) {
                        e.preventDefault();
                        expiryError.style.display = 'block';
                        expiryDate.classList.add('invalid');
                        if (isValid) expiryDate.focus();
                        isValid = false;
                    }

                    const rawCvv = cvv.value.replace(/\D/g, '');
                    if (rawCvv.length !== 3) {
                        e.preventDefault();
                        cvvError.style.display = 'block';
                        cvv.classList.add('invalid');
                        if (isValid) cvv.focus();
                        isValid = false;
                    }
                }
            });

            // Initial validation
            validateForm();
        });
    </script>

    <jsp:include page="includes/footer.jsp" />
</body>
</html>

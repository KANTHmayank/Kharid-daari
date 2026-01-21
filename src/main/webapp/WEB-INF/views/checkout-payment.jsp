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
            <a href="${pageContext.request.contextPath}/checkout/review" class="step">3. Review</a>
            <span class="step active">4. Payment</span>
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

            <div class="payment-info" id="card-info">
                <strong>Card Details Already Provided</strong>
                <p style="margin-top: 0.5rem; font-size: 0.95rem;">Card ending in ${billingInfo.cardNumber.substring(billingInfo.cardNumber.length() - 4)}</p>
                <p style="font-size: 0.9rem; color: #666;">Name: ${billingInfo.cardName}</p>
                <p style="font-size: 0.9rem; color: #666;">Expiry: ${billingInfo.expiryDate}</p>
                <a href="${pageContext.request.contextPath}/checkout/billing" style="color: #667eea; font-size: 0.9rem;">Change Card</a>
            </div>

            <div class="payment-info" id="upi-info" style="display: none;">
                <strong>UPI Payment</strong>
                <p style="margin-top: 0.5rem;">You will be redirected to your UPI app to complete the payment.</p>
            </div>

            <div class="payment-info" id="cod-info" style="display: none;">
                <strong>Cash on Delivery</strong>
                <p style="margin-top: 0.5rem;">Pay cash when your order is delivered to your doorstep.</p>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/checkout/place-order" method="post">
            <input type="hidden" name="paymentMethod" id="selectedPaymentMethod" value="card">
            <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                <a href="${pageContext.request.contextPath}/checkout/review" class="btn-back">Back</a>
                <button type="submit" class="btn-place-order">Place Order</button>
            </div>
        </form>
    </div>

    <script>
        const paymentMethods = document.querySelectorAll('.payment-method');
        const cardInfo = document.getElementById('card-info');
        const upiInfo = document.getElementById('upi-info');
        const codInfo = document.getElementById('cod-info');
        const selectedPaymentInput = document.getElementById('selectedPaymentMethod');

        paymentMethods.forEach(method => {
            method.addEventListener('click', function() {
                paymentMethods.forEach(m => m.classList.remove('selected'));
                this.classList.add('selected');
                const radio = this.querySelector('input[type="radio"]');
                radio.checked = true;
                
                const paymentType = radio.value;
                selectedPaymentInput.value = paymentType;

                cardInfo.style.display = 'none';
                upiInfo.style.display = 'none';
                codInfo.style.display = 'none';

                if (paymentType === 'card') {
                    cardInfo.style.display = 'block';
                } else if (paymentType === 'upi') {
                    upiInfo.style.display = 'block';
                } else if (paymentType === 'cod') {
                    codInfo.style.display = 'block';
                }
            });
        });
    </script>

    <jsp:include page="includes/footer.jsp" />
</body>
</html>

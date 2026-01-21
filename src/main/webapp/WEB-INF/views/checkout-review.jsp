<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout - Review</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .checkout-container { max-width: 800px; margin: 2rem auto; padding: 2rem; background: #fff; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        .steps { display: flex; justify-content: space-between; margin-bottom: 2rem; border-bottom: 1px solid #eee; padding-bottom: 1rem; }
        .step { color: #ccc; font-weight: bold; padding: 0.5rem 1rem; border-radius: 5px; text-decoration: none; transition: all 0.3s ease; }
        .step.active { color: #667eea; background: rgba(102, 126, 234, 0.1); }
        .step:not(.active):not(.disabled):hover { color: #667eea; background: #f0f0f0; cursor: pointer; }
        a.step { display: inline-block; }
        .review-section { margin-bottom: 2rem; padding: 1.5rem; border: 1px solid #eee; border-radius: 8px; }
        .review-section h3 { margin-bottom: 1rem; color: #333; }
        .summary-row { display: flex; justify-content: space-between; margin-bottom: 0.5rem; }
        .total-row { font-weight: bold; font-size: 1.2rem; margin-top: 1rem; border-top: 2px solid #ddd; padding-top: 1rem; color: #667eea; }
        .btn-place-order { background: #28a745; color: white; padding: 1rem 2rem; border: none; border-radius: 5px; font-size: 1.2rem; cursor: pointer; width: 100%; margin-top: 2rem; transition: background 0.3s ease; text-decoration: none; text-align: center; }
        .btn-place-order:hover { background: #218838; }
        .btn-back { background: #6c757d; color: white; padding: 1rem 2rem; border: none; border-radius: 5px; font-size: 1.2rem; cursor: pointer; width: 100%; margin-top: 2rem; text-decoration: none; text-align: center; }
        .alert-error { color: #dc3545; background-color: #f8d7da; border: 1px solid #f5c6cb; padding: 1rem; margin-bottom: 1rem; border-radius: 5px; }
    </style>
</head>
<body>
    <jsp:include page="includes/header.jsp" />

    <div class="checkout-container">
        <div class="steps">
            <a href="${pageContext.request.contextPath}/checkout/shipping" class="step">1. Shipping</a>
            <a href="${pageContext.request.contextPath}/checkout/billing" class="step">2. Billing</a>
            <span class="step active">3. Review</span>
            <span class="step">4. Payment</span>
        </div>

        <c:if test="${not empty error}">
            <div class="alert-error">${error}</div>
        </c:if>

        <h2>Review Your Order</h2>

        <div class="review-section">
            <h3>Shipping Address</h3>
            <p>
                <strong>${shippingAddress.line1}</strong><br>
                <c:if test="${not empty shippingAddress.line2}">${shippingAddress.line2}<br></c:if>
                ${shippingAddress.city}, ${shippingAddress.state} ${shippingAddress.postalCode}<br>
                ${shippingAddress.country}
            </p>
            <a href="${pageContext.request.contextPath}/checkout/shipping" style="color: #667eea;">Edit</a>
        </div>

        <c:if test="${not empty billingAddress}">
            <div class="review-section">
                <h3>Billing Address</h3>
                <p>
                    <strong>${billingAddress.line1}</strong><br>
                    <c:if test="${not empty billingAddress.line2}">${billingAddress.line2}<br></c:if>
                    ${billingAddress.city}, ${billingAddress.state} ${billingAddress.postalCode}<br>
                    ${billingAddress.country}
                </p>
                <a href="${pageContext.request.contextPath}/checkout/billing" style="color: #667eea;">Edit</a>
            </div>
        </c:if>

        <div class="review-section">
            <h3>Order Summary</h3>
            <c:forEach items="${cart.items}" var="item">
                <div class="summary-row">
                    <span>${item.productName} x ${item.quantity}</span>
                    <span>₹ ${item.subtotal}</span>
                </div>
            </c:forEach>
            <div class="summary-row total-row">
                <span>Grand Total</span>
                <span>₹ ${cart.total}</span>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/checkout/payment" method="get">
            <div style="display: flex; gap: 1rem;">
                <a href="${pageContext.request.contextPath}/checkout/billing" class="btn-back">Back</a>
                <button type="submit" class="btn-place-order" style="background: #667eea;">Continue to Payment</button>
            </div>
        </form>
    </div>

    <jsp:include page="includes/footer.jsp" />
</body>
</html>

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
        .steps { display: flex; justify-content: space-between; margin-bottom: 2rem; border-bottom: 1px solid #eee; padding-bottom: 1rem; }
        .step { color: #ccc; font-weight: bold; padding: 0.5rem 1rem; border-radius: 5px; text-decoration: none; transition: all 0.3s ease; }
        .step.active { color: #667eea; background: rgba(102, 126, 234, 0.1); }
        .step.disabled { cursor: default; }
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
        
        <form action="${pageContext.request.contextPath}/checkout/shipping" method="post">
            <c:if test="${empty addresses}">
                <p>No addresses found. Please go to your <a href="${pageContext.request.contextPath}/profile">profile</a> to add an address.</p>
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

            <button type="submit" class="btn-proceed" ${empty addresses ? 'disabled' : ''}>Continue to Billing</button>
        </form>
    </div>

    <jsp:include page="includes/footer.jsp" />
</body>
</html>

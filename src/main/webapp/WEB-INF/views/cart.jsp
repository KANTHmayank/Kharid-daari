<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Shopping Cart - Kharid-daari</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                <style>
                    .cart-container {
                        max-width: 1200px;
                        margin: 2rem auto;
                        padding: 2rem;
                    }

                    .cart-items {
                        background: white;
                        border-radius: 10px;
                        padding: 2rem;
                        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                        margin-bottom: 2rem;
                    }

                    .cart-item {
                        display: flex;
                        align-items: center;
                        padding: 1.5rem 0;
                        border-bottom: 1px solid #eee;
                    }

                    .cart-item:last-child {
                        border-bottom: none;
                    }

                    .cart-item img {
                        width: 100px;
                        height: 100px;
                        object-fit: cover;
                        border-radius: 10px;
                        margin-right: 2rem;
                    }

                    .cart-item-details {
                        flex: 1;
                    }

                    .cart-item-name {
                        font-size: 1.2rem;
                        font-weight: 600;
                        color: #333;
                        margin-bottom: 0.5rem;
                    }

                    .cart-item-price {
                        font-size: 1.1rem;
                        color: #667eea;
                        font-weight: 600;
                    }

                    .cart-item-quantity {
                        display: flex;
                        align-items: center;
                        gap: 1rem;
                        margin: 1rem 0;
                    }

                    .cart-item-quantity input {
                        width: 60px;
                        padding: 0.5rem;
                        border: 2px solid #ddd;
                        border-radius: 5px;
                        text-align: center;
                    }

                    .cart-item-actions {
                        display: flex;
                        gap: 1rem;
                    }

                    .cart-summary {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        border-radius: 10px;
                        padding: 2rem;
                        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
                    }

                    .cart-summary h3 {
                        margin-bottom: 1.5rem;
                        font-size: 1.5rem;
                    }

                    .cart-summary-row {
                        display: flex;
                        justify-content: space-between;
                        margin-bottom: 1rem;
                        font-size: 1.1rem;
                    }

                    .cart-summary-total {
                        border-top: 2px solid rgba(255, 255, 255, 0.3);
                        padding-top: 1rem;
                        margin-top: 1rem;
                        font-size: 1.5rem;
                        font-weight: 700;
                    }

                    .empty-cart {
                        text-align: center;
                        padding: 4rem 2rem;
                    }

                    .empty-cart h2 {
                        color: #667eea;
                        margin-bottom: 1rem;
                    }
                </style>
            </head>

            <body>
                <jsp:include page="includes/header.jsp" />

                <div class="cart-container">
                    <h2>Shopping Cart</h2>

                    <c:choose>
                        <c:when test="${empty cart.items}">
                            <div class="empty-cart">
                                <h2>Your cart is empty</h2>
                                <p>Start shopping and add items to your cart!</p>
                                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">Continue
                                    Shopping</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="cart-items">
                                <c:forEach var="item" items="${cart.items}">
                                    <div class="cart-item">
                                        <img src="${item.productImage}" alt="${item.productName}">
                                        <div class="cart-item-details">
                                            <div class="cart-item-name">${item.productName}</div>
                                            <div class="cart-item-price">₹
                                                <fmt:formatNumber value="${item.price}" type="number"
                                                    minFractionDigits="2" maxFractionDigits="2" />
                                            </div>

                                            <form action="${pageContext.request.contextPath}/cart/update" method="post"
                                                class="cart-item-quantity" onsubmit="return validateQuantity(this)">
                                                <input type="hidden" name="productId" value="${item.productId}">
                                                <label>Quantity:</label>
                                                <input type="number" name="quantity" value="${item.quantity}" min="1"
                                                    max="999">
                                                <button type="submit" class="btn btn-outline"
                                                    style="padding: 0.5rem 1rem;">Update</button>
                                            </form>

                                            <div class="cart-item-price">
                                                Subtotal: ₹
                                                <fmt:formatNumber value="${item.subtotal}" type="number"
                                                    minFractionDigits="2" maxFractionDigits="2" />
                                            </div>
                                        </div>

                                        <div class="cart-item-actions">
                                            <form action="${pageContext.request.contextPath}/cart/remove" method="post">
                                                <input type="hidden" name="productId" value="${item.productId}">
                                                <button type="submit" class="btn btn-primary"
                                                    style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">Remove</button>
                                            </form>
                                        </div>
                                    </div>
                                </c:forEach>

                                <div style="margin-top: 2rem; text-align: right;">
                                    <form action="${pageContext.request.contextPath}/cart/clear" method="post"
                                        style="display: inline;"
                                        onsubmit="return confirm('Are you sure you want to clear the cart?')">
                                        <button type="submit" class="btn btn-outline">Clear Cart</button>
                                    </form>
                                </div>
                            </div>

                            <div class="cart-summary">
                                <h3>Order Summary</h3>
                                <div class="cart-summary-row">
                                    <span>Items (${cart.itemCount}):</span>
                                    <span>₹
                                        <fmt:formatNumber value="${cart.total}" type="number" minFractionDigits="2"
                                            maxFractionDigits="2" />
                                    </span>
                                </div>
                                <div class="cart-summary-row cart-summary-total">
                                    <span>Total:</span>
                                    <span>₹
                                        <fmt:formatNumber value="${cart.total}" type="number" minFractionDigits="2"
                                            maxFractionDigits="2" />
                                    </span>
                                </div>
                                <a href="${pageContext.request.contextPath}/checkout" class="btn btn-block"
                                    style="background: white; color: #667eea; margin-top: 1.5rem;">Proceed to
                                    Checkout</a>
                                <a href="${pageContext.request.contextPath}/products" class="btn btn-block"
                                    style="background: white; color: #667eea; margin-top: 1rem;">Continue Shopping</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <script>
                    function validateQuantity(form) {
                        const quantity = parseInt(form.querySelector('input[name="quantity"]').value);
                        if (quantity < 1) {
                            alert('Quantity must be at least 1');
                            return false;
                        }
                        return true;
                    }
                </script>

                <jsp:include page="includes/footer.jsp" />
            </body>

            </html>
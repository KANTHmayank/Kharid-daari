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

                    .modal {
                        display: none;
                        position: fixed;
                        z-index: 1000;
                        left: 0;
                        top: 0;
                        width: 100%;
                        height: 100%;
                        overflow: auto;
                        background-color: rgba(0, 0, 0, 0.5);
                        align-items: center;
                        justify-content: center;
                    }

                    .modal-content {
                        background-color: #fefefe;
                        padding: 2rem;
                        border-radius: 10px;
                        width: 90%;
                        max-width: 400px;
                        text-align: center;
                        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
                        animation: slideDown 0.3s ease-out;
                    }

                    @keyframes slideDown {
                        from { transform: translateY(-50px); opacity: 0; }
                        to { transform: translateY(0); opacity: 1; }
                    }

                    .modal-buttons {
                        margin-top: 2rem;
                        display: flex;
                        justify-content: center;
                        gap: 1rem;
                    }

                    .btn-danger {
                        background: linear-gradient(135deg, #ff416c 0%, #ff4b2b 100%);
                        color: white;
                        border: none;
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
                                        onsubmit="return confirmClear(event)">
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

                <!-- Custom Confirmation Modal -->
                <div id="clearCartModal" class="modal">
                    <div class="modal-content">
                        <h3 style="color: #333; margin-bottom: 1rem;">Clear Shopping Cart?</h3>
                        <p style="color: #666; margin-bottom: 1.5rem;">Are you sure you want to remove all items from your cart? This action cannot be undone.</p>
                        <div class="modal-buttons">
                            <button id="confirmClearBtn" type="button" class="btn btn-primary btn-danger">Yes, Clear Cart</button>
                            <button onclick="closeModal()" type="button" class="btn btn-outline" style="border: 1px solid #ddd;">Cancel</button>
                        </div>
                    </div>
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

                    let clearFormToSubmit = null;

                    function confirmClear(event) {
                        event.preventDefault(); // Stop default form submission
                        clearFormToSubmit = event.target; // Store the form reference
                        const modal = document.getElementById('clearCartModal');
                        modal.style.display = "flex";
                        return false;
                    }

                    function closeModal() {
                        const modal = document.getElementById('clearCartModal');
                        modal.style.display = "none";
                        clearFormToSubmit = null;
                    }

                    // Handle Confirm Click
                    document.getElementById('confirmClearBtn').onclick = function() {
                        if (clearFormToSubmit) {
                            clearFormToSubmit.submit();
                        }
                    };

                    // Close if clicked outside
                    window.onclick = function(event) {
                        const modal = document.getElementById('clearCartModal');
                        if (event.target == modal) {
                            closeModal();
                        }
                    }
                </script>

                <jsp:include page="includes/footer.jsp" />
            </body>

            </html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Order History - Kharid-daari</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                <style>
                    .orders-container {
                        max-width: 1200px;
                        margin: 2rem auto;
                        padding: 2rem;
                    }

                    .order-card {
                        background: white;
                        border-radius: 10px;
                        padding: 2rem;
                        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                        margin-bottom: 2rem;
                    }

                    .order-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        padding-bottom: 1rem;
                        border-bottom: 2px solid #eee;
                        margin-bottom: 1rem;
                    }

                    .order-id {
                        font-size: 1.2rem;
                        font-weight: 600;
                        color: #333;
                    }

                    .order-date {
                        color: #666;
                    }

                    .order-status {
                        padding: 0.5rem 1rem;
                        border-radius: 20px;
                        font-weight: 600;
                        font-size: 0.9rem;
                    }

                    .status-pending {
                        background: #fff3cd;
                        color: #856404;
                    }

                    .status-processing {
                        background: #cce5ff;
                        color: #004085;
                    }

                    .status-shipped {
                        background: #d1ecf1;
                        color: #0c5460;
                    }

                    .status-delivered {
                        background: #d4edda;
                        color: #155724;
                    }

                    .status-cancelled {
                        background: #f8d7da;
                        color: #721c24;
                    }

                    .order-items {
                        margin: 1.5rem 0;
                    }

                    .order-item {
                        display: flex;
                        align-items: center;
                        padding: 1rem;
                        border-bottom: 1px solid #eee;
                    }

                    .order-item:last-child {
                        border-bottom: none;
                    }

                    .order-item-image {
                        width: 80px;
                        height: 80px;
                        object-fit: cover;
                        border-radius: 8px;
                        margin-right: 1.5rem;
                    }

                    .order-item-details {
                        flex: 1;
                    }

                    .order-item-name {
                        font-size: 1.1rem;
                        font-weight: 600;
                        color: #333;
                        margin-bottom: 0.5rem;
                    }

                    .order-item-info {
                        color: #666;
                        font-size: 0.95rem;
                    }

                    .order-summary {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        padding: 1.5rem;
                        border-radius: 8px;
                        margin-top: 1rem;
                    }

                    .order-summary-row {
                        display: flex;
                        justify-content: space-between;
                        margin-bottom: 0.5rem;
                    }

                    .order-total {
                        font-size: 1.3rem;
                        font-weight: 700;
                        border-top: 2px solid rgba(255, 255, 255, 0.3);
                        padding-top: 0.5rem;
                        margin-top: 0.5rem;
                    }

                    .empty-orders {
                        text-align: center;
                        padding: 4rem 2rem;
                    }

                    .empty-orders h2 {
                        color: #667eea;
                        margin-bottom: 1rem;
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

                    .profile-tab:hover {
                        color: #667eea;
                    }
                </style>
            </head>

            <body>
                <jsp:include page="includes/header.jsp" />

                <div class="orders-container">
                    <h2>My Profile</h2>

                    <div class="profile-tabs">
                        <button class="profile-tab"
                            onclick="window.location.href='${pageContext.request.contextPath}/profile#details'">Profile
                            Details</button>
                        <button class="profile-tab"
                            onclick="window.location.href='${pageContext.request.contextPath}/profile#edit'">Edit
                            Profile</button>
                        <button class="profile-tab"
                            onclick="window.location.href='${pageContext.request.contextPath}/profile#password'">Change
                            Password</button>
                        <button class="profile-tab"
                            onclick="window.location.href='${pageContext.request.contextPath}/profile/addresses'">Addresses</button>
                        <button class="profile-tab active">Order History</button>
                    </div>

                    <c:choose>
                        <c:when test="${empty orders}">
                            <div class="empty-orders">
                                <h2>No orders yet</h2>
                                <p>You haven't placed any orders yet. Start shopping!</p>
                                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">Browse
                                    Products</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="order" items="${orders}">
                                <div class="order-card">
                                    <div class="order-header">
                                        <div>
                                            <div class="order-id">Order #${order.id}</div>
                                            <div class="order-date">
                                                Placed on
                                                <fmt:formatDate value="${order.createdAt}"
                                                    pattern="MMM dd, yyyy 'at' hh:mm a" />
                                            </div>
                                        </div>
                                        <div>
                                            <c:set var="statusClass" value="status-${order.status.toLowerCase()}" />
                                            <span class="order-status ${statusClass}">
                                                ${order.status}
                                            </span>
                                        </div>
                                    </div>

                                    <div class="order-items">
                                        <c:forEach var="item" items="${order.items}">
                                            <div class="order-item">
                                                <img src="${item.productImage}" alt="${item.productName}"
                                                    class="order-item-image">
                                                <div class="order-item-details">
                                                    <div class="order-item-name">${item.productName}</div>
                                                    <div class="order-item-info">
                                                        Quantity: ${item.quantity} × ₹
                                                        <fmt:formatNumber value="${item.unitPrice}" type="number"
                                                            minFractionDigits="2" maxFractionDigits="2" />
                                                    </div>
                                                </div>
                                                <div class="order-item-total">
                                                    ₹
                                                    <fmt:formatNumber value="${item.lineTotal}" type="number"
                                                        minFractionDigits="2" maxFractionDigits="2" />
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>

                                    <div class="order-summary">
                                        <div class="order-summary-row">
                                            <span>Subtotal:</span>
                                            <span>₹
                                                <fmt:formatNumber value="${order.subtotal}" type="number"
                                                    minFractionDigits="2" maxFractionDigits="2" />
                                            </span>
                                        </div>
                                        <div class="order-summary-row">
                                            <span>Tax:</span>
                                            <span>₹
                                                <fmt:formatNumber value="${order.tax}" type="number"
                                                    minFractionDigits="2" maxFractionDigits="2" />
                                            </span>
                                        </div>
                                        <div class="order-summary-row">
                                            <span>Shipping:</span>
                                            <span>₹
                                                <fmt:formatNumber value="${order.shippingFee}" type="number"
                                                    minFractionDigits="2" maxFractionDigits="2" />
                                            </span>
                                        </div>
                                        <div class="order-summary-row order-total">
                                            <span>Total:</span>
                                            <span>₹
                                                <fmt:formatNumber value="${order.totalAmount}" type="number"
                                                    minFractionDigits="2" maxFractionDigits="2" />
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>

                    <div style="margin-top: 2rem;">
                        <a href="${pageContext.request.contextPath}/profile" class="btn btn-outline">Back to Profile</a>
                    </div>
                </div>

                <jsp:include page="includes/footer.jsp" />
            </body>

            </html>
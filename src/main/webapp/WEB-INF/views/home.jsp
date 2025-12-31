<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kharid-daari - Home</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <jsp:include page="includes/header.jsp" />    <!-- Hero Section -->
    <section class="hero">
        <div class="container">
            <h1>Welcome to Kharid-daari</h1>
            <p>Your one-stop destination for quality products</p>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">Shop Now</a>
        </div>
    </section>

    <!-- Featured Products -->
    <section class="products-section">
        <div class="container">
            <h2>Featured Products</h2>
            <div class="products-grid">
                <c:forEach var="product" items="${products}">
                    <div class="product-card">
                        <img src="${product.imageUrl}" alt="${product.name}">
                        <div class="product-info">
                            <h3>${product.name}</h3>
                            <p class="product-description">${product.description}</p>
                            <div class="product-footer">
                                <span class="price">$<fmt:formatNumber value="${product.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                                <c:choose>
                                    <c:when test="${product.stock > 0}">
                                        <span class="stock in-stock">In Stock</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="stock out-of-stock">Out of Stock</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <jsp:include page="includes/footer.jsp" />
</body>
</html>

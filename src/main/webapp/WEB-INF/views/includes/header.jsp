<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="header">
    <nav class="navbar">
        <div class="container">
            <div class="nav-brand">
                <a href="${pageContext.request.contextPath}/">Kharid-daari</a>
            </div>
            <ul class="nav-menu">
                <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/products">Products</a></li>
                <li><a href="${pageContext.request.contextPath}/about">About</a></li>
                <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
                <li>
                    <a href="${pageContext.request.contextPath}/cart" style="position: relative;">
                        🛒 Cart
                        <c:if test="${not empty sessionScope.cart && sessionScope.cart.itemCount > 0}">
                            <span id="cartCount" style="position: absolute; top: -8px; right: -10px; background: #f5576c; color: white; border-radius: 50%; width: 20px; height: 20px; display: flex; align-items: center; justify-content: center; font-size: 0.75rem; font-weight: bold;">
                                ${sessionScope.cart.itemCount}
                            </span>
                        </c:if>
                        <c:if test="${empty sessionScope.cart || sessionScope.cart.itemCount == 0}">
                            <span id="cartCount" style="position: absolute; top: -8px; right: -10px; background: #f5576c; color: white; border-radius: 50%; width: 20px; height: 20px; display: none; align-items: center; justify-content: center; font-size: 0.75rem; font-weight: bold;">
                                0
                            </span>
                        </c:if>
                    </a>
                </li>
            </ul>
            
            <div class="nav-auth">
                <c:choose>
                    <c:when test="${not empty sessionScope.userId}">
                        <a href="${pageContext.request.contextPath}/profile" class="btn btn-outline">My Profile</a>
                        <span class="user-greeting">Hello, ${sessionScope.userName}</span>
                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline">Logout</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">Login</a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Register</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </nav>
</header>

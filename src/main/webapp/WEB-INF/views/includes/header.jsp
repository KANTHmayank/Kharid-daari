<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="header">        <nav class="navbar">
            <div class="container">
                <div class="nav-brand">
                    <a href="${pageContext.request.contextPath}/">Kharid-daari</a>
                </div>
                <ul class="nav-menu">
                <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/products">Products</a></li>
                <li><a href="${pageContext.request.contextPath}/about">About</a></li>
                <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
            </ul>
            
            <div class="nav-auth">
                <c:choose>
                    <c:when test="${not empty sessionScope.userId}">
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

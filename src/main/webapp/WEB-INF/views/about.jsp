<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - Kharid-daari</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <jsp:include page="includes/header.jsp" />    <div class="about-container">
        <div class="container">
            <h2>About Kharid-daari</h2>
            <div class="about-content">
                <p>Welcome to Kharid-daari, your trusted online shopping destination!</p>
                
                <h3>Our Mission</h3>
                <p>We strive to provide quality products at competitive prices, with exceptional customer service.</p>
                
                <h3>Why Choose Us?</h3>
                <ul>
                    <li>Wide range of quality products</li>
                    <li>Secure payment processing</li>
                    <li>Fast and reliable shipping</li>
                    <li>24/7 customer support</li>
                    <li>Easy returns and exchanges</li>
                </ul>
                
                <h3>Our Values</h3>
                <p>We believe in transparency, quality, and customer satisfaction. Every product we offer is carefully selected to meet our high standards.</p>
            </div>
        </div>
    </div>

    <jsp:include page="includes/footer.jsp" />
</body>
</html>

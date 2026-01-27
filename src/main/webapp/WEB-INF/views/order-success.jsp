<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Processing</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow-x: hidden;
            overflow-y: auto;
            padding: 2rem 0;
        }

        .container {
            text-align: center;
            position: relative;
            width: 100%;
            max-width: 800px;
            padding: 1rem 2rem;
            margin: auto;
        }

        /* Loading Animation */
        .loading-screen {
            animation: fadeOut 0.5s ease-in-out 3.5s forwards;
        }

        .hold-on-text {
            font-size: 2.5rem;
            font-weight: bold;
            color: white;
            margin-bottom: 2rem;
            animation: pulse 1.5s ease-in-out infinite;
            text-shadow: 0 0 20px rgba(255, 255, 255, 0.5);
        }

        /* Rocket Animation */
        .rocket-container {
            position: relative;
            height: 150px;
            margin: 1rem 0;
            overflow: visible;
        }

        .rocket {
            position: absolute;
            left: -150px;
            top: 50%;
            transform: translateY(-50%) rotate(-45deg);
            animation: flyRocket 3s ease-in-out forwards;
            font-size: 80px;
            filter: drop-shadow(0 0 10px rgba(255, 255, 255, 0.5));
        }

        .trail {
            position: absolute;
            left: -200px;
            top: 50%;
            transform: translateY(-50%);
            animation: fadeTrail 3s ease-in-out forwards;
        }

        .trail span {
            display: inline-block;
            font-size: 24px;
            opacity: 0;
            animation: sparkle 0.8s ease-in-out infinite;
        }

        .trail span:nth-child(1) { animation-delay: 0s; }
        .trail span:nth-child(2) { animation-delay: 0.1s; }
        .trail span:nth-child(3) { animation-delay: 0.2s; }
        .trail span:nth-child(4) { animation-delay: 0.3s; }
        .trail span:nth-child(5) { animation-delay: 0.4s; }

        /* Success Screen */
        .success-screen {
            opacity: 0;
            animation: fadeIn 0.8s ease-in-out 3.5s forwards;
        }

        .success-screen.active {
            pointer-events: all;
        }

        .success-icon {
            width: 100px;
            height: 100px;
            margin: 0 auto 1.5rem;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            animation: scaleIn 0.5s ease-out 3.8s both;
        }

        .checkmark {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: block;
            stroke-width: 4;
            stroke: #4CAF50;
            stroke-miterlimit: 10;
            box-shadow: inset 0px 0px 0px #4CAF50;
            animation: fillCheck 0.4s ease-in-out 4s forwards, scaleCheck 0.3s ease-in-out 4.2s both;
        }

        .checkmark-circle {
            stroke-dasharray: 166;
            stroke-dashoffset: 166;
            stroke-width: 4;
            stroke-miterlimit: 10;
            stroke: #4CAF50;
            fill: none;
            animation: strokeCircle 0.6s cubic-bezier(0.65, 0, 0.45, 1) 3.8s forwards;
        }

        .checkmark-check {
            transform-origin: 50% 50%;
            stroke-dasharray: 48;
            stroke-dashoffset: 48;
            animation: strokeCheck 0.3s cubic-bezier(0.65, 0, 0.45, 1) 4.2s forwards;
        }

        .success-title {
            font-size: 2rem;
            font-weight: bold;
            color: white;
            margin-bottom: 0.8rem;
            text-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
            animation: slideUp 0.5s ease-out 3.8s both;
        }

        .success-message {
            font-size: 1.1rem;
            color: rgba(255, 255, 255, 0.9);
            margin-bottom: 1rem;
            animation: slideUp 0.5s ease-out 3.9s both;
        }

        .order-details {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 1.2rem;
            margin: 1.5rem auto;
            max-width: 500px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            animation: slideUp 0.5s ease-out 4s both;
        }

        .order-details p {
            color: white;
            margin: 0.4rem 0;
            font-size: 1rem;
        }

        .order-details strong {
            color: #ffd700;
        }

        .action-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 1.5rem;
            margin-bottom: 2rem;
            animation: slideUp 0.5s ease-out 4.1s both;
            flex-wrap: wrap;
        }

        .btn {
            padding: 0.9rem 2rem;
            font-size: 1rem;
            font-weight: 600;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
            position: relative;
            z-index: 10;
        }

        .btn-primary {
            background: white;
            color: #667eea !important;
            font-weight: 700;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.4);
            background: #f8f8f8;
            color: #5568d3 !important;
        }

        .btn-secondary {
            background: transparent;
            color: white;
            border: 2px solid white;
        }

        .btn-secondary:hover {
            background: white;
            color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.4);
        }

        /* Confetti */
        .confetti {
            position: fixed;
            width: 10px;
            height: 10px;
            background: #ffd700;
            position: absolute;
            animation: confettiFall 3s ease-in-out forwards;
        }

        .confetti:nth-child(1) { left: 10%; background: #ff6b6b; animation-delay: 4s; }
        .confetti:nth-child(2) { left: 20%; background: #4ecdc4; animation-delay: 4.1s; }
        .confetti:nth-child(3) { left: 30%; background: #ffe66d; animation-delay: 4.2s; }
        .confetti:nth-child(4) { left: 40%; background: #ff6b6b; animation-delay: 4.3s; }
        .confetti:nth-child(5) { left: 50%; background: #4ecdc4; animation-delay: 4.4s; }
        .confetti:nth-child(6) { left: 60%; background: #ffe66d; animation-delay: 4.5s; }
        .confetti:nth-child(7) { left: 70%; background: #ff6b6b; animation-delay: 4.6s; }
        .confetti:nth-child(8) { left: 80%; background: #4ecdc4; animation-delay: 4.7s; }
        .confetti:nth-child(9) { left: 90%; background: #ffe66d; animation-delay: 4.8s; }

        /* Animations */
        @keyframes flyRocket {
            0% {
                left: -150px;
                opacity: 0;
            }
            10% {
                opacity: 1;
            }
            90% {
                opacity: 1;
            }
            100% {
                left: calc(100% + 150px);
                opacity: 0;
            }
        }

        @keyframes fadeTrail {
            0%, 100% {
                opacity: 0;
            }
            50% {
                opacity: 1;
            }
        }

        @keyframes sparkle {
            0%, 100% {
                opacity: 0;
                transform: scale(0.5);
            }
            50% {
                opacity: 1;
                transform: scale(1);
            }
        }

        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.05);
            }
        }

        @keyframes fadeOut {
            to {
                opacity: 0;
                visibility: hidden;
            }
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes scaleIn {
            from {
                transform: scale(0);
            }
            to {
                transform: scale(1);
            }
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes strokeCircle {
            100% {
                stroke-dashoffset: 0;
            }
        }

        @keyframes strokeCheck {
            100% {
                stroke-dashoffset: 0;
            }
        }

        @keyframes fillCheck {
            100% {
                box-shadow: inset 0px 0px 0px 30px #4CAF50;
            }
        }

        @keyframes scaleCheck {
            0%, 100% {
                transform: none;
            }
            50% {
                transform: scale3d(1.1, 1.1, 1);
            }
        }

        @keyframes confettiFall {
            0% {
                top: -10%;
                transform: translateX(0) rotateZ(0deg);
            }
            100% {
                top: 110%;
                transform: translateX(100px) rotateZ(720deg);
            }
        }

        /* Responsive */
        @media (max-width: 768px) {
            .hold-on-text {
                font-size: 1.8rem;
            }

            .success-title {
                font-size: 1.6rem;
            }

            .success-message {
                font-size: 0.95rem;
            }

            .action-buttons {
                flex-direction: column;
                width: 100%;
                padding: 0 1rem;
            }

            .btn {
                width: 100%;
                max-width: 300px;
                margin: 0 auto;
            }

            .rocket {
                font-size: 60px;
            }

            .container {
                padding: 1rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Loading Screen -->
        <div class="loading-screen">
            <h1 class="hold-on-text">Hold On...</h1>
            <div class="rocket-container">
                <div class="trail">
                    <span>✨</span>
                    <span>✨</span>
                    <span>✨</span>
                    <span>✨</span>
                    <span>✨</span>
                </div>
                <div class="rocket">🚀</div>
            </div>
        </div>

        <!-- Success Screen -->
        <div class="success-screen">
            <div class="success-icon">
                <svg class="checkmark" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 52 52">
                    <circle class="checkmark-circle" cx="26" cy="26" r="25" fill="none"/>
                    <path class="checkmark-check" fill="none" d="M14.1 27.2l7.1 7.2 16.7-16.8"/>
                </svg>
            </div>

            <h1 class="success-title">🎉 Order Placed Successfully!</h1>
            <p class="success-message">Thank you for your purchase. Your order is being processed.</p>

            <c:if test="${not empty orderId}">
                <div class="order-details">
                    <p><strong>Order ID:</strong> #${orderId}</p>
                    <c:if test="${not empty paymentMethod}">
                        <p><strong>Payment Method:</strong> ${paymentMethod}</p>
                    </c:if>
                    <p>📧 Confirmation email will be sent shortly</p>
                </div>
            </c:if>

            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">Continue Shopping</a>
                <a href="${pageContext.request.contextPath}/profile/orders" class="btn btn-secondary">View Orders</a>
            </div>

            <!-- Confetti -->
            <div class="confetti"></div>
            <div class="confetti"></div>
            <div class="confetti"></div>
            <div class="confetti"></div>
            <div class="confetti"></div>
            <div class="confetti"></div>
            <div class="confetti"></div>
            <div class="confetti"></div>
            <div class="confetti"></div>
        </div>
    </div>

    <script>
        // Make sure success screen is fully interactive after animation
        setTimeout(function() {
            var successScreen = document.querySelector('.success-screen');
            if (successScreen) {
                successScreen.classList.add('active');
                successScreen.style.pointerEvents = 'all';
            }
            
            // Ensure all links and buttons are clickable
            var allLinks = document.querySelectorAll('.btn, a');
            allLinks.forEach(function(link) {
                link.style.pointerEvents = 'all';
                link.style.cursor = 'pointer';
            });
        }, 3800);
    </script>
</body>
</html>

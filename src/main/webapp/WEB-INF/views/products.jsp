<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Products - Kharid-daari</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                <style>
                    .filter-sort-container {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-bottom: 2rem;
                        flex-wrap: wrap;
                        gap: 1rem;
                    }

                    .filter-group,
                    .sort-group {
                        display: flex;
                        align-items: center;
                        gap: 1rem;
                    }

                    .filter-group select,
                    .sort-group select {
                        padding: 0.5rem 1rem;
                        border: 2px solid #667eea;
                        border-radius: 5px;
                        font-size: 1rem;
                        background-color: white;
                        cursor: pointer;
                    }

                    .quantity-selector {
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                        margin-top: 1rem;
                    }

                    .quantity-selector input {
                        width: 60px;
                        padding: 0.5rem;
                        border: 2px solid #ddd;
                        border-radius: 5px;
                        text-align: center;
                        font-size: 1rem;
                    }

                    .btn-add-to-cart {
                        margin-top: 1rem;
                        width: 100%;
                        padding: 0.8rem;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        border: none;
                        border-radius: 50px;
                        cursor: pointer;
                        font-size: 1rem;
                        font-weight: 600;
                        transition: all 0.3s;
                    }

                    .btn-add-to-cart:hover:not(:disabled) {
                        transform: translateY(-2px);
                        box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
                    }

                    .btn-add-to-cart:disabled {
                        background: #ccc;
                        cursor: not-allowed;
                    }

                    .notification {
                        position: fixed;
                        top: 80px;
                        right: 20px;
                        padding: 1rem 1.5rem;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        border-radius: 10px;
                        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
                        z-index: 1000;
                        animation: slideIn 0.3s ease-out;
                    }

                    @keyframes slideIn {
                        from {
                            transform: translateX(400px);
                            opacity: 0;
                        }

                        to {
                            transform: translateX(0);
                            opacity: 1;
                        }
                    }
                </style>
            </head>

            <body>
                <jsp:include page="includes/header.jsp" />

                <section class="products-page">
                    <div class="container">
                        <h2>All Products</h2>

                        <!-- Filter and Sort Options -->
                        <div class="filter-sort-container">
                            <div class="filter-group">
                                <label for="priceFilter">Filter by Price:</label>
                                <select id="priceFilter" onchange="filterAndSort()">
                                    <option value="all">All Prices</option>
                                    <option value="0-50">Under ₹50</option>
                                    <option value="50-100">₹50 - ₹100</option>
                                    <option value="100-200">₹100 - ₹200</option>
                                    <option value="200+">Over ₹200</option>
                                </select>

                                <label for="stockFilter">Availability:</label>
                                <select id="stockFilter" onchange="filterAndSort()">
                                    <option value="all">All</option>
                                    <option value="instock">In Stock</option>
                                    <option value="outofstock">Out of Stock</option>
                                </select>
                            </div>

                            <div class="sort-group">
                                <label for="sortBy">Sort by:</label>
                                <select id="sortBy" onchange="filterAndSort()">
                                    <option value="default">Default</option>
                                    <option value="name-asc">Name (A-Z)</option>
                                    <option value="name-desc">Name (Z-A)</option>
                                    <option value="price-asc">Price (Low to High)</option>
                                    <option value="price-desc">Price (High to Low)</option>
                                    <option value="stock-desc">Stock (High to Low)</option>
                                </select>
                            </div>
                        </div>

                        <div class="products-grid" id="productsGrid">
                            <c:forEach var="product" items="${products}">
                                <div class="product-card" data-price="${product.price}" data-stock="${product.stock}"
                                    data-name="${product.name}">
                                    <img src="${product.imageUrl}" alt="${product.name}">
                                    <div class="product-info">
                                        <h3>${product.name}</h3>
                                        <p class="product-description">${product.description}</p>
                                        <div class="product-footer">
                                            <span class="price">₹
                                                <fmt:formatNumber value="${product.price}" type="number"
                                                    minFractionDigits="2" maxFractionDigits="2" />
                                            </span>
                                            <c:choose>
                                                <c:when test="${product.stock > 0}">
                                                    <span class="stock in-stock">In Stock (${product.stock})</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="stock out-of-stock">Out of Stock</span>
                                                </c:otherwise>
                                            </c:choose>

                                        </div>
                                        <div class="product-meta"
                                            style="margin-bottom: 0.5rem; font-size: 0.9rem; color: #666;">
                                            <span id="cart-qty-${product.id}">In Cart: ${cartQuantities[product.id] !=
                                                null ? cartQuantities[product.id] : 0}</span>
                                        </div>

                                        <c:if test="${product.stock > 0}">
                                            <div class="quantity-selector">
                                                <label for="qty-${product.id}">Quantity:</label>
                                                <input type="number" id="qty-${product.id}" value="1" min="1"
                                                    max="${product.stock}">
                                            </div>
                                            <button class="btn-add-to-cart"
                                                onclick="addToCart(${product.id}, ${product.stock})">
                                                Add to Cart
                                            </button>
                                        </c:if>
                                        <c:if test="${product.stock <= 0}">
                                            <button class="btn-add-to-cart" disabled>
                                                Out of Stock
                                            </button>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </section>

                <script>
                    function filterAndSort() {
                        const priceFilter = document.getElementById('priceFilter').value;
                        const stockFilter = document.getElementById('stockFilter').value;
                        const sortBy = document.getElementById('sortBy').value;
                        const productsGrid = document.getElementById('productsGrid');
                        const products = Array.from(productsGrid.getElementsByClassName('product-card'));

                        // Filter products
                        products.forEach(product => {
                            let showProduct = true;
                            const price = parseFloat(product.dataset.price);
                            const stock = parseInt(product.dataset.stock);

                            // Price filter
                            if (priceFilter !== 'all') {
                                if (priceFilter === '0-50' && price >= 50) showProduct = false;
                                else if (priceFilter === '50-100' && (price < 50 || price >= 100)) showProduct = false;
                                else if (priceFilter === '100-200' && (price < 100 || price >= 200)) showProduct = false;
                                else if (priceFilter === '200+' && price < 200) showProduct = false;
                            }

                            // Stock filter
                            if (stockFilter !== 'all') {
                                if (stockFilter === 'instock' && stock <= 0) showProduct = false;
                                else if (stockFilter === 'outofstock' && stock > 0) showProduct = false;
                            }

                            product.style.display = showProduct ? 'block' : 'none';
                        });

                        // Sort products
                        const visibleProducts = products.filter(p => p.style.display !== 'none');

                        if (sortBy !== 'default') {
                            visibleProducts.sort((a, b) => {
                                const priceA = parseFloat(a.dataset.price);
                                const priceB = parseFloat(b.dataset.price);
                                const nameA = a.dataset.name.toLowerCase();
                                const nameB = b.dataset.name.toLowerCase();
                                const stockA = parseInt(a.dataset.stock);
                                const stockB = parseInt(b.dataset.stock);

                                switch (sortBy) {
                                    case 'name-asc': return nameA.localeCompare(nameB);
                                    case 'name-desc': return nameB.localeCompare(nameA);
                                    case 'price-asc': return priceA - priceB;
                                    case 'price-desc': return priceB - priceA;
                                    case 'stock-desc': return stockB - stockA;
                                    default: return 0;
                                }
                            });

                            // Re-append sorted products
                            visibleProducts.forEach(product => productsGrid.appendChild(product));
                        }
                    }

                    function addToCart(productId, maxStock) {
                        const quantityInput = document.getElementById('qty-' + productId);
                        const quantity = parseInt(quantityInput.value);

                        if (quantity < 1 || quantity > maxStock) {
                            showNotification('Please enter a valid quantity (1-' + maxStock + ')', 'error');
                            return;
                        }

                        // Send AJAX request to add to cart
                        fetch('${pageContext.request.contextPath}/cart/add', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                            },
                            body: 'productId=' + productId + '&quantity=' + quantity
                        })
                            .then(response => response.json())
                            .then(data => {
                                if (data.success) {
                                    showNotification('Product added to cart!', 'success');
                                    updateCartCount(data.itemCount);

                                    // Update quantity on card
                                    const qtyDisplay = document.getElementById('cart-qty-' + productId);
                                    if (qtyDisplay) {
                                        const currentText = qtyDisplay.textContent;
                                        const currentQty = parseInt(currentText.split(':')[1].trim());
                                        qtyDisplay.textContent = 'In Cart: ' + (currentQty + quantity);
                                    }

                                    // Reset input to 1
                                    document.getElementById('qty-' + productId).value = 1;
                                } else {
                                    showNotification(data.message || 'Failed to add to cart', 'error');
                                }
                            })
                            .catch(error => {
                                showNotification('Error adding to cart', 'error');
                            });
                    }

                    function showNotification(message, type) {
                        const notification = document.createElement('div');
                        notification.className = 'notification';
                        notification.textContent = message;
                        if (type === 'error') {
                            notification.style.background = 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)';
                        }
                        document.body.appendChild(notification);

                        setTimeout(() => {
                            notification.remove();
                        }, 3000);
                    }

                    function updateCartCount(count) {
                        // Update cart count in header if element exists
                        const cartCountElement = document.getElementById('cartCount');
                        if (cartCountElement) {
                            cartCountElement.textContent = count;
                            if (count > 0) {
                                cartCountElement.style.display = 'flex';
                            } else {
                                cartCountElement.style.display = 'none';
                            }
                        }
                    }
                </script>

                <jsp:include page="includes/footer.jsp" />
            </body>

            </html>
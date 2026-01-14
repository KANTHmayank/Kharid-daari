package com.ecommerce.service;

import com.ecommerce.model.Cart;
import com.ecommerce.model.CartItem;
import com.ecommerce.model.Product;
import com.ecommerce.repository.CartItemRepository;
import com.ecommerce.repository.CartRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
public class CartService {

    @Autowired
    private CartRepository cartRepository;

    @Autowired
    private CartItemRepository cartItemRepository;

    @Autowired
    private ProductService productService;

    public Cart getOrCreateCart(Long userId) {
        Long cartId = cartRepository.findCartIdByUserId(userId);
        
        if (cartId == null) {
            cartId = cartRepository.createCart(userId);
        }

        Cart cart = new Cart();
        List<CartItem> items = cartItemRepository.findByCartId(cartId);
        cart.setItems(items);
        
        return cart;
    }

    public void addToCart(Long userId, Long productId, Integer quantity) {
        Long cartId = cartRepository.findCartIdByUserId(userId);
        
        if (cartId == null) {
            cartId = cartRepository.createCart(userId);
        }

        Product product = productService.getProductById(productId);
        if (product == null || product.getStock() < quantity) {
            throw new RuntimeException("Product not available or insufficient stock");
        }

        BigDecimal unitPrice = product.getPrice();
        BigDecimal lineTotal = unitPrice.multiply(new BigDecimal(quantity));

        cartItemRepository.addItem(cartId, productId, quantity, unitPrice, lineTotal);
        updateCartTotal(cartId);
    }

    public void updateQuantity(Long userId, Long productId, Integer quantity) {
        Long cartId = cartRepository.findCartIdByUserId(userId);
        
        if (cartId != null) {
            cartItemRepository.updateQuantity(cartId, productId, quantity);
            updateCartTotal(cartId);
        }
    }

    public void removeFromCart(Long userId, Long productId) {
        Long cartId = cartRepository.findCartIdByUserId(userId);
        
        if (cartId != null) {
            cartItemRepository.removeItem(cartId, productId);
            updateCartTotal(cartId);
        }
    }

    public void clearCart(Long userId) {
        Long cartId = cartRepository.findCartIdByUserId(userId);
        
        if (cartId != null) {
            cartItemRepository.clearCart(cartId);
            updateCartTotal(cartId);
        }
    }

    private void updateCartTotal(Long cartId) {
        List<CartItem> items = cartItemRepository.findByCartId(cartId);
        BigDecimal total = items.stream()
                .map(CartItem::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        cartRepository.updateCartTotal(cartId, total);
    }

    public int getCartItemCount(Long userId) {
        Long cartId = cartRepository.findCartIdByUserId(userId);
        
        if (cartId == null) {
            return 0;
        }

        List<CartItem> items = cartItemRepository.findByCartId(cartId);
        return items.stream().mapToInt(CartItem::getQuantity).sum();
    }
}

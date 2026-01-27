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
        if (product == null) {
            throw new RuntimeException("Product not found");
        }

        // Check existing quantity in cart
        Integer existingQuantity = cartItemRepository.getItemQuantity(cartId, productId);
        Integer totalQuantity = existingQuantity + quantity;

        // Validate against stock
        if (totalQuantity > product.getStock()) {
            throw new RuntimeException("Cannot add to cart. Only " + product.getStock() + " items available" + 
                (existingQuantity > 0 ? " (you already have " + existingQuantity + " in cart)" : ""));
        }

        BigDecimal unitPrice = product.getPrice();
        BigDecimal lineTotal = unitPrice.multiply(new BigDecimal(quantity));

        cartItemRepository.addItem(cartId, productId, quantity, unitPrice, lineTotal);
        updateCartTotal(cartId);
    }

    public void updateQuantity(Long userId, Long productId, Integer quantity) {
        Long cartId = cartRepository.findCartIdByUserId(userId);
        
        if (cartId != null) {
            // Validate against stock when updating quantity
            Product product = productService.getProductById(productId);
            if (product != null && quantity > product.getStock()) {
                throw new RuntimeException("Cannot update quantity. Only " + product.getStock() + " items available");
            }
            
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
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : items) {
            total = total.add(item.getSubtotal());
        }
        cartRepository.updateCartTotal(cartId, total);
    }

    public int getCartItemCount(Long userId) {
        Long cartId = cartRepository.findCartIdByUserId(userId);
        
        if (cartId == null) {
            return 0;
        }

        List<CartItem> items = cartItemRepository.findByCartId(cartId);
        int count = 0;
        for (CartItem item : items) {
            count += item.getQuantity();
        }
        return count;
    }
}

package com.ecommerce.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class Cart implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private List<CartItem> items;
    private BigDecimal total;

    public Cart() {
        this.items = new ArrayList<>();
        this.total = BigDecimal.ZERO;
    }

    public void addItem(CartItem item) {
        // Check if item already exists in cart
        for (CartItem existingItem : items) {
            if (existingItem.getProductId().equals(item.getProductId())) {
                // Update quantity
                existingItem.setQuantity(existingItem.getQuantity() + item.getQuantity());
                calculateTotal();
                return;
            }
        }
        // Add new item
        items.add(item);
        calculateTotal();
    }

    public void removeItem(Long productId) {
        items.removeIf(item -> item.getProductId().equals(productId));
        calculateTotal();
    }

    public void updateQuantity(Long productId, Integer quantity) {
        for (CartItem item : items) {
            if (item.getProductId().equals(productId)) {
                item.setQuantity(quantity);
                calculateTotal();
                return;
            }
        }
    }

    public void clear() {
        items.clear();
        total = BigDecimal.ZERO;
    }

    private void calculateTotal() {
        total = BigDecimal.ZERO;
        for (CartItem item : items) {
            total = total.add(item.getSubtotal());
        }
    }

    public int getItemCount() {
        int count = 0;
        for (CartItem item : items) {
            count += item.getQuantity();
        }
        return count;
    }

    // Getters and Setters
    public List<CartItem> getItems() {
        return items;
    }

    public void setItems(List<CartItem> items) {
        this.items = items;
        calculateTotal();
    }

    public BigDecimal getTotal() {
        return total;
    }

    public void setTotal(BigDecimal total) {
        this.total = total;
    }
}

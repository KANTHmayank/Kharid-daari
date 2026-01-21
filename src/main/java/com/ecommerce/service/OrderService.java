package com.ecommerce.service;

import com.ecommerce.model.Cart;
import com.ecommerce.model.CartItem;
import com.ecommerce.model.Order;
import com.ecommerce.model.OrderItem;
import com.ecommerce.repository.OrderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
public class OrderService {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private CartService cartService;

    public Order placeOrder(Long userId, Long shippingAddressId, Long billingAddressId) {
        Cart cart = cartService.getOrCreateCart(userId);
        if (cart.getItems() == null || cart.getItems().isEmpty()) {
            throw new RuntimeException("Cart is empty");
        }

        Order order = new Order();
        order.setUserId(userId);
        order.setShippingAddressId(shippingAddressId);
        order.setBillingAddressId(billingAddressId);
        order.setSubtotal(cart.getTotal());
        order.setTax(BigDecimal.ZERO); // Simplified tax
        order.setShippingFee(BigDecimal.ZERO); // Simplified shipping
        order.setTotalAmount(cart.getTotal());
        order.setStatus("PENDING");
        
        Long orderId = orderRepository.create(order);
        order.setId(orderId);

        for (CartItem cartItem : cart.getItems()) {
            OrderItem orderItem = new OrderItem();
            orderItem.setOrderId(orderId);
            orderItem.setProductId(cartItem.getProductId());
            orderItem.setQuantity(cartItem.getQuantity());
            orderItem.setUnitPrice(cartItem.getPrice());
            orderItem.setLineTotal(cartItem.getSubtotal());
            
            orderRepository.saveOrderItem(orderItem);
        }

        cartService.clearCart(userId);
        
        return order;
    }

    public List<Order> getUserOrders(Long userId) {
        List<Order> orders = orderRepository.findByUserId(userId);
        
        // Load items for each order
        for (Order order : orders) {
            order.setItems(orderRepository.findItemsByOrderId(order.getId()));
        }
        
        return orders;
    }

    public Order getOrderById(Long orderId) {
        Order order = orderRepository.findById(orderId);
        if (order != null) {
            order.setItems(orderRepository.findItemsByOrderId(orderId));
        }
        return order;
    }
}

package com.ecommerce.service;

import com.ecommerce.model.Order;
import com.ecommerce.repository.OrderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class OrderService {

    @Autowired
    private OrderRepository orderRepository;

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

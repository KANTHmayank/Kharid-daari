package com.ecommerce.service;

import com.ecommerce.model.Cart;
import com.ecommerce.model.CartItem;
import com.ecommerce.model.Order;
import com.ecommerce.model.OrderItem;
import com.ecommerce.model.Payment;
import com.ecommerce.repository.OrderRepository;
import com.ecommerce.repository.PaymentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class OrderService {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private CartService cartService;
    
    @Autowired
    private PaymentRepository paymentRepository;

    public Order placeOrder(Long userId, Long shippingAddressId, Long billingAddressId, Map<String, String> paymentDetails) {
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
        order.setStatus("COMPLETED"); // Set to COMPLETED instead of PENDING
        
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

        // Create payment record
        if (paymentDetails != null) {
            Payment payment = new Payment();
            payment.setOrderId(orderId);
            payment.setAmount(cart.getTotal());
            payment.setStatus("COMPLETED");
            // Don't set paidAt - let MySQL use CURRENT_TIMESTAMP for IST time
            
            String paymentMethod = paymentDetails.get("paymentMethod");
            payment.setPaymentMethod(paymentMethod != null ? paymentMethod.toUpperCase() : "CARD");
            
            // Set payment provider based on method
            if ("card".equalsIgnoreCase(paymentMethod)) {
                payment.setProvider("CARD_GATEWAY");
                String cardNumber = paymentDetails.get("cardNumber");
                if (cardNumber != null && cardNumber.length() >= 4) {
                    payment.setCardLastFour(cardNumber.replaceAll("\\s", "").substring(cardNumber.replaceAll("\\s", "").length() - 4));
                }
                payment.setCardName(paymentDetails.get("cardName"));
                payment.setReferenceId("CARD-" + System.currentTimeMillis());
            } else if ("upi".equalsIgnoreCase(paymentMethod)) {
                payment.setProvider("UPI_GATEWAY");
                payment.setUpiId(paymentDetails.get("upiId"));
                payment.setReferenceId("UPI-" + System.currentTimeMillis());
            } else if ("cod".equalsIgnoreCase(paymentMethod)) {
                payment.setProvider("COD");
                payment.setReferenceId("COD-" + System.currentTimeMillis());
            }
            
            // Add billing information
            payment.setGstNumber(paymentDetails.get("gstNumber"));
            payment.setCompanyName(paymentDetails.get("companyName"));
            payment.setInvoiceEmail(paymentDetails.get("invoiceEmail"));
            
            paymentRepository.create(payment);
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

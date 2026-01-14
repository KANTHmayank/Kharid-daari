package com.ecommerce.repository;

import com.ecommerce.model.Order;
import com.ecommerce.model.OrderItem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class OrderRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static class OrderRowMapper implements RowMapper<Order> {
        @Override
        public Order mapRow(ResultSet rs, int rowNum) throws SQLException {
            Order order = new Order();
            order.setId(rs.getLong("id"));
            order.setUserId(rs.getLong("user_id"));
            order.setShippingAddressId(rs.getLong("shipping_address_id"));
            order.setSubtotal(rs.getBigDecimal("subtotal"));
            order.setTax(rs.getBigDecimal("tax"));
            order.setShippingFee(rs.getBigDecimal("shipping_fee"));
            order.setTotalAmount(rs.getBigDecimal("total_amount"));
            order.setStatus(rs.getString("status"));
            order.setCreatedAt(rs.getTimestamp("created_at"));
            return order;
        }
    }

    private static class OrderItemRowMapper implements RowMapper<OrderItem> {
        @Override
        public OrderItem mapRow(ResultSet rs, int rowNum) throws SQLException {
            OrderItem item = new OrderItem();
            item.setId(rs.getLong("id"));
            item.setOrderId(rs.getLong("order_id"));
            item.setProductId(rs.getLong("product_id"));
            item.setQuantity(rs.getInt("quantity"));
            item.setUnitPrice(rs.getBigDecimal("unit_price"));
            item.setLineTotal(rs.getBigDecimal("line_total"));
            
            // Try to get product details if available
            try {
                item.setProductName(rs.getString("product_name"));
                item.setProductImage(rs.getString("product_image"));
            } catch (SQLException e) {
                // Product details not in result set
            }
            
            return item;
        }
    }

    public List<Order> findByUserId(Long userId) {
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";
        return jdbcTemplate.query(sql, new OrderRowMapper(), userId);
    }

    public Order findById(Long orderId) {
        String sql = "SELECT * FROM orders WHERE id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, new OrderRowMapper(), orderId);
        } catch (Exception e) {
            return null;
        }
    }

    public List<OrderItem> findItemsByOrderId(Long orderId) {
        String sql = "SELECT oi.*, p.name as product_name, p.image_url as product_image " +
                    "FROM order_items oi " +
                    "JOIN products p ON oi.product_id = p.id " +
                    "WHERE oi.order_id = ?";
        return jdbcTemplate.query(sql, new OrderItemRowMapper(), orderId);
    }
}

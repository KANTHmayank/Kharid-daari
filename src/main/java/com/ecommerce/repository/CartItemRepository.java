package com.ecommerce.repository;

import com.ecommerce.model.CartItem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class CartItemRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static class CartItemRowMapper implements RowMapper<CartItem> {
        @Override
        public CartItem mapRow(ResultSet rs, int rowNum) throws SQLException {
            CartItem item = new CartItem();
            item.setProductId(rs.getLong("product_id"));
            item.setQuantity(rs.getInt("quantity"));
            item.setPrice(rs.getBigDecimal("unit_price"));
            item.setSubtotal(rs.getBigDecimal("line_total"));
            return item;
        }
    }

    public List<CartItem> findByCartId(Long cartId) {
        String sql = "SELECT ci.*, p.name as product_name, p.image_url " +
                    "FROM cart_items ci " +
                    "JOIN products p ON ci.product_id = p.id " +
                    "WHERE ci.cart_id = ?";
        
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            CartItem item = new CartItem();
            item.setProductId(rs.getLong("product_id"));
            item.setProductName(rs.getString("product_name"));
            item.setProductImage(rs.getString("image_url"));
            item.setQuantity(rs.getInt("quantity"));
            item.setPrice(rs.getBigDecimal("unit_price"));
            item.setSubtotal(rs.getBigDecimal("line_total"));
            return item;
        }, cartId);
    }

    public void addItem(Long cartId, Long productId, Integer quantity, BigDecimal unitPrice, BigDecimal lineTotal) {
        // Check if item already exists
        String checkSql = "SELECT quantity FROM cart_items WHERE cart_id = ? AND product_id = ?";
        try {
            Integer existingQty = jdbcTemplate.queryForObject(checkSql, Integer.class, cartId, productId);
            // Update existing item
            Integer newQty = existingQty + quantity;
            BigDecimal newTotal = unitPrice.multiply(new BigDecimal(newQty));
            String updateSql = "UPDATE cart_items SET quantity = ?, line_total = ? WHERE cart_id = ? AND product_id = ?";
            jdbcTemplate.update(updateSql, newQty, newTotal, cartId, productId);
        } catch (Exception e) {
            // Insert new item
            String insertSql = "INSERT INTO cart_items (cart_id, product_id, quantity, unit_price, line_total) VALUES (?, ?, ?, ?, ?)";
            jdbcTemplate.update(insertSql, cartId, productId, quantity, unitPrice, lineTotal);
        }
    }

    public void updateQuantity(Long cartId, Long productId, Integer quantity) {
        String sql = "UPDATE cart_items SET quantity = ?, line_total = unit_price * ? WHERE cart_id = ? AND product_id = ?";
        jdbcTemplate.update(sql, quantity, quantity, cartId, productId);
    }

    public void removeItem(Long cartId, Long productId) {
        String sql = "DELETE FROM cart_items WHERE cart_id = ? AND product_id = ?";
        jdbcTemplate.update(sql, cartId, productId);
    }

    public void clearCart(Long cartId) {
        String sql = "DELETE FROM cart_items WHERE cart_id = ?";
        jdbcTemplate.update(sql, cartId);
    }
}

package com.ecommerce.repository;

import com.ecommerce.model.Cart;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

@Repository
public class CartRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static class CartRowMapper implements RowMapper<Cart> {
        @Override
        public Cart mapRow(ResultSet rs, int rowNum) throws SQLException {
            Cart cart = new Cart();
            cart.setTotal(rs.getBigDecimal("total"));
            return cart;
        }
    }

    public Long findCartIdByUserId(Long userId) {
        String sql = "SELECT id FROM carts WHERE user_id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, Long.class, userId);
        } catch (Exception e) {
            return null;
        }
    }

    public Long createCart(Long userId) {
        String sql = "INSERT INTO carts (user_id, total, updated_at) VALUES (?, 0.00, CURRENT_TIMESTAMP)";
        KeyHolder keyHolder = new GeneratedKeyHolder();
        
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setLong(1, userId);
            return ps;
        }, keyHolder);
        
        return keyHolder.getKey().longValue();
    }

    public void updateCartTotal(Long cartId, BigDecimal total) {
        String sql = "UPDATE carts SET total = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        jdbcTemplate.update(sql, total, cartId);
    }

    public void deleteCart(Long cartId) {
        String sql = "DELETE FROM carts WHERE id = ?";
        jdbcTemplate.update(sql, cartId);
    }

    public Cart getCartByUserId(Long userId) {
        String sql = "SELECT * FROM carts WHERE user_id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, new CartRowMapper(), userId);
        } catch (Exception e) {
            return null;
        }
    }
}

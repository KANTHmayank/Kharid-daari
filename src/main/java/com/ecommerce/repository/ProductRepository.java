package com.ecommerce.repository;

import com.ecommerce.model.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class ProductRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static final RowMapper<Product> PRODUCT_ROW_MAPPER = new RowMapper<Product>() {
        @Override
        public Product mapRow(ResultSet rs, int rowNum) throws SQLException {
            Product product = new Product();
            product.setId(rs.getLong("id"));
            product.setSku(rs.getString("sku"));
            product.setName(rs.getString("name"));
            product.setDescription(rs.getString("description"));
            product.setPrice(rs.getBigDecimal("price"));
            product.setStock(rs.getInt("stock"));
            product.setImageUrl(rs.getString("image_url"));
            product.setActive(rs.getBoolean("active"));
            product.setCreatedAt(rs.getTimestamp("created_at"));
            return product;
        }
    };

    public List<Product> findAll() {
        String sql = "SELECT * FROM products WHERE active = 1 ORDER BY created_at DESC";
        return jdbcTemplate.query(sql, PRODUCT_ROW_MAPPER);
    }

    public List<Product> findFeaturedProducts(int limit) {
        String sql = "SELECT * FROM products WHERE active = 1 ORDER BY created_at DESC LIMIT ?";
        return jdbcTemplate.query(sql, PRODUCT_ROW_MAPPER, limit);
    }

    public Product findById(Long id) {
        String sql = "SELECT * FROM products WHERE id = ? AND active = 1";
        try {
            return jdbcTemplate.queryForObject(sql, PRODUCT_ROW_MAPPER, id);
        } catch (Exception e) {
            return null;
        }
    }
}

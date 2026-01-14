package com.ecommerce.repository;

import com.ecommerce.model.Address;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.List;

@Repository
public class AddressRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static final RowMapper<Address> ADDRESS_ROW_MAPPER = (rs, rowNum) -> {
        Address address = new Address();
        address.setId(rs.getLong("id"));
        address.setUserId(rs.getLong("user_id"));
        address.setLine1(rs.getString("line1"));
        address.setLine2(rs.getString("line2"));
        address.setCity(rs.getString("city"));
        address.setState(rs.getString("state"));
        address.setPostalCode(rs.getString("postal_code"));
        address.setCountry(rs.getString("country"));
        address.setDefault(rs.getBoolean("is_default"));
        return address;
    };

    public List<Address> findByUserId(Long userId) {
        String sql = "SELECT * FROM addresses WHERE user_id = ? ORDER BY is_default DESC, id DESC";
        return jdbcTemplate.query(sql, ADDRESS_ROW_MAPPER, userId);
    }

    public Address findById(Long id) {
        String sql = "SELECT * FROM addresses WHERE id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, ADDRESS_ROW_MAPPER, id);
        } catch (Exception e) {
            return null;
        }
    }

    public Address findDefaultByUserId(Long userId) {
        String sql = "SELECT * FROM addresses WHERE user_id = ? AND is_default = 1";
        try {
            return jdbcTemplate.queryForObject(sql, ADDRESS_ROW_MAPPER, userId);
        } catch (Exception e) {
            return null;
        }
    }

    public Long create(Address address) {
        String sql = "INSERT INTO addresses (user_id, line1, line2, city, state, postal_code, country, is_default) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setLong(1, address.getUserId());
            ps.setString(2, address.getLine1());
            ps.setString(3, address.getLine2());
            ps.setString(4, address.getCity());
            ps.setString(5, address.getState());
            ps.setString(6, address.getPostalCode());
            ps.setString(7, address.getCountry());
            ps.setBoolean(8, address.isDefault());
            return ps;
        }, keyHolder);
        
        return keyHolder.getKey().longValue();
    }

    public void update(Address address) {
        String sql = "UPDATE addresses SET line1 = ?, line2 = ?, city = ?, state = ?, " +
                     "postal_code = ?, country = ?, is_default = ? WHERE id = ?";
        jdbcTemplate.update(sql, address.getLine1(), address.getLine2(), address.getCity(),
                address.getState(), address.getPostalCode(), address.getCountry(),
                address.isDefault(), address.getId());
    }

    public void delete(Long id) {
        String sql = "DELETE FROM addresses WHERE id = ?";
        jdbcTemplate.update(sql, id);
    }

    public void clearDefaultForUser(Long userId) {
        String sql = "UPDATE addresses SET is_default = 0 WHERE user_id = ?";
        jdbcTemplate.update(sql, userId);
    }

    public void setAsDefault(Long addressId, Long userId) {
        // First clear all defaults for this user
        clearDefaultForUser(userId);
        // Then set this address as default
        String sql = "UPDATE addresses SET is_default = 1 WHERE id = ? AND user_id = ?";
        jdbcTemplate.update(sql, addressId, userId);
    }
}

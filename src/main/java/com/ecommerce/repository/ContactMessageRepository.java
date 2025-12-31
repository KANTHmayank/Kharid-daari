package com.ecommerce.repository;

import com.ecommerce.model.ContactMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.Statement;

@Repository
public class ContactMessageRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public ContactMessage save(ContactMessage message) {
        String sql = "INSERT INTO contact_messages (name, email, message, status) VALUES (?, ?, ?, ?)";
        
        KeyHolder keyHolder = new GeneratedKeyHolder();
        
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, message.getName());
            ps.setString(2, message.getEmail());
            ps.setString(3, message.getMessage());
            ps.setString(4, message.getStatus());
            return ps;
        }, keyHolder);
        
        message.setId(keyHolder.getKey().longValue());
        return message;
    }
}

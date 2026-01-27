package com.ecommerce.repository;

import com.ecommerce.model.Payment;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.Statement;

@Repository
public class PaymentRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final RowMapper<Payment> paymentRowMapper = (rs, rowNum) -> {
        Payment payment = new Payment();
        payment.setId(rs.getLong("id"));
        payment.setOrderId(rs.getLong("order_id"));
        payment.setProvider(rs.getString("provider"));
        payment.setReferenceId(rs.getString("reference_id"));
        payment.setStatus(rs.getString("status"));
        payment.setPaidAt(rs.getTimestamp("paid_at"));
        return payment;
    };

    public Long create(Payment payment) {
        String sql = "INSERT INTO payments (order_id, payment_method, provider, reference_id, amount, status, " +
                    "card_last_four, card_name, upi_id, gst_number, company_name, invoice_email) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setLong(1, payment.getOrderId());
            ps.setString(2, payment.getPaymentMethod());
            ps.setString(3, payment.getProvider());
            ps.setString(4, payment.getReferenceId());
            ps.setBigDecimal(5, payment.getAmount());
            ps.setString(6, payment.getStatus());
            ps.setString(7, payment.getCardLastFour());
            ps.setString(8, payment.getCardName());
            ps.setString(9, payment.getUpiId());
            ps.setString(10, payment.getGstNumber());
            ps.setString(11, payment.getCompanyName());
            ps.setString(12, payment.getInvoiceEmail());
            return ps;
        }, keyHolder);
        
        return keyHolder.getKey().longValue();
    }

    public Payment findByOrderId(Long orderId) {
        String sql = "SELECT * FROM payments WHERE order_id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, paymentRowMapper, orderId);
        } catch (Exception e) {
            return null;
        }
    }

    public void updateStatus(Long paymentId, String status) {
        String sql = "UPDATE payments SET status = ? WHERE id = ?";
        jdbcTemplate.update(sql, status, paymentId);
    }
}

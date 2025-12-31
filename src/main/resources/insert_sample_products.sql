-- Insert Sample Products Only
-- Run this if you already have all tables created
-- This script only adds 6 sample products for testing

USE ecommerce;

-- Clear existing products (optional - remove this line if you want to keep existing products)
-- DELETE FROM products;

-- Insert 6 Sample Products with vibrant images
INSERT INTO products (sku, name, description, price, stock, image_url, active) VALUES
('PROD-001', 'Wireless Headphones', 'Premium noise-cancelling wireless headphones with superior sound quality', 129.99, 50, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&h=500&fit=crop', 1),
('PROD-002', 'Smart Watch', 'Fitness tracking smartwatch with heart rate monitor and GPS', 199.99, 30, 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&h=500&fit=crop', 1),
('PROD-003', 'Laptop Backpack', 'Water-resistant laptop backpack with USB charging port and anti-theft design', 49.99, 100, 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500&h=500&fit=crop', 1),
('PROD-004', 'Bluetooth Speaker', 'Portable Bluetooth speaker with 12-hour battery life and waterproof design', 79.99, 75, 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=500&h=500&fit=crop', 1),
('PROD-005', 'USB-C Hub', '7-in-1 USB-C hub with HDMI, SD card reader, and fast charging', 39.99, 120, 'https://images.unsplash.com/photo-1625948515291-69613efd103f?w=500&h=500&fit=crop', 1),
('PROD-006', 'Wireless Mouse', 'Ergonomic wireless mouse with adjustable DPI and long battery life', 29.99, 200, 'https://images.unsplash.com/photo-1527814050087-3793815479db?w=500&h=500&fit=crop', 1);

-- Verify products inserted
SELECT COUNT(*) as total_products FROM products;
SELECT id, sku, name, price, stock FROM products;

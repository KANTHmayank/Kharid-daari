-- Fix PROD-005 to be a Mechanical Keyboard instead of USB-C Hub
USE ecommerce;

UPDATE products 
SET name = 'Mechanical Keyboard', 
    description = 'RGB mechanical gaming keyboard with tactile switches and customizable backlighting', 
    price = 89.99 
WHERE sku = 'PROD-005';

-- Verify the update
SELECT sku, name, description, price, LEFT(image_url, 60) as image_url_preview 
FROM products 
WHERE sku = 'PROD-005';

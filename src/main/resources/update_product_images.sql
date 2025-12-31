-- Update Product Images with High-Quality Images
-- Run this to update existing products with better images

USE ecommerce;

-- Update product images with Unsplash images
UPDATE products SET image_url = 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&h=500&fit=crop', 
                    description = 'Premium noise-cancelling wireless headphones with superior sound quality'
WHERE sku = 'PROD-001';

UPDATE products SET image_url = 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&h=500&fit=crop',
                    description = 'Fitness tracking smartwatch with heart rate monitor and GPS'
WHERE sku = 'PROD-002';

UPDATE products SET image_url = 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500&h=500&fit=crop',
                    description = 'Water-resistant laptop backpack with USB charging port and anti-theft design'
WHERE sku = 'PROD-003';

UPDATE products SET image_url = 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=500&h=500&fit=crop',
                    description = 'Portable Bluetooth speaker with 12-hour battery life and waterproof design'
WHERE sku = 'PROD-004';

UPDATE products SET image_url = 'https://images.unsplash.com/photo-1625948515291-69613efd103f?w=500&h=500&fit=crop',
                    description = 'RGB mechanical gaming keyboard with tactile switches and customizable backlighting'
WHERE sku = 'PROD-005';

UPDATE products SET image_url = 'https://images.unsplash.com/photo-1527814050087-3793815479db?w=500&h=500&fit=crop',
                    description = 'Ergonomic wireless mouse with adjustable DPI and long battery life'
WHERE sku = 'PROD-006';

-- Verify the updates
SELECT sku, name, LEFT(image_url, 50) as image_url_preview FROM products;

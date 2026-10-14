-- =========================================================
-- Create raw Olist source tables
-- These tables mirror the structures of the original CSVs.
-- No transformations are performed in thIS raw layer.
-- =========================================================



-- 1. Create Customers Tables
DROP TABLE IF EXISTS raw.customers;

SELECT '=== Creating Customers Table' AS info;
CREATE TABLE raw.customers (
    customer_id                 VARCHAR,
    customer_unique_id          VARCHAR,
    customer_zip_code_prefix    VARCHAR,
    customer_city               VARCHAR,
    customer_state              VARCHAR
);

-- 2. Create Geolocation Table
DROP TABLE IF EXISTS raw.geolocation;

SELECT '=== Creating Geolocation Table ===' AS info;
CREATE TABLE raw.geolocation (
    geolocation_zip_code_prefix           VARCHAR,
    geolocation_lat                       DOUBLE,
    geolocation_lng                       DOUBLE,
    geolocation_city                      VARCHAR,
    geolocation_state                     VARCHAR                         
);

-- 3. Create Orders Table
DROP TABLE IF EXISTS raw.orders;

SELECT '=== Creating Orders Table' AS info;
CREATE TABLE raw.orders (
    order_id                        VARCHAR,
    customer_id                     VARCHAR,
    order_status                    VARCHAR,
    order_purchase_timestamp        TIMESTAMP,
    order_approved_at               TIMESTAMP,
    order_delivered_carrier_date    TIMESTAMP,
    order_delivered_customer_date   TIMESTAMP,
    order_estimated_delivery_date   TIMESTAMP   
);

-- 4. Create Order Items Table
DROP TABLE IF EXISTS raw.order_items;

SELECT '=== Creating Order Items Table' AS info;
CREATE TABLE raw.order_items (
    order_id                VARCHAR,
    order_item_id           BIGINT,
    product_id              VARCHAR,
    seller_id               VARCHAR,
    shipping_limit_date     TIMESTAMP,
    price                   DOUBLE,
    freight_value           DOUBLE
);

-- 5. Create Order Payments Table
DROP TABLE IF EXISTS raw.order_payments;

SELECT '=== Creating Order Payments Table' AS info;
CREATE TABLE raw.order_payments (
    order_id                    VARCHAR,
    payment_sequential          BIGINT,
    payment_type                VARCHAR,
    payment_installments        BIGINT,
    payment_value               DOUBLE
);

-- 6. Create Order Reviews Table
DROP TABLE IF EXISTS raw.order_reviews;

SELECT '=== Creating Order Reviews Table' AS info;
CREATE TABLE raw.order_reviews (
    review_id                   VARCHAR,
    order_id                    VARCHAR,
    review_score                BIGINT,
    review_comment_title        VARCHAR,
    review_comment_message      VARCHAR,
    review_creation_date        TIMESTAMP,
    review_answer_timestamp     TIMESTAMP
);

-- 7. Create Products Table
DROP TABLE IF EXISTS raw.products;

SELECT '=== Creating Products Table ===' AS info;
CREATE TABLE raw.products (
    product_id                     VARCHAR,
    product_category_name           VARCHAR,
    product_name_lenght             BIGINT,
    product_description_lenght      BIGINT,
    product_photos_qty              BIGINT,
    product_weight_g                BIGINT,
    product_length_cm               BIGINT,
    product_height_cm               BIGINT,
    product_width_cm                BIGINT
);

-- 8. Create Sellers Table
DROP TABLE IF EXISTS raw.sellers;

SELECT '=== Creating Sellers Table ===' AS info;
CREATE TABLE raw.sellers (
    seller_id                   VARCHAR,
    seller_zip_code_prefix      VARCHAR,
    seller_city                 VARCHAR,
    seller_state                VARCHAR
);

-- 9. Create Product Category Translation
DROP TABLE IF EXISTS raw.product_category_translation;

SELECT '=== Creating Product Category Translation Table ===' AS info;
CREATE TABLE raw.product_category_translation (
    product_category_name                   VARCHAR,
    product_category_name_english           VARCHAR
);

-- Validate Table Creation 
SELECT '=== Validating Table Creation Success ===' AS info;
SELECT 
    table_schema,
    table_name
FROM information_schema.tables
WHERE table_schema = 'raw'
ORDER BY table_name;

-- Inspect One Table
SELECT 'Inspecting One Table' AS info;
DESCRIBE raw.orders;

SELECT '=== Inspecting Customers Table ===' AS info;
DESCRIBE raw.customers;
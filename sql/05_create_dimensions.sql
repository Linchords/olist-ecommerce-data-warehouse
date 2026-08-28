-- =========================================================
-- CUSTOMER DIMENSION
-- Grain: One row per source customer_id
-- =========================================================


DROP TABLE warehouse.dim_customer;

SELECT '=== Creating Dim Customer Table ===' AS info;
CREATE TABLE warehouse.dim_customer (
    customer_key                BIGINT          PRIMARY KEY, -- Warehouse ID
    customer_id                 VARCHAR, -- Olist source system ID
    customer_unique_id          VARCHAR, -- Actual shopper identity across multiple orders
    customer_city               VARCHAR,
    customer_state              VARCHAR
);


-- =========================================================
-- PRODUCT DIMENSION
-- Grain: One row per product_id
-- =========================================================


DROP TABLE IF EXISTS warehouse.dim_product;

SELECT '=== Creating Dim Product Table ===' AS info;
CREATE TABLE warehouse.dim_product (
    product_key                     BIGINT              PRIMARY KEY,
    product_id                      VARCHAR,
    product_category_name           VARCHAR,
    product_category_name_english   VARCHAR,
    product_name_length             INTEGER,
    product_description_length      INTEGER,
    product_photos_qty              INTEGER,
    product_weight_g                INTEGER,
    product_length_cm               INTEGER,
    product_height_cm               INTEGER,
    product_width_cm                INTEGER
);

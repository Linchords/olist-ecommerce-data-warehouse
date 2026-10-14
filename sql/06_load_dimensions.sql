-- =========================================================
-- LOAD CUSTOMER DIMENSION
-- =========================================================

SELECT '=== Loading Dim Customer Table ===' AS info;
INSERT INTO warehouse.dim_customer(
    customer_key,
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state
)
SELECT 
    ROW_NUMBER() OVER(
        ORDER BY customer_id
    ) AS customer_key,
    
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state
FROM raw.customers;


-- Verify Loads
SELECT '=== Checking Total Counts For Dim Customer ===' AS info;
SELECT 
    COUNT(*) AS total_rows_dim_customer
FROM warehouse.dim_customer;

SELECT '=== Checking First 5 Rows For Dim Customer ===' AS info;
SELECT *
FROM warehouse.dim_customer
LIMIT 10;

-- Verify if dim_customer rows match with the total customer rows 
SELECT '=== Verifying total customers rows ===' AS info;
SELECT 
    COUNT(*) AS total_rows_customers
FROM raw.customers;


-- Data Quality Check for Surrogate customer keys
SELECT '=== Checking Duplicates For Customer Key ===' AS info;
SELECT 
    customer_key,
    COUNT(*) AS unique_keys_total_counts
FROM warehouse.dim_customer
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- View Difference Between Olist Customer IDs 
SELECT '=== Checking Customer Order IDs Greater than 1 ===' AS info;
SELECT 
    customer_unique_id,
    COUNT(DISTINCT customer_id) AS customer_id_count
FROM warehouse.dim_customer
GROUP BY customer_unique_id
HAVING COUNT(DISTINCT customer_id) > 1
ORDER BY customer_id_count DESC
LIMIT 10;


-- =========================================================
-- LOAD PRODUCT DIMENSION
-- =========================================================
SELECT '=== Loading Dim Products Table ===' AS info;
INSERT INTO warehouse.dim_product (
    product_key,
    product_id,
    product_category_name,
    product_category_name_english,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
)
SELECT 
    ROW_NUMBER() OVER(
        ORDER BY product_id
    ) AS product_key,

    p.product_id,
    p.product_category_name,
    pct.product_category_name_english,
    p.product_name_lenght AS product_name_length,
    p.product_description_lenght AS product_description_length,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm

FROM raw.products p
LEFT JOIN raw.product_category_translation pct 
    ON p.product_category_name = pct.product_category_name;


-- Vefify product dimension table 
SELECT '=== Previewing Few Rows In Product Dimension === ' AS info;
SELECT *
FROM warehouse.dim_product
LIMIT 10;


-- Compare Row counts dim_products & raw.products
SELECT '=== Checking Raw Products Count ===' AS info;
SELECT 
    COUNT(*) AS total_raw_products
FROM raw.products;

SELECT '=== Checking Warehouse Products Count ===' AS info;
SELECT 
    COUNT(*) AS total_warehouse_products
FROM warehouse.dim_product;

-- Checking Missing Product Category Name 
SELECT '=== Checking Missing Product Category Name Count ===' AS info;
SELECT 
    COUNT(*) AS product_category_without_translation
FROM warehouse.dim_product
WHERE product_category_name_english IS NULL;


-- Checking Few Missing Rows
SELECT '=== Checking Missing Product Category Name Count First 10 rows ===' AS info;
SELECT
    product_id,
    product_category_name,
    product_category_name_english
FROM warehouse.dim_product
WHERE product_category_name_english IS NULL 
LIMIT 10;


-- =========================================================
-- LOAD SELLER DIMENSION
-- =========================================================

SELECT '=== Loading Dim Sellers Table ===' AS info;
INSERT INTO warehouse.dim_seller (
    seller_key,
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
)
SELECT 
    ROW_NUMBER() OVER(
        ORDER BY seller_id
    ) AS seller_key,

    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
FROM raw.sellers;

-- Checking First 10 rows of the Dim_Sellers Table
SELECT '=== Checking Dim Sellers Table Rows ===' AS info;
SELECT *
FROM warehouse.dim_seller
LIMIT 10;


-- Checking if table rows match 
SELECT '=== Comparing Dim Sellers With Raw Sellers ===' AS info;
SELECT
    COUNT(*) AS total_raw_sellers_count
FROM raw.sellers;

SELECT 
    COUNT(*) AS total_dim_seller_count
FROM warehouse.dim_seller;

-- Checking Uniqueness 
SELECT '=== Checking Unique Values ===' AS info;
SELECT 
    seller_key,
    COUNT(*) 
FROM warehouse.dim_seller
GROUP BY seller_key
HAVING COUNT(*) > 1;

-- =========================================================
-- LOAD DATE DIMENSION
-- =========================================================

SELECT '=== Loading Dim Date Table ===' AS info;
INSERT INTO warehouse.dim_date (
    date_key,
    full_date,
    year,
    quarter,
    month,
    month_name,
    day,
    day_name,
    is_weekend
)

WITH date_range AS (
    SELECT 
        MIN(CAST(order_purchase_timestamp AS DATE)) AS min_date,
        MAX(CAST(order_purchase_timestamp AS DATE)) AS max_date
    FROM raw.orders
),

calendar AS (
    SELECT
        CAST(generated_date AS DATE) AS full_date
    FROM date_range,
    generate_series(
        min_date,
        max_date,
        INTERVAL 1 DAY
    ) AS t(generated_date)
)

SELECT
    CAST(
        STRFTIME(full_date, '%Y%m%d')
        AS INTEGER
    ) AS date_key,

    full_date,
    
    EXTRACT(YEAR FROM full_date) AS year,

    EXTRACT(QUARTER FROM full_date) AS quarter,

    EXTRACT(MONTH FROM full_date) AS month,

    STRFTIME(full_date, '%B') AS month_name,

    EXTRACT(DAY FROM full_date) AS day,

    STRFTIME(full_date, '%A') AS day_name,

    CASE
        WHEN STRFTIME(full_date, '%A') IN ('Saturday', 'Sunday')
        THEN TRUE
        ELSE FALSE 
    END AS is_weekend

FROM calendar;

-- VERIFY DIM DATE
SELECT '=== Checking Rows In Dim Date ===' AS info;
SELECT *
FROM warehouse.dim_date
ORDER BY full_date
LIMIT 10;

-- CHECK THE RANGE
SELECT '=== Checking first day, last day, and total rows in dim date table ===' AS info;
SELECT 
    MIN(full_date) AS first_date,
    MAX(full_date) AS last_date,
    COUNT(*) AS number_of_days
FROM warehouse.dim_date; 

-- CHECK WEEKENDS 
SELECT '=== Checking Weekends Days ===' AS info;
SELECT *
FROM warehouse.dim_date
WHERE is_weekend = TRUE
LIMIT 10;






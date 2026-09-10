-- =========================================================
-- WAREHOUSE DATA VALIDATION
-- Purpose: Verify dimensions and fact tables after ETL
-- =========================================================

-- =========================================================
-- 1. DIMENSION ROW COUNTS
-- =========================================================

SELECT '=== Checking Dimension Table Warehouse Data ===' AS info;
SELECT 'dim_customer' AS table_name, COUNT(*) AS row_count FROM warehouse.dim_customer
UNION ALL
SELECT 'dim_product', COUNT(*) FROM warehouse.dim_product
UNION ALL 
SELECT 'dim_seller', COUNT(*) FROM warehouse.dim_seller
UNION ALL 
SELECT 'dim_date', COUNT(*) FROM warehouse.dim_date;

-- =========================================================
-- 2. FACT TABLE ROW COUNTS
-- =========================================================
SELECT '=== Checking Fact Table Warehouse Data ===' AS info;

SELECT 'fact_sales' AS table_name, COUNT(*) AS row_count FROM warehouse.fact_sales
UNION ALL 
SELECT 'fact_payments', COUNT(*) FROM warehouse.fact_payments
UNION ALL 
SELECT 'fact_reviews', COUNT(*) FROM warehouse.fact_reviews;

-- COMPARE RAW DATA WITH WAREHOUSE DATA
SELECT '=== Comparing Raw Data With Warehouse Data ===' AS info;

SELECT '=== Comparing Raw Orders & Warehouse Fact Data ===' AS info;
SELECT
    (SELECT COUNT(*) FROM raw.order_items) AS raw_orders_items,
    (SELECT COUNT(*) FROM warehouse.fact_sales) AS fact_sales_rows;

SELECT '=== Comparing Raw Payment & Warehouse Payment Fact Data ===' AS info;
SELECT
    (SELECT COUNT(*) FROM raw.order_payments) AS raw_payments_rows,
    (SELECT COUNT(*) FROM warehouse.fact_payments) AS fact_payment_rows;

SELECT '=== Comparing Raw Reviews & Warehouse Review Fact Data ===' AS info;
SELECT
    (SELECT COUNT(*) FROM raw.order_reviews) AS raw_reviews_rows,
    (SELECT COUNT(*) FROM warehouse.fact_reviews) AS fact_review_rows;


-- VERIFY PRIMARY KEYS ARE UNIQUE
SELECT '=== VERIFYING PRIMARY KEY ARE UNIQUE ===' AS info;

SELECT '=== Verifying Customer Key ===' AS info;
SELECT 
    customer_key,
    COUNT(*) AS occurrences 
FROM warehouse.dim_customer
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- PRODUCT KEY VERIFICATION 
SELECT '=== Verifying Product Key ===' AS info;
SELECT 
    product_key,
    COUNT(*) AS occurrences
FROM warehouse.dim_product
GROUP BY product_key
HAVING COUNT(*) > 1;

-- SELLER KEY VERIFICATION
SELECT '=== Verifying Seller Key ===' AS info;
SELECT 
    seller_key,
    COUNT(*) AS occurrences
FROM warehouse.dim_seller
GROUP BY seller_key
HAVING COUNT(*) > 1;

-- SALES GRAIN VERIFICATION 
SELECT '=== Verifying Sales Grain ===' AS info;
SELECT 
    order_id,
    order_item_id,
    COUNT(*) AS occurrences
FROM warehouse.fact_sales
GROUP BY 
    order_id,
    order_item_id
HAVING COUNT(*) > 1;


-- CHECKING FOR MISSING DIMENSION KEYS 
SELECT '=== Checking For Missing Dimension Keys ===' AS info;
SELECT 
    COUNT(*) FILTER (WHERE customer_key IS NULL) AS missing_customer_key,
    COUNT(*) FILTER (WHERE product_key IS NULL) AS missing_product_key,
    COUNT(*) FILTER (WHERE seller_key IS NULL) AS missing_seller_key,
    COUNT(*) FILTER (WHERE date_key IS NULL) AS missing_date_key
FROM warehouse.fact_sales;

-- RECONCILING SALES MONEY
SELECT '=== Reconciling Raw Sales Money ===' AS info;
SELECT
    SUM(price) AS raw_sales,
    SUM(freight_value) AS raw_freight
FROM raw.order_items;

SELECT '=== Reconciling Warehouse Sales Money ===' AS info;
SELECT 
    SUM(price) AS warehouse_sales,
    SUM(freight_value) AS warehouse_freight
FROM warehouse.fact_sales;

-- RECONCILING PAYMENTS
SELECT '=== Reconciling Raw Payments ===' AS info;
SELECT 
    SUM(payment_value) AS raw_payments_value
FROM raw.order_payments;

SELECT '=== Reconciling Warehouse Payments ===' AS info;
SELECT 
    SUM(payment_value) AS warehouse_payments_value
FROM warehouse.fact_payments;

-- CHECKING DIMENSION DATE
SELECT '=== Checking Dimension Date Coverage ===' AS info;
SELECT 
    MIN(full_date) AS first_dimension_date,
    MAX(full_date) AS last_dimension_date
FROM warehouse.dim_date;

-- COMPARING TO RAW ORDERS
SELECT '=== Comparing To Reviews ===' AS info;
SELECT 
    MIN(CAST(review_creation_date AS DATE)) AS first_review_date,
    MAX(CAST(review_creation_date AS DATE)) AS last_review_date
FROM raw.order_reviews;

SELECT
    COUNT(*) AS reviews_outside_date_dimension
FROM raw.order_reviews r
LEFT JOIN warehouse.dim_date d
    ON CAST(r.review_creation_date AS DATE) = d.full_date
WHERE r.review_creation_date IS NOT NULL
  AND d.date_key IS NULL;



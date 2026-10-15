-- =========================================================
-- FINAL PROJECT VALIDATION
-- Purpose:
-- Confirm that the complete data pipeline is working
-- =========================================================

--- 1. CHECK RAW TABLE COUNTS

SELECT '=== Raw Table Counts ===' AS info;
SELECT 'raw.customers' AS object_name, COUNT(*) AS row_count
FROM raw.customers

UNION ALL 

SELECT 'raw.orders', COUNT(*)
FROM raw.orders

UNION ALL 

SELECT 'raw.order_items', COUNT(*)
FROM raw.order_items

UNION ALL 

SELECT 'raw.order_payments', COUNT(*)
FROM raw.order_payments

UNION ALL 

SELECT 'raw.order_reviews', COUNT(*)
FROM raw.order_reviews;


-- 2. CHECK DIMENSION COUNTS

SELECT '=== Dimension Table Counts ===' AS info;
SELECT 'warehouse.dim_customer' AS object_name, COUNT(*) AS row_count
FROM warehouse.dim_customer

UNION ALL 

SELECT 'warehouse.dim_product', COUNT(*)
FROM warehouse.dim_product

UNION ALL 

SELECT 'warehouse.dim_seller', COUNT(*)
FROM warehouse.dim_seller

UNION ALL 

SELECT 'warehouse.dim_date', COUNT(*)
FROM warehouse.dim_date;


-- CHECK FACT TABLE COUNTS

SELECT '=== Fact Table Counts ===' AS info;
SELECT 'warehouse.fact_sales' AS object_name, COUNT(*) AS row_count
FROM warehouse.fact_sales

UNION ALL 

SELECT 'warehouse.fact_payments', COUNT(*)
FROM warehouse.fact_payments

UNION ALL 

SELECT 'warehouse_fact_reviews', COUNT(*)
FROM warehouse.fact_reviews

UNION ALL 

SELECT 'warehouse.fact_delivery', COUNT(*)
FROM warehouse.fact_delivery;


-- 4. VERIFY SALES RECONCILIATION 

SELECT '=== Verify Sales Reconciliation ===' AS info;
SELECT 
    (SELECT SUM(price)
    FROM raw.order_items) AS sales,

    (SELECT SUM(price)
    FROM warehouse.fact_sales) AS warehouse_sales;

-- 5. VERIFY PAYMENT RECONCILIATION

SELECT '=== Verify Payment Reconciliation ===' AS info;
SELECT 
    (SELECT SUM(payment_value)
    FROM raw.order_payments) AS raw_payments,

    (SELECT SUM(payment_value)
    FROM warehouse.fact_payments) AS warehouse_payments;


-- 6. VERIFY MARTS EXIST

SELECT '=== Verify Marts Exist ===' AS info;
SELECT 
    table_schema,
    table_name
FROM information_schema.views
WHERE table_schema = 'marts'
ORDER BY table_name;

-- 7. TEST MONTHLY MART

SELECT '=== Testing Monthly Sales Mart ===' AS info;
SELECT *
FROM marts.vw_monthly_sales
ORDER BY year, Month
LIMIT 10;


-- 8. TEST CUSTOMER MART

SELECT '=== Testing Customer Mart ===' AS info;
SELECT *
FROM marts.vw_customer_summary
ORDER BY total_spent DESC
LIMIT 5;

-- 9. TEST PRODUCT MART 
SELECT '=== Testing Product Mart ===' AS info;
SELECT *
FROM marts.vw_product_performance
ORDER BY total_product_sales DESC 
LIMIT 5;


-- TEST SELLER MART 

SELECT '=== Testing Seller Mart ===' AS info;
SELECT *
FROM marts.vw_seller_performance
ORDER BY total_revenue DESC
LIMIT 5;


-- Cross-Mart Reconciliation
-- Purpose
-- We now want to verify that all four sales-related data marts report identical totals.
SELECT '=== Cross Mart Reconciliation ===' AS info;
SELECT
    'Monthly Sales' AS mart,
    SUM(total_items_sold) AS items,
    ROUND(SUM(product_sales), 2) AS product_sales,
    ROUND(SUM(freight_revenue), 2) AS freight_value
FROM marts.vw_monthly_sales

UNION ALL

SELECT
    'Product Performance',
    SUM(total_items_sold),
    ROUND(SUM(total_product_sales), 2),
    ROUND(SUM(total_freight_value), 2)
FROM marts.vw_product_performance

UNION ALL

SELECT
    'Customer Summary',
    SUM(total_items_purchased),
    ROUND(SUM(total_product_sales), 2),
    ROUND(SUM(total_freight_paid), 2)
FROM marts.vw_customer_summary

UNION ALL

SELECT
    'Seller Performance',
    SUM(total_items_sold),
    ROUND(SUM(total_product_sales), 2),
    ROUND(SUM(total_freight_value), 2)
FROM marts.vw_seller_performance;

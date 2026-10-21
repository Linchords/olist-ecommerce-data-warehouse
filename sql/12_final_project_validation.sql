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
WITH baseline AS (
    SELECT
        COUNT(*) AS items,

        CAST(
            ROUND(SUM(oi.price), 2)
            AS DECIMAL(18,2)
        ) AS product_sales,

        CAST(
            ROUND(SUM(oi.freight_value), 2)
            AS DECIMAL(18,2)
        ) AS freight_value

    FROM raw.order_items oi

    INNER JOIN raw.orders o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'
),

mart_totals AS (

    SELECT
        'Monthly Sales' AS mart,
        SUM(total_items_sold) AS items,
        CAST(ROUND(SUM(product_sales), 2) AS DECIMAL(18,2)) AS product_sales,
        CAST(ROUND(SUM(freight_revenue), 2) AS DECIMAL(18,2)) AS freight_value
    FROM marts.vw_monthly_sales

    UNION ALL

    SELECT
        'Product Performance',
        SUM(total_items_sold),
        CAST(ROUND(SUM(total_product_sales), 2) AS DECIMAL(18,2)),
        CAST(ROUND(SUM(total_freight_value), 2) AS DECIMAL(18,2))
    FROM marts.vw_product_performance

    UNION ALL

    SELECT
        'Customer Summary',
        SUM(total_items_purchased),
        CAST(ROUND(SUM(total_product_sales), 2) AS DECIMAL(18,2)),
        CAST(ROUND(SUM(total_freight_paid), 2) AS DECIMAL(18,2))
    FROM marts.vw_customer_summary

    UNION ALL

    SELECT
        'Seller Performance',
        SUM(total_items_sold),
        CAST(ROUND(SUM(total_product_sales), 2) AS DECIMAL(18,2)),
        CAST(ROUND(SUM(total_freight_value), 2) AS DECIMAL(18,2))
    FROM marts.vw_seller_performance
)

SELECT
    m.mart,
    m.items,
    m.product_sales,
    m.freight_value,

    CASE
        WHEN m.items = b.items
            AND m.product_sales = b.product_sales
            AND m.freight_value = b.freight_value
        THEN 'PASS'
        ELSE 'FAIL'
    END AS reconciliation_status

FROM mart_totals m
CROSS JOIN baseline b

ORDER BY m.mart;


-- Date Coverage Validation

SELECT '=== Date Coverage Validation ===' AS info;
WITH source_dates AS (

    SELECT
        'Order Purchase' AS date_source,
        CAST(order_purchase_timestamp AS DATE) AS event_date
    FROM raw.orders

    UNION ALL

    SELECT
        'Order Approval',
        CAST(order_approved_at AS DATE)
    FROM raw.orders

    UNION ALL

    SELECT
        'Carrier Delivery',
        CAST(order_delivered_carrier_date AS DATE)
    FROM raw.orders

    UNION ALL

    SELECT
        'Customer Delivery',
        CAST(order_delivered_customer_date AS DATE)
    FROM raw.orders

    UNION ALL

    SELECT
        'Estimated Delivery',
        CAST(order_estimated_delivery_date AS DATE)
    FROM raw.orders

    UNION ALL

    SELECT
        'Shipping Deadline',
        CAST(shipping_limit_date AS DATE)
    FROM raw.order_items

    UNION ALL

    SELECT
        'Review Creation',
        CAST(review_creation_date AS DATE)
    FROM raw.order_reviews

    UNION ALL

    SELECT
        'Review Answer',
        CAST(review_answer_timestamp AS DATE)
    FROM raw.order_reviews
)

SELECT
    s.date_source,

    MIN(s.event_date) AS first_date,

    MAX(s.event_date) AS last_date,

    COUNT(*) FILTER (
        WHERE s.event_date IS NOT NULL
          AND d.date_key IS NULL
    ) AS dates_not_covered,

    CASE
        WHEN COUNT(*) FILTER (
            WHERE s.event_date IS NOT NULL
              AND d.date_key IS NULL
        ) = 0
        THEN 'PASS'

        WHEN s.date_source = 'Shipping Deadline'
             AND COUNT(*) FILTER (
                 WHERE s.event_date IS NOT NULL
                   AND d.date_key IS NULL
             ) = 4
             AND COUNT(*) FILTER (
                 WHERE s.event_date IS NOT NULL
                   AND d.date_key IS NULL
                   AND s.event_date NOT IN (
                       DATE '2020-02-03',
                       DATE '2020-02-05',
                       DATE '2020-04-09'
                   )
             ) = 0
        THEN 'KNOWN EXCEPTION'

        ELSE 'FAIL'
    END AS validation_status

FROM source_dates s

LEFT JOIN warehouse.dim_date d
    ON s.event_date = d.full_date

GROUP BY s.date_source

ORDER BY s.date_source;
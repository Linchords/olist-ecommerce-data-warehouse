-- =========================================================
-- RAW DATA VALIDATION
-- Purpose: Check the quality and integrity of ingested data
-- =========================================================

-- 1. ROW COUNTS - To validate if all rows were loaded and how much data do we have 
SELECT '=== Checking Row Counts & How Much Data We Have ===' AS info;
SELECT 'Customers' as table_name, COUNT(*) AS record_count FROM raw.customers
UNION ALL
SELECT 'Geolocation', COUNT(*) FROM raw.geolocation
UNION ALL
SELECT 'Orders', COUNT(*) FROM raw.orders 
UNION ALL 
SELECT 'Order Items', COUNT(*) FROM raw.order_items
UNION ALL 
SELECT 'Order Payments', COUNT(*) FROM raw.order_payments
UNION ALL 
SELECT 'Order Reviews', COUNT(*) FROM raw.order_reviews
UNION ALL 
SELECT 'Products', COUNT(*) FROM raw.products
UNION ALL 
SELECT 'Product Category Translation', COUNT(*) FROM raw.product_category_translation
UNION ALL 
SELECT 'Sellers', COUNT(*) FROM raw.sellers; 


-- 2. CHECK DUPLICATES PRIMARY-LOOKING IDs - To find duplicate ID's because these IDs column look like identifiers that may later use as keys
SELECT '=== Customer IDs Duplicate Check ===' AS info;
SELECT 
    customer_id,
    COUNT(*) AS occurrences
FROM raw.customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT '=== Order IDs Duplicate Check ===' AS info;
SELECT 
    order_id,
    COUNT(*) AS occurrences
FROM raw.orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT '=== Product IDs Duplicate Check ===' AS info;
SELECT 
    product_id,
    COUNT(*) AS occurrences
FROM raw.products
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT '=== Sellers IDs Duplicate Check ===' AS info;
SELECT 
    seller_id,
    COUNT(*) AS occurrences
FROM raw.sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;

-- 3. Checking Null Values For IDs
SELECT '=== Checking Null Values Customers ===' AS info;
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customer_id,
    COUNT(*) FILTER (WHERE customer_unique_id IS NULL) AS null_customer_unique_id
    FROM raw.customers;

SELECT '=== Checking Null Values Orders ===' AS info;
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE order_id IS NULL) AS null_order_id,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customer_id,
    COUNT(*) FILTER (WHERE order_purchase_timestamp IS NULL) AS null_purchase_date
    FROM raw.orders;

SELECT '=== Checking Null Values Products ===' AS info;
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE product_id IS NULL) AS null_product_id,
    COUNT(*) FILTER (WHERE product_category_name IS NULL) AS null_category
FROM raw.products;

-- 4. Checking Orphan Orders 
SELECT '=== Checking Orders With No Matching Customers ===' AS info;
SELECT COUNT(*) AS orphan_orders
FROM raw.orders o
LEFT JOIN raw.customers c
    ON o.customer_id = c.customer_id 
WHERE c.customer_id IS NULL;


-- 5. Checking Orphan Order Items 
SELECT '=== Checking Order Items With No Matching Orders ===' AS info;
SELECT COUNT(*) AS orphan_order_items
FROM raw.order_items oi
LEFT JOIN raw.orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- 6. Checking Order Items Against Products
SELECT '=== Checking Order Items With No Matching Products ===' AS info;
SELECT COUNT(*) AS orphan_products
FROM raw.order_items oi
LEFT JOIN raw.products p 
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

-- 7. Checking Order Items Against Sellers
SELECT '=== Checking Order Items With No Matching Sellers ===' AS info;
SELECT COUNT(*) AS orphan_sellers
FROM raw.order_items oi
LEFT JOIN raw.sellers s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

-- 8. Inspecting Order Statuses
SELECT '=== Inspecting Order Statuses ===' AS info;
SELECT 
    order_status,
    COUNT(*) AS order_count
FROM raw.orders
GROUP BY order_status
ORDER BY order_count;

-- 9. Checking the date range
SELECT '=== Checking Order Purchase Date Range ===' AS info;
SELECT 
    MIN(order_purchase_timestamp) AS first_order,
    MAX(order_purchase_timestamp) AS last_order,
    COUNT(*) AS total_orders,
    COUNT(*) FILTER (WHERE order_purchase_timestamp IS NULL) AS null_purchase_timestamps
FROM raw.orders;

-- 10. Checking Suspicious Numeric Values
SELECT '=== Checking Suspicious Numeric Value For Price & Freight Value in Order Items ===' AS info;
SELECT *
FROM raw.order_items
WHERE price < 0 
    OR freight_value < 0;


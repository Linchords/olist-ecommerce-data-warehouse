-- =========================================================
-- LOAD SALES FACT TABLE
-- =========================================================

SELECT '=== Loading Fact Sales Table ===' AS info;

INSERT INTO warehouse.fact_sales (
    order_id,
    order_item_id,
    customer_key,
    product_key,
    seller_key,
    date_key,
    order_status,
    shipping_limit_date,
    price,
    freight_value
)

SELECT 
    oi.order_id,
    oi.order_item_id,
    dc.customer_key,
    dp.product_key,
    ds.seller_key,
    dd.date_key,
    o.order_status,
    oi.shipping_limit_date,
    oi.price,
    oi.freight_value
FROM raw.order_items oi

INNER JOIN raw.orders o
    ON oi.order_id = o.order_id

INNER JOIN warehouse.dim_customer dc 
    ON o.customer_id = dc.customer_id

INNER JOIN warehouse.dim_product dp 
    ON oi.product_id = dp.product_id

INNER JOIN warehouse.dim_seller ds 
    ON oi.seller_id = ds.seller_id

INNER JOIN warehouse.dim_date dd
    ON CAST(order_purchase_timestamp AS DATE) = dd.full_date;


-- VERIFY FACT TABLE 
SELECT '=== Verify Fact Table ===' AS info;

SELECT *
FROM warehouse.fact_sales
LIMIT 10;

-- COMPARE COUNTS 
SELECT '=== Comparing Counts ===' AS info;
SELECT COUNT(*) AS raw_order_items
FROM raw.order_items;

SELECT COUNT(*) AS fact_sales_rows
FROM warehouse.fact_sales;

-- TEST ANALYTICAL QUERY
SELECT '=== Testing Analytical Query ===' AS info;
SELECT 
    dp.product_category_name_english,
    SUM(fs.price) AS total_sales
FROM warehouse.fact_sales fs

JOIN warehouse.dim_product dp
    ON fs.product_key = dp.product_key
GROUP BY dp.product_category_name_english
ORDER BY total_sales DESC
LIMIT 10;

-- =========================================================
-- LOAD PAYMENTS FACT TABLE
-- =========================================================

SELECT '=== Loading Fact Payments Table ===' AS info;
INSERT INTO warehouse.fact_payments (
    order_id,
    payment_sequential,
    customer_key,
    date_key,
    payment_type,
    payment_installments,
    payment_value,
    order_status
)

SELECT 
    op.order_id,
    op.payment_sequential,
    dc.customer_key,
    dd.date_key,
    op.payment_type,
    op.payment_installments,
    op.payment_value,
    o.order_status

FROM raw.order_payments op

INNER JOIN raw.orders o
    ON op.order_id = o.order_id

INNER JOIN warehouse.dim_customer dc
    ON o.customer_id = dc.customer_id 

INNER JOIN warehouse.dim_date dd 
    ON CAST(order_purchase_timestamp AS DATE) = dd.full_date;

SELECT '=== Previewing Few Roles In Fact Payment Table ===' AS info;
SELECT *
FROM warehouse.fact_payments
LIMIT 10;


SELECT '=== Comparing Counts ===' AS info;
SELECT COUNT(*) AS raw_order_payments
FROM raw.order_payments;

SELECT COUNT(*) AS fact_payments_count
FROM warehouse.fact_payments;

SELECT '=== Analytical Query ===' AS info;
SELECT
    payment_type,
    COUNT(*) AS payment_transactions,
    SUM(payment_value) AS total_payment_value
FROM warehouse.fact_payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;


-- =========================================================
-- LOAD REVIEWS FACT TABLE
-- =========================================================

SELECT '=== Loading Reviews Fact Table ===' AS info;
INSERT INTO warehouse.fact_reviews (
    review_key,
    review_id,
    order_id,
    customer_key,
    date_key,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
)

SELECT
    ROW_NUMBER() OVER (
        ORDER BY
            r.order_id,
            r.review_id,
            r.review_creation_date,
            r.review_answer_timestamp
    ) AS review_key,

    r.review_id,
    r.order_id,

    dc.customer_key,
    dd.date_key,

    r.review_score,
    r.review_comment_title,
    r.review_comment_message,
    r.review_creation_date,
    r.review_answer_timestamp

FROM raw.order_reviews r

INNER JOIN raw.orders o
    ON r.order_id = o.order_id

INNER JOIN warehouse.dim_customer dc
    ON o.customer_id = dc.customer_id

INNER JOIN warehouse.dim_date dd
    ON CAST(r.review_creation_date AS DATE) = dd.full_date;


-- Checking Unique Values
SELECT '=== Checking Unique Keys ===' AS info;
SELECT
    review_key,
    COUNT(*) AS occurrences
FROM warehouse.fact_reviews
GROUP BY review_key
HAVING COUNT(*) > 1;

-- Verify Count
SELECT '=== Verifying Counts For Fact Reviews ===' AS info;
SELECT *
FROM warehouse.fact_reviews
LIMIT 10;

-- Compare Counts
SELECT '=== Comparing Counts ===' AS info;
SELECT 
    COUNT(*) 
FROM raw.order_reviews;

SELECT 
    COUNT(*)
FROM warehouse.fact_reviews;

-- Test Analytical Query
SELECT '=== Testing Analytical Query ===' AS info;
SELECT
    review_score,
    COUNT(*) AS review_count
FROM warehouse.fact_reviews
GROUP BY review_score
ORDER by review_score;
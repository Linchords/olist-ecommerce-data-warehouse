-- BUSINESS QUESTIONS 
-- =========================================================
-- 1. MONTHLY SALES TREND
-- =========================================================

SELECT '=== How much revenue are we generating each month? ===' AS info;
SELECT 
    year,
    month,
    month_name,
    total_orders,
    total_items_sold,
    product_sales,
    total_order_item_value
FROM marts.vw_monthly_sales
ORDER BY year, month;


-- =========================================================
-- 2. TOP 10 PRODUCTS BY SALES
-- =========================================================

SELECT '=== Which products generate the most money? ===' AS info;
SELECT 
    product_id,
    product_category_name_english,
    total_items_sold,
    total_orders,
    total_product_sales
FROM marts.vw_product_performance
ORDER BY total_product_sales DESC
LIMIT 10;


-- =========================================================
-- 3. TOP PRODUCT CATEGORIES
-- =========================================================

SELECT '=== Which categories generate the most sales? ===' AS info;
SELECT 
    product_category_name_english,
    SUM(total_items_sold) AS items_sold,
    SUM(total_product_sales) AS category_sales
FROM marts.vw_product_performance
GROUP BY product_category_name_english
ORDER BY category_sales DESC
LIMIT 10;



-- =========================================================
-- 4. TOP CUSTOMERS BY TOTAL SPENDING
-- =========================================================

SELECT'=== Who are out highest value customers? ===' AS info;
SELECT 
    customer_unique_id,
    total_orders,
    total_items_purchased,
    total_spent,
    average_order_value
FROM marts.vw_customer_summary
ORDER BY total_spent DESC
LIMIT 10;


-- =========================================================
-- 5. REPEAT CUSTOMERS
-- =========================================================

SELECT'=== Which customers have purchased more than once? ===' AS info;
SELECT 
    customer_unique_id,
    total_orders,
    total_spent
FROM marts.vw_customer_summary
WHERE total_orders > 1
ORDER BY total_orders DESC, total_spent DESC
LIMIT 20;


-- =========================================================
-- 6. TOP SELLERS
-- =========================================================

SELECT '=== Which sellers generate the most revenue? ===' AS info;
SELECT 
    seller_id,
    seller_city,
    seller_state,
    total_items_sold,
    total_orders,
    total_revenue
FROM marts.vw_seller_performance
ORDER BY total_revenue DESC
LIMIT 10;


-- =========================================================
-- 7. OVERALL REVIEW SCORE
-- =========================================================

SELECT '=== Overall, how satisfied are customers? ===' AS info;
SELECT 
    AVG(review_score) AS average_review_score
FROM warehouse.fact_reviews;


-- =========================================================
-- 8. REVIEW SCORE DISTRIBUTION
-- =========================================================

SELECT '=== Review Score Distribution ===' AS info;
SELECT 
    review_score,
    COUNT(*) AS review_count
FROM warehouse.fact_reviews
GROUP BY review_score
ORDER BY review_score;


-- =========================================================
-- 9. LATE DELIVERY RATE
-- =========================================================

SELECT '=== What percentage of delivered orders arrived late? ===' AS info;
SELECT
    COUNT(*) FILTER(
        WHERE is_late_delivery = TRUE 
    ) AS late_orders,

    COUNT(*) FILTER(
        WHERE is_late_delivery IS NOT NULL
    ) AS delivered_orders,

    
    ROUND(
        100.0 * 
        COUNT(*) FILTER(WHERE is_late_delivery = TRUE)
        /
        NULLIF(
            COUNT(*) FILTER(
                WHERE is_late_delivery IS NOT NULL
            ),
            0
        ),
        2
    ) AS late_delivery_percentage

FROM marts.vw_delivery_performance;



-- =========================================================
-- 10. AVERAGE DELIVERY TIME
-- =========================================================

SELECT '=== Average Delivery Time ===' AS info;
SELECT 
    ROUND(
        AVG(actual_delivery_days),
        2
    ) AS average_delivery_days
FROM marts.vw_delivery_performance
WHERE actual_delivery_days IS NOT NULL;


SHOW ALL TABLES;

SELECT COUNT(*) FROM raw.orders;
SELECT COUNT(*) FROM warehouse.fact_sales;
SELECT COUNT(*) FROM warehouse.fact_payments;
SELECT COUNT(*) FROM warehouse.fact_reviews;
SELECT COUNT(*) FROM warehouse.fact_delivery;

SELECT *
FROM marts.vw_monthly_sales
LIMIT 5;

SELECT *
FROM marts.vw_customer_summary
LIMIT 5;


SELECT
    review_id,
    COUNT(*) AS rows_count,
    COUNT(DISTINCT order_id) AS order_count
FROM raw.order_reviews
GROUP BY review_id
HAVING COUNT(*) > 1
ORDER BY rows_count DESC;

SELECT
    review_id,
    order_id,
    COUNT(*) AS occurrences
FROM raw.order_reviews
GROUP BY
    review_id,
    order_id
HAVING COUNT(*) > 1;
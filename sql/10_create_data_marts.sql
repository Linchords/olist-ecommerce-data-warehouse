-- =========================================================
-- MONTHLY SALES MART
-- Purpose:
-- Provides monthly sales KPIs for reporting and dashboards
-- =========================================================
SELECT '=== Creating Monthly Sales Mart ===' AS info;
CREATE OR REPLACE VIEW marts.vw_monthly_sales AS 

SELECT 
    d.year,
    d.month,
    d.month_name,

    COUNT(DISTINCT fs.order_id) AS total_orders,
    COUNT(*) AS total_items_sold,

    SUM(fs.price) AS product_sales,
    SUM(fs.freight_value) AS freight_revenue,

    SUM(fs.price + fs.freight_value) AS total_order_item_value,
    AVG(fs.price) AS avarage_item_price

FROM warehouse.fact_sales fs

INNER JOIN warehouse.dim_date d
    ON fs.date_key = d.date_key
GROUP BY 
    d.year,
    d.month,
    d.month_name;


-- TEST 
SELECT '=== Testing Monthly sales mart ===' AS info;
SELECT *
FROM marts.vw_monthly_sales
ORDER BY year, month
LIMIT 20;

-- Business Question Query
-- Question: Which month generated the highest product sales
SELECT '=== Business Question Query ===' AS info;
SELECT 
    year,
    month_name,
    product_sales
FROM marts.vw_monthly_sales
ORDER by product_sales DESC 
LIMIT 10;


-- =========================================================
-- PRODUCT PERFORMANCE MART
-- Purpose:
-- Summarizes product and category sales performance
-- =========================================================

SELECT '=== Creating Product Performance Mart ===' AS info;
CREATE OR REPLACE VIEW marts.vw_product_performance AS 

SELECT 
    dp.product_key,
    dp.product_id,
    dp.product_category_name,
    dp.product_category_name_english,

    COUNT(*) AS total_items_sold,
    COUNT(DISTINCT fs.order_id) AS total_orders,

    SUM(fs.price) AS total_product_sales,
    SUM(fs.freight_value) AS total_freight_value,
    SUM(fs.price + fs.freight_value) AS total_revenue,

    AVG(fs.price) AS average_item_price

FROM warehouse.fact_sales fs 

INNER JOIN warehouse.dim_product dp 
    ON fs.product_key = dp.product_key

GROUP BY 
    dp.product_key,
    dp.product_id,
    dp.product_category_name,
    dp.product_category_name_english;

-- Top Products by Sales
SELECT '=== Testing Product Performance Mart ===' AS info;
SELECT 
    product_id,
    product_category_name_english,
    total_product_sales
FROM marts.vw_product_performance
ORDER BY total_product_sales DESC
LIMIT 10;

-- Top Categories
SELECT '=== Top Product Categories ===' AS info;
SELECT 
    product_category_name_english,
    SUM(total_product_sales) AS category_sales
FROM marts.vw_product_performance
GROUP BY product_category_name_english
ORDER BY category_sales DESC
LIMIT 10;

-- =========================================================
-- CUSTOMER SUMMARY MART
-- Purpose:
-- Summarizes customer purchasing behavior
-- Grain: One row per unique customer
-- =========================================================

SELECT '=== Creating Customer Summary Mart ===' AS info;
CREATE OR REPLACE VIEW marts.vw_customer_summary AS

WITH order_totals AS (

SELECT 
    dc.customer_unique_id,
    fs.order_id,

    SUM(fs.price) AS product_sales,
    SUM(fs.freight_value) AS freight_value,
    SUM(fs.price + fs.freight_value) AS order_value,

    COUNT(*) AS items_in_order

FROM warehouse.fact_sales fs 

INNER JOIN warehouse.dim_customer dc
    ON fs.customer_key = dc.customer_key

GROUP BY 
    dc.customer_unique_id,
    fs.order_id
)

SELECT 

    customer_unique_id,

    COUNT(*) AS total_orders,

    SUM(items_in_order) AS total_items_purchased,

    SUM(product_sales) AS total_product_sales,

    SUM(freight_value) AS total_freight_paid,

    SUM(order_value) AS total_spent,

    AVG(order_value) AS average_order_value
FROM order_totals
GROUP BY customer_unique_id;


-- Test Customer Mart
SELECT '=== Testing Customer Summary Mart ===' AS info;
SELECT *
FROM marts.vw_customer_summary
LIMIT 10;

-- Top Customers by Spending
SELECT '=== Top Customers By Spending ===' AS info;
SELECT 
    customer_unique_id,
    total_orders,
    total_spent
FROM marts.vw_customer_summary
ORDER BY total_spent DESC
LIMIT 10;

-- Find Repeat Customers
SELECT '=== Repeat Customers ===' AS info;
SELECT 
    customer_unique_id,
    total_orders,
    total_spent
FROM marts.vw_customer_summary
WHERE total_orders > 1
ORDER BY total_orders DESC, total_spent DESC
LIMIT 20;


-- =========================================================
-- SELLER PERFORMANCE MART
-- Purpose:
-- Summarizes seller sales performance
-- Grain: One row per seller
-- =========================================================

SELECT '=== Creating Seller Performance Mart ===' AS info;
CREATE OR REPLACE VIEW marts.vw_seller_performance AS 

SELECT 
    ds.seller_key,
    ds.seller_id,
    ds.seller_city,
    ds.seller_state,

    COUNT(*) AS total_items_sold,

    COUNT(DISTINCT fs.order_id) AS total_orders,

    SUM(fs.price) AS total_product_sales,

    SUM(fs.freight_value) AS total_freight_value,

    SUM(fs.price + fs.freight_value) AS total_revenue,

    AVG(fs.price) AS average_item_price

FROM warehouse.fact_sales fs

INNER JOIN warehouse.dim_seller ds 
    ON fs.seller_key = ds.seller_key

GROUP BY 
    ds.seller_key,
    ds.seller_id,
    ds.seller_city,
    ds.seller_state;

-- TEST
SELECT '=== Top Sellers By Revenue ===' AS info;
SELECT 
    seller_id,
    seller_city,
    seller_state,
    total_orders,
    total_revenue
FROM marts.vw_seller_performance
ORDER BY total_revenue DESC
LIMIT 10;

-- Top states by seller revenue
SELECT '=== Top States By Seller Revenue ===' AS info;
SELECT 
    seller_state,
    SUM(total_revenue) AS state_revenue
FROM marts.vw_seller_performance
GROUP BY seller_state
ORDER BY state_revenue DESC;
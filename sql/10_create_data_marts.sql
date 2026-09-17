-- =========================================================
-- MONTHLY SALES MART
-- Purpose:
-- Provides monthly sales KPIs for reporting and dashboards
-- =========================================================

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
SELECT *
FROM marts.vw_monthly_sales
ORDER BY year, month
LIMIT 20;

-- Business Question Query
-- Question: Which month generated the highest product sales

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
SELECT 
    product_id,
    product_category_name_english,
    total_product_sales
FROM marts.vw_product_performance
ORDER BY total_product_sales DESC
LIMIT 10;

-- Top Categories
SELECT 
    product_category_name_english,
    SUM(total_product_sales) AS category_sales
FROM marts.vw_product_performance
GROUP BY product_category_name_english
ORDER BY category_sales DESC
LIMIT 10;

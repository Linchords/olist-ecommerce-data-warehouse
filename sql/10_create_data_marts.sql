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
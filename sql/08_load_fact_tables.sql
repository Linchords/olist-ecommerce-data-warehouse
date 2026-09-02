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


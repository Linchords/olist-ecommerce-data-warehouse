-- =========================================================
-- Load Olist CSV files into raw tables
-- =========================================================

-- Make Script Idempotent/Rerunnable
DELETE FROM raw.customers;
DELETE FROM raw.geolocation;
DELETE FROM raw.orders;
DELETE FROM raw.order_items;
DELETE FROM raw.order_payments;
DELETE FROM raw.order_reviews;
DELETE FROM raw.products;
DELETE FROM raw.sellers;
DELETE FROM raw.product_category_translation;



-- Load Customers Table
SELECT '=== Loading Customers Table CSV ===' AS info;
INSERT INTO raw.customers BY NAME
SELECT *
FROM read_csv(
    'data/raw/olist_customers_dataset.csv',
    header = TRUE
);


-- Load Geolocation Table
SELECT '=== Loading Geolocation Table CSV ===' AS info;
INSERT INTO raw.geolocation BY NAME
SELECT * 
FROM read_csv(
    'data/raw/olist_geolocation_dataset.csv',
    header = TRUE
);


-- Load Orders Table
SELECT '=== Loading Orders Table CSV ===' AS info;
INSERT INTO raw.orders BY NAME
SELECT * 
FROM read_csv(
    'data/raw/olist_orders_dataset.csv',
    header = TRUE
);

-- Load Order Items Table
SELECT '=== Loading Order Items Table CSV ===' AS info;
INSERT INTO raw.order_items BY NAME
SELECT *
FROM read_csv(
    'data/raw/olist_order_items_dataset.csv',
    header = TRUE
);

-- Load Order Payments Table
SELECT '=== Loading Order Payments Table CSV ===' AS info;
INSERT INTO raw.order_payments BY NAME 
SELECT *
FROM read_csv(
    'data/raw/olist_order_payments_dataset.csv',
    header = TRUE
);

-- Load Order Reviews Table
SELECT '=== Loading Order Reviews Table CSV ===' AS info;
INSERT INTO raw.order_reviews BY NAME
SELECT * 
FROM read_csv(
    'data/raw/olist_order_reviews_dataset.csv',
    header = TRUE
);

-- Load Products Table
SELECT '=== Loading Product Table CSV ===' AS info;
INSERT INTO raw.products BY NAME
SELECT *
FROM read_csv(
    'data/raw/olist_products_dataset.csv',
    header = TRUE
);

-- Load Sellers Table
SELECT '=== Loading Sellers Table CSV ===' AS info;
INSERT INTO raw.sellers BY NAME
SELECT *
FROM read_csv(
    'data/raw/olist_sellers_dataset.csv',
    header = TRUE
);

-- Product Category Translation Table
SELECT '=== Loading Category Translation Table CSV ===' AS info;
INSERT INTO raw.product_category_translation BY NAME
SELECT *
FROM read_csv(
    'data/raw/product_category_name_translation.csv',
    header = TRUE
);


-- Validate Table Insertion Using Union & Count
SELECT '=== Validating Row Insertion ===' AS info;
SELECT 'Customers' AS table_name, COUNT(*) AS record_count FROM raw.customers
UNION ALL
SELECT 'Geolocation', COUNT(*) FROM raw.geolocation
UNION ALL
SELECT 'Order Items', COUNT(*) FROM raw.order_items
UNION ALL 
SELECT 'Order Payments', COUNT(*) FROM raw.order_payments
UNION ALL 
SELECT 'Order Reviews', COUNT(*) FROM raw.order_reviews
UNION ALL 
SELECT 'Orders', COUNT(*) FROM raw.orders
UNION ALL 
SELECT 'Product Category Translation', COUNT(*) FROM raw.product_category_translation
UNION ALL 
SELECT 'Products', COUNT(*) FROM raw.products
UNION ALL 
SELECT 'Seller', COUNT(*) FROM raw.sellers;

-- Preview Few Rows 
SELECT '=== Previewing First Five(5) Rows ===' AS info;

SELECT 'Customers Table Preview ===' AS info;
SELECT * 
FROM raw.customers
LIMIT 5;

SELECT '=== Products Table Preview ===' AS info;
SELECT *
FROM raw.products 
LIMIT 5;

SELECT '=== Order Table Preview ===' AS info;
SELECT *
FROM raw.orders
LIMIT 5;







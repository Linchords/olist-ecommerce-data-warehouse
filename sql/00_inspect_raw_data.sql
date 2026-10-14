
-- Inspect Customers
SELECT ' === Inspecting Customers Raw Dataset === ' AS info;
DESCRIBE
SELECT *
FROM read_csv_auto(
    'data/raw/olist_customers_dataset.csv', 
    HEADER = TRUE
);

-- Inspect Orders
SELECT ' === Inspecting Orders Raw Dataset === ' AS info;
DESCRIBE
SELECT *
FROM read_csv_auto(
    'data/raw/olist_orders_dataset.csv', 
    HEADER = TRUE
);

-- Inspect Order Items 
SELECT ' === Inspecting Order Items Raw Dataset === ' AS info;
DESCRIBE
SELECT *
FROM read_csv_auto(
    'data/raw/olist_order_items_dataset.csv', 
    HEADER = TRUE
);

-- Inspect Order Payments
SELECT ' === Inspecting Order Payments Raw Dataset === ' AS info;
DESCRIBE
SELECT *
FROM read_csv_auto(
    'data/raw/olist_order_payments_dataset.csv', 
    HEADER = TRUE
);

-- Inspect Order Reviews
SELECT ' === Inspecting Order Reviews Raw Dataset === ' AS info;
DESCRIBE
SELECT *
FROM read_csv_auto(
    'data/raw/olist_order_reviews_dataset.csv', 
    HEADER = TRUE
);


-- Inspect products
SELECT ' === Inspecting Products Raw Dataset === ' AS info;
DESCRIBE
SELECT *
FROM read_csv_auto(
    'data/raw/olist_products_dataset.csv',
    HEADER = TRUE
);

-- Inspect sellers
SELECT ' === Inspecting Sellers Raw Dataset === ' AS info;
DESCRIBE
SELECT *
FROM read_csv_auto(
    'data/raw/olist_sellers_dataset.csv',
    HEADER = TRUE
);

-- Inspect geolocation
SELECT ' === Inspecting Geolocation Raw Dataset === ' AS info;
DESCRIBE
SELECT *
FROM read_csv_auto(
    'data/raw/olist_geolocation_dataset.csv',
    HEADER = TRUE
);

-- Inspect Product category translations
SELECT ' === Inspecting Product Category Raw Dataset === ' AS info;
DESCRIBE
SELECT *
FROM read_csv_auto(
    'data/raw/product_category_name_translation.csv',
    HEADER = TRUE
);


-- PREVIEWING FEW 
-- Customers Row 
SELECT ' === Previewing Customers Raw Dataset Rows === ' AS info;
SELECT *
FROM read_csv_auto(
    'data/raw/olist_customers_dataset.csv',
    HEADER = TRUE
)
LIMIT 5;


-- Orders Row 
SELECT ' === Previewing Orders Raw Dataset Rows === ' AS info;
SELECT *
FROM read_csv_auto(
    'data/raw/olist_orders_dataset.csv',
    HEADER = TRUE
)
LIMIT 5;




-- =========================================================
-- LOAD CUSTOMER DIMENSION
-- =========================================================

SELECT '=== Loading Dim Customer Table ===' AS info;
INSERT INTO warehouse.dim_customer(
    customer_key,
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state
)
SELECT 
    ROW_NUMBER() OVER(
        ORDER BY customer_id
    ) AS customer_key,
    
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state
FROM raw.customers;


-- Verify Loads
SELECT '=== Checking Total Counts For Dim Customer ===' AS info;
SELECT 
    COUNT(*) AS total_rows_dim_customer
FROM warehouse.dim_customer;

SELECT '=== Checking First 5 Rows For Dim Customer ===' AS info;
SELECT *
FROM warehouse.dim_customer
LIMIT 10;

-- Verify if dim_customer rows match with the total customer rows 
SELECT '=== Verifying total customers rows ===' AS info;
SELECT 
    COUNT(*) AS total_rows_customers
FROM raw.customers;


-- Data Quality Check for Surrogate customer keys
SELECT '=== Checking Duplicates For Customer Key ===' AS info;
SELECT 
    customer_key,
    COUNT(*) AS unique_keys_total_counts
FROM warehouse.dim_customer
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- View Difference Between Olist Customer IDs 
SELECT '=== Checking Customer Order IDs Greater than 1 ===' AS info;
SELECT 
    customer_unique_id,
    COUNT(DISTINCT customer_id) AS customer_id_count
FROM warehouse.dim_customer
GROUP BY customer_unique_id
HAVING COUNT(DISTINCT customer_id) > 1
ORDER BY customer_id_count DESC
LIMIT 10;
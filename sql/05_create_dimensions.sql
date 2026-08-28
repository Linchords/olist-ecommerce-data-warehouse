-- =========================================================
-- CUSTOMER DIMENSION
-- Grain: One row per source customer_id
-- =========================================================

DROP TABLE warehouse.dim_customer;

CREATE TABLE warehouse.dim_customer (
    customer_key                BIGINT          PRIMARY KEY, -- Warehouse ID
    customer_id                 VARCHAR, -- Olist source system ID
    customer_unique_id          VARCHAR, -- Actual shopper identity across multiple orders
    customer_city               VARCHAR,
    customer_state              VARCHAR
);


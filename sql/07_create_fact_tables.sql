-- =========================================================
-- SALES FACT TABLE
-- Grain: One row per order item
-- =========================================================

DROP TABLE IF EXISTS warehouse.fact_sales;

SELECT '=== Creating Fact Sales Table ===' AS info;

CREATE TABLE warehouse.fact_sales (
    order_id                    VARCHAR,
    order_item_id               INTEGER,
    customer_key                BIGINT,
    product_key                 BIGINT,
    seller_key                  BIGINT,
    date_key                    INTEGER,
    order_status                VARCHAR,
    shipping_limit_date         TIMESTAMP,
    price                       DOUBLE,
    freight_value               DOUBLE,

    PRIMARY KEY (order_id, order_item_id),

    FOREIGN KEY (customer_key)
        REFERENCES warehouse.dim_customer(customer_key),
    
    FOREIGN KEY (product_key)
        REFERENCES warehouse.dim_product(product_key),

    FOREIGN KEY (seller_key)
        REFERENCES warehouse.dim_seller(seller_key),

    FOREIGN KEY (date_key)
        REFERENCES warehouse.dim_date(date_key)
);

-- =========================================================
-- PAYMENTS FACT TABLE
-- Grain: One row per payment transaction within an order
-- =========================================================

DROP TABLE IF EXISTS warehouse.fact_payments;

SELECT '=== Creating Fact Payments Table ===' AS info;
CREATE TABLE warehouse.fact_payments (
    order_id                VARCHAR,
    payment_sequential      INTEGER,
    customer_key            BIGINT,
    date_key                INTEGER,
    payment_type            VARCHAR,
    payment_installments    INTEGER,
    payment_value           DOUBLE,
    order_status            VARCHAR,

    PRIMARY KEY (order_id, payment_sequential),

    FOREIGN KEY (customer_key)
        REFERENCES warehouse.dim_customer(customer_key),
    
    FOREIGN KEY (date_key)
        REFERENCES warehouse.dim_date(date_key)
); 



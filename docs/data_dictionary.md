# Olist E-Commerce Data Dictionary

## warehouse.dim_customer

Grain: One row per source customer_id.

| Column             | Type    | Description                                      |
| ------------------ | ------- | ------------------------------------------------ |
| customer_key       | BIGINT  | Warehouse-generated surrogate key                |
| customer_id        | VARCHAR | Customer identifier from the Olist source system |
| customer_unique_id | VARCHAR | Unique shopper identifier across multiple orders |
| customer_city      | VARCHAR | Customer city                                    |
| customer_state     | VARCHAR | Customer state abbreviation                      |

---

## warehouse.dim_product

Grain: One row per product_id.

| Column                        | Type    | Description                               |
| ----------------------------- | ------- | ----------------------------------------- |
| product_key                   | BIGINT  | Warehouse-generated surrogate key         |
| product_id                    | VARCHAR | Product identifier from the source system |
| product_category_name         | VARCHAR | Original Portuguese product category      |
| product_category_name_english | VARCHAR | English category translation              |
| product_name_length           | INTEGER | Length of product name                    |
| product_description_length    | INTEGER | Length of product description             |
| product_photos_qty            | INTEGER | Number of product photos                  |
| product_weight_g              | INTEGER | Product weight in grams                   |
| product_length_cm             | INTEGER | Product length in centimeters             |
| product_height_cm             | INTEGER | Product height in centimeters             |
| product_width_cm              | INTEGER | Product width in centimeters              |

---

## warehouse.dim_seller

Grain: One row per seller_id.

| Column                 | Type    | Description                                    |
| ---------------------- | ------- | ---------------------------------------------- |
| seller_key             | BIGINT  | Warehouse-generated surrogate key              |
| seller_id              | VARCHAR | Seller identifier from the Olist source system |
| seller_zip_code_prefix | INTEGER | Seller ZIP code prefix                         |
| seller_city            | VARCHAR | Seller city                                    |
| seller_state           | VARCHAR | Seller state abbreviation                      |

---

## warehouse.dim_date

Grain: One row per calendar date.

| Column     | Type    | Description                              |
| ---------- | ------- | ---------------------------------------- |
| date_key   | INTEGER | Date surrogate key in YYYYMMDD format    |
| full_date  | DATE    | Calendar date                            |
| year       | INTEGER | Calendar year                            |
| quarter    | INTEGER | Calendar quarter                         |
| month      | INTEGER | Month number                             |
| month_name | VARCHAR | Month name                               |
| day        | INTEGER | Day of month                             |
| day_name   | VARCHAR | Day of week                              |
| is_weekend | BOOLEAN | TRUE when the date is Saturday or Sunday |

---

## warehouse.fact_sales

Grain: One row per order item.

| Column              | Type      | Description                                  |
| ------------------- | --------- | -------------------------------------------- |
| order_id            | VARCHAR   | Order identifier                             |
| order_item_id       | INTEGER   | Sequence number of the item within the order |
| customer_key        | BIGINT    | Foreign key to dim_customer                  |
| product_key         | BIGINT    | Foreign key to dim_product                   |
| seller_key          | BIGINT    | Foreign key to dim_seller                    |
| date_key            | INTEGER   | Foreign key to dim_date using purchase date  |
| order_status        | VARCHAR   | Order status                                 |
| shipping_limit_date | TIMESTAMP | Seller shipping deadline                     |
| price               | DOUBLE    | Product selling price                        |
| freight_value       | DOUBLE    | Freight cost associated with the item        |

---

## warehouse.fact_payments

Grain: One row per payment transaction within an order.

| Column               | Type    | Description                       |
| -------------------- | ------- | --------------------------------- |
| order_id             | VARCHAR | Order identifier                  |
| payment_sequential   | INTEGER | Payment sequence within the order |
| customer_key         | BIGINT  | Foreign key to dim_customer       |
| date_key             | INTEGER | Foreign key to dim_date           |
| payment_type         | VARCHAR | Payment method                    |
| payment_installments | INTEGER | Number of installments            |
| payment_value        | DOUBLE  | Payment amount                    |
| order_status         | VARCHAR | Order status                      |

---

## warehouse.fact_reviews

Grain: One row per review.

| Column                  | Type      | Description                                        |
| ----------------------- | --------- | -------------------------------------------------- |
| review_id               | VARCHAR   | Review identifier                                  |
| order_id                | VARCHAR   | Related order identifier                           |
| customer_key            | BIGINT    | Foreign key to dim_customer                        |
| date_key                | INTEGER   | Foreign key to dim_date using review creation date |
| review_score            | INTEGER   | Customer review score                              |
| review_comment_title    | VARCHAR   | Review title                                       |
| review_comment_message  | VARCHAR   | Review message                                     |
| review_creation_date    | TIMESTAMP | Date review was created                            |
| review_answer_timestamp | TIMESTAMP | Date review was answered                           |

---

## warehouse.fact_delivery

Grain: One row per order.

| Column                        | Type      | Description                                 |
| ----------------------------- | --------- | ------------------------------------------- |
| order_id                      | VARCHAR   | Order identifier                            |
| customer_key                  | BIGINT    | Foreign key to dim_customer                 |
| purchase_date_key             | INTEGER   | Foreign key to dim_date using purchase date |
| order_status                  | VARCHAR   | Order status                                |
| order_purchase_timestamp      | TIMESTAMP | Time order was placed                       |
| order_approved_at             | TIMESTAMP | Time payment/order approval occurred        |
| order_delivered_carrier_date  | TIMESTAMP | Time order was handed to carrier            |
| order_delivered_customer_date | TIMESTAMP | Actual customer delivery date               |
| order_estimated_delivery_date | TIMESTAMP | Estimated delivery date                     |

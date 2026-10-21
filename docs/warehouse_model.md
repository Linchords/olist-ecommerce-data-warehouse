# Olist E-Commerce Data Warehouse Model

## 1. Overview

This document describes the dimensional data model developed for the Olist E-Commerce Data Warehouse.

The warehouse transforms raw transactional data into analytical tables supporting sales reporting, customer behavior analysis, product performance, seller performance, payment analysis, customer reviews, and delivery monitoring.

The model consists of **four dimensions and four fact tables**, organized within the `warehouse` schema.

## 2. Dimensional Modeling Approach

The warehouse separates descriptive attributes into dimension tables and measurable business events into fact tables.

Dimension tables use surrogate keys to establish relationships with fact tables, while original business identifiers are retained for reference and traceability.

### Dimension Tables

| Dimension      | Grain                            | Purpose                              |
| -------------- | -------------------------------- | ------------------------------------ |
| `dim_customer` | One row per source `customer_id` | Customer identification and location |
| `dim_product`  | One row per product              | Product attributes and categories    |
| `dim_seller`   | One row per seller               | Seller identification and location   |
| `dim_date`     | One row per calendar date        | Time-based analysis                  |

### Fact Tables

| Fact Table      | Grain                                           | Business Process               |
| --------------- | ----------------------------------------------- | ------------------------------ |
| `fact_sales`    | One row per order item                          | Sales transactions             |
| `fact_payments` | One row per payment transaction within an order | Order payments                 |
| `fact_reviews`  | One row per source review record                | Customer feedback              |
| `fact_delivery` | One row per order                               | Order fulfillment and delivery |

---

## 3. Dimension Tables

### 3.1 `warehouse.dim_customer`

**Purpose:** Stores descriptive customer information.

**Source:** `raw.customers`

**Primary Key:** `customer_key`

**Important Attributes:**

- `customer_id`
- `customer_unique_id`
- `customer_city`
- `customer_state`

**Design Consideration:** The source `customer_id` identifies a customer record associated with an order, while `customer_unique_id` identifies the shopper across orders. This distinction supports repeat-customer analysis.

### 3.2 `warehouse.dim_product`

**Purpose:** Stores product attributes and category information.

**Sources:**

- `raw.products`
- `raw.product_category_translation`

**Primary Key:** `product_key`

**Important Attributes:**

- `product_id`
- `product_category_name`
- `product_category_name_english`
- `product_weight_g`
- `product_length_cm`
- `product_height_cm`
- `product_width_cm`

**Design Consideration:** Product category translations support business reporting using English category names.

### 3.3 `warehouse.dim_seller`

**Purpose:** Stores descriptive information about marketplace sellers.

**Source:** `raw.sellers`

**Primary Key:** `seller_key`

**Important Attributes:**

- `seller_id`
- `seller_zip_code_prefix`
- `seller_city`
- `seller_state`

### 3.4 `warehouse.dim_date`

**Purpose:** Enables reporting and filtering by calendar attributes.

**Sources:**

- `raw.orders`
- `raw.order_reviews`

**Primary Key:** `date_key` (YYYYMMDD format)

**Important Attributes:**

- `full_date`
- `year`
- `quarter`
- `month`
- `month_name`
- `day`
- `day_name`
- `is_weekend`

**Design Consideration:** The date dimension is generated using the earliest and latest relevant order and review event dates.

For the original dataset, it covers **2016-09-04 through 2018-11-12**, totaling **800 calendar days**.

Four anomalous shipping-deadline records occur in 2020 and remain outside the generated calendar. They are preserved in the source data and identified through a documented validation exception.

---

## 4. Fact Tables

### 4.1 `warehouse.fact_sales`

**Grain:** One row per order item.

**Sources:**

- `raw.order_items`
- `raw.orders`

**Primary Key:** (`order_id`, `order_item_id`)

**Foreign Keys:**

- `customer_key` → `dim_customer`
- `product_key` → `dim_product`
- `seller_key` → `dim_seller`
- `date_key` → `dim_date`

**Measures:**

- `price`
- `freight_value`

**Additional Attributes:**

- `order_status`
- `shipping_limit_date`

**Design Consideration:** The fact table retains sales items across available order statuses, while the four sales reporting marts filter for `delivered` orders.

### 4.2 `warehouse.fact_payments`

**Grain:** One row per payment transaction within an order.

**Sources:**

- `raw.order_payments`
- `raw.orders`

**Primary Key:** (`order_id`, `payment_sequential`)

**Foreign Keys:**

- `customer_key` → `dim_customer`
- `date_key` → `dim_date`

**Measures and Attributes:**

- `payment_type`
- `payment_installments`
- `payment_value`
- `order_status`

**Design Consideration:** An order can have multiple payment records. Keeping the payment sequence preserves the payment-level grain.

### 4.3 `warehouse.fact_reviews`

**Grain:** One row per source review record.

**Source:** `raw.order_reviews`

**Primary Key:** `review_key`

**Foreign Keys:**

- `customer_key` → `dim_customer`
- `date_key` → `dim_date`

**Important Attributes:**

- `review_id`
- `order_id`
- `review_score`
- `review_comment_title`
- `review_comment_message`
- `review_creation_date`
- `review_answer_timestamp`

**Design Consideration:** The original dataset contains duplicate `review_id` values. A generated `review_key` uniquely identifies each review record without discarding the original identifier.

Reviews are associated with orders rather than individual products. The review performance mart attributes each review to distinct product-seller combinations within its order and avoids duplicate attribution caused by multiple order-item rows for the same combination.

### 4.4 `warehouse.fact_delivery`

**Grain:** One row per order.

**Source:** `raw.orders`

**Primary Key:** `order_id`

**Foreign Keys:**

- `customer_key` → `dim_customer`
- `purchase_date_key` → `dim_date`

**Important Attributes:**

- `order_status`
- `order_purchase_timestamp`
- `order_approved_at`
- `order_delivered_carrier_date`
- `order_delivered_customer_date`
- `order_estimated_delivery_date`

**Design Consideration:** Delivery events are modeled at the order level rather than the order-item level.

The delivery performance mart derives delivery duration, delay duration, and late-delivery indicators from these timestamps.

---

## 5. Analytical Data Marts

The `marts` schema contains six analytical views:

| Data Mart                 | Business Purpose                               |
| ------------------------- | ---------------------------------------------- |
| `vw_monthly_sales`        | Monthly order-item sales trends                |
| `vw_product_performance`  | Product and category performance               |
| `vw_customer_summary`     | Customer purchasing behavior                   |
| `vw_seller_performance`   | Seller sales performance                       |
| `vw_review_performance`   | Review-score attribution by product and seller |
| `vw_delivery_performance` | Delivery duration and lateness                 |

The four sales-related marts use delivered orders for consistent completed-sales reporting.

Sales values are calculated from item prices, and freight values are tracked separately. These amounts should not be interpreted as audited accounting revenue.

## 6. Data Quality and Validation

The warehouse includes checks for:

- Source and warehouse record counts
- Surrogate-key uniqueness
- Sales and payment reconciliation
- Date dimension coverage
- Review-count consistency
- Delivered-order sales reconciliation across four reporting marts

The cross-mart reconciliation compares reported item counts, product sales, and freight values directly with the original delivered-order records.

## 7. Related Documentation

- [Entity Relationship Diagram](erd.md)
- [Data Dictionary](data_dictionary.md)
- [Architecture Documentation](architecture.md)
- [Project README](../README.md)

# Olist E-Commerce Data Warehouse Model

## Business Process

The warehouse will support analysis of:

- customer purchasing behavior
- product sales
- seller performance
- revenue trends
- payments
- reviews
- delivery performance

## Dimensions

### dim_customer.

**Purpose:**  
Stores descriptive information about customers.

**Source:**

- raw.customers

**Important fields:**

- customer_key
- customer_id
- customer_unique_id
- customer_city
- customer_state

### dim_product

**Purpose:**  
Stores descriptive product information.

**Sources:**

- raw.products
- raw.product_category_tanslation

**Important fields:**

- product_key
- product_id
- product_category_name
- product_category_name_english
- product_weight_g
- product_length_cm
- product_height_cm
- product_width_cm

### dim_seller

**Purpose:**  
Stores seller information.

**Source:**

- raw.sellers

**Important fields:**

- seller_key
- seller_id
- seller_city
- seller_state

### dim_date

**Purpose:**  
Supports year, month, quarter and other time-based analysis.

**Source:**

- raw.orders

**Important fields:**

- date_key
- full_date
- year
- quarter
- month
- month_name
- day

## Fact Tables

### Fact_sales

**Grain:**  
One row per order item.

**Sources:**

- raw.orders_items
- raw.orders

**Keys:**

- customer_key
- product_key
- seller_key
- date_key

**Degenerate dimensions:**

- order_id
- order_item_id

**Measures:**

- price
- freight_value

### fact_payments

**Grain:**  
One row per payment transaction within an order.

**Source:**

- raw.order_payments

**Fields:**

- order_id
- payment_sequenatial
- payment_type
- payment_installments
- payment_value

### fact_reviews

**Grain:**  
One row per review.

**Source:**

- raw.order_reviews

**Fields:**

- review_id
- order_id
- review_score
- review_creation_date
- review_answer_timestamp

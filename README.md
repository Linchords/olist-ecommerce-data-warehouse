# Olist E-Commerce Data Warehouse

A SQL Data Engineering project built using the Brazilian Olist E-Commerce dataset from Kaggle.

The goal of this project is to simulate a real-world data engineering workflow by ingesting raw CSV data, validating it, transforming it into a dimensional warehouse, creating business-ready data marts, and answering analytical business questions.

---

## Technologies Used

- SQL
- DuckDB
- Git
- GitHub
- VS Code
- Kaggle

---

## Data Pipeline Architecture

```text
Kaggle CSV Files
        ↓
Raw Layer
        ↓
Data Validation
        ↓
Warehouse Layer
        ↓
Dimensions + Fact Tables
        ↓
Warehouse Validation
        ↓
Data Marts
        ↓
Business Analytics
```

---

## Project Structure

```text
olist-ecommerce-data-warehouse/
│
├── data/
│   ├── raw/
│   └── database/
│
├── sql/
│   ├── 00_inspect_raw_data.sql
│   ├── 01_create_schemas.sql
│   ├── 02_create_raw_tables.sql
│   ├── 03_load_raw_data.sql
│   ├── 04_raw_data_validation.sql
│   ├── 05_create_dimensions.sql
│   ├── 06_load_dimensions.sql
│   ├── 07_create_fact_tables.sql
│   ├── 08_load_fact_tables.sql
│   ├── 09_warehouse_validation.sql
│   ├── 10_create_data_marts.sql
│   ├── 11_business_queries.sql
│   └── 12_final_project_validation.sql
│
├── docs/
│   ├── architecture.md
│   ├── warehouse_model.md
│   ├── data_dictionary.md
│   └── erd.md
│
├── images/
├── README.md
└── .gitignore
```

---

## Data Layers

### Raw Layer

Schema:

```text
raw
```

Stores the original Olist source data with minimal transformation.

Main tables:

- raw.customers
- raw.orders
- raw.order_items
- raw.order_payments
- raw.order_reviews
- raw.products
- raw.sellers
- raw.geolocation
- raw.product_category_translation

---

## Warehouse Layer

Schema:

```text
warehouse
```

Transforms the source data into dimensional models designed for analytics.

### Dimensions

- dim_customer
- dim_product
- dim_seller
- dim_date

### Fact Tables

- fact_sales
- fact_payments
- fact_reviews
- fact_delivery

---

## Data Mart Layer

Schema:

```text
marts
```

Contains business-ready analytical views.

Views include:

- vw_monthly_sales
- vw_product_performance
- vw_customer_summary
- vw_seller_performance
- vw_review_performance
- vw_delivery_performance

---

## Business Questions Answered

The project supports analysis such as:

- What are the monthly sales trends?
- Which products generate the highest sales?
- Which product categories perform best?
- Who are the highest-value customers?
- Which customers make repeat purchases?
- Which sellers generate the most revenue?
- What payment methods are most commonly used?
- What is the average customer review score?
- What percentage of orders are delivered late?
- What is the average delivery time?

---

## Key Data Engineering Concepts Practiced

- Data ingestion
- CSV loading
- SQL DDL and DML
- Data validation
- Data quality checks
- Dimensional modeling
- Fact tables
- Dimension tables
- Surrogate keys
- Primary and foreign keys
- Star-schema concepts
- ETL / ELT workflows
- CTEs
- Window functions
- Aggregate functions
- Date functions
- CASE expressions
- Views
- Data marts
- Git branching workflow

---

## Dataset

Brazilian E-Commerce Public Dataset by Olist from Kaggle.

The raw CSV files are stored locally and excluded from GitHub through `.gitignore`.

Dataset source:

https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

---

## Documentation

Additional project documentation is available in the `docs/` directory:

- `architecture.md` — pipeline architecture
- `warehouse_model.md` — dimensional model design
- `data_dictionary.md` — table and column definitions
- `erd.md` — warehouse entity relationship diagram

# Olist E-Commerce Data Warehouse

**An End-to-End SQL Data Engineering & Analytics Project**

**Tech Stack:** SQL | DuckDB | Dimensional Modeling | ETL/ELT | Data Quality | Git & GitHub

## Project Overview

This project demonstrates the design and implementation of an analytical data warehouse using the Brazilian E-Commerce Public Dataset by Olist.

The solution transforms nine raw CSV datasets into a structured dimensional warehouse, enabling reliable reporting and business analysis across sales, customers, products, sellers, payments, reviews, and deliveries.

The pipeline covers data ingestion, validation, dimensional modeling, fact-table construction, analytical data marts, and reconciliation against source data.

## Key Project Highlights

| Metric                   | Validated Result |
| ------------------------ | ---------------: |
| Delivered orders         |           96,478 |
| Delivered order items    |          110,197 |
| Delivered product sales  |  R$13,221,498.11 |
| Delivered freight value  |   R$2,198,275.64 |
| Review records modeled   |           99,224 |
| Business reporting marts |                6 |

_Sales figures represent delivered-order item prices and associated freight values, not audited accounting revenue._

## Engineering Achievements

- **Dimensional Modeling:** Designed four dimension tables and four fact tables to support analytical queries.
- **Data Quality:** Implemented source-to-warehouse validation, surrogate-key checks, date coverage checks, and cross-mart reconciliation.
- **Business Analytics:** Developed six reporting views covering sales, customer behavior, seller performance, product performance, reviews, and delivery performance.
- **Data Integrity:** Addressed non-unique review identifiers and prevented order-item joins from inflating review counts.
- **Reproducibility:** Successfully tested the complete SQL pipeline using a fresh DuckDB database.
- **Version Control:** Managed development through feature branches, testing, and merges into `develop` and `main`.

---

## Technologies Used

- SQL
- DuckDB
- Git
- GitHub
- VS Code
- Kaggle

---

## Getting Started — Reproduce the Data Warehouse

This project can be reproduced locally using DuckDB and the publicly available Olist e-commerce dataset.

### Prerequisites

Before running the project, make sure you have:

- Git installed
- DuckDB Command Line Interface (CLI) installed
- Access to the Olist dataset on Kaggle
- A terminal or code editor such as VS Code

For macOS users with Homebrew, DuckDB can be installed using:

```bash
brew install duckdb
```

### 1. Clone the Repository

Open your terminal and run:

```bash
git clone https://github.com/Linchords/olist-ecommerce-data-warehouse.git

cd olist-ecommerce-data-warehouse
```

### 2. Download the Dataset

Download the **Brazilian E-Commerce Public Dataset by Olist** from Kaggle:

https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

Create the required directories if they do not already exist:

```bash
mkdir -p data/raw data/database
```

Extract the downloaded ZIP file and place the following nine CSV files inside `data/raw/`:

- `olist_customers_dataset.csv`
- `olist_geolocation_dataset.csv`
- `olist_orders_dataset.csv`
- `olist_order_items_dataset.csv`
- `olist_order_payments_dataset.csv`
- `olist_order_reviews_dataset.csv`
- `olist_products_dataset.csv`
- `olist_sellers_dataset.csv`
- `product_category_name_translation.csv`

**Note:** Raw CSV files and DuckDB database files are excluded from Git version control through `.gitignore`.

### 3. Create a Fresh DuckDB Database

From the repository's root directory, run:

```bash
duckdb data/database/olist_warehouse_demo.duckdb
```

This opens a separate DuckDB database for reproducing the project.

**Important:** The initial setup script drops and recreates the project's schemas. Run the full pipeline only against a new or disposable database, not a database containing data you want to preserve.

### 4. Execute the Data Pipeline

Inside the DuckDB CLI, execute the SQL scripts in the following order:

```sql
.read sql/01_create_schemas.sql
.read sql/02_create_raw_tables.sql
.read sql/03_load_raw_data.sql
.read sql/04_raw_data_validation.sql
.read sql/05_create_dimensions.sql
.read sql/06_load_dimensions.sql
.read sql/07_create_fact_tables.sql
.read sql/08_load_fact_tables.sql
.read sql/09_warehouse_validation.sql
.read sql/10_create_data_marts.sql
.read sql/11_business_queries.sql
.read sql/12_final_project_validation.sql
```

Run each script sequentially and inspect any errors before continuing.

These scripts create the schemas, ingest raw data, build the dimensional warehouse, create analytical views, and run validation checks.

### 5. Verify the Results

After the pipeline completes, check the available data marts:

```sql
SELECT table_name
FROM information_schema.views
WHERE table_schema = 'marts'
ORDER BY table_name;
```

Expected: **Six analytical views**.

Verify the warehouse's date dimension:

```sql
SELECT
    MIN(full_date) AS first_date,
    MAX(full_date) AS last_date,
    COUNT(*) AS total_days
FROM warehouse.dim_date;
```

Expected results for the original Olist dataset:

| First Date | Last Date  | Total Days |
| ---------- | ---------- | ---------: |
| 2016-09-04 | 2018-11-12 |        800 |

The final validation script also compares delivered-order sales figures across four business marts against the raw source data. Each reconciliation should return `PASS`.

**Known data-quality exception:** Four shipping-deadline records fall outside the normal calendar coverage, with dates in 2020. These anomalous source records are preserved and explicitly reported as `KNOWN EXCEPTION`, rather than silently discarded.

### 6. Exit DuckDB

```sql
.quit
```

The completed database remains available locally at:

`data/database/olist_warehouse_demo.duckdb`

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

## Data Warehouse Architecture & Design Decisions

### Dimensional Modeling Approach

The warehouse uses a dimensional modeling approach, organizing data into fact tables containing measurable business events and dimension tables containing descriptive attributes.

The warehouse contains:

- **4 dimension tables:** Customers, Products, Sellers, and Dates.
- **4 fact tables:** Sales, Payments, Reviews, and Deliveries.
- **6 analytical views:** Supporting business reporting across sales, customers, products, sellers, reviews, and delivery performance.

The design separates source data from analytics-ready data, allowing business reporting without directly modifying the original dataset.

### Fact Table Granularity

Each fact table has a clearly defined _grain_, meaning what one row represents.

| Fact Table      | Grain                                           | Primary Purpose                    |
| --------------- | ----------------------------------------------- | ---------------------------------- |
| `fact_sales`    | One row per order item                          | Product sales and freight analysis |
| `fact_payments` | One row per payment transaction within an order | Payment methods and values         |
| `fact_reviews`  | One row per source review record                | Customer satisfaction analysis     |
| `fact_delivery` | One row per order                               | Delivery times and delays          |

Defining the grain helps prevent incorrect aggregations when multiple tables are joined.

### Key Engineering Decisions

**1. Using Surrogate Keys**

Warehouse-generated keys are used to identify dimension records and individual reviews. This separates internal warehouse identifiers from the original business identifiers provided by Olist.

**2. Handling Duplicate Review Identifiers**

The source dataset contains duplicate `review_id` values. Because the source identifier is not guaranteed to be unique, the review fact table uses a generated `review_key` as its primary key.

The original `review_id` is retained for traceability.

**3. Preventing Inflated Review Counts**

Joining order-level reviews directly to order items can multiply review records when an order contains multiple items.

The review performance mart deduplicates each review by `review_key`, product, and seller before aggregation.

**Analytical limitation:** Reviews belong to orders, not individual products. An order-level review is therefore attributed to each distinct product-seller combination within that order; it should not be interpreted as an independently submitted review for each product.

**4. Reporting Completed Sales**

The four sales-related data marts include only orders with `order_status = 'delivered'`.

The underlying sales fact table retains other order statuses, preserving the broader transaction history for further analysis.

Reported product sales represent the sum of item prices. Freight values are reported separately. These figures are not equivalent to audited accounting revenue.

**5. Date Dimension Coverage**

The calendar dimension is generated from relevant order and review event dates, covering September 4, 2016, through November 12, 2018.

During validation, four shipping-deadline records were identified with dates in 2020, outside the normal business-event range.

Rather than modifying or discarding these records, the validation process identifies them as a `KNOWN EXCEPTION`.

**6. Cross-Mart Reconciliation**

An automated SQL validation compares delivered-order item counts, product sales, and freight values across four reporting marts against the raw source records.

The validation returns `PASS` or `FAIL` for each mart, helping detect inconsistent business metrics.

### Entity Relationship Diagram

The warehouse's table relationships, primary keys, and foreign keys are documented in the [Entity Relationship Diagram](docs/erd.md).

Additional technical documentation is available in the [Data Dictionary](docs/data_dictionary.md).

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

Explore the technical documentation:

- [Data Pipeline Architecture](docs/architecture.md) — Overview of the data pipeline.
- [Warehouse Model](docs/warehouse_model.md) — Dimensional model and engineering decisions.
- [Data Dictionary](docs/data_dictionary.md) — Table definitions and column descriptions.
- [Entity Relationship Diagram](docs/erd.md) — Visual representation of the warehouse relationships.

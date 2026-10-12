# Olist E-Commerce Data Warehouse

A SQL Data Engineering project built using the Brazilian Olist E-Commerce dataset.

## Technologies

- SQL
- DuckDB
- Git
- GitHub
- VS Code

## Architecture

Kaggle CSV Files
→ Raw Layer
→ Warehouse Layer
→ Data Marts
→ Business Analytics

## Data Layers

### Raw

Stores source CSV data with minimal transformation.

### Warehouse

Contains dimensional models including:

- dim_customer
- dim_product
- dim_seller
- dim_date
- fact_sales
- fact_payments
- fact_reviews
- fact_delivery

### Marts

Business-ready views including:

- vw_monthly_sales
- vw_product_performance
- vw_customer_summary
- vw_seller_performance
- vw_review_performance
- vw_delivery_performance

## Dataset

Brazilian E-Commerce Public Dataset by Olist from Kaggle.

The raw CSV files are excluded from Git using `.gitignore`.

## Project Structure

```text
data/
sql/
docs/
images/
README.md
.gitignore
```

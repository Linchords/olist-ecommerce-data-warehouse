# Olist E-Commerce Data Warehouse Architecture

## Overview

This project builds an analytical data warehouse using the Brazilian Olist E-Commerce dataset.

The pipeline follows a layered architecture:

```text
Kaggle CSV Files
        |
        v
Raw Layer
        |
        v
Warehouse Layer
        |
        v
Data Mart Layer
        |
        v
Business Analysis
```

## Warehouse Model

```text
                 dim_customer
                      |
                      |
                      v
dim_product ---> fact_sales <--- dim_seller
                      |
                      |
                      v
                   dim_date


dim_customer ---> fact_payments <--- dim_date

dim_customer ---> fact_reviews  <--- dim_date

dim_customer ---> fact_delivery <--- dim_date
```

# E-Commerce Growth & Checkout Analysis

## 1. Project Overview
This project analyzes an e-commerce dataset to identify practical growth levers with a focus on **revenue development**, **checkout/payment behavior**, and **customer experience (delivery & reviews)**.  
The goal is to produce insights that are transferable to real online shops (e.g., improving checkout performance, increasing order value, and reducing customer dissatisfaction caused by delivery issues).

---

## 2. Dataset
Source: **Brazilian E-Commerce Public Dataset by Olist** (public dataset).

Main tables used:
- **orders** (order status + timestamps)
- **order_items** (item-level prices + freight)
- **order_payments** (payment methods + installments)
- **order_reviews** (review score + timestamps)
- **products** + **category translation** (product → category mapping)

Notes / assumptions:
- **Revenue proxy:** item prices aggregated to order level (`SUM(order_items.price)`).
- Reviews are used as a **customer satisfaction proxy**.
- Some fields may contain **NULL values**; they are kept to reflect real-world data quality.

---

## 3. Tools & Technologies
- **PostgreSQL**
- **psql** (CSV import via `\copy`)
- **VS Code** (SQL development)
- **Git / GitHub**
- **Excel** (charts)

---

## 4. Repository Structure
- ├PROJECT-ECOMMERCE-GROWTH-CHECKOUT-ANALYSIS/
- ├─ .vscode/
- │  └─ settings.json
- ├─ charts/
- │  └─ Montly Revenue Growth.png
- ├─ data/
- │  ├─ olist_order_items_dataset.csv
- │  ├─ olist_order_payments_dataset.csv
- │  ├─ olist_order_reviews_dataset.csv
- │  ├─ olist_orders_dataset.csv
- │  ├─ olist_products_dataset.csv
- │  └─ product_category_name_translation.csv
- ├─ SQL/
- │  ├─ 00_schemas.sql
- │  ├─ 01_raw_tables.sql
- │  ├─ 02_clean_tables.sql
- │  ├─ 03_cleaning_logic.sql
- │   └─ 04_analysis/
- │     ├─ revenue.sql
- │     ├─ checkout.sql
- │     ├─ experience.sql
- │     └─ categories.sql
- └─ README.md

---

## 5. Methodology (Step-by-Step)
This project is organized into **two database schemas** to keep the workflow clean and reproducible:

### Step 1 — Create Schemas
File: `sql/00_schemas.sql`  
- `raw` = original imported data (no transformations)  
- `clean` = transformed, analysis-ready layer

### Step 2 — Create RAW Tables and Load CSVs
Files:
- `sql/01_raw_tables.sql` (table definitions)
- CSV import via `psql` using `\copy`

Key rule:
- RAW tables mirror CSV structure and remain unchanged.

### Step 3 — Build CLEAN Tables (Transformations)
Files:
- `sql/02_clean_tables.sql`
- `sql/03_cleaning_logic.sql`

Clean layer includes:
- Delivered orders base (`clean.orders`)
- Order-level revenue aggregation (`clean.orders_revenue`)
- Order-level checkout aggregation (`clean.orders_checkout`)
- Order-level experience data (delivery + reviews) (`clean.orders_experience`)
- Product categories enriched with English names (`clean.products`)

### Step 4 — Run Analysis Queries (Read-Only)
Folder: `sql/04_analysis/`  
Important rule:
- Only `SELECT` queries here (no table creation).

---

## 6. Key Analyses & Results

### 6.1 Revenue Growth Over Time
A monthly revenue analysis shows strong business growth from late 2016 to mid 2018.

- Revenue increases rapidly throughout 2017.
- Peak revenue is reached at the end of 2017 and remains on a high level in 2018.
- The trend indicates successful scaling with short-term fluctuations.

![alt text](<charts/Montly Revenue Growth.png>)

---

### 6.2 Checkout & Payment Behavior
Checkout performance was analyzed on an order level using different payment methods.

Key findings:
- **Credit card payments** generate the highest number of orders and the highest average order value.
- Installment-based payments appear to reduce purchase friction and support higher order values.
- Alternative payment methods (boleto, voucher, debit card) show lower average order values.

This indicates that checkout design and payment options can be an effective growth lever.

---

### 6.3 Delivery Performance & Customer Experience
Delivery performance has a strong impact on customer satisfaction.

- Orders delivered **on time** have an average review score of **~4.29 / 5**.
- **Delayed deliveries** show a significantly lower average review score of **~2.57 / 5**.

This highlights logistics reliability as one of the most critical drivers of customer experience and retention.

---

### 6.4 Customer Satisfaction by Product Category
Review scores vary notably across product categories.

- Large categories such as furniture and home-related products show consistently lower review scores.
- Smaller and less complex product categories tend to receive higher customer ratings.

Category-level analysis helps identify operational bottlenecks and prioritize improvements where the impact is highest.

## 7. Business Takeaways

- **Revenue Growth:** Continuous monthly growth indicates strong market traction and scaling potential.
- **Checkout Optimization:** Credit card payments and installment options represent a key opportunity to increase average order value.
- **Logistics Impact:** Delivery delays dramatically reduce customer satisfaction and should be prioritized operationally.
- **Category Focus:** Category-level insights enable targeted quality and logistics improvements instead of generic optimizations.

## 8. Next Steps

- Build a lightweight dashboard based on the existing analysis results.
- Extend the analysis with:
  - order cancellations and returns
  - seller-level performance metrics
  - cohort-based customer behavior analysis
- Incorporate additional operational data to further improve growth and customer experience insights.
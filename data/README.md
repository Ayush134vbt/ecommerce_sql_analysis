# E-Commerce Sales & Customer Analytics Using SQL

## Project Overview

This project analyses the **Brazilian E-Commerce Public Dataset by Olist** using PostgreSQL to investigate sales performance, customer purchasing behaviour, product performance and delivery efficiency.

The dataset contains approximately 100,000 orders placed between 2016 and 2018 on a Brazilian e-commerce marketplace.

The objective is to apply SQL to real-world business questions, calculate key performance indicators (KPIs), identify trends and communicate actionable business insights.

The project forms part of my Data Analyst portfolio and demonstrates practical experience with relational databases, SQL querying, data validation and business analytics.

**Project status:** SQL analysis completed (16 business questions). Visualisations and final reporting in progress.

---

## Business Objectives

The analysis focuses on five areas:

1. **Data Exploration & Validation:** Understand the dataset, identify missing values and validate data integrity.
2. **Sales Performance:** Analyse product revenue, order volume, average order value and revenue growth.
3. **Customer Analytics:** Investigate unique customers, repeat purchasing and customer spending.
4. **Product Analytics:** Identify the highest-performing product categories by revenue and sales volume.
5. **Delivery Performance:** Evaluate delivery reliability, delays and geographic differences.

## Tools & Technologies

- **PostgreSQL 14:** Relational database management and SQL analysis.
- **Visual Studio Code:** Writing, executing and organising SQL scripts.
- **Git & GitHub:** Version control, documentation and project management.

### SQL Skills Demonstrated

- Relational database design and primary/foreign keys
- `INNER JOIN` and multi-table queries
- Aggregate functions (`SUM`, `COUNT`, `AVG`)
- Conditional aggregation using `FILTER`
- `GROUP BY` and `HAVING`
- Common Table Expressions (CTEs)
- Window functions (`LAG`, `SUM OVER`)
- Date functions (`DATE_TRUNC`, `EXTRACT`, `TO_CHAR`)
- Data validation and NULL handling
- Business KPI calculations

---

## Dataset

**Source:** [Brazilian E-Commerce Public Dataset by Olist — Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

Five datasets were imported into a local PostgreSQL database named `ecommerce_analysis`.

| Table | Records | Description |
|---|---:|---|
| customers | 99,441 | Customer identifiers and geographic information |
| orders | 99,441 | Order status, purchase dates and delivery timestamps |
| products | 32,951 | Product categories and product attributes |
| order_items | 112,650 | Items purchased, prices and freight costs |
| order_payments | 103,886 | Payment methods, instalments and payment values |

The tables are linked using primary and foreign keys.

An important distinction is that `customer_id` identifies a customer record associated with an order, while `customer_unique_id` identifies the underlying customer across multiple orders.

**Note:** Raw CSV datasets are excluded from the GitHub repository using `.gitignore`. They can be downloaded from Kaggle using the link above.

---

## Project Structure

```text
ecommerce_sql_analysis/
│
├── data/
│   └── README.md
│
├── sql/
│   ├── 01_database_setup.sql
│   ├── 02_data_exploration.sql
│   ├── 03_sales_analysis.sql
│   ├── 04_customer_analysis.sql
│   ├── 05_product_analysis.sql
│   └── 06_delivery_analysis.sql
│
├── figures/
│
├── insights/
│
├── .gitignore
└── README.md
```

Each SQL script focuses on a specific analytical area, with queries organised around business questions and accompanied by findings.

---

# Analysis & Key Findings

## 1. Data Exploration & Validation

**Business Questions 1–3**

The initial analysis investigated order statuses, missing values, duplicate records and timestamp consistency.

### Order Status Distribution

Of the 99,441 recorded orders, **97.02% have a delivered status**.

Although most orders were recorded as delivered, delivery timeliness must also be considered when evaluating operational performance.

### Missing Values

| Column | Missing values |
|---|---:|
| order_approved_at | 160 |
| order_delivered_carrier_date | 1,783 |
| order_delivered_customer_date | 2,965 |

No missing values were identified in order IDs, customer IDs, order statuses, purchase timestamps or estimated delivery dates.

Most missing delivery-related timestamps were associated with orders that had not reached the corresponding fulfilment stage.

However, several inconsistencies were identified:

- 14 delivered orders had missing approval timestamps.
- 2 delivered orders had missing carrier timestamps.
- 8 delivered orders had missing customer delivery timestamps.
- 6 cancelled orders contained customer delivery timestamps.

Additional validation confirmed that no duplicate order IDs were present and no orders had recorded customer delivery timestamps earlier than their purchase timestamps.

**Data handling decision:** The 8 delivered orders without customer delivery timestamps were excluded from delivery-duration calculations.

---

## 2. Sales Performance Analysis

**Business Questions 4–8**

This analysis investigated product revenue, average order value, monthly sales trends and the factors associated with revenue growth.

### Key Sales KPIs

| KPI | Result |
|---|---:|
| Total product revenue | R$13,221,498.11 |
| Delivered orders | 96,478 |
| Units sold | 110,197 |
| Average order value | R$137.04 |
| Average units per order | 1.14 |

*Revenue represents the sum of product item prices for delivered orders, excluding freight.*

### Monthly Revenue Trends

Revenue increased substantially during 2017, from approximately R$112,000 in January to a major spike in November.

Notable findings:

- November 2017 revenue increased approximately 52.4% compared with October.
- December 2017 revenue subsequently declined by 26.5%.
- Revenue was comparatively stable during 2018, generally ranging from approximately R$826,000 to R$977,000 per month.
- May 2018 recorded the highest reported monthly revenue during 2018, at approximately R$977,545.

The November increase is consistent with seasonal shopping activity, although the data alone does not establish its cause.

### What Drives Revenue Growth?

Revenue was analysed in relation to two components:

**Total Revenue = Number of Orders × Average Order Value**

Between January 2017 and August 2018:

- Monthly order volume increased approximately 8.5-fold.
- Monthly product revenue increased approximately 7.5-fold.
- Average order value declined by approximately 11%.

The November 2017 revenue spike was also primarily associated with increased order volume. Orders increased approximately 63%, while average order value decreased around 6%.

**Key insight:** Revenue growth was driven predominantly by higher transaction volumes rather than increased spending per order.

This suggests that understanding customer acquisition and purchasing frequency is important for explaining the observed revenue trends.

---

## 3. Customer Analytics

**Business Questions 9–12**

This section investigated the number of customers, repeat purchasing behaviour, customer revenue contributions and monthly customer activity.

### Key Customer KPIs

| KPI | Result |
|---|---:|
| Unique customers who placed orders | 96,096 |
| Repeat purchase rate | 3.12% |
| Revenue contribution of top customer | ~0.10% |
| Combined revenue contribution of top 10 customers | ~0.51% |

Customer counts and repeat purchase rates were calculated using all recorded orders, regardless of order status. Customer revenue contributions were calculated using delivered orders only.

### Repeat Purchasing

Only **3.12% of observed customers placed more than one order** during the available observation period.

This suggests that repeat purchasing was relatively uncommon, with most customers making only one recorded purchase.

However, the dataset's limited historical period prevents a complete assessment of long-term customer retention.

### Customer Revenue Concentration

The highest-spending customer contributed approximately 0.10% of total delivered-order product revenue.

The ten highest-spending customers collectively contributed approximately 0.51%.

This suggests that revenue was not heavily dependent on a small number of individual high-spending customers.

### Monthly Customer Trends

Monthly purchasing customers increased from approximately 765 in January 2017 to a peak of 7,430 in November 2017.

During much of 2018, monthly purchasing customer counts were comparatively stable at around 6,100–7,200.

This pattern is consistent with the earlier finding that revenue changes were primarily associated with changes in order volume.

**Business implication:** Customer acquisition and repeat purchasing represent important areas for further investigation. Additional analysis would be needed to identify the mechanisms responsible for customer growth.

---

## 4. Product Performance Analysis

**Business Questions 13–14**

Product performance was evaluated using revenue contribution and total units sold.

### Highest-Revenue Product Categories

| Product category | Share of product revenue |
|---|---:|
| Health & Beauty | 9.33% |
| Watches & Gifts | 8.82% |
| Bed, Table & Bath | 7.74% |

The category names above are English interpretations of the original Portuguese labels.

Health & Beauty contributed the largest share of product revenue among the categories.

### Product Revenue vs Sales Volume

The Bed, Table & Bath category sold the highest number of units:

- **10,953 units sold**
- **9.94% of total units**
- Third-highest category by revenue

In contrast, Watches & Gifts ranked second in revenue but seventh in units sold, with an estimated average product price of approximately R$199.

**Key insight:** High sales volume does not necessarily correspond to the highest revenue.

Bed, Table & Bath generated high unit volume at a comparatively lower average price, whereas Watches & Gifts generated substantial revenue from fewer, higher-priced items.

**Business implication:** Product performance should be evaluated using both revenue and unit sales, rather than relying on either metric alone.

---

## 5. Delivery Performance Analysis

**Business Questions 15–16, plus initial delivery analysis**

The delivery analysis investigated fulfilment times, delivery delays and geographic variation in operational performance.

### Key Delivery KPIs

| KPI | Result |
|---|---:|
| Delivered orders with usable delivery timestamps | 96,470 |
| Average delivery time | 12.6 days |
| Average estimated delivery time | 23.7 days |
| Late deliveries | 7,826 |
| Late delivery rate | 8.11% |
| Average delay among late orders | 9.6 days |
| Maximum recorded delay | 189 days |

Most delivered orders arrived within their estimated delivery windows.

However, the orders that arrived late were delayed by an average of 9.6 days, indicating that late deliveries could represent a meaningful customer experience concern.

### Geographic Differences in Late Deliveries

Several northeastern Brazilian states recorded particularly high late-delivery rates.

| State | Late delivery rate |
|---|---:|
| Alagoas (AL) | 23.9% |
| Maranhão (MA) | 19.7% |
| Piauí (PI) | 16.0% |
| Ceará (CE) | 15.3% |
| Sergipe (SE) | 15.2% |
| Bahia (BA) | 14.0% |
| Rio de Janeiro (RJ) | 13.5% |
| São Paulo (SP) | 5.9% |
| Minas Gerais (MG) | 5.6% |

Rio de Janeiro also recorded 1,664 late orders, demonstrating that areas with large order volumes can contribute substantially to the total number of delays.

States with relatively few observations require cautious interpretation because their estimated late-delivery rates are less stable.

### Delivery Speed vs Reliability

Average delivery times varied considerably between states.

- São Paulo (SP) recorded an average delivery time of approximately 8.8 days.
- Roraima (RR) recorded approximately 29.4 days.

However, longer average delivery times did not necessarily correspond to higher late-delivery rates.

Some remote northern states had relatively long delivery durations but low late-delivery rates, apparently benefiting from longer estimated delivery windows.

In contrast, several northeastern states had shorter estimated delivery windows relative to their delivery times and experienced higher rates of late arrival.

**Key insight:** Delivery reliability depends not only on how quickly orders arrive, but also on the accuracy and generosity of the estimated delivery windows.

These geographic differences suggest areas for operational investigation, but the analysis does not establish the causes of delivery delays.

---

# Business Recommendations

Based on the observed results, the following actions could be considered.

### 1. Investigate Customer Retention

With only 3.12% of observed customers placing repeat orders, understanding why repeat purchasing is uncommon could help identify opportunities for improved customer engagement.

Possible areas for investigation include customer satisfaction, product experience, purchasing frequency and repeat purchase patterns.

### 2. Evaluate Revenue Growth Beyond Order Volume

Revenue growth was primarily associated with increasing order volume rather than higher average order values.

Future analysis could investigate opportunities to improve order value through product recommendations, complementary products or basket composition.

### 3. Investigate Regional Delivery Performance

Northeastern states experienced relatively high late-delivery rates.

A targeted investigation of shipping routes, seller locations, carrier performance and delivery estimates could help identify contributing factors.

Rio de Janeiro may also warrant attention because of its substantial absolute number of delayed orders.

### 4. Improve Delivery Estimate Accuracy

Some states had long delivery times but relatively low late-delivery rates, while others experienced frequent delays despite shorter average delivery durations.

Reviewing how estimated delivery dates are determined could improve the reliability of delivery commitments.

### 5. Consider Both Revenue and Unit Volume in Product Decisions

Product categories differ in how they contribute to revenue and sales volume.

Inventory, pricing and product strategy should consider both metrics, alongside additional information such as margins and fulfilment costs.

*These recommendations are hypotheses for further investigation, rather than proven solutions.*

---

## Methodology & Analytical Considerations

Several principles were applied throughout the analysis:

- **Revenue definition:** Product item prices from delivered orders, excluding freight.
- **Order counting:** `COUNT(DISTINCT order_id)` was used where necessary to prevent overcounting after joining order-level and item-level tables.
- **Customer identification:** `customer_unique_id` was used to identify customers across multiple orders.
- **Missing values:** Missing timestamps were investigated by order status, and records without required delivery dates were excluded from delivery-duration metrics.
- **Time-series analysis:** The main revenue growth analysis focused on January 2017 onward to avoid the sparse 2016 data.
- **Geographic comparisons:** Delivery rates were interpreted alongside order volumes to account for differences in sample size.

## Limitations

1. **Historical data:** The dataset covers 2016–2018 and may not represent current market conditions.
2. **Incomplete observation period:** The available 2018 data does not represent a full calendar year. Sparse final months should not be interpreted as evidence of business decline.
3. **Customer retention:** Customers may have purchased before or after the available dataset period, limiting conclusions about lifetime repeat purchasing.
4. **Delivery information:** Some delivery timestamps are missing or inconsistent.
5. **Revenue definition:** The analysis focuses on product sales, not profit, and excludes freight from revenue calculations.
6. **Limited operational detail:** Carrier performance, geographic distance, fulfilment processes and other potential causes of delivery delays were not directly modelled.
7. **Causality:** Observed associations and trends do not establish causal relationships.

---

## Reproducing the Analysis

### Prerequisites

- PostgreSQL
- A PostgreSQL client such as `psql` or a VS Code database extension
- The Olist dataset from Kaggle

### Step 1 — Download the Dataset

Download the Brazilian E-Commerce Public Dataset by Olist from Kaggle.

Place the required CSV files inside the local `data/` directory.

### Step 2 — Create the Database

Connect to PostgreSQL and create a database:

```sql
CREATE DATABASE ecommerce_analysis;
```

Skip this step if the database already exists.

### Step 3 — Create the Tables

From the project root, execute the database setup script:

```bash
psql -h localhost -d ecommerce_analysis -f sql/01_database_setup.sql
```

This creates the five relational tables.

### Step 4 — Import the CSV Files

Connect to the project database using `psql` from the project root:

```bash
psql -h localhost -d ecommerce_analysis
```

Run the following commands inside `psql`, in the order shown:

```sql
\copy customers FROM 'data/olist_customers_dataset.csv' WITH (FORMAT csv, HEADER true, NULL '');
\copy orders FROM 'data/olist_orders_dataset.csv' WITH (FORMAT csv, HEADER true, NULL '');
\copy products FROM 'data/olist_products_dataset.csv' WITH (FORMAT csv, HEADER true, NULL '');
\copy order_items FROM 'data/olist_order_items_dataset.csv' WITH (FORMAT csv, HEADER true, NULL '');
\copy order_payments FROM 'data/olist_order_payments_dataset.csv' WITH (FORMAT csv, HEADER true, NULL '');
```

These commands assume the tables are empty. The relative file paths are resolved from the working directory where `psql` was launched.

### Step 5 — Execute the Analysis

Run the SQL files in the `sql/` directory:

1. `02_data_exploration.sql`
2. `03_sales_analysis.sql`
3. `04_customer_analysis.sql`
4. `05_product_analysis.sql`
5. `06_delivery_analysis.sql`

Each script contains SQL queries addressing specific business questions.

---

## Visualisations — Upcoming

The next stage of the project will present key findings visually.

Planned visualisations include:

1. **Monthly Product Revenue:** Revenue trends over time.
2. **Order Volume and Average Order Value:** Examining the components of revenue growth.
3. **Top Product Categories:** Comparing category performance by revenue.
4. **Late Delivery Rates by State:** Highlighting geographic differences in delivery reliability.

Visualisations will be stored in the `figures/` directory.

---

## Conclusion

This project demonstrates how SQL can be used to transform relational transaction data into meaningful business insights.

Across 16 business questions, the analysis identified four major findings:

- Revenue growth was primarily associated with increasing order volume.
- Repeat purchasing was relatively uncommon during the observed period.
- Product categories differed considerably in revenue contribution and unit sales.
- Delivery reliability varied significantly across geographic regions.

The project strengthened my ability to design SQL queries, work with relational databases, calculate KPIs, validate data and communicate analytical findings in a business context.

**Next steps:** Develop visualisations, finalise the business insights report and prepare the completed project for portfolio presentation.
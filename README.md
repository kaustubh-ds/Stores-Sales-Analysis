# Stores Sales Analysis (SQL)

## Project Overview

This project analyzes retail sales data using SQL, focusing on product sales performance, profitability, and discount patterns. The analysis is based on the [Stores Sales Forecasting Dataset](https://www.kaggle.com/datasets/tanayatipre/store-sales-forecasting-dataset), with the goal of uncovering products that consistently underperform, identifying the financial impact of discounting, and tracking profit trends over time. The insights aim to support more effective pricing, discount optimization, and product strategy decisions. The dataset contains transactional records from 2014 to 2017.

## Tools 

- **Python:** Data Cleaning and Encoding resolution
- **SQL (PostgreSQL):** Data Cleaning, Transformation and SQL Analysis
- **Power BI:** Data Reporting.

## Data Cleaning

1. Python was used to standardize inconsistent date formats in `Order Date` and `Ship Date` columns (e.g., 2/12/2016 to 02-12-2016), convert to YYYY-MM-DD format, and resolve encoding issues by converting the dataset to UTF-8 format, fixing a `UnicodeDecodeError` encountered during CSV import in PostgreSQL database. [Pre-SQL Cleaned Dataset]()
2. SQL was used to remove leading and trailing whitespace from all text columns using the TRIM() function, and to identify and remove duplicate rows. Dataset did not contain any `NULL` or missing values.

There were 2120 total rows in the table after data cleaning.

## Exploratory Data Analysis

EDA involved exploring the sales data to answer key questions, such as:

- Which 10 products generated the highest profit?
- How do the discounts affect profit?
- How has profit changed year over year?

## Overview of Results 
The analysis covers approximately $741K in total revenue and over 18K in total profit from sales transactions between 2014 and 2017. Profitability across products is highly uneven; while a few high-performing chairs and lighting products drive substantial margins, many large-ticket furniture items repeatedly generate losses. Discounts play a significant role in shaping outcomes, with high-discount ranges showing sharply negative profit margins. Despite the Consumer segment accounting for the largest revenue share, the Corporate and Home Office segments proved more profitable overall. Time-based trends reveal strong year-end profits but high volatility across months.

## Key Insights

### Product Profitability Patterns:
Several office chairs (e.g., `Hon Deluxe Fabric Upholstered Stacking Chairs`) led in total profit, earning margins above 17%. In contrast, conference tables, bookcases, and similar large furniture items were often associated with significant losses. Many of these products not only appeared among the lowest in profit but also showed high sales volumes with consistently poor margins, revealing potential mispricing or over-discounting issues.

<img width="800" alt="Top 10 Most Profitable Products" src="https://github.com/user-attachments/assets/a9a68009-c04e-404a-9932-dd4c3870dba5" />
<img width="800" alt="Top 10 Least Profitable Products" src="https://github.com/user-attachments/assets/137b82da-b972-418e-b174-dfccd9a035e3" />


### Discount Patterns:
Discounts were frequent, with an average of 17.39%, and a maximum discount of 70%. A correlation coefficient of -0.48 suggests that higher discounts strongly reduce profits. Discount brackets above 30% were linked to heavily negative profit margins, most notably the 61–70% range, which averaged -166% margin.

<img width="800" alt="Average Profit Margin by Discount" src="https://github.com/user-attachments/assets/eb34525b-c982-422c-abd8-439c452afbb7" />

### Customer Segments:
While the Consumer segment contributed the most revenue, the Corporate and Home Office segments achieved higher profit margins, at 3.31% and 3.20% respectively.
The Home Office segment also had the highest average margin and the lowest average discount, implying more efficient pricing in that group.

<img width="800" alt="Total Revenue and Profit of each Customer Segment" src="https://github.com/user-attachments/assets/dcc15dae-5ffb-4631-8a5d-fc4c5ba7e46a" />

### Time-Based Insights:
Year-over-year trends show strong growth in 2016 (the most profitable year), followed by a sharp drop in 2017. Month-wise, December was the most profitable, while October and January were net loss months. A cumulative profit trend shows that while 2016 had a stable profit curve, 2017 and 2015 lagged significantly.

<img width="800" alt="Total Profit by Year" src="https://github.com/user-attachments/assets/933b91c6-81c3-4bff-9183-b1e6b3fa9dcc" />

## Recommendations
- **Discontinue or Reevaluate Unprofitable Products:** 20+ products showed a consistently negative profit across all orders, including conference tables and specific bookcases. These items contributed losses of over $100 each. It is recommended to discontinue these products or renegotiate supplier costs for such SKUs.
- **Cap Discounts Above 30 Percent:** Orders with discounts above 30% averaged profit margins below -30%, with the 61–70% discount range yielding -166% margin. Implementing a strict discount ceiling of 25–30% could help preserve profit margins and reduce avoidable losses.
- **Promote High-Margin Chair Products:** Office chairs such as `Hon Pagoda Stacking Chairs and Global Deluxe High-Back Manager’s Chair` showed profit margins above 17%, with relatively high sales volumes. Focused marketing and bundling of these products could increase overall profit contribution by 10–15%.
- **Target Corporate and Home Office Segments:** Although the Consumer segment contributes the most revenue, Corporate and Home Office customers offer up to 70% higher margins. Allocating sales resources and offers toward these segments could boost average profitability per transaction.

## Limitations and Assumptions
- Profit is assumed to represent net gain per order without accounting for logistics or operational overhead.
- Discounts are treated as consistent and intentional across transactions.
- The analysis spans only 2014–2017; trends beyond this period are not considered.
- Product names contain inconsistencies (e.g., special characters like Ò, Ó), which were not cleaned or standardized.

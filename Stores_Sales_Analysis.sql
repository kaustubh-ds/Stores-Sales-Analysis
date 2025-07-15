-- Project Title: Stores Sales Analysis
-- Dataset Title: Stores Sales Forecasting Dataset
-- Data Source: https://www.kaggle.com/datasets/tanayatipre/store-sales-forecasting-dataset
-- Purpose: To analyze product sales, profit and discount
-- Author: Kaustubh Salunkhe
-- Date: July 2025

SELECT * FROM Stock_Sales LIMIT 100;

-- Data Cleaning and Tranformation
UPDATE Stock_Sales
SET
	"Order ID" = TRIM("Order ID"), 
	"Ship Mode" = TRIM("Ship Mode"), 
	"Customer ID" = TRIM("Customer ID"), 
	"Customer Name" = TRIM("Customer Name"), 
	Segment = TRIM(Segment), 
	Country = TRIM(Country), 
	City = TRIM(City), 
	"State" = TRIM("State"), 
	Region = TRIM(Region),
	"Product ID" = TRIM("Product ID"), 
	Category = TRIM(Category), 
	"Sub-Category" = TRIM("Sub-Category"), 
	"Product Name" = TRIM("Product Name"); -- Removing unnecessary whitespaces

DELETE FROM Stock_Sales
WHERE
	"Row ID" IS NULL OR
	"Order ID" IS NULL OR
	"Order Date" IS NULL OR
	"Ship Date" IS NULL OR
	"Ship Mode" IS NULL OR
	"Customer ID" IS NULL OR
	"Customer Name" IS NULL OR
	Segment IS NULL OR
	Country IS NULL OR
	City IS NULL OR
	"State" IS NULL OR
	"Postal Code" IS NULL OR
	Region IS NULL OR
	"Product ID" IS NULL OR
	Category IS NULL OR
	"Sub-Category" IS NULL OR
	"Product Name" IS NULL OR
	Sales IS NULL OR
	Quantity IS NULL OR
	Discount IS NULL OR
	Profit IS NULL; -- Deleting NULL values

SELECT 
	"Order ID", "Order Date", "Ship Date", "Ship Mode", 
	"Customer ID", "Customer Name", Segment, 
	Country, City, "State", "Postal Code", Region, 
	"Product ID", Category, "Sub-Category", "Product Name", 
	Sales, Quantity, Discount, Profit, COUNT(*) AS count
FROM Stock_Sales
GROUP BY 
	"Order ID", "Order Date", "Ship Date", "Ship Mode", 
	"Customer ID", "Customer Name", Segment, 
	Country, City, "State", "Postal Code", Region, 
	"Product ID", Category, "Sub-Category", "Product Name", 
	Sales, Quantity, Discount, Profit
HAVING COUNT(*) > 1; -- Identifying duplicate values

DELETE FROM Stock_Sales
WHERE "Row ID" NOT IN (
    SELECT MIN("Row ID")
    FROM Stock_Sales
    GROUP BY 
		"Order ID", "Order Date", "Ship Date", "Ship Mode", 
		"Customer ID", "Customer Name", Segment, 
		Country, City, "State", "Postal Code", Region, 
		"Product ID", Category, "Sub-Category", "Product Name", 
		Sales, Quantity, Discount, Profit
); -- Deleting duplicate values


-- Q1. What are the total revenue, total profit, and overall profit margin of the business?
SELECT 
	ROUND(SUM(Sales)::NUMERIC, 2) AS "Total Revenue", 
	ROUND(SUM(Profit)::NUMERIC, 2) AS "Total Profit",
	ROUND((SUM(Profit) / SUM(Sales) * 100)::NUMERIC, 2) AS "Profit Margin (%)"
FROM Stock_Sales;

-- Q2. Which 10 products generated the highest total profit?
SELECT 
	"Product Name",
	ROUND(SUM(Profit)::NUMERIC, 2) AS "Total Profit",
	ROUND((SUM(Profit) / SUM(Sales) * 100)::NUMERIC, 2) AS "Profit Margin (%)",
	ROUND(SUM(Sales)::NUMERIC, 2) AS "Total Revenue"
FROM Stock_Sales
GROUP BY "Product Name"
ORDER BY "Total Profit" DESC
LIMIT 10;

-- Q3. Which 10 products generated the lowest total profit?
SELECT 
	"Product Name",
	ROUND(SUM(Profit)::NUMERIC, 2) AS "Total Profit",
	ROUND((SUM(Profit) / SUM(Sales) * 100)::NUMERIC, 2) AS "Profit Margin (%)",
	ROUND(SUM(Sales)::NUMERIC, 2) AS "Total Revenue"
FROM Stock_Sales
GROUP BY "Product Name"
ORDER BY "Total Profit"
LIMIT 10;

-- Q4. Are there products with high sales volume but low profit margins?
WITH product_margins AS (
    SELECT 
        "Product Name",
        SUM(Sales) AS "Total Sales",
        (SUM(Profit) / NULLIF(SUM(Sales), 0)) * 100 AS "Profit Margin"
    FROM Stock_Sales
    GROUP BY "Product Name"
), -- Calculating total sales and profit margins for each product
averages AS (
    SELECT 
        AVG("Total Sales") AS avg_sales,
        AVG("Profit Margin") AS avg_margin
    FROM product_margins
) -- Calculating average sales and profit margins for each product
SELECT 
    pm."Product Name",
    ROUND(pm."Total Sales"::NUMERIC, 2) AS "Total Sales",
    ROUND(pm."Profit Margin"::NUMERIC, 2) AS "Profit Margin"
FROM product_margins pm
CROSS JOIN averages a
WHERE 
    pm."Total Sales" > a.avg_sales
    AND pm."Profit Margin" < a.avg_margin
ORDER BY pm."Profit Margin"; -- Products with above average sales yet below average profit margin

-- Q5. Which products only generated loss?
SELECT 
	"Product Name",
	COUNT(*) AS "Total Orders",
	SUM(CASE WHEN Profit < 0 THEN 1 ELSE 0 END) AS "Total Orders in Loss", -- Total negative value count
	ROUND(SUM(Profit)::NUMERIC, 2) AS "Total Profit"
FROM Stock_Sales
GROUP BY "Product Name"
HAVING COUNT(*) = SUM(CASE WHEN Profit < 0 THEN 1 ELSE 0 END) -- Total orders = Orders in loss
ORDER BY "Total Orders in Loss" DESC;

-- Q6. What is the average discount?
SELECT ROUND(AVG(Discount * 100)::NUMERIC, 2) AS "Average Discount (%)"
FROM Stock_Sales;

-- Q7. How do the discounts affect profit?
SELECT ROUND(CORR(Discount, Profit)::NUMERIC, 2) AS "Discount-Profit Correlation"
FROM Stock_Sales;

-- Q8. What is the highest discount?
SELECT (Discount * 100) AS "Highest Discount (%)"
FROM Stock_Sales
ORDER BY Discount DESC
LIMIT 1;

-- Q9. Which discount ranges are associated with the sharpest drop in margin?
SELECT 
	CASE
		WHEN Discount > 0 AND Discount <= 0.10 THEN '1% - 10%'
		WHEN Discount > 0.10 AND Discount <= 0.20 THEN '11% - 20%'
		WHEN Discount > 0.20 AND Discount <= 0.30 THEN '21% - 30%'
		WHEN Discount > 0.30 AND Discount <= 0.40 THEN '31% - 40%'
		WHEN Discount > 0.40 AND Discount <= 0.50 THEN '41% - 50%'
		WHEN Discount > 0.50 AND Discount <= 0.60 THEN '51% - 60%'
		WHEN Discount > 0.60 AND Discount <= 0.70 THEN '61% - 70%' -- 70% is the highest discount
		WHEN Discount = 0 THEN 'No Discount'
		ELSE 'NULL'
	END AS "Discount Range",
	ROUND ((SUM(Profit) / NULLIF(SUM(Sales), 0) * 100)::NUMERIC, 2) AS "Average Profit Margin (%)",
	COUNT(*) AS "Total Orders"
FROM Stock_Sales
GROUP BY "Discount Range"
ORDER BY "Average Profit Margin (%)";

-- Q10. Which products were always sold with a discount?
SELECT 
	"Product Name",
	COUNT(*) AS "Total Orders",
	SUM(CASE WHEN Discount > 0 THEN 1 ELSE 0 END) AS "Discounted Orders"
FROM Stock_Sales
GROUP BY "Product Name"
HAVING COUNT(*) = SUM(CASE WHEN Discount > 0 THEN 1 ELSE 0 END) -- Total orders = Discounted orders
ORDER BY "Discounted Orders" DESC;

-- Q11. What is the total profit of each customer segment?
SELECT 
	Segment AS "Segment", 
	ROUND(SUM(Profit)::NUMERIC, 2) AS "Total Profit",
	ROUND((SUM(Profit) / SUM(Sales) * 100)::NUMERIC, 2) AS "Profit Margin (%)",
	ROUND(SUM(Sales)::NUMERIC, 2) AS "Total Revenue"
FROM Stock_Sales
GROUP BY Segment
ORDER BY "Total Profit" DESC;

-- Q12. What is the average profit margin and discount per each customer segment?
SELECT 
	Segment AS "Segment", 
	ROUND((AVG(Profit / NULLIF(Sales, 0)) * 100)::NUMERIC, 2) AS "Profit Margin (%)",
	ROUND(AVG(Discount * 100)::NUMERIC, 2) AS "Average Discount (%)"
FROM Stock_Sales
GROUP BY Segment
ORDER BY "Profit Margin (%)" DESC;

-- Q13. How has profit changed year over year?
SELECT 
	DATE_PART('year', "Order Date") AS "Year",
	ROUND(SUM(Profit)::NUMERIC, 2) AS "Total Profit",
	ROUND((SUM(Profit) / SUM(Sales) * 100)::NUMERIC, 2) AS "Profit Margin (%)"
FROM Stock_Sales
GROUP BY DATE_PART('year', "Order Date")
ORDER BY "Year";

-- Q14. What is the year-end cumulative profit for each year?
WITH running_profit AS (
	SELECT
		DATE_PART('year', "Order Date") AS "Year",
		SUM(Profit) OVER (
			PARTITION BY DATE_PART('year', "Order Date") 
			ORDER BY "Order Date"
		) AS "Total Running Profit"
	FROM Stock_Sales
)
SELECT 
	"Year",
	ROUND(MAX("Total Running Profit")::NUMERIC, 2) AS "Year-End Running Profit"
FROM running_profit
GROUP BY "Year"
ORDER BY "Year";

-- Q15. How is profitability distributed across months?
SELECT 
	TRIM(TO_CHAR("Order Date", 'Month')) AS "Month",
	ROUND(SUM(Profit)::NUMERIC, 2) AS "Total Profit",
	ROUND((SUM(Profit) / SUM(Sales) * 100)::NUMERIC, 2) AS "Profit Margin (%)"
FROM Stock_Sales
GROUP BY TO_CHAR("Order Date", 'Month')
ORDER BY MIN(DATE_PART('Month', "Order Date"));
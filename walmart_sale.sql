--I. Overview data
SELECT * from [WalmartSalesData.csv]
-- 1. Add the time_of_day column
ALTER TABLE [dbo].[WalmartSalesData.csv]
ADD time_of_day VARCHAR(20);
UPDATE [dbo].[WalmartSalesData.csv]
SET time_of_day = CASE
    WHEN CAST(time AS TIME) BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
    WHEN CAST(time AS TIME) BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
    ELSE 'Evening'
END;

-- 2. Add day_name column

ALTER TABLE [WalmartSalesData.csv] ADD day_name VARCHAR(20);

-- Update the day_name column with DAYNAME
UPDATE [WalmartSalesData.csv]
SET day_name = DATENAME(weekday, [date]);

-- 3. Add month_name column

ALTER TABLE [WalmartSalesData.csv] ADD month_name VARCHAR(10);

-- 4. Update the day_name column with DAYNAME
UPDATE [WalmartSalesData.csv]
SET month_name = DATENAME(MONTH, [date]);


-----------------ABOUT GENERAL----------------
-- 1. How many unique cities does the data have?
SELECT distinct city 
from [dbo].[WalmartSalesData.csv]
-- 2. Each branch in city?
SELECT distinct city, branch
from [dbo].[WalmartSalesData.csv]
-- 3. How many unique product lines does the data have?
select distinct product_line 
from [dbo].[WalmartSalesData.csv]
-- 4. The most selling product line?
SELECT
	SUM(quantity) as qty,
    product_line
FROM [dbo].[WalmartSalesData.csv]
GROUP BY product_line
ORDER BY qty DESC;
-- 5. Total revenue by month?
SELECT month_name, sum(total) as total_rev
from [dbo].[WalmartSalesData.csv]
group by month_name
order by total_rev
-- 6. Month had the largest COGS?
SELECT
	month_name AS month,
	SUM(cogs) AS cogs
FROM [dbo].[WalmartSalesData.csv]
GROUP BY month_name 
ORDER BY cogs;

-- 7. Product line had the largest rev?
SELECT
	product_line,
	sum(total) as total_rev
FROM [dbo].[WalmartSalesData.csv]
GROUP BY product_line
ORDER BY total_rev DESC;

-- 8. The city with the largest rev?
SELECT
	branch,
	city,
	SUM(total) AS total_rev
FROM [dbo].[WalmartSalesData.csv]
GROUP BY city, branch 
ORDER BY total_rev;

-- 9. The product line had the largest VAT?
SELECT
	product_line,
	ROUND(AVG(Tax_5), 2) as avg_tax
FROM [dbo].[WalmartSalesData.csv]
GROUP BY product_line
ORDER BY avg_tax DESC;

-- 10. how good or bad than avg_qnty?
SELECT
	AVG(quantity) AS avg_qnty
FROM [dbo].[WalmartSalesData.csv]
SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN 'Good'
        ELSE 'Bad'
    END AS remark
FROM [dbo].[WalmartSalesData.csv]
GROUP BY product_line;

-- 11. The branch sold more products than avg product sold?
SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM [dbo].[WalmartSalesData.csv]
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM [dbo].[WalmartSalesData.csv])

-- 12. the most common product line by gender?
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM [dbo].[WalmartSalesData.csv]
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- 13. The average rating of each product line?
SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    product_line
FROM [dbo].[WalmartSalesData.csv]
GROUP BY product_line
ORDER BY avg_rating DESC;

-------------------ABOUT CUSTOMERS----------------------
-- 1. Unique customer types?
SELECT
	COUNT(DISTINCT customer_type) AS unique_customer_types
FROM [dbo].[WalmartSalesData.csv]

-- 2. Unique payment methods?
SELECT
	COUNT(DISTINCT payment) AS unique_payment_methods
FROM [dbo].[WalmartSalesData.csv]

-- 3. the most common customer type?
SELECT TOP 1
	customer_type,
	COUNT(*) AS count
FROM [dbo].[WalmartSalesData.csv]
GROUP BY customer_type
ORDER BY count DESC;
-- 4. customer type buys the most?
SELECT TOP 1
	customer_type,
	COUNT(*) AS total_sales
FROM [dbo].[WalmartSalesData.csv]
GROUP BY customer_type
ORDER BY total_sales DESC;

-- 5. the gender of most of the customers?
SELECT TOP 1
	gender,
	COUNT(*) AS gender_count
FROM [dbo].[WalmartSalesData.csv]
GROUP BY gender
ORDER BY gender_count DESC;

-- 6. the gender distribution per branch?
SELECT
	branch,
	gender,
	COUNT(*) AS gender_count
FROM [dbo].[WalmartSalesData.csv]
GROUP BY branch, gender
ORDER BY branch, gender_count DESC;


-- 7. time of the day do customers give most ratings?
SELECT TOP 1
	time_of_day,
ROUND(AVG(rating), 2) AS avg_rating
FROM [dbo].[WalmartSalesData.csv]
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- 8. time of the day do customers give most ratings per branch?
SELECT TOP 1
	branch,
	time_of_day,
ROUND(AVG(rating), 2) AS avg_rating
FROM [dbo].[WalmartSalesData.csv]
GROUP BY branch, time_of_day
ORDER BY branch, avg_rating DESC;

-- 9.  day of the week has the best average ratings?
SELECT TOP 1
	day_name,
ROUND(AVG(rating), 2) AS avg_rating
FROM [dbo].[WalmartSalesData.csv]
GROUP BY day_name
ORDER BY avg_rating DESC;

-- 10. Number of sales made in each time of the day per weekday? 
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM [dbo].[WalmartSalesData.csv]
WHERE day_name = 'Sunday'
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- 11. city has the largest tax/VAT percent?
SELECT TOP 1
	city,
	ROUND(AVG(Tax_5), 2) AS avg_tax_pct
FROM [dbo].[WalmartSalesData.csv]
GROUP BY city
ORDER BY avg_tax_pct DESC;

-- 12. customer type pays the most in VAT?
 SELECT TOP 1
	customer_type,
	round(AVG(Tax_5), 2) AS total_tax
FROM [dbo].[WalmartSalesData.csv]
GROUP BY customer_type
ORDER BY total_tax DESC;
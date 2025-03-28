-- created database
CREATE DATABASE sales_db;
USE sales_db;
-- Created tables 
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(100),
    quantity INT,
    price_per_unit DECIMAL(10,2),
    cogs DECIMAL(10,2),
    total_sale DECIMAL(10,2)
);

-- After loading CSV file changed table name
RENAME TABLE sales_db.transactions TO sales_db.sales_table;

-- Checked for null values
SELECT * 
FROM sales_table 
WHERE transaction_id IS NULL 
   OR sale_date IS NULL 
   OR sale_time IS NULL 
   OR customer_id IS NULL 
   OR gender IS NULL 
   OR age IS NULL 
   OR category IS NULL 
   OR quantity IS NULL 
   OR price_per_unit IS NULL 
   OR cogs IS NULL 
   OR total_sale IS NULL;

-- Data Exploration
USE SALES_DB;
-- How many sales we have?

Select count(*) as total_sale from sales_table;

-- How many unique customers we have?
select count(distinct customer_id) from sales_table;

-- How many unique category we have?
select count(distinct category) from sales_table;


-- Business key Problems
/*
1) Write a SQL query to retrieve all columns for sales made on '2022-11-05:
2) Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
3) Write a SQL query to calculate the total sales (total_sale) for each category.
4) Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
5) Write a SQL query to find all transactions where the total_sale is greater than 1000.
6) Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
7) Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
8) Write a SQL query to find the top 5 customers based on the highest total sales.
9) Write a SQL query to find the number of unique customers who purchased items from each category.
10) Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
*/
-- 1)  Write a SQL query to retrieve all columns for sales made on '2022-11-05?

Select *
From sales_table
Where sale_date = '2022-11-07';

-- 2) Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is > = to 4 in the month of Nov-2022:

SELECT *  
FROM sales_table  
WHERE category = 'Clothing'  
AND quantity >= 4  
AND MONTH(sale_date) = 11  
AND YEAR(sale_date) = 2022;

-- 3) Write a SQL query to calculate the total sales (total_sale) for each category.

Select category, SUM(TOTAL_SALE) as Net_sales
From sales_table
Group by category;

-- 4) Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

Select category, avg(age) as Avg_age
From sales_table
where category = 'Beauty';


-- 5)Write a SQL query to find all transactions where the total_sale is greater than 1000.

Select * from sales_table
Where total_sale > 1000;

-- 6)  Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

Select 
  gender, 
  category, 
  count(transaction_id) as total_transactions
  From sales_table
Group by 
  gender, category
Order by category DESC; 

-- 7) Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

SELECT 
    year,
    month,
    avg_sale
FROM (    
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        SUM(total_sale) AS total_sales,
        DENSE_RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY SUM(total_sale) DESC) AS ranking
    FROM sales_table
    GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
) AS t1
WHERE ranking = 1;

-- 8) Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT customer_id, SUM(total_sale) AS total_sales  
FROM Sales_table  
GROUP BY customer_id  
ORDER BY total_sales DESC  
LIMIT 5;

-- 9) Write a SQL query to find the number of unique customers who purchased items from each category.

Select 
    count(distinct customer_id) as Unique_customers_purchase, category
From 
   sales_table
 Group by category; 

 -- 10)  Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

SELECT 
    CASE 
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift, 
    COUNT(customer_id) AS num_orders
FROM sales_table
GROUP BY shift;



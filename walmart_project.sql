USE walmart_db;

SELECT * FROM walmart_sales;
SELECT COUNT(*) FROM walmart_sales;

select payment_method, count(*) from walmart_sales 
group by payment_method;

select count(distinct branch) from walmart_sales;


select min(quantity) from walmart_sales;

-- problem 1 : Find different payment methods, number of transactions, and quantity sold by payment method


select 
     payment_method,
     count(*) as no_payments,
     sum(quantity) as no_qty_sold
     
from walmart_sales
group by payment_method;


-- problem 2: Identify the highest-rated category in each branch
-- Display the branch, category, and avg rating

SELECT branch, category, avg_rating
FROM (
    SELECT 
        branch,
        category,
        AVG(rating) AS avg_rating,
        RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC )as rnk_no
    FROM walmart_sales
    GROUP BY branch, category 
)  as ranked
where rnk_no = 1;


-- problem 3 Identify the busiest day for each branch based on the number of transactions

SELECT branch, day_name, no_transactions
FROM (
    SELECT 
        branch,
        DAYNAME(STR_TO_DATE(date, '%d/%m/%Y')) AS day_name,
        COUNT(*) AS no_transactions,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank_no
    FROM walmart_sales
    GROUP BY branch, day_name
) AS ranked
WHERE rank_no = 1;


-- probelm 4 
-- Calculate the total quantity of items sold per payment method

select 
     payment_method,
     sum(quantity) as no_qty_sold
     
from walmart_sales
group by payment_method;

-- problem 5
-- : Determine the average, minimum, and maximum rating of categories for each city

select 
    city,
    category,
	round(min(rating),2) as min_rating,
    round(max(rating),2) as max_rating,
   round(avg(rating),2) as avg_rating
from walmart_sales
group by city, category;

-- problem 6 : Calculate the total profit for each category

select 
    category,
    round(sum(total),2)as total_revenue,
    round(sum(total * profit_margin),2) as profit
from walmart_sales
group by category;

-- problem 7 : Determine the most common payment method for each branch

WITH cte AS (
    SELECT 
        branch,
        payment_method,
        COUNT(*) AS total_trans,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank_no
    FROM walmart_sales
    GROUP BY branch, payment_method
)
SELECT *
FROM cte
WHERE rank_no = 1;

-- problem 8: Categorize sales into Morning, Afternoon, and Evening shifts

SELECT
    branch,
    CASE 
        WHEN HOUR(TIME(time)) < 12 THEN 'Morning'
        WHEN HOUR(TIME(time)) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS num_invoices
FROM walmart_sales
GROUP BY branch, shift
ORDER BY branch, num_invoices DESC;



     




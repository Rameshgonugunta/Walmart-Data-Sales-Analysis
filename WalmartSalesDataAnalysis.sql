create database walmarts;
-- creating a table-----

CREATE TABLE IF NOT EXISTS salesw(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT NOT NULL ,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT NOT NULL,
    gross_income DECIMAL(12, 4) NOT NULL,
    rating FLOAT NOT NULL
);

alter table salesw change tax_pct VAT float;
select * from salesw;

-- ADD COLUMN  time of the day --

SELECT
	time,
	(CASE
		WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_the_day
FROM salesw;

ALTER TABLE salesw add column time_of_the_day varchar(20);

update salesw
set time_of_the_day = (CASE
		WHEN time BETWEEN "00:00:00" AND "11:59:59" THEN "Morning"
        WHEN time BETWEEN "12:01:00" AND "15:59:59" THEN "Afternoon"
        ELSE "Evening"
    END);
    
    -- adding column  DAY NAME---
    ALTER TABLE salesw ADD COLUMN day_name VARCHAR(10);
   
   update salesw
   set day_name = dayname(date);
   
 -- adding month name -- 
 alter table salesw add column month_name varchar(10);
 
 update salesw
 set month_name = monthname(date);
 -- ----------------------------------------------
 -- generic -----
 -- 1. How many unique cities does the data have?
 SELECT DISTINCT city FROM salesw;
 
 -- 2.In which city is each branch in an alphabetic order ?
 SELECT DISTINCT CITY, BRANCH FROM salesw ORDER BY CITY;
 
 -- PRODUCT --------
-- 1.How many unique product lines does the data have?
SELECT  count(DISTINCT product_line) FROM salesw;

-- 2.What is the most common payment method?
SELECT payment, count(payment) as cnt FROM salesw
GROUP BY payment
ORDER BY cnt desc
limit 1;

-- 3.What is the most selling product line?
SELECT product_line, count(product_line) as cnt FROM salesw
GROUP BY product_line
ORDER BY cnt desc
limit 1;

-- 4.What is the total revenue by month?
SELECT month_name AS MONTH,sum(total) as total_revenue from salesw
group by month 
order by total_revenue desc;

-- 5.What month had the largest COGS?
SELECT month_name AS MONTH,sum(cogs) as cogs from salesw
group by month 
order by cogs desc;



-- 6.What product line had the largest revenue?
SELECT product_line,sum(total) as total_revenue from salesw
group by product_line 
order by total_revenue desc;

-- 7. What is the city with the largest revenue?
SELECT city,sum(total) as total_revenue from salesw
group by city 
order by total_revenue desc;

-- 8. What product line had the largest VAT?
SELECT 
    product_line, AVG(VAT) AS tax_pct
FROM
    salesw
GROUP BY product_line
ORDER BY tax_pct DESC;


-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT product_line, 
(case
when sum(total) > (select avg(total) from salesw) then "GOOD"
else "BAD"
END) AS QUALITY FROM salesw
GROUP BY product_line;


-- 10. Which branch sold more products than average product sold?
SELECT branch, sum(quantity) as qty from salesw
group by branch
having sum(quantity)>(select avg(quantity) from salesw);

-- 11.What is the most common product line by gender?
SELECT product_line, gender,COUNT(GENDER) AS CNT
FROM salesw
GROUP BY PRODUCT_LINE,GENDER
ORDER BY CNT DESC;

-- 12.What is the average rating of each product line?
SELECT product_line, round(avg(rating),2) as avg_rating from salesw
group by product_line
order by avg_rating desc
;   

 -- SALES ------------------------------------------------ 
 -- --------------------------------------------------------
-- 1.Number of sales made in each time of the day per weekday
SELECT time_of_the_day, count(*) as total_sales from salesw
WHERE day_name= "Wednesday"
GROUP BY time_of_the_day
ORDER BY total_sales desc;

-- 2.Which of the customer types brings the most revenue?
SELECT customer_type, round(sum(total),2) as revenue from salesw
GROUP BY customer_type
order by revenue desc;

-- 3.Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT city, ROUND(AVG(VAT),2)AS tax_pct FROM salesw
GROUP BY city
ORDER BY tax_pct DESC;

-- 4. Which customer type pays the most in VAT?
SELECT customer_type, ROUND(AVG(VAT),2)AS tax_pct FROM salesw
GROUP BY customer_type
ORDER BY tax_pct DESC;


--  CUSTOMER---------------------------
-- ---------------------------------------
-- 1. How many unique customer types does the data have?
SELECT COUNT(DISTINCT customer_type) FROM salesw;

-- 2.How many unique payment methods does the data have?
SELECT COUNT(DISTINCT payment) FROM salesw;

-- 3.What is the most common customer type?

SELECT customer_type, count(customer_type) as cnt
FROM salesw
group by customer_type
order by cnt DESC;

-- 4.Which customer type buys the most?
SELECT customer_type, SUM(total) as cnt
FROM salesw
group by customer_type
order by cnt DESC; 

-- 5. What is the gender of most of the customers?
SELECT gender, count(GENDER) AS gender_cnt
FROM salesw
GROUP BY gender
ORDER BY gender_cnt DESC;

-- 6.What is the gender distribution per branch?
SELECT  branch,gender, count(GENDER) AS gender_cnt
FROM salesw
group by branch, gender
ORDER BY BRANCH, gender_cnt desc ;

-- 7.Which time of the day do customers give most ratings?

SELECT time_of_the_day, round(avg(rating),2) AS r_cnt
from salesw
group by time_of_the_day
order by r_cnt desc;
-- 8. Which time of the day do customers give most ratings per branch?

SELECT branch, time_of_the_day, round(avg(rating),2) AS r_cnt
from salesw
group by branch, time_of_the_day
order by branch, r_cnt DESC;

-- 9.Which day of the week has the best avg ratings?

SELECT day_name, round(avg(rating),2) AS r_cnt
from salesw
group by day_name
order by r_cnt desc;

-- 10.Which day of the week has the best average ratings per branch?
SELECT branch, day_name, round(avg(rating),2) AS r_cnt
from salesw
group by branch, day_name
order by branch, r_cnt DESC;






 
 
  
   
   
  
    





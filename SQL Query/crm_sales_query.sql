create database crm_Sales;
use crm_sales;

select* from accounts;
select* from data_dictionary;
select * from products;
select* from sales_teams;
select * from sales_pipeline;

#1. How is each sales team performing compared to the rest?
select
sales_agent,count(*) as total_deals,
SUM(close_value) as total_revenue,
SUM(CASE WHEN deal_stage ='Won' then 1 else 0 END) as won_deals,
ROUND(SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
) AS win_rate
from sales_pipeline
group by sales_agent
order by total_revenue DESC;

#2. Are any sales agents lagging behind?
SELECT * FROM (
    SELECT sales_agent,
	SUM(close_value) AS revenue,
        ROUND(SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
            2
        ) AS win_rate
    FROM sales_pipeline
    GROUP BY sales_agent
) t
WHERE win_rate < 50 OR revenue < 2000;


#3. Quarter-over-quarter trends
select 
       year(close_date) as year,
	   quarter(close_date) as quarter,
       sum(close_value) as revenue,
	   count(*) as total_deals
from sales_pipeline
where deal_stage = 'Won'
group by Year(close_date),quarter(close_date)
order by year ,quarter;

#4.Do any products have better win rates?alter
SELECT product, 
count(*) as total_deals,
    sum(CASE WHEN deal_stage = 'Won' THEN 1 else 0 END) as wins,
    round(sum(CASE WHEN deal_stage = 'Won' THEN 1 else 0 END) *100.0 /count(*),
    2 )
    as win_rate
    From sales_pipeline
    group by product
    order by win_rate DESC;
    
    

use superstore_db;
/* Sales and Profit */

select 
    sub_category,
    category,
    sum(sales) as total_sales,
    sum(profit) as total_profit,
    avg(discount) as avg_discount,
    count(distinct order_id) as num_orders
 from orders
 group by sub_category, category
 order by total_sales desc;

/* order quantity trends */

select year(order_date) as year, month(order_date) as month,  sum(quantity) as total_quantity
from orders
group by year, month
order by year, month;








/* trend analysis */

select year(order_date) as year, month(order_date)as month, sum(sales) as total_sales, sum(profit) as total_profit
from orders
group by year, month
order by year, month;


/* Category - trend analysis */

select category, sub_category, region, sum(sales) as total_sales, sum(profit) as total_profit
from orders
group by region, category, sub_category
order by total_profit desc;






/* profitable and discount analysis */
SELECT category, AVG(discount) AS avg_discount, SUM(profit) AS total_profit
FROM orders
GROUP BY category
ORDER BY total_profit DESC;


/* Customer Behavior */
SELECT customer_id, COUNT(DISTINCT order_id) AS num_orders, SUM(sales) AS total_sales
FROM orders
GROUP BY customer_id
ORDER BY total_sales DESC
limit 20;



/*Profit margin analysis */

select category, sum(profit)/sum(sales) * 100 as ProfitMarginPercentage
from orders
group by category
order by ProfitMarginPercentage desc;







/* Profit margin by sub-category*/

select 
   sub_category,
   sum(sales) as total_sales,
   sum(profit) as total_profits,
   (sum(profit)/sum(sales))*100 as profit_margin
from orders
group by sub_category
order by profit_margin desc;

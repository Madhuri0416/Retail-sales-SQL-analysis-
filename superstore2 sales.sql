
use superstore_db;

select count(*) from orders;
/* MAking  aprimary key*/
/* Chcked duplicates and null values */
SELECT row_ID, COUNT(*)
FROM orders
GROUP BY row_ID
HAVING COUNT(*) > 1;

ALTER TABLE ORDERS
ADD PRIMARY KEY (row_ID);

/* Cleaning the data*/
describe orders;

/*Checking for nulls*/
select count(*) from orders where order_id is null;
select count(*) from orders where order_date is null;
select 
   sum(case when row_ID is null then 1 else 0 end) as row_ID_null from orders;
select count(*) from orders where ship_date is null;
select count(*) from orders where customer_id is null;
select count(*) from orders where customer_name is null;  
select count(*) from orders where sales is null;
select count(*) from orders where quantity is null;

/* Remove rows where critical value are <=0 */
select count(*)
from orders
where sales <=0 or quantity <=0;
/* There were no values that are less than zero*/

/*Checking date format consistency*/
/* the order_date and ship_date are in VARCHAR to change that I created new date column and populated them using STR_TO_DATE*/

select order_date from orders; 
select distinct order_date
from orders;

Alter table orders
add column order_date_clean date;

Alter table orders
add column ship_date_clean date;

update orders
set 
   order_date_clean = STR_TO_DATE(order_date, '%m/%d/%Y')
where row_ID > 0 ;

update orders
set 
   ship_date_clean = STR_TO_DATE(ship_date, '%m/%d/%Y')
where row_ID > 0;

select 
	  order_date, order_date_clean
      ship_date, ship_date_clean 
from orders
limit 10;

select count(*)
from orders
where order_date IS NOT NULL
  and order_date_clean IS NULL;
  
Alter table orders drop column order_date;
alter table orders change order_date_clean order_date date;
  
Alter table orders drop column ship_date;
alter table orders change ship_date_clean ship_date date; 

/* Validate numeric columns*/

select
	min(sales), max(sales),
    min(quantity), max(quantity),
    min(profit), max(profit),
    min(discount), max(discount)
from orders;    

select * from orders
where profit = -6599.98;
select * from orders
where profit < -1000;

select *, (sales*(1 - discount) - profit ) as implied_cost
from orders
where profit < -1000
   and (sales * (1-discount) - profit) > sales;
/* Flaging the rows which have extreme unrealistic negative values*/   
alter table orders add column is_outlier boolean default false;

update orders
set is_outlier = true
where row_ID > 0
    and profit < -1000
    and (sales * (1-discount) - profit) > sales;
    
select * from orders
where  profit < -1000
   and (sales * (1-discount) - profit) > sales; 
   
/* Duplicates*/
SELECT order_id, COUNT(*)
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;
SELECT order_id, 
       SUM(sales) AS total_sales,
       SUM(profit) AS total_profit,
       SUM(quantity) AS total_quantity
FROM orders
GROUP BY order_id;

SELECT order_id, COUNT(DISTINCT product_id) AS num_products,
       GROUP_CONCAT(DISTINCT category) AS categories
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1
LIMIT 10;

select * 
from (
   select *,
      row_number() over(
        partition by order_id, category, product_name, order_date, ship_date, sales, quantity, profit, discount
        order by row_ID
        ) as rn
     from orders
) as temp
where rn >1; 

/* Deleting the row*/

DELETE o
FROM orders o
JOIN (
    SELECT row_ID
    FROM (
        SELECT row_ID,
               ROW_NUMBER() OVER (
                   PARTITION BY order_id, category, product_name, order_date, ship_date, sales, quantity, profit, discount
                   ORDER BY row_ID
               ) AS rn
        FROM orders
    ) AS temp
    WHERE rn > 1
) AS dup
ON o.row_ID = dup.row_ID;
         
SELECT order_id, category, product_name, order_date, ship_date, sales, quantity, profit, discount,  COUNT(*)
FROM orders
GROUP BY order_id, category, product_name, order_date, ship_date, sales, quantity, profit, discount
HAVING COUNT(*) > 1;

   
  
  
  
      

   
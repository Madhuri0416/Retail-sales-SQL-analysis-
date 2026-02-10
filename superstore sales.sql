create database superstore_db;
drop table if exists orders;
create table orders (
   row_ID INT,
   order_id varchar(30),
   order_date varchar(30),
   ship_date varchar(30),
   ship_mode varchar(30),
   customer_id VARCHAR(30),
   customer_name VARCHAR(100),
   segment VARCHAR(30),
   country VARCHAR(30),
   city VARCHAR(50),
   state VARCHAR(50),
   postal_code VARCHAR(20),
   region VARCHAR(30),
   product_id VARCHAR(30),
   category VARCHAR(30),
   sub_category VARCHAR(30),
   product_name VARCHAR(200),
   sales DECIMAL(10,2),
   quantity INT,
   discount DECIMAL(5,2),
   profit DECIMAL(10,2)
);




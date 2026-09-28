-- ========================================================
-- Project: Blinkit Grocery Sales & Performance Analysis
-- Author: Sara
-- Database Engine: MySQL
-- ========================================================

use sara;

-- --------------------------------------------------------
-- 1. TABLE CREATION
-- --------------------------------------------------------

drop table if exists blinkit;
CREATE TABLE blinkit (
    Item_Identifier VARCHAR(20),
    Item_Weight DECIMAL(6,3),
    Item_Fat_Content VARCHAR(20),
    Item_Visibility DECIMAL(10,6),
    Item_Type VARCHAR(50),
    Item_MRP DECIMAL(10,4),
    Outlet_Identifier VARCHAR(30),
    Outlet_Establishment_Year INT,
    Outlet_Size VARCHAR(20),
    Outlet_Location_Type VARCHAR(20),
    Outlet_Type VARCHAR(50),
    Item_Outlet_Sales DECIMAL(10,4),
    PRIMARY KEY (Item_Identifier, Outlet_Identifier) 
);
describe blinkit; 

-- --------------------------------------------------------
-- 2. DATA EXPLORATION
-- --------------------------------------------------------

-- Count of rows 
select count(*) from blinkit; 

-- Count of columns
select count(*) as number_of_columns
from information_schema.columns
where table_schema = 'sara'
and table_name = 'blinkit';

-- Sample data preview
select * from blinkit
limit 10;

-- Identify missing/null values
select * from blinkit 
where Item_Identifier is null or 
    Item_Weight is null or
    Item_Fat_Content is null or
    Item_Visibility is null or
    Item_Type is null or
    Item_MRP is null or
    Outlet_Identifier is null or
    Outlet_Establishment_Year is null or
    Outlet_Size is null or
    Outlet_Location_Type is null or
    Outlet_Type is null or
    Item_Outlet_Sales is null;
    
-- Distinct product categories
select distinct item_type from blinkit
order by item_type asc;

-- Distinct outlets 
select distinct outlet_identifier as outlet_location
from blinkit 
order by Outlet_Identifier asc;

-- Distribution of items per category 
select distinct item_identifier as number_of_items
from blinkit
order by Item_Identifier asc;

-- product name multiple times
select item_type, count(*) as number_of_items
from blinkit 
group by item_type
ORDER BY number_of_items DESC;

-- --------------------------------------------------------
-- 3. DATA CLEANING & TRANSFORMATION
-- --------------------------------------------------------

-- product prize zero
select * from blinkit
where item_MRP = 0 and item_outlet_sales = 0;

-- data transformation
select item_outlet_sales/item_mrp as net_quantity 
from blinkit; -- finding net quantity in kg

update blinkit 
set item_fat_content = 'regular'
where item_fat_content = 'reg'
and item_identifier !=''
and outlet_identifier != '';

update blinkit 
set item_fat_content = 'low fat'
where item_fat_content = 'LF'
and item_identifier !=''
and outlet_identifier != '';

-- Add derived column for Net Estimated Quantity
 alter table blinkit
 add column net_quantity DECIMAL(10,2); 
 
 update blinkit 
 set net_quantity = item_outlet_sales/item_mrp
 where item_identifier != ''
 and outlet_identifier != ''
 and item_mrp > 0 
 and item_outlet_sales > 0;
 
 -- Preview cleaned table
 select * from blinkit;
 
 -- --------------------------------------------------------
-- 4. BUSINESS QUESTIONS & ANALYSIS
-- --------------------------------------------------------

-- Q1. What are the top 10 highest-selling items by sales value?
select Item_Identifier, sum(Item_Outlet_Sales), Item_Type from blinkit
group by Item_Type, Item_Identifier
order by sum(Item_Outlet_Sales) desc
limit 10;

-- Q2. Which outlet type generates the highest average sales?
select avg(item_outlet_sales), outlet_type from blinkit
group by outlet_type 
order by avg(item_outlet_sales) desc;

-- Q3. How does total sales vary by outlet location type (Tier 1/2/3)?
select sum(Item_Outlet_Sales), outlet_location_type from blinkit
group by Outlet_Location_Type
order by sum(Item_Outlet_Sales) desc;

-- Q4. What's the distribution of items by fat content?
select item_fat_content, count(*) as total 
from blinkit
group by Item_Fat_Content;

-- Q5. How does the outlet's establishment year relate to average sales?
select outlet_establishment_year, avg(item_outlet_sales)
from blinkit
group by outlet_establishment_year 
order by outlet_establishment_year asc;

-- Q6. What are the top-selling item types by total sales?
select item_type, sum(item_outlet_sales)
from blinkit group by Item_Type
order by sum(item_outlet_sales) desc
limit 5;

-- Q7. What's the average price (MRP) by item type?
select item_type, avg(item_mrp) from blinkit
group by Item_Type
order by avg(item_mrp) desc
limit 5;

-- Q8. How does outlet size affect average sales? 
select outlet_size, avg(Item_Outlet_Sales)
from blinkit
group by Outlet_Size
order by avg(Item_Outlet_Sales) desc
limit 10;
---



 









    
    
    
    









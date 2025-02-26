create database Pizza_Sales

use pizza_sales

select * from order_details
select * from pizzas
select * from pizza_types
select * from  orders

--- 1. Retrieve the total number of orders placed.---

select count(distinct order_id) as Total_Orders from Orders;

--- 2. Calculate the total revenue generated from pizza sales. ---

select sum(s.quantity * p.price) as total_revenue from order_details s
join pizzas p on s.pizza_id = p.pizza_id;

--- 3. Identify the highest-priced pizza. ---

select m.name, p.size, p.price from pizzas p
join pizza_types m on p.pizza_type_id = m.pizza_type_id
order by p.price desc limit 1;

--- 4. Identify the most common pizza size ordered. ---

select p.size, COUNT(*) as total_orders from order_details od
join pizzas p on od.pizza_id = p.pizza_id
group by p.size
order by total_orders desc limit 1;

--- 5. List the top 5 most ordered pizza types along with their quantities. ---
 
select p.pizza_type_id, SUM(a.quantity) AS total_quantity
from order_details a
join pizzas p ON a.pizza_id = p.pizza_id
group by p.pizza_type_id
limit 5;

--- 6. Join the necessary tables to find the total quantity of each pizza category ordered. ---

select a.category, SUM(q.quantity) as total_quantity
from order_details q
join pizzas p on q.pizza_id = p.pizza_id
join pizza_types a on p.pizza_type_id = a.pizza_type_id
group by a.category
order by total_quantity desc;

--- 7.Determine the distribution of orders by hour of the day. ----

Select hour(time) as Hours,
Count(order_id) as distribution
From Orders
group by(Hours);

---- 8. Join relevant tables to find the category-wise distribution of pizzas. ---

select c.category, COUNT(p.pizza_id) as total_pizzas from pizzas p
join pizza_types c on p.pizza_type_id = c.pizza_type_id
group by c.category
order by total_pizzas desc;

--- 9. Group the orders by date and calculate the average number of pizzas ordered per day. ----

Select O.Date ,AVG(SUM(Quantity)) Over() Average_Pizza
From Orders O JOIN Order_details OD 
ON O.Order_id = OD.Order_id
Group BY O.Date 
Order by Date;

--- 10. Determine the top 3 most ordered pizza types based on revenue. ---

select a.name as pizza_type, SUM(od.quantity * p.price) as total_revenue from order_details od
join pizzas p on od.pizza_id = p.pizza_id
join pizza_types a on p.pizza_type_id =a.pizza_type_id
group by a.name
order by total_revenue desc limit 3;

-- 26-02-2025 --

---- 11. Calculate the Percentage Contribution of Each Pizza Type to Total Revenue---

select n.name as pizza_type, 
       sum(od.quantity * p.price) as total_revenue,
       sum(od.quantity * p.price) * 100 / SUM(SUM(od.quantity * p.price)) over() as revenue_percentage
from order_details od
join pizzas p on od.pizza_id = p.pizza_id
join pizza_types n on p.pizza_type_id = n.pizza_type_id
group by n.name
order by total_revenue desc;

---- 12. Analyze the cumulative revenue generated over time. ----

select o.date, 
       SUM(p.price * od.quantity) 
       over (Order by o.date) as cumulative_revenue 
from orders o 
join order_details od on o.order_id = od.order_id 
join pizzas p on p.pizza_id = od.pizza_id  
order by o.date;

--- 13. Determine the top 3 most ordered pizza types based on revenue for each pizza category. ---

select p.pizza_type_id, pt.category, SUM(p.price * od.quantity) AS total_revenue  from pizzas p 
join pizza_types pt on pt.pizza_type_id = p.pizza_type_id  
join order_details od on od.pizza_id = p.pizza_id  
group by p.pizza_type_id, pt.category  
order by total_revenue desc limit 3;

-- Retrieve the totla number of order placed ?

select  count(order_id) from orders

-- Calculate the total revenue generated from pizza sales?

select round(SUM(order_details.quantity * pizzas.price), 1)
as total_revenue
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id;

-- identify the highest priced pizza?

select pizza_types.name, pizzas.price
from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by price desc
limit 1

-- Identify the most common pizza size that ordered.

select  pizzas.size , count(order_details.order_details_id) as size_count
from pizzas join order_details
on order_details.pizza_id = pizzas.pizza_id 
group by pizzas.size
order by size_count desc;

-- list the top 5 most ordered pizza types along with their quantities.

select pizza_types.name, sum(order_details.quantity) as quantity 
from pizza_types
join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name 
order by quantity desc
limit 5;

-----------------------Moderate-----------------------------------------------

-- join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category , sum(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by quantity desc;


-- determine the distribution of orders by hour of the day.

select extract(hour from time) as hours , count(order_id) as order_count
from orders
group by hours order by hours asc;

-- join relevant table to find the category-wise distribution of pizzas.

select category , count(name) as types
from pizza_types
group by category order by types asc;

-- Group the orders by date and calculate the average number of pizzas ordered per day.


select Round(avg(quantity),0) as average_pizza_ordered

from
(select orders.date, sum(order_details.quantity) as quantity
from orders join order_details
on orders.order_id = order_details.order_id
group by orders.date) as ordered_quantity; 

-- Determine the top 3 most ordered pizza types based on revenue.

select pizza_types.name , 
SUM(order_details.quantity *pizzas.price) as total_revenue
from pizza_types join pizzas 
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details 
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name 
order by total_revenue  desc
limit 3;

---------------------------------------Advanced------------------------------------

-- calculate the percentage contribution of each pizza type to total revenue..

select pizza_types.category , 

round(SUM(order_details.quantity *pizzas.price)/ (select round(SUM(order_details.quantity * pizzas.price), 2)
as total_revenue
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id)*100, 2) as total_revenue

from pizza_types join pizzas 
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details 
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category 
order by total_revenue  desc

-- Analyze the cumulative revenue generated over time..


select date,
sum(revenue) over (order by date) as cumulative_revenue
from

(select orders.date, 
sum(order_details.quantity *pizzas.price) as revenue
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id
join orders
on orders.order_id = order_details.order_id
group by orders.date) as sales;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category .

select name, revenue 
from

(select category, name , revenue,
rank() over (partition by category order by revenue desc) as revn
from

(select pizza_types.category , pizza_types.name,
sum((order_details.quantity )* pizzas.price) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category , pizza_types.name) as a) as b

where revn <=3





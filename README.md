# Pizza Sales Data Analysis Using SQL
![Pizza logo](https://github.com/Firdousrahmani/pizza_saless/blob/main/pizza.png.png)

## Objective


This project analyzes pizza sales data using SQL to extract insights on orders, revenue, and customer preferences. It covers key metrics such as total sales,
top-performing pizzas, peak order times, and category-wise performance. Advanced SQL techniques, including joins, window functions, and ranking, are used to 
optimize data-driven decision-making.
 

### **Key Objectives:**  
- Retrieve total orders placed and analyze ordering patterns.  
- Calculate total revenue and identify top-selling and highest-priced pizzas.  
- Determine the most popular pizza size and analyze category-wise performance.  
- Examine order distribution by time to identify peak sales hours.  
- Analyze cumulative revenue trends and rank top pizzas based on revenue.  
- Utilize window functions and ranking techniques for advanced analytics.


## Business Problem and Solutions


# 1. Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category , sum(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by quantity desc;


# 2.determine the distribution of orders by hour of the day.

select extract(hour from time) as hours , count(order_id) as order_count
from orders
group by hours order by hours asc;


# 3.join relevant table to find the category-wise distribution of pizzas.

select category , count(name) as types
from pizza_types
group by category order by types asc;


# 4.Group the orders by date and calculate the average number of pizzas ordered per day.


select Round(avg(quantity),0) as average_pizza_ordered

from
(select orders.date, sum(order_details.quantity) as quantity
from orders join order_details
on orders.order_id = order_details.order_id
group by orders.date) as ordered_quantity; 



# 5.calculate the percentage contribution of each pizza type to total revenue..

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




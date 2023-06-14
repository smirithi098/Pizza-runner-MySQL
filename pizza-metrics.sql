USE pizza_db;

-- 1. How many pizzas were ordered?
SELECT COUNT(order_id) AS Number_of_pizzas_ordered FROM new_customer_orders;

-- 2. How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id) AS Number_of_unique_pizzas_ordered FROM new_customer_orders;

-- 3. How many successful orders were delivered by each runner?
SELECT runner_id, COUNT(order_id) AS orders_delivered FROM runner_orders GROUP BY runner_id;

-- 4. How many of each type of pizza was delivered?
SELECT pizza_id, COUNT(r.order_id) AS Number_of_orders_delivered 
	FROM new_customer_orders AS c RIGHT JOIN runner_orders AS r
    ON c.order_id = r.order_id
    GROUP BY pizza_id;
    
-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT pizza_name, COUNT(order_id) AS Pizzas_ordered
	FROM new_customer_orders as c INNER JOIN pizza_names AS p
    ON c.pizza_id = p.pizza_id
    GROUP BY pizza_name;
    
-- 6. What was the maximum number of pizzas delivered in a single order?

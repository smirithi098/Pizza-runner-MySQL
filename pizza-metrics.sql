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
SELECT MAX(No_of_pizzas_ordered) AS max_pizzas
	FROM ( SELECT order_id, COUNT(pizza_id) AS No_of_pizzas_ordered
			FROM new_customer_orders
			GROUP BY order_id
		 ) AS temp_table;
         
-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT customer_id, 
	SUM(change_in_order = 0) AS pizza_without_change,
	SUM(change_in_order = 1) AS pizza_with_change
    FROM 
		( SELECT c.order_id AS order_id, c.customer_id AS customer_id,
			CASE
				WHEN c.exclusion = 0 AND c.extra = 0 THEN 0
				WHEN c.exclusion > 0 OR c.extra > 0 THEN 1
			END AS change_in_order
			FROM runner_orders as r LEFT JOIN new_customer_orders AS c
			ON r.order_id = c.order_id) AS temp_table
	GROUP BY customer_id;

-- 8. How many pizzas were delivered that had both exclusions and extras?
SELECT COUNT(pizza_id) AS pizza_with_exclusions_and_extras
	FROM (SELECT c.pizza_id AS pizza_id, c.customer_id AS customer_id,
			CASE
				WHEN c.exclusion > 0 AND c.extra > 0 THEN 1
				ELSE 0
			END AS order_with_changes
			FROM runner_orders as r LEFT JOIN new_customer_orders AS c
			ON r.order_id = c.order_id) AS temp_table
	WHERE order_with_changes = 1;
    
-- 9. 
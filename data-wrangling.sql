USE pizza_db;

-- #####################CUSTOMER_ORDERS TABLE#######################

-- Set 0 for rows where NULL or NA - exclusions
UPDATE customer_orders SET exclusions = 0 WHERE exclusions = '' or exclusions = "null";

-- Set 0 for rows where NULL or NA - extras
UPDATE customer_orders SET extras = 0 WHERE extras = "null" or extras = '' or extras IS NULL;

-- Split the multi value rows to individual rows and create a new table 
CREATE TABLE new_customer_orders AS
	SELECT *, 
		TRIM(SUBSTRING_INDEX(exclusions, ',', 1)) AS exclusion, 
		TRIM(SUBSTRING_INDEX(extras, ',', 1)) AS extra 
	FROM customer_orders 
	UNION DISTINCT
	SELECT *, 
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(exclusions, ',', - 1), ',', 1)), 
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(extras, ',', - 1), ',', 1)) 
	FROM customer_orders;

-- Drop the originl `exclusions` and `extras` column from new table
ALTER TABLE new_customer_orders DROP COLUMN exclusions;
ALTER TABLE new_customer_orders DROP COLUMN extras;

-- #########################RUNNER_ORDERS TABLE########################

-- Delete order records which were cancelled (customer/restaurant)
DELETE FROM runner_orders WHERE cancellation LIKE "%Cancellation";

-- Remove string part from `distance` column
UPDATE runner_orders 
	SET distance = IF(LOCATE("k", distance) = 0, distance, TRIM(SUBSTRING(distance, 1, LOCATE("k", distance)-1)));
    
-- Remove string part from `duration` column
UPDATE runner_orders
	SET duration = IF(LOCATE("m", duration) = 0, duration, TRIM(SUBSTRING(duration, 1, LOCATE("m", duration)-1)));

-- Update the `cancellation` column with meaningful string for orders not cancelled
UPDATE runner_orders
	SET cancellation = "Not cancelled" WHERE cancellation = '' or cancellation IS NULL or cancellation = "null";

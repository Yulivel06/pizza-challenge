-- Total Revenue
SELECT
	SUM(quantity*price) AS TOTAL_VENTAS
FROM  order_details AS od
INNER JOIN pizzas AS p USING (pizza_id);

-- Average revenue per order
WITH revenue_order AS (
    SELECT SUM(quantity*price) AS revenue_order
	FROM orders AS o
	INNER JOIN order_details AS od USING (order_id)
	INNER JOIN pizzas AS p USING (pizza_id)
	GROUP BY order_id
    )
SELECT ROUND(AVG(revenue_order),2) avg_revenue_order
FROM revenue_order;

-- Total pizzas solds

SELECT
    sum(quantity) AS quantity_pizzas_year
FROM order_details;

-- Average pizza by order
WITH quantity_pizza_order AS  (
    SELECT
    SUM(quantity) quantity_pizzas
    FROM order_details
    GROUP BY order_id
)
SELECT round( AVG(quantity_pizzas), 2) avg_pizza_order
FROM quantity_pizza_order;

-- Ingredients per pizza

 WITH ingredients_per_pizza AS (
        SELECT
            pt.pizza_type_id,
            pt.name,
            y.ingredients
        FROM   pizzas_types AS pt
        LEFT   JOIN unnest(string_to_array(pt.ingredients, ', '))  AS y(ingredients) ON true),
 number_ingredients_pizza AS (
    SELECT
        name, pizza_type_id,
        count(ingredients) AS total_ingredientes
    FROM ingredients_per_pizza
    GROUP BY name, pizza_type_id
)
select avg(total_ingredientes)
from number_ingredients_pizza;

-- Hours and days peaks

SELECT
	to_char(date, 'day') AS name_day,
	date_part('dow', date) as num_day,
	to_char(time,'HH24') AS hour_day,
	count(order_id) AS num_ordenes
FROM orders
GROUP BY name_day, num_day, hour_day
ORDER BY num_ordenes DESC;

-- Pizza most sold per revenue, percentage of revenue and number of ingredients of each pizza

WITH total_final AS (
        WITH total_vendidas as (SELECT
            pizza_id, pizza_type_id,
            SUM(od.quantity)*price AS total_ventas
        FROM order_details AS od
            INNER JOIN pizzas AS p USING (pizza_id)
        GROUP BY  od.pizza_id, pizza_type_id,price)
SELECT
        name, pizza_type_id,
        sum(total_ventas) as total_ventas_pizza,
        round(100*sum(total_ventas)/(select
        SUM(quantity*price) AS TOTAL_VENTAS
        FROM  order_details AS od
        INNER JOIN pizzas AS p USING (pizza_id)),1) AS PER_SOLD
    FROM  total_vendidas INNER JOIN pizzas_types USING(pizza_type_id)
    GROUP BY pizza_type_id,name
),
total_ingredientes_final AS (
WITH INGREDIENTES AS (
    SELECT pt.pizza_type_id, pt.name, y.ingredients
    FROM   pizzas_types AS pt
    LEFT   JOIN unnest(string_to_array(pt.ingredients, ', '))  AS y(ingredients) ON true)
SELECT
    name, pizza_type_id,
    count(ingredients) AS total_ingredientes
FROM INGREDIENTES
GROUP BY name, pizza_type_id
ORDER BY total_ingredientes DESC
)
SELECT tp.name, per_sold, total_ventas_pizza, total_ingredientes
FROM total_final AS tp inner join  total_ingredientes_final USING (pizza_type_id)
ORDER BY total_ingredientes, PER_SOLD DESC;

-- Top 5 and worst sold pizza per quantity

WITH top5 AS (
        SELECT  name,
            SUM(quantity) as total_vendidas
        FROM order_details AS o
        INNER JOIN pizzas AS p
            USING(pizza_id)
        INNER JOIN pizzas_types AS pt
            USING (pizza_type_id)
        GROUP BY  pizza_type_id, name
        ORDER BY SUM(quantity) DESC
        LIMIT 5
    ),
 top1_worst as (
         SELECT  name,
            SUM(quantity)
        FROM order_details AS o
        INNER JOIN pizzas AS p
            USING(pizza_id)
        INNER JOIN pizzas_types AS pt
            USING (pizza_type_id)
        GROUP BY  pizza_type_id, name
        ORDER BY SUM(quantity) ASC
        LIMIT 1
)
SELECT *
FROM top5
UNION ALL
SELECT *
FROM top1_worst
ORDER BY total_vendidas DESC
;

-- Pizza sold by size
SELECT
	size,
    sum(quantity) AS total_quantity,
    ROUND(100*sum(quantity)/(select sum(quantity) FROM order_details),2) as percentage
FROM order_details
INNER JOIN pizzas USING(pizza_id)
GROUP BY size
ORDER BY percentage DESC;

-- AMOUNT OF PIZZA SOLD AND AVERAGE PRICE PER SIZE

SELECT
	size,
    sum(quantity) AS total_quantity,
    100.0*sum(quantity)/(select sum(quantity) FROM order_details) as percentaje,
    avg(price) avg_price_size
FROM order_details
INNER JOIN pizzas using (pizza_id)
GROUP BY size
ORDER BY percentaje DESC;



-- Revenue per month

SELECT
    to_char(date, 'month') AS month,
	to_char(date, 'MM') AS number_month,
	SUM(quantity*price) AS total_sold
FROM  orders AS o INNER JOIN order_details AS od  USING (order_id)
INNER JOIN pizzas AS p USING (pizza_id)
GROUP BY number_month, month;

-- QUANTITY ORDER PER MONTH
/**
  pregunta.

-
 */
SELECT
     to_char(date, 'month') AS month,
     to_char(date, 'MM') AS number_month,
    count(order_id) total_order
FROM orders
GROUP BY number_month, month
ORDER BY total_order;

--number pizza per month

SELECT
    to_char(date, 'month') AS month,
	to_char(date, 'MM') AS number_month,
	SUM(quantity) AS total_pizza
FROM  orders AS o INNER JOIN order_details AS od  USING (order_id)
INNER JOIN pizzas AS p USING (pizza_id)
GROUP BY number_month, month
ORDER BY total_pizza;

-- AVG per day of week

WITH order_day_week AS (
    SELECT
	to_char(date, 'day') AS dia_name,
	to_char(date, 'ID') AS num_week,
	count(order_id) AS num_ord
	from orders
	group by date, dia_name)
SELECT
    dia_name,
    num_week,
    ROUND(AVG(num_ord),2) avg_day_week
FROM  order_day_week
GROUP BY dia_name, num_week
ORDER BY avg_day_week
;

-- average orders per day

WITH num_order_date AS (
    SELECT
	date,
	count(order_id) AS num_ord
	from orders
	group by date)
SELECT AVG(num_ord)
from num_order_date;

select date, count(order_id) total_ventas
from orders
group by date
order by total_ventas desc;

-- TOP5 ingredients most used and least in pizzas

WITH INGREDIENTES as (SELECT pt.pizza_type_id, pt.name, y.ingredients
FROM   pizzas_types AS pt
LEFT   JOIN unnest(string_to_array(pt.ingredients, ', '))  AS y(ingredients) ON true),
TOP5 AS (SELECT ingredients, count(pizza_type_id) AS usado_by_pizza
    FROM INGREDIENTES
    GROUP BY  ingredients
    ORDER BY count(pizza_type_id) DESC
    limit 5),
TOP5WORS AS
        (SELECT ingredients, count(pizza_type_id) AS usado_by_pizza
        FROM INGREDIENTES
        GROUP BY  ingredients
        ORDER BY count(pizza_type_id) ASC
        limit 5)
SELECT ingredients, usado_by_pizza
FROM TOP5
UNION ALL
SELECT *   FROM TOP5WORS
ORDER BY usado_by_pizza DESC;

-- TOTAL PIZZAS

SELECT distinct count(pizza_type_id) total_pizzas
FROM pizzas_types;








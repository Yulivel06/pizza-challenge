# Panel pizzas - resultado final 

![enter image description here](https://github.com/Yulivel06/pizza-challenge/blob/main/docu/panel_pizzas.jpg)

  [**Mira aquí mi informe**](https://app.powerbi.com/view?r=eyJrIjoiZDNjNTgzMzctN2NhMy00Mjk1LWE5NzEtYjgyM2UyYzFhZjEwIiwidCI6IjcwOTg2ZWU0LTUzNzktNDU4Ni1iZDIzLTVhOTBiNGVjMmMwZSJ9&pageName=ReportSection)
  

# Descripción 
Este es un conjunto de datos de #mavenchallenge disponible [Aquí](https://www.mavenanalytics.io/data-playground)

### Descripcion del conjunto de datos


-   Este conjunto de datos contiene **4 tablas** en formato CSV
-   La tabla **Orders** contiene la fecha y la hora en que se realizaron todos los pedidos de la mesa.
-   La tabla **Order Details** contiene las diferentes pizzas servidas con cada pedido en la tabla Pedidos y sus cantidades.
-   La tabla **Pizzas** contiene el tamaño y el precio de cada pizza distinta en la tabla Detalles del pedido, así como su tipo de pizza más amplio.
-   La tabla **Pizza Types** contiene detalles sobre los tipos de pizza en la tabla Pizzas, incluido su nombre tal como aparece en el menú, la categoría a la que pertenece y su lista de ingredientes.

### ¿Qué herramientas usamos para analizar estos datos?
- PostgreSQL (Análisis exploratorio de datos)
- Power BI (visualización de datos) 

### Pasos a seguir 

 **1. Creamos cada una de nuestras tablas.**
 ``` sql
CREATE TABLE order_details  (  
    order_details_id integer not null  primary key,  
    order_id         integer,  
	pizza_id         varchar(40),  
	quantity         integer  
);
```
 ``` sql
CREATE TABLE orders  (  
    order_id integer not null  primary key, 
    date     date, 
    time     time
);
```
 ``` sql
CREATE TABLE pizzas_types  (  
    pizza_type_id varchar(40) not null  primary key, 
    name   varchar(40),  
	category  varchar(40),  
   ingredients  varchar(1000)
);
```
 ``` sql
CREATE TABLE pizzas  (  
    pizza_id      varchar(40) not null  
	primary key,  pizza_type_id varchar(40),  
    size          char(5),  
    price         numeric(10, 2)  
);
```

**2. Importamos nuestros archivos CSV**

Los archivos CSV estan ubicados en la carpeta **datasets**.

**3. Ahora, es momento de explorar y analizar nuestros datos**

``` sql
-- Total Revenue  
SELECT  
  SUM(quantity*price) AS TOTAL_VENTAS  
FROM order_details AS od  
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
WITH quantity_pizza_order AS (  
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
  FROM pizzas_types AS pt  
        LEFT   JOIN unnest(string_to_array(pt.ingredients, ', '))  AS y(ingredients) ON true),  
  number_ingredients_pizza AS (  
    SELECT  
 name, pizza_type_id,  
  count(ingredients) AS total_ingredientes  
    FROM ingredients_per_pizza  
    GROUP BY name, pizza_type_id  
)  
SELECT avg(total_ingredientes)  
FROM number_ingredients_pizza;  
  
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
        GROUP BY od.pizza_id, pizza_type_id,price)  
SELECT  
 name, pizza_type_id,  
  sum(total_ventas) as total_ventas_pizza,  
  round(100*sum(total_ventas)/(select  
  SUM(quantity*price) AS TOTAL_VENTAS  
        FROM order_details AS od  
        INNER JOIN pizzas AS p USING (pizza_id)),1) AS PER_SOLD  
    FROM total_vendidas INNER JOIN pizzas_types USING(pizza_type_id)  
    GROUP BY pizza_type_id,name  
),  
total_ingredientes_final AS (  
WITH INGREDIENTES AS (  
    SELECT pt.pizza_type_id, pt.name, y.ingredients  
  FROM pizzas_types AS pt  
    LEFT   JOIN unnest(string_to_array(pt.ingredients, ', '))  AS y(ingredients) ON true)  
SELECT  
 name, pizza_type_id,  
  count(ingredients) AS total_ingredientes  
FROM INGREDIENTES  
GROUP BY name, pizza_type_id  
ORDER BY total_ingredientes DESC  
)  
SELECT tp.name, per_sold, total_ventas_pizza, total_ingredientes  
FROM total_final AS tp inner join total_ingredientes_final USING (pizza_type_id)  
ORDER BY total_ingredientes, PER_SOLD DESC;
```


4. Por útlimo, graficamos nuestras consultas en nuestra herramienta de visualización preferida.  
 (Es hora de visualizar deja volar tu imaginación) 
 






 
 

 

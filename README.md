> # Descripción 
> Este es un conjunto de datos de #mavenchallenge disponible [Aquí](https://www.mavenanalytics.io/data-playground)
> 
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

 1. Creamos cada una de nuestras tablas. 
 ```
create table order_details  (  
    order_details_id integer not null  primary key,  
    order_id         integer,  
	pizza_id         varchar(40),  
	quantity         integer  
);
```
 ```
create table orders  (  
    order_id integer not null  primary key, 
    date     date, 
    time     time
);
```
 ```
create table pizzas_types  (  
    pizza_type_id varchar(40) not null  primary key, 
    name   varchar(40),  
	category  varchar(40),  
   ingredients  varchar(1000)
);
```
 ```
create table pizzas  (  
    pizza_id      varchar(40) not null  
	primary key,  pizza_type_id varchar(40),  
    size          char(5),  
    price         numeric(10, 2)  
);
```

2. Exportamos nuestros archivos CSV 

3. Ahora, es momento de explorar y analizar nuestros datos 

4. Por útlimo, pasamos cada consulta a graficar en Power BI. 
 (Es hora de visualizar deja volar tu imaginación) 

 [Mira aquí mi informe]https://app.powerbi.com/view?r=eyJrIjoiZDNjNTgzMzctN2NhMy00Mjk1LWE5NzEtYjgyM2UyYzFhZjEwIiwidCI6IjcwOTg2ZWU0LTUzNzktNDU4Ni1iZDIzLTVhOTBiNGVjMmMwZSJ9&pageName=ReportSection


 
 

 

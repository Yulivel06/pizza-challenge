
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
- AWS S3 (almacenar los datos)
- Glue 
- Athena (para analizar los datos)
- Power BI (visualización de datos) 

### Pasos a seguir para importar nuestros datos

 1. Inicialmente, utilizando el servicio de amazon S3 almacenamos e importamos nuestros objetos (archivos CSV) en el "Bucket". 
 Para esto, creamos primeramente nuestro Bucket que debe contener un nombre único en todo amazon web services. 
  2. Creamos una carpeta para cada archivo CSV (order, order_details, pizzas_types, pizzas)
  3. Cargamos cada archivo CSV a su respectiva carpeta. 
 
 Ahora, con **AWS Glue** 
 

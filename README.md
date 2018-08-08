# FeedReader
Lector de noticias en formato JSON diseñado y desarrollado para iOS con modo de lectura offline.

## Diseño de clases

Hay 3 targets

1. WiredReader: Es la app iOs
2. FeedKit: Lógica ETL para el feed de wired
3. WiredKit: Framework de soporte a la app, de momento sólo gestiona los datos locales

##  Patrones de diseño

Vais a encontrar 2:

1. Singleton. Los he empleado como acceso a los clientes de Feed y al controlador de datos local
2. Adapter. Para poder usar celdas de diferntes tipos como si fueran sólo una. 

Lo que viene siendo los patrones Singleton y Adapter de toda la vida ;)


## Soporte Offline

Usando Core Data, se crea una copia nada más descargarse el feed a nuestra móvil


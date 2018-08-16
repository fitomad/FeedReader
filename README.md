# FeedReader
Lector de noticias en formato JSON de la publicación [WIRED](https://www.wired.com/about/rss_feeds/) diseñado y desarrollado para iOS con modo de lectura offline.

![Pantallazo](https://github.com/fitomad/FeedReader/blob/master/Screenshots/Captura%20de%20pantalla%202018-08-08%20a%20las%204.01.50.png?raw=true) 

## Diseño de clases

Hay 3 targets

1. **WiredReader**: Es la app iOS
2. **FeedKit**: Lógica ETL para el feed de Wired
3. **WiredKit**: Framework de soporte a la app, de momento sólo gestiona los datos locales

##  Patrones de diseño

Vais a encontrar 2:

1. Singleton. Los he empleado como acceso a los clientes de Feed y al controlador de datos local
2. Adapter. Para poder usar celdas de diferentes tipos como si fueran sólo una. 

Lo que viene siendo los patrones Singleton y Adapter de toda la vida ;)


## Soporte Offline

Usando Core Data, se crea una copia nada más descargarse el feed a nuestra móvil

## ¿Y por qué...?

**¿...has usado SafariViewController para mostrar la web?**

Por dos motivos:
1. Tiene soporte para *Vista de lectura* por lo que las noticias del feed se verán muy bien
2. El usuario no sale en ningún momento de la app.

**¿...cuando está en modo offline no salen las imágenes en la lista de feed pero sí en la del artículo?**

Es a modo de feedback, para que el usuario sepa que no hay conexión


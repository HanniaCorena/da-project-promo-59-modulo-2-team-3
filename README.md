## Nuestro código cuenta de dos fases.

## FASE 1:

Primero se importaron las librerías necesarias para conectarse a la API de Spotify y obtener datos, se usó pandas para organizar y analizar esa información en tablas, y se definieron los parámetros del análisis: cinco géneros (indie rock, jazz, funk, pop latino y reggaetón, y sus subgéneros), todos en el rango de años de 2010 a 2024.  

Se instaló la librería python-dotenv, que permite leer las variables del archivo .env para usar claves y credenciales de forma segura dentro del código Python.  

Luego se cargaron las variables de entorno desde el archivo `.env` y se obtuvieron las credenciales necesarias (Spotify y Last.fm) de forma segura, sin escribirlas directamente en el código. Cada integrante usó sus propias credenciales de Spotify y LastFM, pues cada integrante hizo una búsqueda local de la base de datos que le correspondía para luego unificarlas (en la Fase 2).  

En la continuación del código se definió el rango de años a analizar, se estableció una lista de términos de búsqueda optimizados para obtener canciones de música urbana y reggaetón de alto volumen (incluyendo etiquetas antiguas y actuales), y se inicializó la conexión con la API de Spotify usando las credenciales, verificando que la conexión fuera exitosa.  

Nuestro código comprueba que la autenticación con Spotify se haya realizado correctamente, verificando el tipo del objeto `sp` creado para acceder a la API.  

Definimos una función para extraer datos de Spotify de forma estable y controlada, con límites de seguridad:

- Extrae hasta 500 canciones en total y máximo 250 por año.  
- Busca canciones usando una lista de términos relacionados con reggaetón y música urbana.  
- Evita duplicados y controla errores durante la búsqueda y paginación.  
- Solo obtiene información básica de cada canción (artista, nombre, álbum, año y popularidad), sin características de audio para mayor estabilidad.  
- Devuelve los resultados en un DataFrame de pandas, listo para análisis.  

Luego de definida la función, se ejecuta la extracción de datos de Spotify y se guardan los resultados en un DataFrame `df_spotify_raw`. Finalizado esto se muestra un resumen con el total de canciones extraídas y los primeros registros (nombre, artista y popularidad). Si el cliente de Spotify no estaba inicializado, se mostraría un mensaje de error.  

Luego de extraídos los datos, se verifica el resultado, mostrando cuántas canciones se encontraron en total y las primeras filas del DataFrame `df_spotify_raw` para revisar que los datos se hayan cargado correctamente.  

Aquí se definió y ejecutó un proceso para extraer y unificar los detalles de los álbumes asociados a las canciones obtenidas de Spotify:

- Se creó la función `extract_album_details` para obtener nombre, año de lanzamiento, artista principal y tipo de cada álbum, haciendo pausas cortas para no saturar la API y manejando posibles errores.  
- Se verificó que el DataFrame de canciones (`df_spotify_raw`) existiera y contuviera la columna `ID_Album`.  
- Se extrajeron los IDs únicos de álbumes y se llamó a la función para obtener sus metadatos.  
- Finalmente, se fusionaron los datos de los álbumes con las canciones en un nuevo DataFrame `df_spotify_final`, listo para análisis, mostrando un resumen de las primeras filas.  

Aquí se definió y ejecutó un proceso para obtener información adicional de los artistas desde Last.fm:

- La función `extract_lastfm_artist_details` consulta la API de Last.fm para obtener biografía resumida, cantidad de reproducciones (playcount) y número de oyentes de un artista.  
- Se recorrieron los artistas únicos del DataFrame de Spotify para evitar búsquedas repetidas, guardando los resultados en `df_lastfm`.  
- Luego, se fusionaron los datos de Last.fm con los de Spotify en un DataFrame final `df_final_reggaeton`, listo para análisis o almacenamiento, mostrando un resumen de los primeros registros y el total de canciones.  

Nuestro código continúa con la fusión de los datos de Spotify cargados desde un CSV local con la información de Last.fm. Se limpiaron columnas nulas y se guardó el resultado final en un nuevo CSV:

- Se cargó el CSV con los datos de canciones de Spotify.  
- Se hizo un merge con `df_lastfm` para agregar biografía, playcount y oyentes de los artistas.  
- Se limpiaron los valores nulos: biografía como `'N/A'` y números como `0`.  
- Finalmente, se guardó el DataFrame consolidado en `data_consolidada_final.csv` y se mostró un resumen con las primeras filas y el total de registros. Los archivos `data_consolidada` pasaron a llamarse `GENERO_data_2010_2024.csv`.  

Aquí se ejecutaron comandos para instalar librerías de Python que permiten conectarse a bases de datos MySQL:

- `mysql-connector-python`: cliente oficial de MySQL para Python.  
- `sqlalchemy + mysqlclient`: alternativa más robusta, especialmente útil para trabajar con pandas y manejar bases de datos de forma eficiente.  

## FASE 2

Luego de extraídos y unificados los datos de Spotify y LastFM, se preparó la conexión a una base de datos MySQL desde Python:

- Se cargaron credenciales desde el archivo `.env`.  
- Se conectó al servidor MySQL y se creó la base de datos `musica_db`.  
- Se definió un engine de SQLAlchemy para manejar la base de datos desde Python, listo para cargar datos y trabajar con pandas.  
- Se incluyeron controles de errores para asegurarse de que la conexión funcionara correctamente.  

Luego se realizó un proceso de consolidación y limpieza de datos musicales de múltiples géneros para prepararlos para MySQL:

- Se cargaron varios CSV de distintos géneros (reggaetón, pop latino, funk, indie, jazz) y se añadió una columna `Genero` a cada uno.  
- Se unieron todos los DataFrames en uno solo (`df_consolidado`) y se eliminaron duplicados por `ID_Spotify`.  
- Se repararon datos de álbumes faltantes: si no había nombre, año o ID de álbum, se rellenaron con valores predeterminados o del nombre/año de la canción.  
- Se limpiaron los datos de Last.fm (`Playcount`, `Listeners`, `Biografia_Resumen`) para reemplazar valores nulos.  
- Se creó un mapa de géneros con un ID único por género y se añadió al DataFrame consolidado.  
- El resultado es un DataFrame limpio y consistente, listo para ser cargado en MySQL.  

Luego se realizó la inserción de los datos consolidados en MySQL siguiendo un esquema normalizado:

- Se eliminaron tablas previas para evitar conflictos.  
- Se crearon e insertaron las tablas `GENEROS`, `ARTISTAS`, `ALBUMES` y `CANCIONES`, definiendo claves primarias y foráneas para mantener integridad referencial.  
- En la tabla `CANCIONES` se añadió la columna `Popularidad` extraída de Spotify.  
- Se realizaron conversiones y reemplazos de valores nulos para asegurar consistencia de tipos.  
- Finalmente, se ejecutó una consulta de verificación mostrando el total de canciones y la popularidad promedio por género, confirmando que los datos se cargaron correctamente.

Las tablas que se generaron se relacionan de la siguiente manera:


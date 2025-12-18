use musica_db;
-- CATEGORIA CANCIONES
-- Canción del año (spotify y lastfm)
SELECT 
    c.Nombre AS Cancion, 
    c.Artista, 
    c.Popularidad AS Spotify_Pop,
    a.Listeners_LastFM AS LastFM_Listeners,
    -- Formula de éxito combinado
    (c.Popularidad + (a.Listeners_LastFM / 50000)) AS Score_Combinado
FROM CANCIONES c
JOIN ARTISTAS a ON c.Artista = a.Artista
WHERE c.Año_lanzamiento = 2010
ORDER BY Score_Combinado DESC
LIMIT 1;

SELECT 
    c.Nombre AS Cancion, 
    c.Artista, 
    c.Popularidad AS Spotify_Pop,
    a.Listeners_LastFM AS LastFM_Listeners,
    (c.Popularidad + (a.Listeners_LastFM / 50000)) AS Score_Combinado
FROM CANCIONES c
JOIN ARTISTAS a ON c.Artista = a.Artista
WHERE c.Año_lanzamiento = 2024
ORDER BY Score_Combinado DESC
LIMIT 1;

-- Top 5 canciones del año
SELECT 
    Nombre AS Cancion, 
    Artista, 
    Popularidad,
    Año_lanzamiento
FROM CANCIONES
WHERE Año_lanzamiento = 2010
ORDER BY Popularidad DESC
LIMIT 5;

SELECT 
    Nombre AS Cancion, 
    Artista, 
    Popularidad,
    Año_lanzamiento
FROM CANCIONES
WHERE Año_lanzamiento = 2024
ORDER BY Popularidad DESC
LIMIT 5;

-- Canción más mainstream
SELECT 
    c.Nombre AS Cancion, 
    c.Artista, 
    a.Listeners_LastFM AS Oyentes_Totales,
    c.Año_lanzamiento
FROM CANCIONES c
JOIN ARTISTAS a ON c.Artista = a.Artista
WHERE c.Año_lanzamiento = 2010
ORDER BY a.Listeners_LastFM DESC
LIMIT 1;
SELECT 
    c.Nombre AS Cancion, 
    c.Artista, 
    a.Listeners_LastFM AS Oyentes_Totales,
    c.Año_lanzamiento
FROM CANCIONES c
JOIN ARTISTAS a ON c.Artista = a.Artista
WHERE c.Año_lanzamiento = 2024
ORDER BY a.Listeners_LastFM DESC
LIMIT 1;

-- Canción infravalorada
SELECT c.Nombre, c.Artista, c.Popularidad, a.Playcount_LastFM
FROM CANCIONES c
JOIN ARTISTAS a ON c.Artista = a.Artista
WHERE c.Popularidad < 40
ORDER BY a.Playcount_LastFM DESC LIMIT 1;

-- Cancion "el clásico inmortal"
SELECT 
    Nombre AS Cancion, 
    Artista, 
    Popularidad AS Relevancia_Actual,
    Año_lanzamiento
FROM CANCIONES
WHERE Año_lanzamiento = 2010
ORDER BY Popularidad DESC
LIMIT 1;

-- CATEGORIA ARTISTAS

-- Artista del año
SELECT 
    a.Artista, 
    ROUND(AVG(c.Popularidad), 2) AS Popularidad_Media,
    a.Listeners_LastFM AS Comunidad_Total
FROM ARTISTAS a
JOIN CANCIONES c ON a.Artista = c.Artista
WHERE c.Año_lanzamiento = 2024
GROUP BY a.Artista, a.Listeners_LastFM
ORDER BY Popularidad_Media DESC, Comunidad_Total DESC
LIMIT 1;

-- Artista más pesado
SELECT 
    Artista, 
    COUNT(CASE WHEN Año_lanzamiento = 2010 THEN 1 END) AS Hits_2010,
    COUNT(CASE WHEN Año_lanzamiento = 2024 THEN 1 END) AS Hits_2024,
    ROUND(AVG(Popularidad), 2) AS Popularidad_Media_Actual
FROM CANCIONES
GROUP BY Artista
HAVING 
    COUNT(CASE WHEN Año_lanzamiento = 2010 THEN 1 END) > 0 
    AND COUNT(CASE WHEN Año_lanzamiento = 2024 THEN 1 END) > 0
ORDER BY Popularidad_Media_Actual DESC
LIMIT 1;
-- Artista revelación del año
SELECT Artista, AVG(Popularidad) as Promedio_Popularidad 
FROM CANCIONES WHERE Año_lanzamiento = 2024 
GROUP BY Artista HAVING COUNT(*) >= 1
ORDER BY Promedio_Popularidad DESC LIMIT 1;

-- Que artista sale en más canciones dentro de cada género

-- CATEGORIA ALBUMES
-- Album del año
SELECT Nombre_Album, al.Artista, AVG(Popularidad) as Popularidad_Media
FROM CANCIONES c
JOIN ALBUMES al ON c.ID_Album = al.ID_Album
GROUP BY c.ID_Album ORDER BY Popularidad_Media DESC LIMIT 1;

-- Album más solido (canciones populares)
SELECT 
    al.Nombre_Album, 
    al.Artista, 
    COUNT(c.ID_Spotify) AS Numero_Canciones,
    ROUND(AVG(c.Popularidad), 2) AS Popularidad_Media_Album
FROM CANCIONES c
JOIN ALBUMES al ON c.ID_Album = al.ID_Album
GROUP BY al.ID_Album, al.Nombre_Album, al.Artista
HAVING Numero_Canciones >= 3  -- Aseguramos que sea un álbum real y no un single
ORDER BY Popularidad_Media_Album DESC
LIMIT 1;
-- Album más variado
SELECT 
    al.Nombre_Album, 
    al.Artista, 
    COUNT(c.ID_Spotify) AS Numero_Canciones,
    ROUND(STDDEV(c.Popularidad), 2) AS Variedad_Popularidad
FROM CANCIONES c
JOIN ALBUMES al ON c.ID_Album = al.ID_Album
GROUP BY al.ID_Album, al.Nombre_Album, al.Artista
HAVING Numero_Canciones >= 3
ORDER BY Variedad_Popularidad DESC
LIMIT 1;
-- Album con más canciones destacadas
SELECT 
    al.Nombre_Album, 
    al.Artista, 
    COUNT(c.ID_Spotify) AS Total_Canciones_Destacadas
FROM CANCIONES c
JOIN ALBUMES al ON c.ID_Album = al.ID_Album
WHERE c.Popularidad > (SELECT AVG(Popularidad) FROM CANCIONES)
GROUP BY al.ID_Album, al.Nombre_Album, al.Artista
ORDER BY Total_Canciones_Destacadas DESC
LIMIT 1;
-- Qué album de 2010 sigue manteniendo popularidad: album atemporal
SELECT al.Nombre_Album, al.Artista, AVG(c.Popularidad) as Popularidad_Actual
FROM ALBUMES al
JOIN CANCIONES c ON al.ID_Album = c.ID_Album
WHERE al.Año_Lanzamiento_Album = 2010
GROUP BY al.ID_Album ORDER BY Popularidad_Actual DESC LIMIT 1;

-- CATEGORIA GENERO MUSICAL 
-- Mejor género del año
SELECT 
    g.nombre_genero, 
    COUNT(c.ID_Spotify) AS Total_Canciones,
    ROUND(AVG(c.Popularidad), 2) AS Popularidad_Media
FROM CANCIONES c
JOIN GENEROS g ON c.genero_id = g.genero_id
WHERE c.Año_lanzamiento = 2010
GROUP BY g.nombre_genero
ORDER BY Popularidad_Media DESC
LIMIT 1;
SELECT 
    g.nombre_genero, 
    COUNT(c.ID_Spotify) AS Total_Canciones,
    ROUND(AVG(c.Popularidad), 2) AS Popularidad_Media
FROM CANCIONES c
JOIN GENEROS g ON c.genero_id = g.genero_id
WHERE c.Año_lanzamiento = 2024
GROUP BY g.nombre_genero
ORDER BY Popularidad_Media DESC
LIMIT 1;
-- Género con mayor producción
SELECT g.nombre_genero, COUNT(c.ID_Spotify) as Volumen_Produccion
FROM CANCIONES c
JOIN GENEROS g ON c.genero_id = g.genero_id
GROUP BY g.nombre_genero ORDER BY Volumen_Produccion DESC LIMIT 1;
-- Género más mainstream
SELECT 
    g.nombre_genero, 
    COUNT(c.ID_Spotify) AS Total_Canciones,
    ROUND(AVG(c.Popularidad), 2) AS Popularidad_Media
FROM CANCIONES c
JOIN GENEROS g ON c.genero_id = g.genero_id
GROUP BY g.nombre_genero
ORDER BY Popularidad_Media DESC
LIMIT 1;
SELECT 
    g.nombre_genero, 
    COUNT(c.ID_Spotify) AS Total_Canciones,
    ROUND(AVG(a.Listeners_LastFM), 0) AS Promedio_Oyentes_LastFM
FROM CANCIONES c
JOIN GENEROS g ON c.genero_id = g.genero_id
JOIN ARTISTAS a ON c.Artista = a.Artista
GROUP BY g.nombre_genero
ORDER BY Promedio_Oyentes_LastFM DESC
LIMIT 1;
-- Género más underground
SELECT g.nombre_genero, AVG(c.Popularidad) as Popularidad_Promedio
FROM CANCIONES c
JOIN GENEROS g ON c.genero_id = g.genero_id
GROUP BY g.nombre_genero ORDER BY Popularidad_Promedio ASC LIMIT 1;

-- PREMIOS TEMPORALES 
-- Género con mayor crecimiento
SELECT 
    g.nombre_genero,
    COUNT(CASE WHEN c.Año_lanzamiento = 2010 THEN 1 END) AS Canciones_2010,
    COUNT(CASE WHEN c.Año_lanzamiento = 2024 THEN 1 END) AS Canciones_2024,
    (COUNT(CASE WHEN c.Año_lanzamiento = 2024 THEN 1 END) - 
     COUNT(CASE WHEN c.Año_lanzamiento = 2010 THEN 1 END)) AS Crecimiento_Absoluto
FROM CANCIONES c
JOIN GENEROS g ON c.genero_id = g.genero_id
GROUP BY g.nombre_genero
ORDER BY Crecimiento_Absoluto DESC
LIMIT 1;
-- Artista que mejor envejece
SELECT 
    Artista, 
    COUNT(ID_Spotify) AS Total_Canciones_Antiguas,
    ROUND(AVG(Popularidad), 2) AS Popularidad_Media_Hits_Pasados
FROM CANCIONES
WHERE Año_lanzamiento BETWEEN 2010 AND 2024
GROUP BY Artista
HAVING Total_Canciones_Antiguas >= 2 -- Filtramos para que tengan al menos un par de temas
ORDER BY Popularidad_Media_Hits_Pasados DESC
LIMIT 1;
-- Premio a la trayectoria

SELECT Artista, Playcount_LastFM 
FROM ARTISTAS 
ORDER BY Playcount_LastFM DESC LIMIT 1;







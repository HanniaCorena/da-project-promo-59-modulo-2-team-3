<p align="center">
  <img width="409" height="420" alt="Yaneli’s Music Awards logo" src="https://github.com/user-attachments/assets/ae4c943b-9199-44e0-b55b-d242ec02caaa" />
</p>

<h1 align="center">Yaneli’s Music Awards (2010–2024)</h1>


Proyecto de análisis musical que convierte datos de Spotify y Last.fm en una gala de premios ficticia: **los Yaneli’s Awards**.  
Analizamos casi 2500 canciones de **Reggaeton, Pop Latino, Funk, Rock Indie y Jazz** de los años 2010 y 2024.

---

## Objetivo del proyecto

- Construir una **base de datos relacional** en MySQL con información de canciones, artistas, álbumes y géneros.  
- Integrar datos procedentes de **múltiples CSV** (Spotify + Last.fm) y normalizarlos en un modelo.  
- Diseñar una **gala de premios musicales** basada en métricas objetivas (popularidad, playcount, oyentes, etc.).  
- Practicar un flujo real de trabajo con **Python (pandas) + SQL + Visual Studio Code + Git/GitHub**.

---

## Arquitectura de datos

La base de datos `musica_db` contiene 4 tablas principales:

- **`artistas`**  
  - `Artista` (PK)  
  - `Playcount_LastFM` (BIGINT)  
  - `Listeners_LastFM` (BIGINT)  
  - `Biografia_Resumen` (TEXT)

- **`albumes`**  
  - `ID_Album` (PK)  
  - `Nombre_Album`  
  - `Año_Lanzamiento_Album`  
  - `Artista` (FK → `artistas`)

- **`generos`**  
  - `genero_id` (PK)  
  - `nombre_genero`

- **`canciones`**  
  - `ID_Spotify` (PK)  
  - `Nombre`  
  - `Año_lanzamiento`  
  - `ID_Album` (FK → `albumes`)  
  - `Artista` (FK → `artistas`)  
  - `genero_id` (FK → `generos`)  
  - `Popularidad` (INT)

Este modelo permite responder preguntas como:

- ¿Qué artista domina cada género entre 2010 y 2024?  
- ¿Qué álbum es el más consistente en popularidad?  
- ¿Qué canciones son las más escuchadas según Last.fm?

---

## Tecnologías utilizadas

- **Python** – lógica principal del proyecto.  
- **pandas, numpy** – limpieza, consolidación y transformación de datos.  
- **MySQL + SQLAlchemy** – creación de `musica_db`, normalización y consultas SQL.  
- **Visual Studio Code** – entorno de desarrollo.  
- **Git & GitHub** – control de versiones y colaboración entre 5 miembros.

---
## Estructura del repositorio

<img width="520" height="212" alt="image" src="https://github.com/user-attachments/assets/4a75b94d-734a-45c7-975f-d04176f7bb03" />
---


## Cómo reproducir el proyecto

1. **Clonar el repositorio**

git clone https://github.com/usuario/da-project-promo-59-modulo-2-team-3.git
cd da-project-promo-59-modulo-2-team-3

2. **Crear la base de datos**

En MySQL: CREATE DATABASE musica_db;
Importar el dump: mysql -u root -p musica_db < sql/musica_db_dump.sql

3. **(Opcional) Regenerar las tablas desde Python**

- Configurar credenciales en `2.env` (`MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_HOST`).  
- Ejecutar en orden los notebooks:

  1. `01_extraccion_consolidacion.ipynb`  
  2. `02_modelado_mysql.ipynb`  
  3. `03_premios_yanelis_awards.ipynb`

4. **Explorar los premios**
En `03_premios_yanelis_awards.ipynb` encontrarás consultas que calculan:

- Ganadores por categoría (canción, artista, álbum, género, año).  
- Tablas de resultados y rankings para la “gala” de los Yaneli’s Awards.

---
## Ejemplos de premios calculados

- **Álbum atemporal 2010–2024** – álbum con popularidad sostenida a lo largo del periodo.  
- **Top Hits 2010–2024** – artista con mayor suma de popularidad / playcount.  
- **Álbum más sólido** – álbum con mayor popularidad media de sus canciones.  
- **Álbum más variado** – álbum con mayor diversidad de géneros o colaboraciones.  
- **Género del año** – género con mayor popularidad media en cada año.

---

## Equipo

Proyecto realizado por el equipo **QUERY QUEENS** (5 miembros):
<p align="center">
  <img width="158" height="320" alt="image" src="https://github.com/user-attachments/assets/8e90d244-b514-4cbb-b409-ebec8cd8903c" />
<img width="222" height="215" alt="image" src="https://github.com/user-attachments/assets/cf788289-0291-4fdd-8d3c-4ef41c3317f2" />
<img width="220" height="300" alt="image" src="https://github.com/user-attachments/assets/34d5480b-2beb-4600-a70d-d3fd1d66b055" />
<img width="136" height="348" alt="image" src="https://github.com/user-attachments/assets/69797b64-f0ad-4b6a-8b43-d8ab68ddfe95" />
<img width="212" height="218" alt="image" src="https://github.com/user-attachments/assets/8e18da99-bcbe-4074-a8fe-9bc6dde5ec88" />
</p>


- HANNIA CORENA (Scrum Master) – coordinación, Git & documentación
- CRISTINA ARAGON – extracción de datos y consolidación  
- RUTH PÉREZ SEGOVIA – modelado relacional y SQL  
- RUTH CUEVAS – limpieza avanzada & calidad de datos  
- ROCIO SANCHEZ – análisis de premios y storytelling  



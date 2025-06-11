# trabajo_final_analisis_de_datos Análisis de Instituciones Educativas y Enseñanza de Idiomas

Este proyecto tiene como objetivo analizar si los colegios privados tienen mayor probabilidad de ofrecer enseñanza en idiomas extranjeros diferentes al inglés, utilizando datos abiertos del Ministerio de Educación de Colombia.

---

## 📁 Estructura del proyecto
📦 proyecto-raíz
├── data/
│ ├── original/ # Datos crudos originales (CSV)
│ └── limpio/ # Datos limpios para análisis
├── sql/
│ ├── convertir_csv_a_sql.sql # Script de creación e inserción SQL
│ └── consultas.sql # Consultas SQL realizadas
├── powerbi/
│ └── dashboard.pbix # Visualización Power BI
├── notebooks/
│ ├── limpieza.ipynb # Notebook de limpieza y exploración
│ └── modelado_idiomas.ipynb # Notebook de modelado y algunas visualizaciónes
├── README.md

---

## 🔧 Fases del Proyecto

### 1. Limpieza de Datos
- Se usó **Pandas** para limpiar el dataset original.
- Se eliminaron nulos irrelevantes y se normalizaron columnas de texto.
- Resultado: CSV limpio guardado en `data/limpio/`.

### 2. Conversión a SQL
- Se convirtió el CSV limpio a tabla SQL para facilitar consultas.
- Se utilizó Mysql.

### 3. Visualización en Power BI
- Se crearon dashboards para visualizar:
  - Distribución de colegios por idioma.
  - Comparación entre colegios públicos y privados.

### 4. Consultas SQL
- Se escribieron consultas para analizar la presencia de idiomas extranjeros (excluyendo inglés).

### 5. Modelado con Python
- Se implementó una regresión logística para estimar la probabilidad de que un colegio ofrezca idiomas extranjeros.
- Se graficaron resultados y probabilidades promedio por tipo de institución.

---

## 📊 Resultado del modelo

> El modelo muestra que **los establecimientos eductaivos privados en Colombia tienen una mayor probabilidad estimada de ofrecer idiomas extranjeros diferentes al inglés** que los establecimientos educativos públicos en Colombia.

---

## 👥 Equipo

- Este repositorio fue trabajado por un equipo de 6 personas, cada uno a cargo de una parte específica del proceso (ver sección Tickets en trello).

---

Clasificación de establecimientos (Público vs Privado)

La columna prestador_de_servicio fue clasificada en *público* o *privado* con base en la fuente oficial del Ministerio de Educación Nacional (Education Profiles – Colombia) y en la normativa educativa colombiana (Ley 115 de 1994 y Decretos reglamentarios).

Se consideró *público* a los prestadores financiados o gestionados por el Estado, y *privado* a aquellos gestionados por entidades no estatales, aunque puedan recibir contratos o recursos públicos.

| Prestador de servicio              | Clasificación |
|-----------------------------------|----------------|
| Oficial                           | Público        |
| Contratada                        | Público        |
| Concesión                         | Público        |
| Régimen especial                  | Público        |
| Natural                           | Privado        |
| Comunidad religiosa               | Privado        |
| Cooperativo                       | Privado        |
| Fundación o Corporaciones         | Privado        |
| Federaciones                      | Privado        |
| Caja de compensación              | Privado        |
| Comunidad                         | Privado        |
| Sociedad                          | Privado        |
| Educación misional contratada     | Privado        |
Fuente: Education Profiles – Colombia y legislación educativa nacional.

## 💡 Requisitos

- Python
- Pandas, Seaborn, Matplotlib, Scikit-learn
- Power BI
- Mysql


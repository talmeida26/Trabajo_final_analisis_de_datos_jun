USE edu_col;

/* 
  Contar todas las instituciones que enseñan al menos un idioma.
  Se excluyen registros donde el campo 'idiomas' sea NULL o contenga 'NaN'.
*/
SELECT COUNT(*)
FROM establecimientos_educativos
WHERE idiomas IS NOT NULL
  AND idiomas <> 'NaN';


/* 
  Contar colegios que enseñan al menos un idioma extranjero distinto del inglés.
  La columna 'idiomas' puede contener varios idiomas separados por comas, por eso se expande.
  Se elimina cualquier idioma que sea 'ingles' o 'inglés'.
*/
SELECT COUNT(id) AS colegios_con_idioma_extranjero
FROM (
  SELECT 
    id,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(idiomas, ',', n.n), ',', -1)) AS idioma
  FROM establecimientos_educativos e
  JOIN (
    -- Serie de números para separar hasta 10 idiomas por registro
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
    UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8
    UNION ALL SELECT 9 UNION ALL SELECT 10
  ) n ON CHAR_LENGTH(e.idiomas) - CHAR_LENGTH(REPLACE(e.idiomas, ',', '')) >= n.n - 1
  WHERE e.idiomas IS NOT NULL AND e.idiomas <> 'NaN'
) idiomas_expandidos
WHERE LOWER(TRIM(idioma)) NOT IN ('ingles', 'inglés');


/*
  Contar colegios que enseñan al menos un idioma extranjero (excluyendo inglés),
  agrupados por tipo de institución (Público o Privado).
  
  Definición de tipo de institución:
  - Público: prestador_de_servicio en ('OFICIAL', 'EDUCACION MISIONAL CONTRATADA', 'CONCESION', 'REGIMEN ESPECIAL')
  - Privado: cualquier otro valor
  
  Se expande la lista de idiomas y se filtra para eliminar inglés.
*/
SELECT
  tipo_institucion,
  COUNT(id) AS colegios_con_idiomas_extranjeros
FROM (
  SELECT 
    id,
    CASE
      WHEN prestador_de_servicio IN (
        'OFICIAL', 
        'EDUCACION MISIONAL CONTRATADA', 
        'CONCESION',
        'REGIMEN ESPECIAL'
      ) THEN 'PUBLICO'
      ELSE 'PRIVADO'
    END AS tipo_institucion,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(idiomas, ',', n.n), ',', -1)) AS idioma
  FROM establecimientos_educativos e
  JOIN (
    -- Serie para separar hasta 10 idiomas
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
    UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8
    UNION ALL SELECT 9 UNION ALL SELECT 10
  ) n ON CHAR_LENGTH(e.idiomas) - CHAR_LENGTH(REPLACE(e.idiomas, ',', '')) >= n.n - 1
  WHERE e.idiomas IS NOT NULL AND e.idiomas <> 'NaN'
) idiomas_expandido
WHERE LOWER(TRIM(idioma)) NOT IN ('ingles', 'inglés')
GROUP BY tipo_institucion;


/* 
  Contar colegios que enseñan al menos un idioma extranjero (excluyendo inglés), 
  segmentados por estrato socioeconómico y tipo de institución (Público o Privado).
  
  1. Se clasifica el estrato socioeconómico en rangos 'ESTRATO 1' a 'ESTRATO 6'.
     Los valores que no coincidan quedan como 'SIN ESTRATO' y se excluyen.
  2. Se clasifica el tipo de institución basado en 'prestador_de_Servicio'.
  3. Se filtran registros que tienen al menos un idioma distinto del inglés.
  4. Se agrupa por estrato y tipo de institución y se cuenta la cantidad de colegios.
*/
SELECT
  estrato,
  tipo_institucion,
  COUNT(*) AS cantidad
FROM (
  SELECT
    CASE
      WHEN estrato_socio_economico LIKE '%ESTRATO 1%' THEN 'ESTRATO 1'
      WHEN estrato_socio_economico LIKE '%ESTRATO 2%' THEN 'ESTRATO 2'
      WHEN estrato_socio_economico LIKE '%ESTRATO 3%' THEN 'ESTRATO 3'
      WHEN estrato_socio_economico LIKE '%ESTRATO 4%' THEN 'ESTRATO 4'
      WHEN estrato_socio_economico LIKE '%ESTRATO 5%' THEN 'ESTRATO 5'
      WHEN estrato_socio_economico LIKE '%ESTRATO 6%' THEN 'ESTRATO 6'
      ELSE 'SIN ESTRATO'
    END AS estrato,
    CASE
      WHEN prestador_de_Servicio IN ('OFICIAL', 'REGIMEN ESPECIAL', 'EDUCACION MISIONAL CONTRATADA') THEN 'Público'
      ELSE 'Privado'
    END AS tipo_institucion,
    idiomas
  FROM establecimientos_educativos
  WHERE idiomas <> 'NaN'
) sub
WHERE EXISTS (
  -- Verifica que el colegio tenga al menos un idioma distinto del inglés
  SELECT 1
  FROM (
    SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(sub.idiomas, ',', n.n), ',', -1)) AS idioma
    FROM (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
          UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8
          UNION ALL SELECT 9 UNION ALL SELECT 10) n
    WHERE n.n <= 1 + LENGTH(sub.idiomas) - LENGTH(REPLACE(sub.idiomas, ',', ''))
  ) idiomas_separados
  WHERE LOWER(idioma) NOT IN ('ingles', 'inglés')
)
AND estrato <> 'SIN ESTRATO'
GROUP BY estrato, tipo_institucion
ORDER BY estrato, tipo_institucion;


/* 
  Contar colegios que enseñan al menos un idioma extranjero (excluyendo inglés),
  agrupados por zona y tipo de institución (Público o Privado).
  
  Parámetros:
  - Se considera público si 'prestador_de_servicio' está en ('OFICIAL', 'EDUCACION MISIONAL CONTRATADA', 'CONCESION', 'REGIMEN ESPECIAL').
  - Se expanden los idiomas para manejar múltiples separados por coma.
  - Se filtran idiomas inglés o inglés.
  - Se agrupa por zona y tipo de institución.
*/

	SELECT
	  zona,  -- Cambia 'zona' por el nombre correcto del campo si es otro (ejemplo: region, departamento)
	  tipo_institucion,
	  COUNT(id) AS colegios_con_idiomas_extranjeros
	FROM (
	  SELECT 
		id,
		zona,
		CASE
		  WHEN prestador_de_servicio IN (
			'OFICIAL', 
			'EDUCACION MISIONAL CONTRATADA', 
			'CONCESION',
			'REGIMEN ESPECIAL'
		  ) THEN 'PUBLICO'
		  ELSE 'PRIVADO'
		END AS tipo_institucion,
		TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(idiomas, ',', n.n), ',', -1)) AS idioma
	  FROM establecimientos_educativos e
	  JOIN (
		-- Serie para separar hasta 10 idiomas por registro
		SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
		UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8
		UNION ALL SELECT 9 UNION ALL SELECT 10
	  ) n ON CHAR_LENGTH(e.idiomas) - CHAR_LENGTH(REPLACE(e.idiomas, ',', '')) >= n.n - 1
	  WHERE e.idiomas IS NOT NULL AND e.idiomas <> 'NaN'
	) idiomas_expandido
	WHERE LOWER(TRIM(idioma)) NOT IN ('ingles', 'inglés')
	GROUP BY zona, tipo_institucion
	ORDER BY zona, tipo_institucion;

-- parte 2.2 -- consulta

SELECT nombre, fecha_nacimiento, patrimonio
FROM actor_por_id
WHERE nacionalidad = 'Chile' AND edad > 40
LIMIT 10
ALLOW FILTERING;


-- parte 2.3 -- sai

CREATE INDEX id_nacionalidad
ON actor_por_id (nacionalidad)
USING 'sai';

CREATE INDEX id_edad
ON actor_por_id (edad)
USING 'sai';

CREATE INDEX id_idiomas
ON actor_por_id (idiomas)
USING 'sai';

-- parte 2.3 -- consulta 1

SELECT nombre, fecha_nacimiento, patrimonio
FROM actor_por_id
WHERE nacionalidad = 'Chile'
LIMIT 10;


-- parte 2.3 -- consulta 2

SELECT nombre, fecha_nacimiento, patrimonio
FROM actor_por_id
WHERE edad > 40
LIMIT 10;


-- parte 2.3 -- consulta 3

SELECT nombre, fecha_nacimiento, patrimonio
FROM actor_por_id
WHERE nacionalidad = 'Chile' AND edad > 40
LIMIT 10;


-- parte 2.3 -- consulta 4
SELECT actor_id, nombre, nacionalidad, edad, idiomas
FROM actor_por_id
WHERE idiomas CONTAINS 'Espanol'
LIMIT 10;

-- parte 2.4 -- consulta especializada

SELECT actor_id, nombre, nacionalidad, edad, fecha_nacimiento, patrimonio
FROM actores_por_nacionalidad
WHERE nacionalidad = 'Chile'
LIMIT 10;

-- parte 2.4 -- consulta con indice

SELECT actor_id, nombre, nacionalidad, edad, fecha_nacimiento, patrimonio
FROM actor_por_id
WHERE nacionalidad = 'Chile'
LIMIT 10;
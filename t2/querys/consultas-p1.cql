-- parte 1 -- consulta 1

SELECT nombre, nacionalidad, edad, idiomas
FROM actor_por_id
WHERE actor_id = 10
LIMIT 10;


-- parte 1 -- consulta 2

SELECT actor_id, nombre, nacionalidad, edad
FROM actores_por_nacionalidad
WHERE nacionalidad = 'Chile'
LIMIT 10;


-- parte 1 -- consulta 3

SELECT nombre_personaje,
       produccion,
       tipo_produccion,
       rol,
       apariciones,
       generos
FROM personajes_por_actor_rol
WHERE actor_id = 15 AND rol = 'Principal'
ORDER BY apariciones DESC
LIMIT 10;


-- parte 1 -- consulta 4

SELECT nombre, edad, fecha_nacimiento, patrimonio
FROM actores_por_nacionalidad
WHERE nacionalidad = 'Chile'
ORDER BY edad ASC
LIMIT 5;



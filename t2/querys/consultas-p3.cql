-- parte 3.2 -- inserciones

INSERT INTO actor_por_id (
    actor_id, nombre, nacionalidad, fecha_nacimiento,
    edad, patrimonio, idiomas
)
VALUES (
    100, 'Yoel Ramírez', 'España', '1996-05-15',
    30, 150000000, {'Espanol', 'Ingles'}
);


INSERT INTO actor_por_id (
    actor_id, nombre, nacionalidad, fecha_nacimiento,
    edad, patrimonio, idiomas
)
VALUES (
    101, 'Camila Torres', 'Chile', '1998-03-12',
    28, 95000000, {'Espanol', 'Ingles'}
);


INSERT INTO actor_por_id (
    actor_id, nombre, nacionalidad, fecha_nacimiento,
    edad, patrimonio, idiomas
)
VALUES (
    102, 'Diego Morales', 'Mexico', '1985-07-24',
    41, 230000000, {'Espanol', 'Portugues'}
);


INSERT INTO actor_por_id (
    actor_id, nombre, nacionalidad, fecha_nacimiento,
    edad, patrimonio, idiomas
)
VALUES (
    103, 'Lucia Fernandez', 'Argentina', '1992-11-08',
    33, 170000000, {'Espanol', 'Italiano'}
);


INSERT INTO actor_por_id (
    actor_id, nombre, nacionalidad, fecha_nacimiento,
    edad, patrimonio, idiomas
)
VALUES (
    104, 'Javier Ortega', 'España', '1974-02-19',
    52, 420000000, {'Espanol', 'Frances', 'Ingles'}
);


INSERT INTO actor_por_id (
    actor_id, nombre, nacionalidad, fecha_nacimiento,
    edad, patrimonio, idiomas
)
VALUES (
    105, 'Sofia Almeida', 'Brasil', '2001-06-30',
    25, 65000000, {'Portugues', 'Espanol'}
);

-- parte 3.2 -- consultas

SELECT nombre, nacionalidad, edad, idiomas
FROM actor_por_id
WHERE actor_id = {100,101,102,103,104,105}
LIMIT 10;

-- parte 3.3 -- consultas

SELECT nombre, nacionalidad, edad, idiomas
FROM actor_por_id
WHERE actor_id IN (100, 101, 102, 103, 104, 105);
LIMIT 10;

-- parte 3.4 -- consulta

SELECT actor_id, nombre, edad, patrimonio
FROM actor_por_id
WHERE actor_id IN (0, 3);

SELECT actor_id, nombre, edad, patrimonio
FROM actores_por_nacionalidad
WHERE nacionalidad = 'Chile';

SELECT actor_id, rol, nombre_personaje, produccion, apariciones
FROM personajes_por_actor_rol
WHERE actor_id = 0 AND rol = 'Principal';

SELECT actor_id, rol, nombre_personaje, produccion, apariciones
FROM personajes_por_actor_rol
WHERE actor_id = 3 AND rol = 'Secundario';
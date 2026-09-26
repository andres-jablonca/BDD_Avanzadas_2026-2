
CREATE TABLE IF NOT EXISTS actor_por_id (
    actor_id int,
    nombre text,
    nacionalidad text,
    fecha_nacimiento date,
    edad int,
    patrimonio bigint,
    idiomas set<text>,
    PRIMARY KEY (actor_id)
);

CREATE TABLE IF NOT EXISTS actores_por_nacionalidad (
    nacionalidad text,
    edad int,
    actor_id int,
    nombre text,
    fecha_nacimiento date,
    patrimonio bigint,
    idiomas set<text>,
    PRIMARY KEY ((nacionalidad), edad, actor_id)
)
WITH CLUSTERING ORDER BY (edad DESC, actor_id ASC);

CREATE TABLE IF NOT EXISTS personajes_por_actor_rol (
    actor_id int,
    rol text,
    apariciones int,
    nombre_personaje text,
    produccion text,
    tipo_produccion text,
    generos set<text>,
    PRIMARY KEY ((actor_id, rol), apariciones, nombre_personaje)
)
WITH CLUSTERING ORDER BY (apariciones DESC, nombre_personaje ASC);

import json
from decimal import Decimal, ROUND_HALF_UP
from pathlib import Path

from cassandra import ConsistencyLevel
from cassandra.cluster import Cluster
from cassandra.query import SimpleStatement

RESULTADOS = Path("results")
RESULTADOS.mkdir(exist_ok=True)


def guardar(nombre, datos):
    (RESULTADOS / nombre).write_text(
        json.dumps(datos, ensure_ascii=False, indent=2, default=str),
        encoding="utf-8",
    )


cluster = Cluster(["127.0.0.1"], port=9042)

try:
    session = cluster.connect("actors")
    session.default_timeout = 30

    def preparar(cql):
        sentencia = session.prepare(cql)
        sentencia.consistency_level = ConsistencyLevel.QUORUM
        return sentencia

    consultar_actores = SimpleStatement(
        "SELECT * FROM actor_por_id",
        consistency_level=ConsistencyLevel.QUORUM,
        fetch_size=100,
    )

    consultar_copia = preparar("""
        SELECT * FROM actores_por_nacionalidad
        WHERE nacionalidad = ? AND edad = ? AND actor_id = ?
    """)

    consultar_personajes = preparar("""
        SELECT * FROM personajes_por_actor_rol
        WHERE actor_id = ? AND rol = ?
    """)

    actualizar_principal = preparar("""
        UPDATE actor_por_id SET patrimonio = ?
        WHERE actor_id = ?
    """)

    actualizar_copia = preparar("""
        INSERT INTO actores_por_nacionalidad (
            nacionalidad, edad, actor_id, nombre,
            fecha_nacimiento, patrimonio, idiomas
        ) VALUES (?, ?, ?, ?, ?, ?, ?)
    """)

    insertar_personaje = preparar("""
        INSERT INTO personajes_por_actor_rol (
            actor_id, rol, apariciones, nombre_personaje,
            produccion, tipo_produccion, generos
        ) VALUES (?, ?, ?, ?, ?, ?, ?)
    """)

    def evidencia():
        registros = []
        for actor in session.execute(consultar_actores):
            copia = session.execute(
                consultar_copia,
                (actor.nacionalidad, actor.edad, actor.actor_id),
            ).one()

            personajes = []
            for rol in ("Principal", "Secundario"):
                for personaje in session.execute(
                    consultar_personajes, (actor.actor_id, rol)
                ):
                    if personaje.produccion == "Sansa Ball Race":
                        personajes.append(personaje._asdict())

            registros.append({
                "actor": actor._asdict(),
                "copia_por_nacionalidad":
                    copia._asdict() if copia else None,
                "participaciones_sansa": personajes,
            })

        return sorted(registros, key=lambda r: r["actor"]["actor_id"])

    # Se conserva el patrimonio original para que, si el script
    # se interrumpe, pueda repetirse sin aplicar otro aumento.
    ruta_plan = RESULTADOS / "sansa_plan.json"

    if ruta_plan.exists():
        plan = json.loads(ruta_plan.read_text(encoding="utf-8"))
    else:
        antes = evidencia()
        plan = []

        for registro in antes:
            actor = registro["actor"]

            if any(actor[campo] is None for campo in
                   ("patrimonio", "edad", "nacionalidad")):
                raise ValueError(
                    f"Datos incompletos del actor {actor['actor_id']}"
                )

            nuevo = int(
                (Decimal(actor["patrimonio"]) * Decimal("1.32"))
                .quantize(Decimal("1"), rounding=ROUND_HALF_UP)
            )

            plan.append({
                "actor_id": actor["actor_id"],
                "patrimonio_original": actor["patrimonio"],
                "patrimonio_nuevo": nuevo,
                "rol": "Principal" if actor["edad"] < 40 else "Secundario",
                "apariciones": 3 if actor["edad"] < 40 else 1,
            })

        guardar("sansa_antes.json", antes)
        guardar("sansa_plan.json", plan)

    actores = {
        actor.actor_id: actor
        for actor in session.execute(consultar_actores)
    }

    for cambio in plan:
        actor = actores[cambio["actor_id"]]
        nuevo = cambio["patrimonio_nuevo"]

        session.execute(
            actualizar_principal, (nuevo, actor.actor_id)
        )

        # También crea la copia completa si faltaba, como podría
        # ocurrir con los actores insertados en las pruebas.
        session.execute(actualizar_copia, (
            actor.nacionalidad, actor.edad, actor.actor_id,
            actor.nombre, actor.fecha_nacimiento,
            nuevo, actor.idiomas,
        ))

        session.execute(insertar_personaje, (
            actor.actor_id,
            cambio["rol"],
            cambio["apariciones"],
            "Sansa",
            "Sansa Ball Race",
            "Profesional",
            {"Animacion", "Aventura"},
        ))

    despues = evidencia()
    guardar("sansa_despues.json", despues)

    por_id = {
        registro["actor"]["actor_id"]: registro
        for registro in despues
    }

    for cambio in plan:
        registro = por_id[cambio["actor_id"]]
        copia = registro["copia_por_nacionalidad"]

        if (
            registro["actor"]["patrimonio"] != cambio["patrimonio_nuevo"]
            or copia is None
            or copia["patrimonio"] != cambio["patrimonio_nuevo"]
            or not any(
                p["rol"] == cambio["rol"]
                and p["apariciones"] == cambio["apariciones"]
                and p["nombre_personaje"] == "Sansa"
                for p in registro["participaciones_sansa"]
            )
        ):
            raise RuntimeError(
                f"Verificación fallida: actor {cambio['actor_id']}"
            )

    print(f"Actualización verificada para {len(plan)} actores.")
    print("Evidencia: results/sansa_antes.json y sansa_despues.json")

finally:
    cluster.shutdown()
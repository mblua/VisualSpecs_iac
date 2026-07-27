# Panel de arquitectura — repositorios y límites de proceso de MiContador

## Objetivo

Preparar una recomendación conversacional, en español, sobre dos decisiones independientes:

1. Un monorepo/Cargo workspace para todos los crates frente a varios repositorios.
2. `web-backend` y `mi-contador-core-server` embebidos en un mismo ejecutable frente a procesos/binarios separados.

No modificar `Architecture.md` ni ningún archivo del repositorio sin petición posterior del usuario.

## Fuente

- `repo-personal/ObsidianVault/Proyectos/MiContador/Architecture.md`, leído completo por el coordinador.
- Objetivo declarado por el documento: conservar la lógica de negocio y poder desplegar componentes juntos, separados en un host o distribuidos.

## Criterios de aceptación

- Separar claramente cuatro conceptos que suelen confundirse: repositorio, Cargo workspace/crate, binario y proceso/despliegue.
- Dar una recomendación inicial concreta y reversible, no sólo una lista neutral de pros/contras.
- Comparar coste de desarrollo, cambios atómicos, versionado, CI, ownership, seguridad, rendimiento, fallos, escalado, observabilidad y operación.
- Explicar cuándo cambia la recomendación: equipos/ownership independientes, cadencias de release distintas, permisos/compliance, múltiples canales activos, necesidad de escalar o aislar fallos.
- Tratar explícitamente el riesgo de que varios backends de canal embeban copias del core (estado, jobs, migraciones y acceso concurrente a BD).
- Proponer una estructura concreta del workspace y composition roots, indicando si conviene mantener binarios compuestos y separados simultáneamente.
- Basar afirmaciones relevantes en evidencia verificable (documentación oficial de Cargo/Rust/NATS o principios operativos concretos), diferenciando hechos de preferencias.
- Mantener una respuesta útil para conversación: conclusión breve, matriz de decisión y preguntas que permitirían ajustar el consejo.

## Supuestos transparentes

Hasta que el usuario los corrija:

- Es un producto en fase inicial con un equipo pequeño.
- No hay todavía exigencias de ownership, permisos o releases independientes por componente.
- Se busca minimizar complejidad inicial sin cerrar la separación futura.
- No se ha pedido publicar cambios en el documento.

## Panel y rotación

- Autor inicial: `architect-2` (rotación posterior al último panel, cuyo autor fue `architect-1`).
- Críticos independientes: `architect-1` y `architect-3`.
- El usuario limitó expresamente el trabajo a una sola ronda y autorizó publicar con acuerdo de al menos dos voces.

## Estado

- [x] Artefacto fuente leído completo.
- [x] `purge-wg --dry-run` pasó y `purge-wg` real terminó con estado `purged` antes del panel.
- [x] Ronda 0 de `architect-2`: propuesta completa, evidencia oficial, dissent y reporte `COMPLETADO` sin blockers (`20260724-232727-wg2-architect-2-to-wg2-experts-coordinator-mi-contador-r0.md`).
- [x] Crítica independiente completada por `architect-1` y `architect-3`; ambos reportaron `COMPLETADO`, sin blockers, y `APRUEBO CON CAMBIOS`.
- [x] Acuerdo 3/3 sobre la dirección central: monorepo + Cargo workspace + monolito modular compuesto como default inicial. Acuerdo 3/3 en que el requisito literal multi-topología de §§1/13 obliga a mantener/probar Direct y NATS desde V1, salvo que el usuario lo rebaje explícitamente a evolvabilidad futura.
- [x] Única ronda cerrada por instrucción del usuario; se incorporan a la respuesta las correcciones coincidentes sobre deployable/réplica, contrato semántico frente a wire, JetStream como proceso externo, seguridad efectiva y coordinación multi-réplica.
- [x] Respuesta final conversacional; sin edición de `Architecture.md`.

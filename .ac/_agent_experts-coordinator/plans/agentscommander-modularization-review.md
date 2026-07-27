# Panel de arquitectura — modularización de AgentsCommander

## Objetivo

Producir una propuesta de refactorización modular, basada en evidencia del repositorio actual, que permita evolucionar AgentsCommander sin un big-bang rewrite. Tras la precisión del usuario, el artefacto principal será un conjunto de reglas normativas, precisas y verificables para crear o refactorizar módulos alineados con dominios específicos.

## Alcance

- Repositorio: `repo-AgentsCommander`.
- Backend Rust/Tauri, CLI/API/daemon y frontend TypeScript/Solid.
- Diseño y plan de migración solamente; no modificar código productivo.

## Criterios de aceptación

1. Referenciar rutas, dependencias o métricas concretas del estado actual; no diagnosticar por intuición.
2. Presentar al menos 3 alternativas reales, incluida la opción conservadora, con ventajas, costes y riesgos.
3. Recomendar una arquitectura objetivo con límites de módulo/crate/package, responsabilidades y dirección permitida de dependencias.
4. Preservar compatibilidad observable de GUI, CLI, API, configuración y persistencia durante una migración incremental.
5. Definir fases pequeñas, ordenadas y reversibles, con gates verificables (`cargo check/test`, tests frontend y controles de dependencias).
6. Identificar primeros seams de extracción, cross-cutting concerns que conviene mantener juntos y antiobjetivos explícitos.
7. Incluir estrategia de tests, ownership y prevención de recaída al monolito.
8. Distinguir claramente hechos observados, hipótesis por validar y decisiones propuestas.
9. Formular reglas numeradas con lenguaje normativo (`MUST`/`MUST NOT`), alcance, ejemplo conforme/no conforme y gate automatizable.
10. Cubrir tanto código nuevo como migración brownfield, y definir qué convierte un conjunto de archivos en un dominio cohesivo, no sólo en una carpeta.
11. Incluir una matriz explícita de dependencias permitidas entre dominio, aplicación/casos de uso, puertos, adaptadores/infraestructura, presentación y composition root.
12. Precisar ownership de estado y datos, APIs públicas, visibilidad, ciclos, imports laterales, DTOs, efectos, persistencia, configuración y eventos.
13. Explicar cuándo usar módulo interno frente a crate/package independiente y cómo evitar granularidad artificial.

## Panel y rotación

- Autor inicial: `architect-3` (siguiente rotación tras el último artefacto cuyo autor fue `architect-2`).
- Críticos independientes: `architect-1` y `architect-2`.
- Hasta 3 rondas; objetivo de consenso unánime. Si no se logra, voto documentado según el proceso del panel.
- Los especialistas sólo proponen mediante mensajes; no editan el repositorio.

## Estado

- [x] `purge-wg` dry-run: gate aprobado.
- [x] `purge-wg` real: completado; no había sesiones activas que destruir.
- [x] Ronda 0: propuesta inicial completa por `architect-3` (`20260724-140613-wg2-architect-3-to-wg2-experts-coordinator-modularization-r0.md`); reportó `COMPLETADO`, sin blocker y sin cambios en repo.
- [x] Ronda 1: dos críticas independientes completadas.
  - `architect-1`: `APRUEBO CON CAMBIOS`, lista cerrada C1–C10 (`20260724-142514-wg2-architect-1-to-wg2-experts-coordinator-modularization-critique-r1.md`).
  - `architect-2`: `APRUEBO CON CAMBIOS`, lista cerrada C1–C9 (`20260724-143034-wg2-architect-2-to-wg2-experts-coordinator-modularization-critique-r1.md`).
  - Convergencia principal: descubrir/charterizar dominios antes de fijar crates; separar Delivery/ControlPlane de ownership Session/Workspace; cerrar matriz y ownership lógico; gates auto-probados; debt exacta; trust/concurrencia/task lifecycle; contratos consumidor-productor; composition least-privilege; extracción física sólo por evidencia.
- [x] Ronda 2: v2 completa por `architect-3` (`20260724-144429-wg2-architect-3-to-wg2-experts-coordinator-modularization-v2-r2.md`); aceptó con fundamento las 19 críticas y reportó `COMPLETADO`, sin blocker para revisión.
- [x] Ronda 3: veredictos finales independientes.
  - `architect-1`: C1–C10 `CERRADO`, sin blockers, `APRUEBO` (`20260724-145402-wg2-architect-1-to-wg2-experts-coordinator-modularization-verdict-r3.md`).
  - `architect-2`: C1–C9 `CERRADO`, sin blockers, `APRUEBO` (`20260724-145303-wg2-architect-2-to-wg2-experts-coordinator-modularization-verdict-r3.md`).
- [x] Artefacto curado publicado en `repo-AgentsCommander/docs/reference/domain-modularization.md`.

## Resultado y voto

- Resultado: **consenso unánime 3/3**; no fue necesario voto por mayoría ni arbitraje del coordinador.
- Autor: `architect-3`, v2 incorporó las 19 críticas.
- Críticos: `architect-1` y `architect-2`, ambos `APRUEBO` y cero blockers residuales.
- Disidentes: ninguno.
- Corrección editorial aplicada al publicar: registry Tauri = 137 handlers (hallazgo opcional y evidenciado de `architect-2`), no 136.

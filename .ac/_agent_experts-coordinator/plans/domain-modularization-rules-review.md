# Panel de arquitectura — reglas objetivas para modularización por dominio

## Objetivo

Crear un documento operativo junto a `domain-modularization.md` que convierta la propuesta arquitectónica en un procedimiento reproducible para:

1. decidir si una capacidad es dominio, subdominio/módulo, adapter, contrato, presentation o composition;
2. asignar exhaustivamente cada archivo a un único contexto owner y a un rol arquitectónico;
3. detectar de manera verificable archivos mixtos que deben dividirse;
4. decidir qué funciones/tipos deben migrar y hacia dónde;
5. demostrar para cada regla un estado observable `ANTES` y un estado verificable `DESPUÉS`.

## Ubicación final

`repo-personal/ObsidianVault/Proyectos/AgentsCommander/Refactoring/domain-modularization-rules.md`, junto a `domain-modularization.md`.

## Fuente

- `repo-personal/ObsidianVault/Proyectos/AgentsCommander/Refactoring/domain-modularization.md` (587 líneas, commit `b0e3404`, idéntico al artefacto aprobado por el panel anterior).
- Repositorio de evidencia: `repo-AgentsCommander`, commit base documentado `0a3dc5a...`.

## Criterios de aceptación del usuario

1. Explicar qué evidencia convierte o no una capacidad en dominio; no usar sólo preguntas vagas como “¿qué dominios existen?”.
2. Dar un procedimiento exhaustivo para clasificar cada archivo y explicar dónde registrar la clasificación.
3. Reglas lógicas, claras y objetivas para dominio, pertenencia de archivo, división de archivo y migración de funciones/tipos.
4. Cada regla debe declarar: input observable, predicado/decisión, acción obligatoria, `ANTES`, `DESPUÉS`, gate y excepción cerrada.
5. Distinguir hechos verificables automáticamente de decisiones semánticas; no llamar “objetivo” a una preferencia no medible.
6. Ningún scoring o umbral arbitrario sin justificación. Los resultados deben ser deterministas dados los inputs registrados.
7. Cubrir greenfield y brownfield, incluidos tests, generated code, contracts, adapters y composition.
8. Proponer manifest/schema y decision trees que permitan cobertura de 100% de archivos de producción, sin ownership múltiple ni globs que oculten casos.
9. Incluir ejemplos conformes/no conformes y casos reales de AgentsCommander (`mailbox`, `selection`, `settings`, `shared/ipc` u otros verificados).
10. Incluir una checklist ejecutable de auditoría y criterios de cierre medibles del refactor.
11. El núcleo normativo debe ser genérico para cualquier aplicación y lenguaje: usar conceptos como contexto, unidad modular, archivo, símbolo, dependencia, boundary y artefacto desplegable, sin asumir Cargo, crates, npm, Tauri o AgentsCommander.
12. Toda especialización debe etiquetarse y aislarse (`[RUST]`, `[TYPESCRIPT]`, etc.): puede traducir la regla genérica a crates/módulos/visibilidad o packages/imports/tooling, pero no cambiar su semántica. Los casos de AgentsCommander son ejemplos, no precondiciones del método.

## Panel y rotación

- Autor inicial: `architect-1` (rotación posterior al último artefacto, cuyo autor fue `architect-3`).
- Críticos independientes: `architect-2` y `architect-3`.
- Hasta tres rondas buscando unanimidad.
- Los especialistas proponen por mensajes y no editan repositorios.

## Estado

- [x] `purge-wg` dry-run aprobado.
- [x] `purge-wg` real completado; no había sesiones activas.
- [x] Ronda 0: artefacto inicial completo por `architect-1` (`20260724-165628-wg2-architect-1-to-wg2-experts-coordinator-domain-rules-r0.md`); 12 reglas, núcleo `[GENERIC]`, overlays `[RUST]`/`[TYPESCRIPT]`, cuatro ejemplos y reporte `COMPLETADO` sin blocker de revisión.
- [x] Ronda 1: críticas independientes completadas.
  - `architect-2`: `RECHAZO`, lista cerrada B01–B08 (`20260724-170912-wg2-architect-2-to-wg2-experts-coordinator-domain-rules-critique-r1.md`).
  - `architect-3`: `RECHAZO`, lista cerrada B01–B10 (`20260724-171046-wg2-architect-3-to-wg2-experts-coordinator-domain-rules-critique-r1.md`).
  - Convergencia: ejes ortogonales; proposals globales/order-independent; source instances multi-artifact/config/region; álgebra total con `REFACTOR_REQUIRED`; módulos/UID/lineage reales; DAG estático separado de interacciones; crosswalk y reglas omitidas del doc base; ejemplos sólo diagnósticos sin predecidir split/context.
- [x] Ronda 2: v2 completa por `architect-1` (`20260724-173337-wg2-architect-1-to-wg2-experts-coordinator-domain-rules-v2.md`); 13 reglas operativas, CORE/PROFILE/LANG separados, aceptó los 18 blockers y reportó `COMPLETADO` sin editar repositorios.
- [x] Ronda 3: veredictos finales independientes.
  - `architect-3`: B01–B10 `CERRADO`, `APRUEBO`, cero blockers; sugirió opcionalmente precisar tags CORE/PROFILE y materializar `sharing` (`20260724-173905-wg2-architect-3-to-wg2-experts-coordinator-domain-rules-verdict-r3.md`).
  - `architect-2`: B02–B08 `CERRADO`; B01 abierto sólo por esas mismas dos precisiones; `APRUEBO CON CAMBIOS` R-01/R-02 y precompromiso de `APRUEBO` al aplicarlas (`20260724-174007-wg2-architect-2-to-wg2-experts-coordinator-domain-rules-verdict-r3.md`).
- [x] Voto final del autor: R-01 `ACEPTO`, R-02 `ACEPTO`, v2 enmendada `A FAVOR`; autorizó al coordinador a aplicar los cambios textuales (`20260724-174525-wg2-architect-1-to-wg2-experts-coordinator-domain-rules-final-vote.md`).
- [x] Publicado en `repo-personal/ObsidianVault/Proyectos/AgentsCommander/Refactoring/domain-modularization-rules.md`.
- [x] Verificación final: 1302 líneas; OR-01–OR-13 presentes; diez campos por regla; 18 adjudicaciones; R-01/R-02 materializadas; cero marcadores de truncado; whitespace check limpio. Git: archivo nuevo no trackeado, sin otros cambios en `repo-personal`.

## Resultado y voto

- Candidato final: v2 + R-01 + R-02.
- `architect-1`: **A FAVOR** y autoriza publicación.
- `architect-2`: **APRUEBO** condicionado a R-01/R-02; ambas aplicadas exactamente.
- `architect-3`: **APRUEBO**; había recomendado esas mismas dos correcciones como precisiones opcionales.
- Resultado: **unanimidad 3/3**, sin disidentes ni arbitraje del coordinador.

# Plan — CodebaseGuide: plano arquitectónico navegable

**Coordinador:** experts-coordinator · **Workgroup:** wg-3-experts-team  
**Pedido:** crear en `repo-CodebaseConstellation/CodebaseGuide/` una aplicación web nueva, independiente del enfoque SQLite/WebGL existente, y cargar un mapa inicial de `repo-AgentsCommander`.  
**Inicio:** 2026-07-11  
**Skills:** `set-task-title-first` + `artifact-panel-refinement` (architects → developers).

## Resultado esperado

Un MVP ejecutable desde navegador que permita comprender una aplicación sin leer código: jerarquía desde repositorio/aplicación/paquete o crate/directorio hasta archivo, relaciones tipadas entre esos componentes, navegación por doble click, movimiento manual de nodos e importación/exportación de un contrato versionado legible. El diseño visual se inspira en un editor de diagramas tipo Lucidchart, sin copiar su interfaz.

## Alcance vinculante

- Crear un producto nuevo y autocontenido bajo `CodebaseGuide/`; preservar el sistema anterior.
- Granularidad mínima actual: **archivo**. No extraer funciones, métodos ni símbolos.
- Modelo extensible a futuros niveles: infraestructura/servidor → aplicaciones → módulos/paquetes → directorios → archivos.
- Tipos iniciales mínimos: `repository`, `application`, `package`, `crate`, `directory`, `file` y un tipo genérico/extensible.
- Relaciones mínimas: `contains`, dependencias de paquete/crate e imports entre archivos cuando puedan extraerse con evidencia local.
- Doble click expande/colapsa contenedores. Una relación cuyo extremo queda oculto debe proyectarse al ancestro visible más próximo, agregando visualmente relaciones equivalentes; al expandir se restauran sus extremos reales. La relación lógica nunca se pierde ni se reescribe por colapsar.
- Nodos arrastrables; pan, zoom, fit, selección, búsqueda y panel de detalle/leyenda suficientes para explorar el grafo.
- Entrada y salida en el **mismo contrato JSON versionado**. Exportar conserva identidades, jerarquía, relaciones y posiciones cambiadas. El contrato debe aceptar metadatos y clases de nodo/relación nuevas sin acoplarse a Rust.
- Incluir un dataset comprobable de `repo-AgentsCommander`, preferentemente generado por una herramienta reproducible incluida en `CodebaseGuide/` y no por edición manual masiva.
- No depender del SQLite, analytics ni renderer WebGL del approach anterior.

## Requisito nuevo: renderer reemplazable

Separar explícitamente:

1. contrato y validación/serialización;
2. modelo de dominio y comandos de edición;
3. proyección de visibilidad (expandir/colapsar y agregación de aristas);
4. estado/controlador de la aplicación;
5. adapter del renderer;
6. componentes UI.

La biblioteca gráfica concreta no puede filtrarse en el contrato ni en la lógica de proyección. Debe existir un puerto/adapter pequeño o una frontera equivalente demostrable, con tests de la lógica independiente del canvas. Cambiar de renderer no debe exigir reescribir importación, exportación, jerarquía ni agregación de relaciones.

## Criterios de aceptación verificables

1. `npm install`/`npm ci`, tests y build terminan con exit 0 en `CodebaseGuide/`.
2. Al abrir el dataset de AgentsCommander se muestra primero una vista de alto nivel comprensible, no cientos de archivos superpuestos.
3. Un test prueba la proyección `archivo A → archivo B` como `contenedor X → contenedor Y` cuando ambos están colapsados y como `A → B` cuando se expanden.
4. Un test prueba agregación determinista: varias relaciones lógicas equivalentes producen una sola arista visual con contador y referencias a las aristas fuente.
5. Un test prueba importación/exportación round-trip y rechazo explícito de JSON inválido o versión incompatible.
6. La UI permite mover al menos un nodo y exportar la posición nueva; recargar el export restaura esa posición.
7. El dataset incluido referencia rutas reales y manifests reales de AgentsCommander y declara procedencia/tipo de evidencia para relaciones inferidas.
8. README explica instalación, ejecución, generación del dataset, contrato, límites del extractor y cómo sustituir/agregar un renderer.
9. No se modifica ni rompe el `web/` existente; el nuevo módulo tiene scripts y dependencias propios.
10. La revisión final incluye resultado explícito, bloqueos y comandos de verificación ejecutados.
11. Tras la validación final, levantar el servidor local de CodebaseGuide y abrir la app en el navegador predeterminado del usuario; dejar el servidor activo para inspección manual.

## Panel y rotación

- **Arquitectura:** autor inicial `architect-1` (rotación después de architect-3); críticos independientes `architect-2` y `architect-3`.
- **Implementación:** autor inicial `developer-1` (rotación después de developer-3); críticos independientes `developer-2` y `developer-3`.
- Hasta 3 rondas por panel buscando unanimidad; voto documentado si no se alcanza.
- Los autores de artefactos proponen en mensajes y no editan disco durante el panel. El trabajo en repo sólo empieza tras publicar la arquitectura curada.

## Estado

- [x] Título de tarea actualizado.
- [x] `purge-wg --dry-run` pasó y purga real terminó (exit 0).
- [x] Repos inspeccionados; ambos estaban limpios al iniciar.
- [x] Alcance y criterios de aceptación documentados.
- [x] Arquitectura R0 — despachada a architect-1 (`20260711-232106-...-codebaseguide-architecture-r0.md`).
- [x] Arquitectura R0 — recibida completa de architect-1 (`20260711-234500-...-architecture-r0.md`), sin blockers.
- [x] Arquitectura R1 — críticas independientes preparadas para architect-2 y architect-3.
- [x] Arquitectura R1 — recibidas: architect-2 y architect-3 = `APRUEBO CON CAMBIOS`, siete bloqueantes convergentes.
- [x] Coordinador contrastó los puntos críticos contra repos y documentación primaria (transport facade/commands/counts/Cytoscape/TS/Tauri).
- [x] Arquitectura R2 — crítica consolidada preparada para revisión completa de architect-1.
- [x] Arquitectura R2 — v2 completa recibida; C1–C7 aceptados y reescritos; leída íntegramente por el coordinador.
- [x] Arquitectura R3 — veredictos finales independientes preparados para architect-2 y architect-3.
- [x] Arquitectura R3 — architect-2 `APRUEBO`; architect-3 `APRUEBO CON CAMBIOS` (3 bloqueantes residuales).
- [x] Voto final architects: **2–1 a favor de publicar v2**. Mayoría: architect-1 + architect-2. Disidente: architect-3.
- [x] Resultado del panel: publicación por mayoría tras 3 rondas; no hubo unanimidad.
- [x] Arquitectura R1..R3 — críticas, revisión y voto documentados.
- [x] Publicar arquitectura curada en `CodebaseGuide/docs/ARCHITECTURE.md` (v2 exacta, voto 2–1; 927 líneas).
- [x] Nuevo ciclo developers: `purge-wg --dry-run` + purga real, exit 0.
- [x] Implementación R0 preparada para developer-1 como único escritor; disenso 2–1 pasado como gates.
- [x] Implementación R0 — developer-1 entregó app funcional, extractor/dataset real, 158 tests y `npm run verify` verde; reporte `20260712-023500-...-codebaseguide-r0-delivery.md`.
- [x] Gate detectado por coordinación: `verify` inicialmente omitía `smoke:adapter`; developer-1 lo incorporó y repitió el pipeline completo con exit 0.
- [x] Revisión independiente R0 — developer-2 y developer-3 completaron auditorías sin escribir el repo; ambos emitieron **RECHAZO**.
- [x] Developer-2: smoke no confiable por `reuseExistingServer`, contención cross-drive incompleta y screenshots de `verify` ensuciando `docs/`.
- [x] Developer-3: `expanded: []` no sobrevive import/export, canvas de sólo 130 px a 800×800, faltan zoom accesible/anuncios y el smoke no ejercita import/export real.
- [x] Auditoría personal del coordinador reprodujo `expanded: [] → ['repo']`, falta de warning para path absoluto en metadata y normalización falsa de traversal; agregó crate de primer nivel, output/tsconfig symlink confinement, ambigüedad dblclick edge/backdrop y filtros nuevos en refresh.
- [x] Corrección consolidada R1 enviada a developer-1 como único escritor (`20260712-024715-...-codebaseguide-r1-fix-brief.md`).
- [x] Implementación R1 recibida (`20260712-034500-...-codebaseguide-r1-delivery.md`): 10 puntos + follow-up de confinement cerrados; 195 unit, typecheck/build, adapter 16/16 y acceptance 13/13 verdes; sin proceso/puerto residual.
- [x] Dataset R1: 744 nodos = repository 1, application 5, package 2, crate 2, directory 97, file 637; 1609 relaciones y 118 unresolved sin cambios; reextracción determinista.
- [x] Revisión independiente R1 completada y ambos reviewers liberaron explícitamente el puerto 5175.
- [x] Developer-2: **APRUEBO CON CAMBIOS**; core/seguridad/smokes R0 cerrados, quedan docs crate y literal residual del hook.
- [x] Developer-3: **RECHAZO**; buckets no seleccionables/anunciables, drawers simultáneos dejan 80 px, scanner omite `/`, docs crate stale y screenshot edge-detail falsa.
- [x] Auditoría personal adicional del coordinador: paths absolutos/de Windows normalizados como internos, inferencia Tauri sin `frontendDist` y sin nearest-anchor, byte cap por UTF-16, UTF-8 U+FFFD falso negativo, race de descarga, lock/comments/renderer stale y notificaciones duplicadas.
- [x] Corrección R2 final consolidada enviada a developer-1 (`20260712-042041-...-codebaseguide-r2-final-fix.md`).
- [ ] Implementación R2, veredictos finales y verificación personal del coordinador.
- [ ] Publicar resultado y evidencia.
- [ ] Abrir la app validada en el navegador del usuario.

## Decisiones/voto/disenso

### Panel de arquitectura

**Voto:** 2–1 a favor de publicar `architecture-r2`.

- architect-1: autor y voto implícito a favor de su v2; aceptó C1–C7.
- architect-2: `APRUEBO`, cero blockers.
- architect-3: `APRUEBO CON CAMBIOS`, tres blockers residuales.

**Disenso que pasa obligatoriamente al panel de developers:**

1. `Outline.placementOf` singular + I10 inyectiva no puede demostrar una vista app-céntrica donde una misma entidad aparezca bajo dos apps; el developer debe elegir y probar semántica honesta de primary-placement o diseñar `placementsOf`/view state por outline instance.
2. Export no puede reemplazar `raw.view` por `ViewState`; debe hacer deep merge estructural que preserve unknown fields dentro de view/Position y posiciones inertes. Arrays desconocidos conservan orden; sólo arrays conocidos canonizan.
3. `npm run verify`/smoke deben dividirse por fase: smoke de adapter con fixture temprano y smoke de aceptación real sólo cuando import/export, dataset y detail existen. El verify final corre ambos; los pasos intermedios no pueden prometer pruebas de artefactos aún inexistentes.

**Errata no bloqueante que el developer debe corregir en docs/dataset:** `tauri.conf.json` y `get_settings` tienen líneas distintas de las del ejemplo; el dataset final debe usar las líneas generadas por el extractor, no valores manuales.

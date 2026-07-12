# Visual Specs — proyectos locales

## Objetivo

Evolucionar `CodebaseGuide` a **Visual Specs** y agregar un modelo de proyecto local basado en un directorio `.visual-specs` dentro de la carpeta elegida por el usuario.

## Pedido del usuario

1. Renombrar el desarrollo de CodebaseGuide a Visual Specs.
2. Exportar JSON con prefijo `YYYYMMDD-HHMMSS_`.
3. Permitir asignar un nombre al proyecto y usarlo después del prefijo en el nombre exportado.
4. Permitir seleccionar el directorio de trabajo; export e import deben operar desde `.visual-specs` dentro de ese proyecto.
5. Incorporar `Open/Create Project`, creando y usando `<directorio-elegido>/.visual-specs` para configuración y datos del proyecto.

## Criterios de aceptación del diseño

- Define exactamente qué significa renombrar: carpeta fuente, metadatos npm, UI, documentos, títulos y formatos, incluyendo compatibilidad/migración.
- Define el nombre de export completo, la zona horaria, padding, sanitización del nombre y colisiones.
- Define el contenido mínimo y versionado de `.visual-specs`, qué archivo es fuente de verdad y qué se guarda automáticamente.
- Define flujos separados y verificables para `Create Project`, `Open Project`, `Import JSON` y `Export JSON`.
- Trata explícitamente permisos, persistencia de handles y limitaciones de File System Access API; no promete escrituras que el navegador no puede realizar.
- Mantiene procesamiento local, sin backend, telemetría ni rutas absolutas dentro del documento portable.
- Mantiene desacoplados dominio/aplicación, persistencia de proyecto y renderer para poder reemplazar la visualización.
- Incluye manejo de cancelación, permisos revocados, carpeta inválida, `.visual-specs` incompatible, nombre vacío, archivos corruptos y navegador no soportado.
- Propone pruebas unitarias, contract tests y aceptación de navegador sobre filesystem simulado/controlado.
- Conserva import/export JSON portable y el dataset actual de AgentsCommander durante la transición.

## Panel de arquitectura

- Autor inicial rotativo: architect-2.
- Críticos independientes: architect-1 y architect-3.
- Hasta tres rondas; se busca unanimidad.
- Los arquitectos sólo proponen el artefacto; el coordinador publica la versión acordada.

## Estado de rondas

- Ronda 0: completada por architect-2 en `20260712-144022-wg3-architect-2-to-wg3-experts-coordinator-visual-specs-architecture-r0.md`.
- Ronda 1: completada; architect-1 y architect-3 emitieron `APRUEBO CON CAMBIOS` con correcciones bloqueantes.
- Ronda 2: ambos críticos emitieron `APRUEBO CON CAMBIOS`; cinco correcciones residuales consolidadas.
- Ronda 3: completada; architect-1 y architect-3 verificaron 5/5 correcciones y emitieron `APRUEBO`.
- Resultado: unanimidad 3/3. Artefacto final: `20260712-152203-wg3-architect-2-to-wg3-experts-coordinator-visual-specs-architecture-r3-final.md`.

## Decisiones/voto

- Voto: unanimidad 3/3 (`architect-1`: APRUEBO; `architect-2`: APRUEBO R3 PARA IMPLEMENTACIÓN; `architect-3`: APRUEBO).
- Disidentes: ninguno.
- R3 es la fuente de verdad congelada para el panel de implementación.

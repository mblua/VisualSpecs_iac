# Visual Specs — implementación y revisión

## Fuente de verdad

Arquitectura R3 unánime: `20260712-152203-wg3-architect-2-to-wg3-experts-coordinator-visual-specs-architecture-r3-final.md`.

## Panel

- Implementador inicial rotativo: developer-2.
- Revisores independientes: developer-1 y developer-3.
- El implementador puede editar `repo-CodebaseConstellation`; revisores empiezan read-only y sólo corrigen por nueva asignación explícita.

## Alcance obligatorio

- Rename completo `CodebaseGuide/` -> `VisualSpecs/`, branding, package, tipos públicos, hooks, extractor, docs y ADRs.
- ProjectStore desacoplado; FSA sólo en adapter, download fallback separado.
- Create/Open Project y `.visual-specs` con manifest/current/autosave view/imports/exports/backups.
- Nombre de proyecto persistido y export con el pedido literal del usuario: `YYYYMMDD-HHMMSS_<safe-name>.json`, UTC sin `Z`.
- Lecturas acotadas antes de materializar, revalidación, read-only, revision canónica y durabilidad de close/backup.
- OPFS para prueba real del adapter; renderer/conformance intacto.
- Dataset regenerado con commit fijado y diff exclusivamente de generator name.

## Gates

- `npm run verify` completo.
- Auditoría npm sin vulnerabilidades.
- Pruebas nuevas de contratos, adapters, UI/fallback, OPFS, tamaño, revalidación y read-only.
- Grep de marca legacy sólo en allowlist documentada.
- Working tree revisado; no commit/push hasta autorización del coordinador.

## Estado

- Implementación inicial: completa por developer-2; `npm run verify` en verde (235 unit/integration, 2 OPFS, 20 acceptance), auditoría 0 vulnerabilidades, sin commit/push.
- Críticas independientes R0: completas; developer-1 y developer-3 dieron `REQUIERE CAMBIOS`. Coinciden en conflicto externo antes de write; developer-1 agregó blockers de recuperación de commit parcial, nombre de proyecto y ausencia de prueba real de backup.
- Correcciones R1: completas por developer-2; 263 tests, 5 adapter/OPFS, 23 acceptance y audit 0. Cerró los blockers funcionales de R0, safe-open/Repair, conflicto externo, backup fresco, nombre estable, prefijo exacto, Save Picker y UI por proyecto.
- Revisión independiente R1: developer-1 aprobó con follow-ups obligatorios; developer-3 requirió cambios por evidencia insuficiente del fallo/orden sobre `FsaProjectStore` real y mensaje de Create ante metadata inválida. El coordinador consolidó además recuperación desde current future/read-only, Unicode y cuatro casos menores.
- Correcciones R2: completas por developer-2 después de `/clear`; entrega `20260712-193110-wg3-developer-2-to-wg3-experts-coordinator-visual-specs-r2-complete.md`. Reporta 267 tests, adapter 7/7, acceptance 23/23, audit 0 y sin commit/push.
- Revisión independiente final R2: consenso unánime. Developer-3 aprobó en `20260712-194142-wg3-developer-3-to-wg3-experts-coordinator-visual-specs-r2-final-review.md`; developer-1 aprobó y retiró su disidencia en `20260712-194740-wg3-developer-1-to-wg3-experts-coordinator-visual-specs-r2-review.md`.
- Gate final del coordinador: `npm run verify` PASS (267 Vitest, adapter 7/7, acceptance 23/23), audit 0, diff-check y whitespace limpios, dataset semánticamente idéntico salvo `generator.name`, 0 cambios fuera de `CodebaseGuide/` + `VisualSpecs/`.
- Resultado: completo. Preview activo en `http://127.0.0.1:4173` y abierto en el navegador del usuario. Sin commit ni push.

---
name: rfc13-premortem-state
description: RFC #13 (per-container fit-to-content) GATE CERRADO - veredicto PASS_WITH_NON_BLOCKING_FINDINGS en 5662485; FIT-1 (P1) y FIT-10 (P2) fijados y medidos contra código real; 3 P3 aceptados.
metadata:
  type: project
---

# GATE FINAL CERRADO (2026-07-24): `PASS_WITH_NON_BLOCKING_FINDINGS` en `5662485`

**Veredicto de mi lane** sobre el incremento ejecutable `feat(visual-specs): per-container fit-to-content (#13)` commit `5662485` (branch `feature/13-fit-container-to-content`). Msg `20260724-234405` (id 2c79111e). Cero P0/P1. FIT-1 y FIT-10 cerrados y medidos contra código que corre. Sin objeción a merge.

**[MEDIDO en 5662485] con comando FitContainer real + computeGeometry real + exportDoc/importDoc reales** (harness `artifacts/rfc13/gate-attack.harness.test.ts`):
- FIT-1 aceptación: 9-stack natural 584×682 → fit **141×592** (=measureText+HEADER_RESERVE 114). PASS.
- No-clip: hijo a x=3000 ⇒ cont.right 3070 ≥ 3048. PASS (piso = init only; grow contiene por construcción, layoutEngine.ts:217-234).
- Guard: fit en colapsado = no-op exacto (v===view), sin no-finitos. PASS.
- Idempotencia: fit∘fit box y pos idénticos. PASS.
- Round-trip FIT-10: export→import ⇒ formatVersion **1.1**, fitted preservado, caja 141×592. PASS.
- Rollback: tight 141 → roomy 400, posiciones intactas (sin pérdida). PASS.
- Suite independiente: **440 passed / 25 files**, tsc 0 errores.

**Implementación verificada (dónde):** piso en `growForPinnedChildren` (init header-mínimo + grow suple childBbox); `fitContainer` guard `childrenShown` + `frozen===0` + finite check (commands.ts:146-179); `fitted` REQUIRED en ViewState (view.ts:23, fuerza with* a threadearlo); `FitContainer` en VIEW_COMMANDS (state.ts:61); derive() pasa view.fitted (controller.ts:273-278); export.ts serializa fitted + bump 1.1; autosave opcional; load import stale-fitted inerte + refresh droppedFitted (load.ts:87-204); renderer kind:'control' + hitHeaderControl + controlId posee el gesto (FIT-2/3); detail.ts botón fit MANDATORY (FIT-8).

**3 P3 residuales aceptados (no bloquean):**
- FIT-11 CONFIRMADO: node:dragend solo dispatcha MoveNode, sin auto-re-center (controller.ts:78-79) ⇒ tras arrastrar un hijo de contenedor fiteado reaparece banda (grow simétrico sobre centro stale), sin clip, re-fiteable. OQ2 del plan impreciso (solo tamaño re-deriva, no centro). Fix v1.1: re-hug al padre en dragend. Aceptado como límite v1.
- FIT-12: freeze-pinning pegajoso tras rollback. FIT-7: H mid-gesture (pre-existente, R igual).

**Higiene:** harnesses zzz_* borrados, stash de agentscommander.json restaurado, repo como lo encontré. Untracked `_redteam_fit_adversarial.test.ts` NO es mío (semantic red-team concurrente), dejado intacto.

---

## Historial (round 1 y 2)

# RFC #13 (per-container "fit to content") — PREMORTEM EMITIDO (2026-07-24)

**Rama:** `feature/13-fit-container-to-content`, repo `repo-VisualSpecs`, app bajo `VisualSpecs/`. HEAD `3c9a68c`. NO hay implementación aún (design premortem, Step 5). Mensaje `20260724-220212` a `VisualSpecs_iac:wg-1-vs-dev-team/vs-spec-core-lead` (msg id f8763964).

**La feature:** comando de vista puro `FitContainer {id}` = (1) freeze: pinnea cada hijo directo visible en su centro dibujado; (2) recenter contenedor a `Cx=(L+R)/2, Cy=(T+B−H)/2`; reescribe solo `view.positions`. Glyph on-canvas + shortcut `H` + botón detail-panel opcional. Owners: core (`commands.ts`,`state.ts`), graph/runtime (renderer/controller/ui).

## Veredicto de mi lane: BLOQUEA por 1×P1 (FIT-1). Resto no-veto.

### P1 — FIT-1 [MEDIDO con código real]: el fit NO puede ajustar por debajo del natural de GridPack
- **Teorema (evidencia en `layoutEngine.ts`):** `computeSizes` fija el contenedor en `max(pack(hijos).width+2P, header)` con pack NATURAL (ignora pins); `growForPinnedChildren` arranca en `natural/2` y solo hace `Math.max` hacia arriba ⇒ un contenedor **nunca** baja del tamaño grid-natural en ningún eje.
- **Repro medido:** 9 hijos hoja (96×38) en columna vertical (extensión 96×518) ⇒ caja fiteada **400×592** vs ideal **140×592** = **260px de banda vacía horizontal**. El alto abraza (bbox>natural); el ancho queda clavado. Falla en cualquier arreglo más compacto que la grilla (lista vertical, cluster, <ceil(√n) columnas; hasta 2 hijos apilados).
- **Criterio violado:** la prueba del plan "Zero empty band / Tight" (enunciada sin condición) + ítem de verificación "tight-box geometry" + objetivo del Scope. N2 propone testear justo el caso donde funciona (testing-to-green).
- **Desbloqueo (elige owner):** (a) BARATO recomendado = corregir promesa/mensaje/docs a "no baja del layout automático" + test explícito del caso `bbox<natural`; (b) caro/fuera-scope = comprimir el piso (toca growForPinnedChildren).

### P2 (no-veto)
- **FIT-2:** arrancar drag sobre el glyph MUEVE el contenedor. `resolveTarget` corre en pointerUP pero el drag se decide en pointerMOVE con `p.nodeId` de pointerDOWN ⇒ "resolve-first" del plan llega tarde; hay que suprimir drag en `onPointerDown`.
- **FIT-3:** dos taps en el glyph COLAPSAN (isDouble+kind==='node'⇒ToggleExpand) salvo 3 cambios coordinados: resolveTarget devuelve `kind:'control'` primero + emitir fit en tap + drag-suppress en pointerdown. 4 casos de conformance exigidos.
- **FIT-4:** `H` = 1 tecla desnuda, mutación bulk irreversible (pinnea N hijos); único deshacer no-manual = `R` global (nuke de TODO el layout). Peor caso de pérdida del #5. Pido mensaje honesto, no undo.

### P3
- **FIT-5:** `FitContainer` debe entrar al Set runtime `VIEW_COMMANDS` (`state.ts:53`); el `never` atrapa case faltante pero NO entrada de Set faltante ⇒ olvido = no-op silencioso. Test "cambia estado".
- **FIT-6:** guarda degenerados (colapsado/childless/0-hijos) ANTES del bbox; min/max sobre ∅=±Inf⇒NaN⇒`MalformedSceneError` (`renderer.ts:271`). De-riesgo: carga capa coords ±1e6 y rechaza no-finitos; promedio acotado; autosave rechaza NaN al recargar ⇒ recuperable, no brick. Testear la guarda.
- **FIT-7:** `H`/shortcuts disparan durante drag de canvas (`isInteractionEvent` app.ts:1673 no guarda gestos de puntero). Pre-existente (`R` igual). Guardar shortcuts con gesto activo.
- **FIT-8:** glyph indescubrible (canvas role=img) + inusable a MIN_ZOOM 0.05. Mitigado por H+node-list+detail-button; pedí ruta no-canvas OBLIGATORIA (§9.4), no "optional".
- **FIT-9:** wording: no llamar "undo" a R; no afirmar "fitted" cuando quedó el piso.

## Resultados negativos (ejecutados; cierran superficie)
- **[MEDIDO] Hermanos NO se mueven al fitear anidado — hipótesis FALSIFICADA** (s1.y 217→217, 0px, con cont.h 1042→192). Causa: `assignPositions` posiciona hermanos con el tamaño NATURAL del contenedor (independiente de pins, recalculado fresco cada pass); el crecido solo afecta el box dibujado. Cierra el sub-ataque "jump vs hermanos" del #4.
- Contenedor tampoco "salta": box se encoge en el lugar sobre hijos estacionarios; centro almacenado = metadata invisible.
- Idempotencia `fit∘fit` se sostiene por construcción. Brick por NaN no alcanzable por fit normal. Perf = 1 recompute = costo de un drag (~0.2-0.3s corpus). `hitHeaderControl` NO debe recomputar geometría por pointermove.

## Reproducibilidad
Harness real (importDoc+computeGeometry+GridPack) en réplica: `__agent_vs-resilience-red-team/artifacts/rfc13/floor-and-sibling.harness.test.ts` (+`.out.txt`). Para re-correr: copiarlo a `VisualSpecs/tests/domain/` y `npx vitest run`. Borrado del repo tras medir (repo pristino).

## ROUND 2 (2026-07-24) — delta B-full: FIT-1 FIJADO, NO bloqueo
El lead eligió **B-full (Hug Total) + piso de legibilidad** (opción b de mi round-1). Delta: `growForPinnedChildren` inicializa `halfW/halfH` en el piso de legibilidad (`width=max(childBbox+2P, headerFloor)`, `height=max(childBbox+2P+H, H+2P)`) en vez del grid-natural, luego crece a los hijos; nuevo estado `fitted: ReadonlySet<NodeId>` en ViewState; doc bump minor 1.0→1.1, autosave NO bumpea (agrega `fitted` opcional). Msg round-2 `20260724-224954` (id 82dbad6e).

**[MEDIDO] FIT-1 aceptación PASA** (harness `artifacts/rfc13/bfull-floor-noclip.harness.test.ts`): 3-stack 270→**141**×232, 9-stack 400→**141**×592 (≈ideal 140, +1px reserva glyph), long-label(mT=207)→**321**×232 (header manda, hijos CENTRADOS no a un costado), 1-child 141×112. Alto siempre abraza. **No-clip CONFIRMADO:** hijo en x=2000 ⇒ box.right 2070≥2048 (el piso es mínimo, el grow contiene — SIEMPRE que el loop de grow corra tras el init del piso).

**Claims de rollback verificados contra código:** `validate.ts:86-95` minor desconocido = read-WRITE (readOnly solo por `requires`); `export.ts mergeView` preserva llaves desconocidas en `view`; `autosaveView.ts:45-47` igualdad estricta ⇒ NO bumpear autosave es correcto. Rollback = degradación aceptable (posiciones sobreviven; solo se pierde la intención `fitted`), NO trampa de datos.

**Nuevos hallazgos round-2:**
- **P2 FIT-10 (must-test, no-veto):** `export.ts mergeView` (54-93) NO serializa `fitted` (solo positions/expanded/viewport); el plan solo menciona extender autosave, NO export. Grep confirma: no hay `fitted` en ningún serializer aún. ⇒ fit de sesión → export → import pierde `fitted` ⇒ caja vuelve a roomy (residual FIT-1) en silencio. Viola "round-trips intact". Requiere extender mergeView + viewToJson/parseView + test de round-trip de fit de sesión.
- **P3 FIT-11:** re-hug dispara en drag-end de hijo pero NO en expand/collapse ni anidados ⇒ banda vacía reaparece (grow simétrico sobre centro stale) hasta re-fit. Sano (sin clip) pero pierde tightness.
- **P3 FIT-12:** freeze-pinning pegajoso e independiente de `fitted`; rollback deja hijos pinneados (costo) sin caja ajustada (beneficio); revertir del todo = `R` global.
- **P3 FIT-13:** secciones stale del plan (46/60/88-91 "no schema change / no growForPinnedChildren change") contradicen el delta B-full; reconciliar/borrar.

**Negativos confirmados bajo B-full:** hermanos NO se mueven (override solo en growForPinnedChildren; computeSizes/assignPositions siguen position-independent; OQ1 del plan igual). Convergencia 2-pass intacta (piso = childBbox de pins estables). Perf = 1 recompute acotado. Header-dominado centra hijos (no a un costado).

## Pendiente
Round-1 FIT-2..FIT-9 plegados como requisitos. Sin objeción bloqueante round-2. Máx 3 rondas, voy 2. Verificaré el incremento ejecutable cuando exista (aceptación FIT-1 con mi harness; no-clip; FIT-10 round-trip; reconciliación import-vs-refresh). Independencia: no implemento las correcciones que evalúo.

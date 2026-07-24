---
name: issue9-round1-gate-state
description: Gate resiliencia issue #9 (watch+follow-file) CERRADO - veredicto final PASS_WITH_NON_BLOCKING_FINDINGS en 944385b, baselines confirmados contra código real
metadata:
  type: project
---

# Issue #9 (extractor --watch + follow-file reload) — GATE CERRADO (2026-07-15)

**Veredicto final de mi lane:** `PASS_WITH_NON_BLOCKING_FINDINGS` sobre el incremento ejecutable, HEAD `944385b` (branch `feature/9-extract-watch-follow-file`, repo `repo-VisualSpecs`, app bajo subdir `VisualSpecs/`). Mensaje `20260715-143635`. Cero P0/P1; tres P3 nuevos. Sin objeción a READY/merge. `npm run verify` = exit 0 (unit+typecheck+build+39 smoke) re-corrido por mí.

Historial: premortem `20260715-051237` (4 P1) → verificación mapeos `20260715-052056` → veredicto ronda 1 `20260715-053527` (sin bloqueo en `c9634e8`) → gate final `20260715-143635`.

## Mis 4 P1 — verificados CERRADOS contra código que corre (no contra plan)

- **A1-P1-2** (write-failure staleness): `createWatcher` real + `publish` inyectado fallando → extractCalls=2 (no per-tick, fingerprint NO parkeado), write reintentado por tick, publica al liberar lock SIN más cambios de repo. Texto nuevo supersede pendiente viejo.
- **A1-P1-3** (stamp+out-en-repo-vigilado): CLI real → `badConfig` exit 10; path git-ignored dentro del repo → aceptado (dogfood vía `.local/`).
- **A1-P1-1** (tick-overrun/costo): loop self-rescheduling setTimeout + tickOnce sincrónico = sin solape por construcción.
- **A2-P1-1** (reload borra selección + SR): `carrySelection` en state.ts (survivors); anuncios por live region + supresión de "Selection cleared." desnudo.

## Baselines CONFIRMADOS contra código real (regresión del futuro)

- Híbrido fingerprint: corpus tick **218-294 ms** (3-spawn); 50k limpio **276-334 ms** (proyección 0.3-0.6s CONFIRMADA, era 7.9-12s pre-híbrido); 50k 10% dirty **0.8-1.0 s**.
- Torn-file: **0 parciales de 527** lecturas concurrentes durante rewrites reales (atomicidad temp+rename OK en Windows/NTFS).
- Follow-loop (startFollowLoop real, handle scriptado): backwards-mtime entregado, single-flight sin out-of-order, oversized 1 skip + shrink-back entregado, transient→ended tras 5, NAE granted sobrevive / denied termina.
- reload corpus 34 ms; curva ×5/×20/×40 = 84/305/1253 ms; extracción 6.3 s; startup N×6.3 s; e2e real ~9 s (dominado por extracción; owner midió 2.45 s con relay OPFS = config más liviana, no contradicción).
- Scripts de ataque: replica `artifacts/gate-issue9/attack-*.mjs` (fingerprint, follow, watch-cycle, watch-cycle2, writefail).

## 3 P3 nuevos (no bloquean, a criterio de owners)

1. Anuncio de reload tragado cuando reload+ended se aplican juntos en `flushPendingFollow` (dos setStatus sincrónicos sobre un `role=status` polite → SR lee sólo el último). Banner visual sí refleja ambos.
2. Reload redundante al bajar del cap a contenido idéntico al pre-oversize (contentHash se pone null en oversized, se pierde el hash previo).
3. Dirty-set explosion transitoria (checkout masivo) empuja el tick hacia orden pre-híbrido, acotado y absorbido por la cadencia.

## Precondición que NO exigí: safe-save manual (runbook 3 rondas). Recomendado una vez antes del merge, no gatea.

## Reglas de proceso confirmadas útiles

- Atacar el INCREMENTO EJECUTABLE, no el plan: correr el proceso real + importar funciones reales con IO scriptado > confiar en unit tests ajenos.
- Verificar dispositions contra el TEXTO/CÓDIGO en HEAD, no contra mensajes de owners.
- Independencia sólo en emisión inicial; después leer al otro red team permitido.
- Fixtures propios bajo `.local/` (gitignored) mantienen el repo pristino. Backgrounding con `&` en Bash resetea cwd/vars → usar orquestador Node self-contained con paths absolutos.
- Peers: lead `CodebaseConstellation_iac:wg-5-vs-dev-team/vs-spec-core-lead`; owners `.../vs-extraction-evidence-dev` (A1), `.../vs-graph-runtime-dev` (A2).

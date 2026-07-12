---
name: artifact-panel-refinement
description: Refina un artefacto (documento, spec, set de reglas, diseño) mediante un panel de 3 especialistas con autor rotativo, crítica independiente basada en evidencia, y hasta 3 rondas buscando consenso unánime. Empieza SIEMPRE con purge-wg. Úsalo cuando el usuario pida que un equipo verifique, mejore, corrija o audite un artefacto, o cuando haya que encadenar paneles (architects → developers).
type: skill
---

# Artifact Panel Refinement

Proceso del coordinador para refinar un artefacto con un panel de especialistas. Produce una versión curada con consenso o voto documentado, no la opinión de un solo agente.

## Cuándo usarlo

- El usuario pide "que el equipo verifique / mejore / corrija / audite <artefacto>".
- Hay que encadenar paneles: architects refinan → developers refinan/validan.
- Cualquier artefacto donde una sola opinión no basta y querés adversarial review real.

## Principio 0 — SIEMPRE `purge-wg` primero

**Obligatorio antes de arrancar cualquier ciclo de refinamiento.** Contexto viejo de un ciclo anterior contamina el panel: los especialistas "recuerdan" versiones muertas, repiten críticas ya resueltas, o anclan en decisiones descartadas. Panel con contexto sucio = crítica sucia.

```bash
# 1. Siempre dry-run primero: evalúa el gate y muestra la tabla por peer, no destruye nada
"<AGENTSCOMMANDER_BINARY_PATH>" purge-wg --token <TOKEN> --root "<ROOT>" --wg <wg-name> --dry-run

# 2. Si el gate pasa, purga real
"<AGENTSCOMMANDER_BINARY_PATH>" purge-wg --token <TOKEN> --root "<ROOT>" --wg <wg-name>
```

Notas de `purge-wg`:
- Coordinator-only. Purga TODOS los peers del workgroup propio. Nunca al caller ni al Root Agent. No hay purga cross-workgroup.
- `--wg` es **aserción de seguridad**, no selector de scope: falla si el workgroup resuelto no se llama exactamente así. Usalo siempre.
- **Busy gate fail-closed:** si CUALQUIER peer produjo output imprimible dentro de `--quiet-period-ms` (default 3000, floor 2500), no purga a NADIE y sale con **exit 3**. Si te da 3, alguien está trabajando — esperá, no lo fuerces.
- Evitá `--graceful`: **stallea TODA la mensajería inter-agente daemon-wide** mientras dura la purga (el poller es secuencial).
- Exit codes: `0` purgado (o dry-run pasaría) | `1` auth/IO | `2` resultado desconocido | `3` gate rechazó (peer ocupado) | `4` destroy falló tras pasar el gate.

**Única excepción:** el equipo recién arrancó y ningún agente tiene contexto todavía. Si dudás, purgá.

## Proceso

### Paso 1 — Encuadre
- Leé el artefacto completo. No delegues sin haberlo leído.
- Resolvé los nombres de peers con `list-peers-lean`. **Nunca los adivines.** El nombre de carpeta en disco NO es un nombre de peer válido.
- Extraé del usuario: criterios de aceptación explícitos (estilo, alcance, qué cuenta como "mejor"). Sin criterio verificable, el panel discute gustos.
- Escribí el plan en `plans/<artefacto>-review.md` de tu Agent Matrix. Es tu estado entre turnos y sobrevive a un context clear.

### Paso 2 — Ronda 0: autor inicial
- **Rotá el autor inicial** entre los especialistas del panel. No uses siempre al mismo: la autoría rotativa reparte el sesgo de anclaje.
- Despachá al autor: verificá cada ítem existente, corregí lo que esté mal, agregá lo que falte, reescribí según los criterios de estilo.
- Exigí en el entregable:
  - El contenido completo propuesto (bloque de código, listo para publicar).
  - Lista de cambios: qué corrigió, qué agregó, **con evidencia concreta** (lint exacto, sección de la spec, regla del lenguaje — no opinión suelta).
  - **Dissent proactivo:** qué puntos anticipa que el panel va a debatir. Acelera las rondas.
- **El autor NO edita el archivo en disco.** Sólo propone. Vos publicás al final.

### Paso 3 — Ronda 1..3: crítica independiente
- Despachá la versión actual a los otros dos especialistas **en paralelo**, con la instrucción explícita: *"critica de forma INDEPENDIENTE, NO coordines con el otro crítico"*. Dos juicios separados > un juicio negociado.
- Exigí de cada crítico:
  1. Ítems incorrectos / técnicamente dudosos + corrección propuesta.
  2. Ítems ambiguos o no verificables + reescritura.
  3. Duplicación con artefactos hermanos (ej. un doc "general" del que este es complemento).
  4. Ítems faltantes + justificación.
  5. Postura sobre cada punto de dissent que marcó el autor.
  6. **Veredicto global explícito:** `APRUEBO` / `APRUEBO CON CAMBIOS` (lista) / `RECHAZO` (motivo). Sin veredicto explícito no podés computar consenso.
- Consolidá ambas críticas y mandáselas al autor para revisión → siguiente versión.
- Exigí al autor que **acepte o rechace cada punto con fundamento**. Un rechazo sin fundamento vuelve.
- Repetí hasta 3 rondas buscando **unanimidad**.

### Paso 4 — Consenso o voto
- **Unánime** → publicá.
- **Sin unanimidad tras 3 rondas** → voto por mayoría entre los 3 especialistas. Registrá el voto.
- **1-1-1 o inconcluso** → resolvés vos, y **documentás la razón** en el plan. Es el único caso donde el coordinador decide contenido.
- Registrá siempre el resultado del voto y los disidentes. El disenso documentado es información, no ruido.

### Paso 5 — Publicar
- Escribís vos el artefacto final curado en disco. Un solo escritor evita ediciones concurrentes.
- Actualizá el plan: versión final, voto, disidentes.

### Paso 6 — Encadenar al siguiente panel
- Si el flujo sigue (architects → developers), arrancá un panel nuevo sobre el artefacto ya publicado.
- Pasale al panel siguiente el **disenso no resuelto** y el **rationale del voto**: son las zonas de mayor riesgo y donde más valor agrega el segundo panel.

## Reglas duras del coordinador

- **No absorbas el trabajo técnico.** Coordinás y arbitrás. No sos autor ni crítico del contenido; sólo desempatás cuando el voto es inconcluso.
- **Nunca infieras completitud** de archivos, logs o flags de estado. El agente asignado debe reportar explícitamente: resultado, blockers, verificación.
- **Agente silencioso:** hasta 3 intentos de contacto. Verificá con `list-peers-lean` (`working: false` + `waitingForInput: true` = idle, perdió el task → re-disparar el mismo mensaje).
- **Timer de 10 minutos:** mientras haya trabajo despachado, pingueá cada 10 min para ver en qué andan. Los agentes se caen, cambian de modelo, o pierden el wake sin avisar.
- **Mensajería en dos pasos:** escribí el archivo en `<workgroup-root>/messaging/` con el patrón `YYYYMMDD-HHMMSS-<wgN>-<vos>-to-<wgN>-<peer>-<slug>.md`, después `send --send <filename> --mode wake`. `--send` toma **sólo el nombre de archivo**, nunca un path.
- Nunca modifiques ni borres un archivo de mensaje ya escrito. Para re-pinguear, re-disparás el `send` con el mismo filename.

## Antipatrones

| Antipatrón | Por qué falla |
|---|---|
| Saltarse `purge-wg` | Contexto viejo contamina la crítica; el panel debate versiones muertas |
| Crítica no independiente | Los críticos convergen y perdés la señal adversarial |
| Sin veredicto explícito | No podés computar consenso ni voto |
| Autor edita el disco | Ediciones concurrentes, el artefacto se corrompe entre rondas |
| Mismo autor inicial siempre | Anclaje de sesgo; el panel refina las ideas de una sola cabeza |
| Coordinador reescribe el contenido | Rompe el panel: tu opinión no fue criticada por nadie |
| Criterio de aceptación vago | El panel discute gustos en vez de evidencia |

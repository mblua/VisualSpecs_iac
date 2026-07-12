# ✅ CERRADO — commit `464d6fd`, pusheado a `origin/main` (2026-07-12)

**Los dos artefactos publicados + registro de evidencia. Cuatro paneles, seis agentes, ninguno degradado. Cron `71c06cd8` borrado.**

| Artefacto | Antes | Después |
|---|---|---|
| `code_best_practices/TypeScript_best_rules.md` | 20 | **38** |
| `architecture_best_practices/TypeScript_best_rules.md` | 15 | **15** (reescritas) |
| `TypeScript_rules_evidence.md` | — | **nuevo** |

## 🔴 EL HALLAZGO CENTRAL: la promesa vacía es RECURSIVA

**Nueve veces.** Y **cuatro veces seguidas el defecto reapareció DENTRO de la corrección del defecto anterior.**

| # | La promesa | La realidad |
|---|---|---|
| 1 | `void p` no se puede gatear | `ignoreVoid:false` lo gatea y acepta `void p.catch(sink)` |
| 2 | `as unknown as` no se puede gatear | `no-unsafe-type-assertion` lo atrapa — **NO está en `strictTypeChecked`** |
| 3 | Sinks de HTML → "checklist" | `no-restricted-syntax` los gatea. **Ya estaba en el apéndice.** Era XSS |
| 4 | El fix de #3 | **Sólo punto.** `el["innerHTML"]` pasaba |
| 5 | (nunca nombrado) | **`eslint-disable` sin descripción apaga cualquier gate.** Había uno VIVO en `HomeView.tsx:54` sobre XSS |
| 6 | `--print-config` prueba el gate | **NO.** `boundaries` **FALLA ABIERTA** y print-config dice severidad 2. **Tres personas la mataron sin enterarse — yo incluido, 3 intentos** |
| 7 | "los alias ya no son residuo" | `const D = Date; D.now()` → exit 0 |
| 8 | El fix de #7 | **Sólo alias por punto.** `const f = Date["now"]; f()` → exit 0 → `1783817033397` |
| 9 | "complementa; nunca reemplaza" | **Componer los 2 catálogos en el orden del README apagaba los 20 selectores de XSS.** Flat-config es last-wins |

### La lección

1. **Todo gate de selectores AST matchea una FORMA SINTÁCTICA, no una IDENTIDAD SEMÁNTICA. Siempre hay una grafía más.** → declarar el inventario **ABIERTO**.
2. **La cláusula de revisión humana no vacía una regla por existir. La vacía por NO COSTAR NADA.** → un `[NO-VER]` es honesto sólo si nombra un artefacto.
3. **La única forma de saber que un gate está vivo es probar que FALLA sobre algo.**

## Lo que hay que recordar para la próxima

- **El auto-reporte de un autor NO es evidencia.** Un entregable llegó **truncado** (`…301 tokens truncated…` literal en el archivo), se comió el cuerpo de la regla de XSS, y el auto-chequeo decía *"38 reglas, secuencia 1–38"*. **Se cazó contando a mano en disco.**
- **Correr el mecanismo yo mismo cazó 9 de 9.** Leer el reporte no habría cazado ninguno.
- **`import/no-cycle` es una trampa** (no ve ciclos de tipos). La sugerí yo. El autor la probó y la descartó.
- **`purge-wg` antes de cada artefacto.** Funcionó las dos veces.
- **Los wakes se pierden tras el purge.** Pasó 3 veces (architect-1, architect-2, developer-1). Re-disparar el mismo filename funciona. **Ojo con el falso positivo:** una vez re-pingueé a un agente cuyo archivo se escribió 4 segundos después de mi chequeo.

---

# Plan — Refinamiento de las reglas de TypeScript (panel doble) [histórico]

**Coordinador:** experts-coordinator · **Workgroup:** wg-2-experts-team
**Pedido del usuario:** "que se haga lo mismo con la docu de typescript" (= el proceso completo que se corrió con Rust).
**Arranque:** 2026-07-11

---

## Artefactos

| # | Archivo | Estado inicial | Hermano de dedup |
|---|---|---|---|
| 1 | `code_best_practices/TypeScript_best_rules.md` | 20 reglas | `code_best_practices/General_best_rules.md` (20 reglas) |
| 2 | `architecture_best_practices/TypeScript_best_rules.md` | 15 reglas | `architecture_best_practices/General_best_rules.md` (20 reglas) |

Repo: `repo-personal` → `ObsidianVault/Coding Agents/IA-Programming/`

⚠ Hay **dos** `General_best_rules.md` con contenidos DISTINTOS, uno por carpeta. Cada doc de TS deduplica contra el de **su propia carpeta**.
Además existen los dos docs de **Rust** ya publicados (48 código / 15 arquitectura): los paneles deben leerlos para no duplicar lo transversal.

---

## Toolchain verificada (2026-07-11) — antes de despachar

| Herramienta | Estado |
|---|---|
| node | v24.13.0 |
| npm | 11.6.2 · pnpm 10.32.1 |
| **tsc** | **5.9.3 — VIVO** en `repo-AgentsCommander/node_modules/.bin/tsc` (instalado con `npm ci`, 294 pkgs, git status quedó LIMPIO — `node_modules/` está gitignoreado) |
| `npm run typecheck` (`tsc --noEmit`) | **exit 0** sobre el repo real |
| `npm test` (`vitest run`) | disponible |
| **ESLint** | **NO EXISTE en ningún repo.** Sin config, sin dep, sin script `lint` |
| **Formatter** | **NO EXISTE** (ni prettier ni biome) |
| **Lint de boundaries** | **NO EXISTE** |

**Repo de referencia:** `repo-AgentsCommander` — Tauri 2 + SolidJS 1.9 + TS 5.9.3 + Vite + Vitest. Es exactamente el perfil que describen las reglas (TSX, Tauri, SolidJS).
**Segundo repo TS:** `repo-CodebaseConstellation/web` — TS **7.0.2** declarado (native port), sin Solid ni Tauri. Ojo: versión mayor distinta → la evidencia de tsc se etiqueta `[TOOL tsc 5.9.3]`, no vale como universal.

---

## Decisión de alcance del usuario (2026-07-11) — VINCULANTE

Pregunté antes de despachar, precisamente por el precedente de Rust (checker de 1.300 líneas → pushback).

**Elegido: "Texto + tsc + ESLint en sandbox".**

- ✅ El panel **corre `tsc` 5.9.3** sobre los snippets. Verificar el texto ejecutando el compilador **está en alcance**.
- ✅ El panel **instala ESLint + typescript-eslint + eslint-plugin-solid en un scratch propio de cada réplica** (NUNCA en el repo) sólo para probar si los lints que las reglas nombran **realmente disparan**.
- ❌ **NO se construye ninguna herramienta.** Nada de boundaries lint. Nada de formatter.
- ❌ **Cero cambios en los repos.** No se toca `package.json` ni ningún archivo trackeado.
- 📌 Toda regla cuyo mecanismo no exista se **reescribe para ENUNCIAR la obligación** y su mecanismo se marca **`[NO-VER]`** — capacidad documentada, NO resultado reproducido.

Consecuencia directa ya identificada, que el panel debe resolver:
- **Code regla 20** promete "typecheck, **linter**, **formatter** y tests → exit 0". **2 de las 4 herramientas no existen.**
- **Architecture regla 15** exige "un **lint de boundaries** debe detectar ciclos, imports internos entre features y acceso de `domain` a I/O". **No existe.**

---

## Rotación de autor

| Artefacto | Autor architects | Críticos | Autor developers | Críticos |
|---|---|---|---|---|
| 1 — TS código | **architect-3** | architect-1, architect-2 | **developer-3** | developer-1, developer-2 |
| 2 — TS arquitectura | **architect-3** | architect-1, architect-2 | **developer-3** | developer-1, developer-2 |

(architect-1 y developer-1 fueron autores del código de Rust; architect-2 y developer-2 de la arquitectura de Rust. Toca el 3.)

---

## Estándar de la mesa (no negociable, va en el primer mensaje)

> **Si nombrás un mecanismo, corrélo. Si no podés correrlo, declaralo como capacidad documentada, NO como resultado reproducido.**

## El defecto que se caza

**"Una promesa de verificabilidad que no verifica."** Apareció 4 veces en el doc de código de Rust.
Corolario (developer-1): **una columna de "revisión humana" puede usarse para VACIAR una regla** — si la regla dice "nunca X" pero el residual manda X a revisión humana, la forma más fácil de hacer X queda impune y la regla suena absoluta mientras está muerta.

## Aprendizajes de Rust que se exigen desde el minuto uno

1. **Los autores rompen su propio mecanismo mientras lo "mejoran".** El coordinador verifica el entregable a mano: conteos, aritmética, referencias cruzadas.
2. **Los defectos EMERGEN al aplicar dos críticas juntas.** Consolidar y revisar el efecto combinado, no cada crítica aislada.
3. **La crítica cruzada encuentra lo que ningún revisor solo encuentra.** Por eso las críticas son independientes y en paralelo; prohibido coordinar entre críticos.
4. **Nadie verifica lo que no le pedís.** En Rust el header del doc citaba una regla EQUIVOCADA de General y sobrevivió los dos paneles enteros. → **Para TS: pedir explícitamente que alguien verifique CADA referencia cruzada.**

## Política de autocontención (del usuario)

Nada de referencias numéricas colgantes. **La regla ENUNCIA la obligación; el número queda sólo como procedencia.**

```diff
- crea `shared` sólo cuando cumple General 16.
+ crea `shared` sólo para un concepto con al menos dos consumidores
+   que compartan el mismo motivo de cambio (General 16).
```

## Evidencia fechada y clasificada por volatilidad

Al cerrar, crear `IA-Programming/TypeScript_rules_evidence.md` con las mismas clases que `Rust_rules_evidence.md`:

- `[LANG]` semántica del lenguaje → re-verificar sólo ante cambio de versión mayor
- `[TOOL <versión>]` comportamiento de tsc/eslint → re-verificar al mover la toolchain
- `[REPO @ fecha]` foto del código → caduca con el próximo commit
- `[NO-VER]` lo que no se pudo verificar, declarado a propósito

---

## Estado

- [x] Leer skill `artifact-panel-refinement`
- [x] Leer los 4 documentos (2 TS + 2 General)
- [x] Verificar toolchain (tsc 5.9.3 vivo; sin eslint/formatter/boundaries lint)
- [x] Preguntar alcance al usuario → "texto + tsc + ESLint sandbox"
- [x] `purge-wg --dry-run` (gate PASS) + purga real (**6 peers purgados, exit 0**)
- [x] Escribir este plan
- [x] **Despachar architect-3 como autor de Artefacto 1** — msg `20260711-181711-wg2-experts-coordinator-to-wg2-architect-3-ts-code-author-r0.md`, entregado `b089c7df` (exit 0)
- [x] **Cron de heartbeat armado: `71c06cd8`, cada 10 min** (session-only, expira en 7 días)
- [x] **Ronda 0 recibida** — architect-3 entregó 18:48 UTC. Propone **20 → 34 reglas**. Msg: `20260711-184828-wg2-architect-3-to-wg2-experts-coordinator-ts-code-r0.md`
- [x] **Ronda 1 despachada** — architect-1 (`35a52c8e`) y architect-2 (`710a0a2a`), críticas independientes en paralelo, 18:50 UTC
- [x] **Ronda 1 recibida.** architect-2 (19:04) y architect-1 (19:12). **Ambos: `APRUEBO CON CAMBIOS`. Ningún rechazo.**
- [x] **Ronda 2 despachada** — crítica consolidada a architect-3 (`957f3b8a`), 19:18 UTC
- [x] **v2 recibida** (19:45) — **37 reglas**. Msg: `20260711-194521-...-architect-3-ts-code-r2-revision-full.md`
- [x] **Ronda 3 (final) despachada** a architect-1 (`984d41d3`) y architect-2 (`329b6c2d`), 19:48 UTC
- [x] **Ronda 3 recibida.** architect-2 (19:55) y architect-1 (19:57). **Ambos `APRUEBO CON CAMBIOS`, sólo bloqueantes.**
- [x] **Pasada final de bloqueantes despachada** a architect-3 (`fe10fae2`), 20:01 UTC
- [x] **v3 final recibida** (20:14) — 37 reglas, apéndice partido `base`/`features`/`solid`, los 4 bloqueantes aplicados
- [x] **APÉNDICE VERIFICADO POR MÍ** contra fixtures (ver abajo) — **gate de publicación PASADO**
- [x] ✅ **ARTEFACTO 1 PUBLICADO** — 37 reglas, secuencia 1..37 exacta verificada en disco
- [x] **Panel de developers arrancado** — developer-3 autor (`bc07ec85`), 20:19 UTC
- [x] **developer-3 entregó** (20:43). Veredicto: **CAMBIOS**. Encontró la **CUARTA promesa falsa — en el doc que YO publiqué**.
- [x] **Críticos despachados** — developer-1 (`e6ee66f7`, foco números/adoptabilidad) y developer-2 (`64271106`, foco regla 22 + tests), 20:47 UTC
- [x] **Críticas recibidas.** developer-2 (21:02) y developer-1 (21:08). **Ambos `APRUEBO CON CAMBIOS`.**
- [x] **Revisión final despachada** a developer-3 (`811b2db6`), 21:13 UTC — 9 bloqueantes consolidados
- [x] **v2 recibida** (21:33) — 38 reglas. Aceptó B1–B9 y R2; rechazó eliminar la 26 pero le dio delta TS real.
- [x] 🔴 **ENTREGABLE TRUNCADO — lo cacé contando a mano.** Ver abajo.
- [x] Regla 35 pedida verbatim y recibida en 2 partes (21:41)
- [x] **APÉNDICE FINAL VERIFICADO POR MÍ** — carga, sin selectores duplicados, y caza los 5 bypasses
- [x] ✅ **ARTEFACTO 1 REPUBLICADO** — 38 reglas, secuencia 1..38 exacta verificada en disco
- [ ] **Artefacto 2 (arquitectura): EN CURSO** — ver sección al final
- [ ] `TypeScript_rules_evidence.md`
- [ ] Commit + push

# ARTEFACTO 2 — ARQUITECTURA (en curso)

- [x] **`purge-wg`** antes de arrancar — 6 peers, exit 0.
- [x] **architect-3 autor R0** (`a53ed3a9`) → entregó 22:23. **15 reglas** (sin relleno).
- [x] **Ronda 1 despachada** — architect-1 (`da6d1f27`, foco gates/config/coste) y architect-2 (`b91d4cc5`, foco `[NO-VER]`/semántica), 22:27 UTC
- [x] **Ronda 1 recibida** — architect-2 (22:45) y architect-1 (22:47). **Ambos `APRUEBO CON CAMBIOS`.**
- [x] **Ronda 2 despachada** (10 bloqueantes) → **v2 recibida 23:29: 15 reglas**
- [x] **CONFIG VERIFICADA POR MÍ** — extraída literal del doc, **dispara al primer intento**
- [x] ✅ **ARTEFACTO 2 PUBLICADO** — 15 reglas, secuencia 1..15 exacta verificada en disco
- [x] ✅ **ENMIENDA aplicada al ARTEFACTO 1** (regla 8) — el hallazgo del fail-open se propagó hacia atrás
- [x] **Panel de developers arrancado** — developer-3 autor (`5298e557`), 23:33 UTC
- [ ] Crítica de developer-1 y developer-2 → republicar artefacto 2
- [ ] `TypeScript_rules_evidence.md` · Commit + push

---

## 🔴🔴 LA SEXTA — Y ES EL HALLAZGO MÁS PROFUNDO DE TODA LA SESIÓN

**Un gate puede estar MUERTO y reportar que está vivo.**

El doc nombraba `eslint --print-config` como su **prueba de vida**. architect-1 desalineó **una línea** (`boundaries/include` con prefijo que no matchea `root-path`):

```
errores de boundaries:  0            ← GATE MUERTA (deny-by-default → allow-everything)
--print-config:         severidad 2, severidad 2, severidad 2
```
Ni `no-unknown-files` grita: no clasifica el archivo → no lo considera *desconocido*, lo considera **fuera de alcance**.

**Y él lo cometió corriendo la config del autor, con el doc delante, BUSCANDO defectos.** 3 iteraciones, 2 fallos silenciosos.

**YO LO VERIFIQUÉ DE LA PEOR FORMA: no pude hacerla andar.** Escribí mi propia config de boundaries — **3 intentos, los 3 exit 0** sobre `domain → adapters`, y `--print-config` diciéndome severidad 2. **Soy el tercero que la mata sin enterarme.** Mi fracaso accidental e independiente **es la prueba**.

> **`eslint --print-config` prueba severidad y opciones. NO prueba que la regla alcance archivo alguno.**
> **La única forma de saber que un gate está vivo es probar que FALLA sobre algo.**

Es el defecto de la regla 15 vieja **reencarnado dentro de su reemplazo**.

**Regla 15 final:** *"…ejecuta cada fixture negativo **afirmando que falla con el rule ID esperado**; un negativo que pasa es no conformidad **aunque `--print-config` muestre severidad de error**."*

**Y SE PROPAGÓ HACIA ATRÁS:** la regla 8 del artefacto 1 tenía el mismo hueco, más débil. **Enmienda aplicada** (frase escrita por architect-3, no por mí).

## Los otros bloqueantes de la Ronda 1

- **B2 — architect-3 contradecía al hermano.** Su regla 10 prohibía TODO specifier calculado; **la regla 22 del doc de código, ya publicada, dice textualmente que NO los prohíbe y que se inventarían.** Su propio header dice *"complementa, nunca reemplaza"*. architect-1 mostró que **no hace falta prohibirlos**: `no-orphans` + región contenida como **sumidero** cierra el mismo ciclo real (exit 1) sin romper el patrón de locales de Vite. **Y el selector tenía un bug liso:** `[source.type!='Literal']` bloquea `` import(`./x.js`) `` — estático, resoluble, arista real del grafo.
- **B3 — reloj y aleatoriedad nombrados en la regla 4, ningún gate los veía, NO declarados `[NO-VER]`.** Y **vivos en el repo**, en `shared` (que el doc declara sujeto a la misma pureza que `domain`): `Date.now()` ×8, `Math.random()`, `new Date()`. La solución obvia (`no-restricted-globals` sobre `Date`/`Math`) **rompe `Math.max` y `new Date(iso)`** — architect-1 la corrió para descartarla **con evidencia, no de palabra**. Fix: gatear la **capacidad**, no el identificador. 6 selectores: 6 impuros caen, 2 puros pasan.
- **B4 — `export * as ns`**: inconsistencia a 3 bandas. La regla decía `export *` sin calificar, TS-código 21 lo **permite**, y el gate `[exported=null]` **no lo caza**. En una API pública de feature **es una fuga** (re-expone el namespace interno entero). La regla tenía razón; el gate y el hermano estaban mal *para esa superficie*.
- **B5 — `enhancedResolveOptions` ausente** → `mermaid` (ESM exports-only) da **falso positivo el día uno**. "Y ése es el momento exacto en que la gente apaga la gate."
- **B6 — `import = require` cross-feature pasaba TODOS los gates.** boundaries 7.0.2 no lo ve (verificado sobre el dist: los nodes son `import|export|dynamic-import|require`), el tapón nombrado **no estaba en su config**, y el patrón del hermano **no matchea este layout**. Fix gratis: dáselo a `dependency-cruiser`, que **sí** lo ve. Caza los 6 casos.
- **B7 — `[NO-VER]` de la regla 14 PARCIALMENTE FALSO** (lo predije, a-2 lo cazó, yo lo verifiqué):
  ```
  shared/ con UN dependiente                  → EXIT 1  DISPARA
  con DOS, features DISTINTAS                 → EXIT 0  pasa
  con DOS, la MISMA feature                   → EXIT 0  ¡PASA!  ← punto ciego
  ```
- **B8 — las «fronteras registradas» eran una ESCAPATORIA. Los dos críticos convergieron SIN HABLARSE:** a-2 metió lógica de negocio en `index.ts` y `bootstrap.ts` → **exit 0, ningún gate**; a-1 lo dedujo notando que **Arq. General 3 no estaba conservada**. Fix del barrel-only verificado por mí.
- **B9 — la regla 7 estaba ARQUITECTÓNICAMENTE MAL:** *"todo adapter implementa un port"* — falso para los adapters **de entrada** (receiver HTTP/IPC/Tauri valida, traduce e invoca la acción; no implementa port de salida).
- **B10 — R1/R9/R11 decían re-enunciar completo y NO lo hacían.** R1 debilitaba Arq. General 1 (módulo → feature).

## Verificación final del coordinador — LA CONFIG ES REPRODUCIBLE

Extraída **literal del markdown publicado**:
```
1:20  boundaries/dependencies  "no policy allowing domain(feature=orders) → adapters(feature=orders)"
3:36  no-restricted-syntax     "RELOJ: domain/shared recibe el instante por parámetro o port"
✖ 2 problems.  EXIT=1
```
**Yo fracasé 3 veces escribiendo la mía. La suya dispara al primer intento.** Ésa es la diferencia entre una config con 6 variables sin definir y una reproducible.

## Panel de developers — encargo

**Lo que los architects NO hicieron y el propio documento ahora exige:**
1. **CONSTRUIR Y CORRER la suite de fixtures negativos**, afirmando el rule ID de cada uno. **La suite no existe.** Un negativo que pasa = **gate muerto** = hallazgo de primer orden. Y **enumerar los modos de muerte silenciosa** de la config.
2. **Medir el coste real de adopción** sobre `repo-AgentsCommander`. Nadie lo hizo: los gates se verificaron contra fixtures de juguete. ¿Es adoptable o describe una arquitectura que este código no alcanza sin reescribirse?
3. **Cazar el séptimo `[NO-VER]` falso.** El patrón se repite.

Le dije que **`SIN CAMBIOS` es respuesta válida**.

## 🟢 La regla 15 deja de ser una promesa vacía

Exigía *"un lint de boundaries"* **que no existe en ningún repo** — el arquetipo del defecto, **y exactamente donde en Rust terminé pidiendo un checker de 1.300 líneas y el usuario me frenó**.

architect-3 lo reemplazó por gates **off-the-shelf, sin construir nada**:

| Promesa de la regla 15 | Gate real, corrido |
|---|---|
| Ciclos (incluidos **tipos**) | `dependency-cruiser` 18.0.0 + `tsPreCompilationDeps:true` → cazó **9 clases**: estático, alias `paths`, reexport, `import()`, `require()`, `import = require`, self, `import type`, `import { type X }` |
| Internals cross-feature | `boundaries/dependencies` con captures + `no-restricted-imports` (TS-código 22) |
| `domain` → I/O | deny-by-default + `no-restricted-globals` + selectores `globalThis.x`, `globalThis["x"]` **y el alias `const p = globalThis`** ← aplicó la lección del bracket del artefacto 1 |
| Cada archivo en una capa | `boundaries/no-unknown-files` |
| Barrel público | `ExportAllDeclaration[exported=null]` |

## 🔴 LA SEXTA PROMESA FALSA ESTABA EN MI BRIEFING

Le sugerí `import/no-cycle` — la opción obvia. **La probó y la descartó.** Lo verifiqué:

```
ciclo SOLO-DE-TIPOS:  a.ts --import type--> b.ts --import type--> a.ts

import/no-cycle (+ resolver TS)                 → EXIT 0.  NO LO VE.
dependency-cruiser (tsPreCompilationDeps:true)  → EXIT 1.  no-circular: a → b → a
```
En un doc de arquitectura TS —donde `domain` y `ports` son mayormente **tipos**— es justo la clase de ciclo que más importa. Si me hubiera hecho caso, la regla 15 salía con un **`[TOOL]` falso**.
**El estándar de la mesa cazó al coordinador. Otra vez.**

## Lo que arregló del doc viejo (todo lo que le marqué)

Regla 1 sin `src` hardcodeado · Regla 2 sin `verbo-sustantivo.ts` · **Regla 14 restituye "mismo motivo de cambio"** (era más débil que Arq. General 16) · autocontención + procedencia · Regla 9 resuelve el conflicto con TS-código 21 (`index.ts` **enumera nombres, no `export *`**) · contrato de adopción · tabla de grafo deny-by-default · **buscó el marcador de truncamiento en su propio mensaje** (cero coincidencias).

## 🔴 Lo que encontré YO y él no puede saber (lo purgué)

**Su config prohíbe TODO specifier calculado** (`import(expr)`, `require(expr)`).
**Eso fue BLOQUEANTE en el artefacto 1**: rompe ``import(`./locales/${lang}.js`)`` (patrón Vite) y **una regla que sobre-bloquea se apaga, reabriendo el agujero que existía para tapar**.

**Pero él tiene un argumento NUEVO:** un specifier calculado **no produce arista en el grafo** → el gate de ciclos tiene un **agujero silencioso** si los permitís.

Se lo mandé a architect-1. Opciones: prohibirlos (grafo completo, regla que se apaga) · permitirlos **enumerados** (huecos declarados, no silenciosos). **No acepto que quede implícito.**

## Encargos

- **a-1**: dirimir el over-block · auditar la config (¿`boundaries` no ve `import = require`? ¿`no-private` deprecated? ¿los selectores cubren `self`/`top`/alias en 2 saltos?) · **correr `dependency-cruiser` contra los 242 archivos reales — nadie midió cuántos ciclos hay hoy**.
- **a-2**: cazar el `[NO-VER]` falso. **Candidato #1: regla 14** — dice *"no hay regla off-the-shelf que gatee cardinalidad dos"*, pero **`dependency-cruiser` TIENE el grafo**. También: ¿el `index.ts` fuera de las capas es escapatoria o agujero? Que meta lógica de negocio ahí y vea si algún gate la caza.

---

## 🔴 EL ENTREGABLE FINAL VINO TRUNCADO. Lo cacé porque conté las reglas a mano.

El mensaje de developer-3 contenía **literalmente** el texto `…301 tokens truncated…` en la línea 311. Su tooling se comió **el cuerpo de la regla 35 — la de XSS**, la que este panel entero se dedicó a arreglar. Sólo sobrevivió la cola.

Daño doble: **la regla 35 perdió su número y su salto de línea.** No existía ninguna línea que empezara con `35.` — quedó como continuación sin numerar de la 34. En markdown se renderizaban como **un solo ítem** y la lista saltaba de 34 a 36.

**Su auto-chequeo decía:** *"Título: 38; reglas reales: 38, secuencia 1–38. Matriz: 20 filas, cobertura continua 1–38."* **Falso.** Había 37 ítems y la matriz referenciaba una fila `35–36` inexistente.

**Es la lección #1 calcada del panel de Rust** (developer-1 borró `lints.workspace = true` al reescribir una regla, dejó inerte la tabla entera, y auto-reportó 49 reglas cuando el markdown tenía 53). **Mismo rol, mismo modo de fallo, y esta vez sobre la regla de XSS.**

Verifiqué que era el **único** truncamiento → pedí sólo la regla 35 verbatim, partida en 2 mensajes. Cero retrabajo.

## ✅ ARTEFACTO 1 REPUBLICADO — 38 reglas (20 → 37 → 38)

### Verificación final del coordinador — corrí el apéndice EXTRAÍDO DEL DOC PUBLICADO

```
CARGA sin error fatal  → los 24 selectores son ÚNICOS
                         (ESLint 9.39.5 rechaza duplicados con exit 2)

innerHTML/outerHTML/insertAdjacentHTML/document.write (punto)  → 4 ✅
los mismos por bracket literal                                 → 4 ✅
*.document.write / *['document'].write / *['document']['write']→ 3 ✅
setHTMLUnsafe (punto + bracket)                                → 2 ✅
document.writeln / *.document.writeln                          → 2 ✅
4 eslint-disable-next-line sin descripción                     → 4 ✅
/* eslint-disable */                                           → 2 ✅
                                                        24 diagnósticos, exit 1
```
**Los CINCO bypasses que el panel descubrió en 5 rondas están cerrados.**

En disco: **38 reglas, secuencia 1..38 exacta**, título coincide. `git status`: sólo ese archivo. Los otros dos repos limpios.

### Consenso del panel de developers

| Agente | Veredicto |
|---|---|
| developer-3 (autor) | v2 con B1–B9 + R2 aplicados |
| developer-1 | `APRUEBO CON CAMBIOS` → los 5 bloqueantes entraron |
| developer-2 | `APRUEBO CON CAMBIOS` → los 3 bloqueantes entraron |

### Las CINCO promesas falsas que cazó la mesa (y el patrón que revelan)

1. `no-floating-promises` + `ignoreVoid:false` **sí** gatea `void p` → estaba `[NO-VER]`
2. `no-unsafe-type-assertion` **sí** atrapa `as unknown as` → estaba `[NO-VER]`
3. Los 4 sinks HTML **sí** se gatean → estaban en "checklist humano". **Era XSS.**
4. Los selectores del fix #3 **sólo cazaban notación con punto** → `el["innerHTML"]` pasaba
5. **`eslint-disable` no estaba gateado** → una línea apagaba el catálogo entero. **Instancia viva en `HomeView.tsx:54`, justificación vacía, sobre la regla de XSS.**

**El patrón: cada vez que se cierra el gate, el mecanismo que lo cierra sobre-promete.** El defecto es recursivo. Por eso hicieron falta 5 rondas y por eso el coordinador tiene que correr el mecanismo él mismo cada vez.

---

## 🔴🔴 LA QUINTA — `eslint-disable` NO ESTÁ GATEADO. Invalida TODOS los `[TOOL]` de ESLint.

developer-1: *"No está en el texto: está en el hueco que el texto no nombra."*

El doc persigue la vía de escape de **TypeScript** con cirugía (regla 12 prohíbe `@ts-ignore`; regla 13 obliga `descriptionFormat`) y **no dice una palabra sobre `eslint-disable`.**

**VERIFICADO POR MÍ:**
```
4 sinks XSS + // eslint-disable-next-line (justificación VACÍA)  → exit 0, 0 diagnósticos
/* eslint-disable */ en línea 1                                  → exit 0. UNA LÍNEA apaga el catálogo entero.
```
**Y la instancia viva — VERIFICADA POR MÍ en `HomeView.tsx:54`:**
```tsx
// eslint-disable-next-line solid/no-innerhtml
innerHTML={html()}
```
**Justificación vacía. Sobre la regla de XSS. En la ruta de DOMPurify.** developer-3 **la vio** ("ESLint informa 18 porque HomeView tiene una supresión local") y la trató como **detalle contable**.

→ **Invalida reglas 12, 13, 14, 15, 18, 21, 22, 24, 25, 27, 28, 31, 34, 35 y media 9/10.**
Es el corolario en su forma más pura: **la cláusula de excepción ni siquiera está en el documento — está en la herramienta, y el documento nunca la nombra.**

## Los otros bloqueantes

**B2 (d-1) — "los cuatro sinks" NO es conjunto cerrado.** Contra los 14 selectores propuestos: `setHTMLUnsafe`, `document.writeln`, `createContextualFragment`, `DOMParser.parseFromString`, `Object.assign(el,{innerHTML})` → **todos 0 diagnósticos**. **`setHTMLUnsafe` es la grafía MODERNA de `innerHTML`, envía en Chromium 124+/WebKit 17.4+ — los motores exactos de una app Tauri.**

**B3 (d-2) — el fix del bracket tiene su propio resto. VERIFICADO POR MÍ:**
```
globalThis.document.write     → CAZADO ✅
globalThis["document"].write  → PASA ❌     ← NO es uno de los 3 residuos declarados
window["document"]["write"]   → PASA ❌
```
**El fix de la cuarta promesa falsa tiene su propia promesa falsa adentro.**

**B4 (d-1) — Regla 35: dos frases FALSAS.**
- *"un tipo que el caller no puede construir directamente"* → **un brand SÍ se falsifica con `as`, y el propio doc lo dice** (reglas 14 y 16). La garantía real es **visibilidad, no imposibilidad**. Techo honesto: Trusted Types — **pero WebKit no lo implementa** → Tauri no puede apoyarse en él.
- *"un string EXTERNO no llega a innerHTML"* → `document.body.innerHTML = ""` es un **literal vacío**, no externo. **Por la letra de la regla, 14 de los 15 hallazgos que d-3 reporta NO son infracciones.** La herramienta es más gruesa que la regla y **d-3 dejó que la herramienta definiera la regla**. Fix: redactar por **sink**, no por procedencia.
- Y d-1 **rechazó el precedente de Rust que yo sugerí**: *"la conclusión transfiere, el razonamiento no"*. Un `todo!()` en test es el mismo defecto en ambos lados; `innerHTML=""` en un test **no es vulnerabilidad**. La razón correcta es otra y más fuerte: **una exención indexada por ruta es otra forma de vaciar la regla**.

**B5 (d-1) — "Adopción incremental" está escrita AL REVÉS.**
- **Prohíbe el mecanismo seguro:** mete en la misma bolsa la baseline silenciosa (mala) y el **registro enumerado con dueño** (bueno). **El repo YA TIENE el bueno: `test-debt.allowlist.json`** — 19 entradas con `id/category/owner/reason/resolution`, reporta stale, falla ante cualquier hallazgo no allowlisteado. **El párrafo la condenaría.**
- **Autoriza el peligroso:** *"acotar `files` sólo si cada gate cubre por completo el alcance que declara"* es **CIRCULAR** — un gate siempre cubre el alcance que declara, porque **quien declara elige el alcance**. Enciendo los sinks sólo en `src/main/**`, exit 0, verde… y `src/sidebar/**` (**823 de 1.176 diagnósticos**) queda "fuera del alcance declarado".
- 4 pernos: alcance = repo entero + **lista de exclusiones** versionada; monotonía; prohibir conformidad global ("cumple N de 37 sobre M de M archivos"); admitir el registro enumerado.

**B6 (d-1) — el número es 1.176/25, no 1.174/23.** Y lo diagnosticó: el 1.174 sólo sale atando los lints type-aware al **tsconfig canónico**; contra el **tsconfig real** (que es lo que exige la propia regla 8) da 1.176. **El baseline de lint es función del tsconfig** → durante una migración **se mueve solo**.

**B7 (d-1) — el apéndice publicado se come 2 FATALES el primer día.** `vite.config.ts`/`vitest.config.ts` están fuera del `include`; el apéndice usa `files:["**/*.{ts,tsx}"]` desde la raíz. El "0 fatales" era cierto **sólo porque la corrida se acotó a `src`**. Y **el repo ya viola la regla 1**.

**B8 (d-2) — el test de la regla 32 no prueba "exactamente".** Un cleanup que **primero borra un listener y un timer AJENOS** y después hace los inversos correctos → **el test PASA** (sólo mira `mock.calls.at(-1)`). Fix: `mockClear()` + `toEqual` sobre el **conjunto completo**.
**El test de la regla 33 SOBREVIVIÓ**: sin el guard `active` falla; con `--unhandled-rejections=strict` pasa; sin coupling a internals. **Ese `[NO-VER]` es artefacto real.**

**B9 — regla 22: "deuda estructural" no puede ser waiver.** Los dos críticos convergieron por separado. d-2 reprodujo los 25 exactos y encontró: `../main/App.tsx` (con extensión) **falla** — la negación sólo re-incluye el specifier sin extensión; y **evasión CJS** (`require()` literal no cae).

## Verificaciones del coordinador en esta ronda

Corrí y confirmé: los dos bypasses de `eslint-disable`; la supresión viva en `HomeView.tsx:54`; el resto del bracket (`globalThis["document"].write`). **d-1 reprodujo TODOS los números de d-3** salvo `no-unnecessary-type-assertion` (25 vs 23), y explicó la diferencia.

## Nota de proceso

Re-pinguée a developer-2 por "caído": su archivo se escribió **4 segundos después** de mi chequeo. **Falso positivo, carrera de timing.** El chequeo era correcto en su momento. Riesgo: que rehaga trabajo al pedo. Si llega un segundo reporte, comparar y descartar.

## Tensión entre paneles — la debe dirimir developer-3

**Regla 26** (mensaje del decoder): los **architects la restituyeron por demanda UNÁNIME** (era la original 18), argumentando que General 6 pide *"operación, recurso y causa"* — otra granularidad. **developer-1 dice que es General 6+19+15 con insignia de TS, sin mecanismo TS, 100% `[NO-VER]`.** Los dos paneles no coinciden. Se lo pasé al autor para que dirima con fundamento.

---

## 🔴 CUARTA PROMESA FALSA — LA PUBLIQUÉ YO

Los selectores de sinks HTML que publiqué **sólo cazan notación con punto**. **VERIFICADO POR MÍ:**

```
SELECTORES PUBLICADOS, 9 formas de sink:
  el.innerHTML / el.outerHTML / el.insertAdjacentHTML / document.write   → CAZADOS ✅ (4)
  el["innerHTML"] = html                                                  → PASA ❌
  el["outerHTML"] = html                                                  → PASA ❌
  el["insertAdjacentHTML"](...)                                           → PASA ❌
  document["write"](html)                                                 → PASA ❌
  globalThis.document.write(html)                                         → PASA ❌
                                                          4 de 9
```
**Un par de comillas evade el gate de XSS entero.**

**Su expansión — VERIFICADA POR MÍ: 9/12.** Split `computed=false` (punto) + `computed=true`/`property.value` (bracket) + `globalThis/window.document.write`. Las 3 indirectas restantes (destructuring, `.bind`, `Reflect.set`) las **declara como residuo explícito** en regla/matriz/checklist en vez de venderlas como cubiertas. Movimiento honesto.

## Números REALES del repo (developer-3, primera vez que se mide)

**Apéndice completo vs 242 archivos: 1.174 diagnósticos, 139 archivos, 0 fatales.**

| Rule | Total | Prod | Test |
|---|---:|---:|---:|
| `no-non-null-assertion` | 442 | 165 | 277 |
| `no-unsafe-type-assertion` | 145 | 75 | 70 |
| `no-misused-promises` | 128 | 128 | 0 |
| `no-restricted-syntax` | 94 | 72 | 22 |
| `no-floating-promises` | **87** | 84 | 3 |
| `consistent-type-imports` | 62 | 60 | 2 |
| `solid/reactivity` | 46 | 42 | 4 |

**Delta de los mecanismos que agregamos:** `ignoreVoid:false` **+62** (25→87) · `no-unsafe-type-assertion` **+145** · `no-restricted-syntax` **+94** · sinks HTML **+15**.

**Sinks reales:** 15 `innerHTML` imperativos (**14 limpiezas de test** + **1 producción: `MermaidPreview.tsx`**), 4 atributos JSX. **0 `outerHTML`, 0 `insertAdjacentHTML`, 0 `document.write`.**
**La "frontera única tipada" de la regla 35 NO EXISTE:** `HomeView.tsx` usa DOMPurify pero devuelve `string` común → el caller puede construirlo. `MermaidPreview.tsx` asigna el SVG de Mermaid directo a `innerHTML`, sin frontera de app ni test malicioso. (Él NO afirma exploit — correcto.)

## Regla 22 contra el grafo real

- 242 archivos. **0 `index.ts`. 0 dirs `internal`/`private`/`impl`.** Aliases `@shared/*`, `@sidebar/*`, `@terminal/*` **exponen cualquier archivo profundo**.
- **Patrón canónico `feat-*/internal` → 0 diagnósticos. Gate vacío.**
- Con contrato provisional (`<feature>/App` público): **25 infracciones** (15 prod, 10 test). main 11, sidebar 11, terminal 3.
- *"Un glob puede prohibir rutas; no puede fabricar la API de destino."* → agrega **"deuda estructural"** a la regla.

## Adoptabilidad

6 flags tsc combinados: **344 diagnósticos**. **NINGUNA zona verde** (browser 106, main 114, sidebar 93…). Encendible hoy con exit 0: sólo `noUncheckedSideEffectImports`, `ban-ts-comment`, `solid/no-destructure`.
→ Agregó párrafo **"Adopción incremental"** al header.

## Los dos tests: ESCRITOS Y PASANDO (tsc exit 0, Vitest 2/2)

Regla 32 (inverso exacto: identidad de handler + timer id) y regla 33 (nueva→vieja, dispose→resolve, dispose→reject sin rejection colgada). **Sin acoplarse a internals de Solid.** → esos `[NO-VER]` **son artefactos reales, no columnas vacías**.

## Lo que les pedí a los críticos — buscar la QUINTA

- **d-1:** reproducir los 1.174; ¿la config expandida (14 selectores vs 8) agrega ruido?; **¿el párrafo de "adopción incremental" es honestidad o es la quinta forma de vaciar el doc?**; los 14 `innerHTML=""` de tests (precedente Rust regla 7: *"un `todo!()` en un test es el mismo agujero que en producción"*).
- **d-2:** reproducir los 25; **¿"es deuda estructural" en la regla 22 es honestidad o quinta válvula de vaciado?**; y sobre todo: **ROMPER los dos tests** — escribir un cleanup incorrecto y verificar que el test FALLA. *Un test que no falla ante el bug que persigue no es un test.*
- [ ] Publicar v2 del artefacto 1 (developers)
- [ ] Artefacto 2 (arquitectura): panel de architects → developers
- [ ] `TypeScript_rules_evidence.md`
- [ ] Commit + push

---

## ✅ ARTEFACTO 1 — PUBLICADO (panel de architects)

`code_best_practices/TypeScript_best_rules.md` — **20 → 37 reglas** (26 TS + 11 Solid).

### Verificación FINAL del coordinador — corrí el apéndice tal cual está escrito

**Perfil `base + features`:**
```
a-sinks.ts        4 SINKS disparan → exactamente 4, SIN duplicar pese a que `features`
                  re-declara no-restricted-syntax (su manejo de flat-config es correcto) ✅
b-dynamic.ts      SÓLO import("./feat-a/internal/impl.js") dispara
                  import("./internal/logger.js")   → PASA  ✅ falso positivo CORREGIDO
                  import(`./locales/${lang}.js`)   → PASA  ✅ falso positivo CORREGIDO
                  import("./feat-a/index.js")      → PASA  ✅
c-static-internal import estático a internals      → dispara ✅
d-exports-ok.ts   export * as feat + export {pub}  → PASAN  ✅ el fix [exported=null] anda
e-export-star.ts  export * from                    → dispara ✅
```
**Perfil `base` SOLO (repo NO organizado por features):**
```
4 sinks XSS      → disparan ✅ (aplican a todo proyecto TS)
export * from    → dispara  ✅
features         → CERO diagnósticos ✅  el alcance condicional funciona
```
**En disco:** 37 reglas numeradas, secuencia 1..37 exacta, título coincide. `git status`: sólo ese archivo.

### Consenso final

| Agente | Veredicto |
|---|---|
| architect-3 (autor) | v3 con los 4 bloqueantes aplicados |
| architect-1 | `APRUEBO CON CAMBIOS` → pre-comprometido: *"si los dos bloqueantes entran, paso a APRUEBO"* → **entraron y los verifiqué** |
| architect-2 | `APRUEBO CON CAMBIOS` → sus 2 bloqueantes entraron; **retiró su disenso sobre 9/12** |

**NO hubo voto por mayoría. Convergencia real.** architect-2 cambió de postura por evidencia, no por consenso (le dije explícitamente que no cediera).

---

## PANEL DE DEVELOPERS — Artefacto 1

Autor: **developer-3** (rotación cumplida). Críticos: developer-1, developer-2.

**Su encargo es lo que los architects NO hicieron: verificar contra CÓDIGO REAL, no contra fixtures.**

1. **¿La regla 22 es siquiera INSTANCIABLE?** El apéndice usa la convención `feat-*/internal`. El repo real usa `browser/ guide/ main/ resource-monitor/ screenshot-overlay/ shared/ sidebar/ spec-board/ terminal/`. **Cero directorios `feat-*` → el patrón matchea NADA.** El doc se cubre con *"cada repo sustituye la convención"*, pero **nadie lo hizo ni probó que se pueda**.
2. **Correr el apéndice COMPLETO contra `repo-AgentsCommander/src`.** Nunca se hizo — sólo contra fixtures de 5 líneas. Cuántos diagnósticos por regla con la config NUEVA (`ignoreVoid:false`, `no-unsafe-type-assertion`, 4 sinks HTML, `allowStatic:false`). **¿Cuántos sinks de HTML imperativo hay en el código real?** Es la regla de XSS y jamás se midió contra el repo. El repo usa `dompurify` — ¿existe ya la frontera de sanitización?
3. **¿El doc es ADOPTABLE o es decorativo?** Coste real, adopción por zonas, subconjunto encendible hoy con exit 0.
4. **Los 6 `[NO-VER]` prometen TESTS. ¿Se pueden escribir?** Que escriba 2 de verdad con Vitest y los corra. El de la regla 33 (carrera + post-dispose) es el más difícil. **Si un test que la regla exige no se puede escribir, la regla es una promesa vacía.**

Le dije explícitamente que **`SIN CAMBIOS` es una respuesta válida** si el doc se sostiene. No quiero cambios inventados para justificar la ronda.

---

## RONDA 3 — resultado. NO HAY VOTO POR MAYORÍA.

**architect-2 RETIRÓ su disenso sobre 9 y 12 → BORRAR OK.** Convergencia real, no negociada: cambió de postura por evidencia. Aportó además **Arq. General 15** (composition root, siempre-on), que cubre el *"recibe sus dependencias"* de la original 9. Ese cierre está firme.

**architect-1 se comprometió por escrito:** *"Si los dos bloqueantes entran, paso a `APRUEBO` sin más rondas."*

### 🔴 4 BLOQUEANTES, los 4 VERIFICADOS POR MÍ corriendo el lint

**B1 (a1) — El `[NO-VER]` de XSS es FALSO. Los 4 sinks SE GATEAN.**
```
b35-html-sinks.ts
  4:3 SINK innerHTML   5:3 SINK outerHTML   6:3 SINK insertAdjacentHTML   7:3 SINK document.write
  → LOS 4 DISPARAN con no-restricted-syntax (core ESLint, YA en su apéndice)
```
**TERCERA aparición del mismo defecto** (`void p` → `as unknown as` → sinks HTML), esta vez sobre **la regla de mayor riesgo del catálogo**. El corolario literal: *una cláusula de revisión humana usada para VACIAR una regla* — y la vaciada era **la de XSS**.
Fix: 4 selectores al apéndice; matriz 35 `[NO-VER]` → `[TOOL]`, salvo **calidad del sanitizador** (irreducible).

**B2 (a1) — Los 2 selectores `ImportExpression` de la regla 22 sobre-bloquean Y están fuera de alcance.**
```
import("./feat-a/internal/impl.js")  → dispara  ✅ correcto
import("./internal/logger.js")       → dispara  ❌ FALSO POSITIVO (internals PROPIOS del módulo)
import(`./locales/${lang}.js`)       → dispara  ❌ FALSO POSITIVO (locales, patrón Vite)
import("./feat-a/index.js")          → pasa     ✅ correcto
```
- Los **dos mecanismos de la MISMA regla 22 se contradicen**: `no-restricted-imports` deja pasar los internals propios (correcto), el selector los marca.
- El selector `:not([source.type='Literal'])` prohíbe **todo** import dinámico calculado, repo-wide. Ninguna regla del doc lo prohíbe.
- **Scope:** los dos viven en el bloque GLOBAL del apéndice, pero la regla 22 es **condicional** (*"cuando el repo se organiza por features"*). **El apéndice canónico impone a TODO repo lo que el doc impone sólo a ALGUNOS.**
- Daño recursivo: una regla que sobre-bloquea **se apaga**, y al apagarla **se reabre el agujero que existía para tapar**.
Fix: anclar a `/feat-[^/]+\/internal\//`; **partir el apéndice en `base` / `features` / `solid`** (arregla de paso que las 5 reglas `solid/*` corran en todo repo pese al "26 de 37").

**B3 (a2) — El gate es MÁS ESTRICTO que la regla. Defecto ESPEJO.**
```
<div innerHTML={"<strong>static</strong>"} />
  default (allowStatic:true)   → exit 0
  {allowStatic:false} (SU apéndice) → DISPARA
```
La regla 35 promete *"un string **externo**"*, pero el gate rechaza **markup literal sin entrada externa**. Un dev choca con un error que la regla no explica → apaga la regla. Fix: que regla y mecanismo digan lo mismo.

**B4 (a2) — Reglas 32/33: el artefacto no prueba lo que la regla promete.**
- 32: `cleaned=true` sólo prueba que corrió *algún* callback, no que revierte **la adquisición exacta** (mismo handler/id/unsubscribe/abort).
- 33: la regla promete seguridad **post-dispose**, pero el test sólo fuerza la carrera nueva→vieja. Falta: disponer → resolver la vieja → afirmar que no muta estado.

### ✅ CERTIFICADO por los críticos — deuda cerrada, no se toca

- **Regla 13 / `descriptionFormat` NO es promesa falsa.** El formato acepta `TS9999` (código inventado) → obliga a escribir *un* código, no *el* código. **Pero el doc lo dice en voz alta y lo deja `[NO-VER]`.** a1 buscó un mecanismo de identidad diagnóstica en la toolchain: **no existe**. `[NO-VER]` genuino. **Mi sospecha era infundada y él la refutó corriendo.**
- **`tsc --showConfig` SÍ expande la familia `strict`** → la regla 2 no necesita nada. Y da el enunciado correcto de la asimetría: **`tsc --showConfig` expande defaults; `eslint --print-config` NO expande opciones de regla.** Ésa es la formulación precisa que costó dos rondas.
- **`export *` NO es alcance colado: es load-bearing para la 22.** Si `feat-a/index.ts` hace `export * from './internal/impl.js'`, toda la superficie de internals sale por el entrypoint legítimo y `no-restricted-imports` **no lo ve**. Aterriza en Arq. General 17 (siempre-on).
- **5 de los 6 `[NO-VER]` sobrevivientes son reales** (11, 24, 29, 30, 37). Sólo el de XSS era falso.

### ⚠ Errores propios declarados — el estándar de la mesa aplicó a todos

- **architect-1** corrió su H4 y **lo declaró falso él mismo**: *"Nombré un mecanismo y no lo corrí — el pecado exacto de esta mesa, cometido por mí, dentro del hallazgo en el que acusaba a architect-3 de no correr las cosas."*
- **Disclosure que NADIE le pidió:** de sus 19 referencias del Encargo A, **abrió personalmente 2**; las otras 17 las abrieron **subagentes con WebFetch**. Las 3 "MAL" salieron de ahí. Riesgo mitigado: las citas salieron **en contra** de la propuesta (un subagente que alucina tiende a confirmar, no a contradecir), architect-3 **reabrió y confirmó** la cita correcta de `readonly`, y architect-2 leyó las mismas páginas de forma independiente.
- **YO** relayé H4 sin verificarlo. architect-3 me corrigió.

---

## RONDA 2 — v2 de architect-3: 37 reglas (8 toolchain + 18 tipos + 11 Solid)

Aritmética verificada por mí: 8+18+11 = 37 ✅ · "sin Solid debe 26 de 37" → 8+18 = 26 ✅

**Aceptó prácticamente todo:**
- **Restituyó 6→21 (named exports), 17→22 (internals + alias de `paths`), 18→26 (mensaje del decoder).** Unánime cumplido.
- **Mantuvo borradas 9 y 12**, del lado de architect-1, y **re-ancló el header a Arq. General 4/6/8 (siempre-on)**. Cumple la condición que a1 puso. **a2 había pedido restituirlas → queda por resolver en R3.**
- **Regla 8 con MIS DOS condiciones**: habilitación explícita aunque el preset la incluya + opciones explícitas. Mi hallazgo emergente entró.
- Reclasificó doble aserción y `void p` de `[NO-VER]` → `[TOOL]`. Corrigió las 3 citas. Apéndice (M1) + alcance normativo (M2). Sacó el claim de JS del header. Pegó su `eslint.config.mjs` de R0 (confirmó que el `{ignoreVoid:true}` lo escribió él a propósito, como control negativo).

## ⚠ architect-1 se equivocó, y yo relayé su error sin verificar

Su **H4** afirmaba que dos configs de comportamiento opuesto **imprimen igual** (`[2]`). **FALSO. Lo corrí yo:**

```
CONFIG A (preset, sin opciones):        2
CONFIG B (explícita ignoreVoid:false):  [2,{"ignoreVoid":false}]
```

**No imprimen igual.** Yo pasé H4 a architect-3 como verificado habiendo verificado sólo H2/H3. **architect-3 lo cazó y me corrigió.** El panel funcionó incluso contra el coordinador.

**El diagnóstico y la cura siguen en pie:** de un `2` pelado no se puede saber si `ignoreVoid` es true o false (el default es invisible) → escribir las opciones explícitas sigue siendo el fix correcto. architect-3 lo aceptó igual.
Se lo dije a architect-1 en R3 y le pedí que declare si algo más de su crítica no lo corrió.

## Verificación del coordinador sobre la v2 — EL APÉNDICE CORRE

El apéndice ES el mecanismo del documento. Lección #1: *los autores rompen su propio mecanismo mientras lo mejoran*. Lo corrí contra fixtures:

```
export default                        → no-restricted-syntax       DISPARA ✅
n as unknown as string                → no-unsafe-type-assertion   DISPARA ✅
import "./feat-a/internal/impl.js"    → no-restricted-imports      DISPARA ✅
void work();                          → no-floating-promises       DISPARA ✅
void work().catch(sink);              → PASA ✅
import "./feat-a/index.js" (público)  → PASA ✅
```

No rompió nada. El mecanismo es real.

## Ronda 3 — qué les pedí

**Mecanismos NUEVOS que architect-3 inventó en la v2 y que NADIE criticó** (los defectos emergen al aplicar dos críticas juntas):
- a1: `export *` prohibido (nadie lo pidió); los 2 selectores de `ImportExpression` para `import()`; `ban-ts-comment` con `descriptionFormat` — **¿obliga a ESCRIBIR el código diagnóstico sin verificar que sea el suprimido? ¿promesa vacía reintroducida?**; completitud del apéndice.
- a2: `solid/no-innerhtml {allowStatic:false}` y `solid/reactivity {customReactiveFunctions:[]}` — ¿el array vacío apaga algo?; ¿los residuos "checklist del cambio" son artefacto real o columna humana vacía?
- **a2 debe decidir 9/12**: si sostiene RESTITUIR → **2-1 a favor de borrar**, se registra voto por mayoría con su disenso documentado. Le dije explícitamente que NO ceda por consenso si tiene el argumento.

### Toolchain PINNEADA (resuelta por architect-3, obligatoria para todos)

```
typescript@5.9.3   eslint@9.39.5   typescript-eslint@8.63.0
eslint-plugin-solid@0.14.5   solid-js@1.9.12   node v24.13.0
```

### En vuelo ahora

| Agente | Tarea | Mensaje | Estado |
|---|---|---|---|
| architect-3 | Autor R2 — aplicar crítica consolidada | `20260711-191806-...-architect-3-ts-code-r2-revision.md` | despachado 19:18 UTC |

---

## RONDA 1 — resultado

| Crítico | Veredicto | Cambios exigidos |
|---|---|---|
| architect-1 | `APRUEBO CON CAMBIOS` | 7 |
| architect-2 | `APRUEBO CON CAMBIOS` | 4 |

**Reproducibilidad de la Ronda 0:** 7/7 controles negativos reprodujeron. 11/11 diagnósticos de compilador reprodujeron. La evidencia de architect-3 se sostiene.

### El hallazgo central: architect-3 introdujo el DEFECTO INVERSO

> **Un `[TOOL]` falso promete un gate que no existe. Un `[NO-VER]` falso REGALA un gate que sí existe.** (architect-1)

Y el segundo ES el canal de vaciado: la regla suena absoluta mientras su cumplimiento se le pasa a un humano que no lo va a hacer.

**VERIFICADO POR MÍ (coordinador), corriendo la toolchain pinneada en sandbox propio — no es la palabra de un agente contra otro:**

```
no-unsafe-type-assertion EXISTE en typescript-eslint 8.63.0 : true
  en configs.all                                            : true
  en configs.strictTypeChecked                              : FALSE   ← por eso a3 midió "exit 0"
  no-floating-promises en strictTypeChecked                 : ["error"]  ← SIN opciones

LINT CORRIDO:
  `void work();`               → MARCADA por no-floating-promises {ignoreVoid:false}
  `void work().catch(sink);`   → PASA
  `n as unknown as string`     → MARCADA por no-unsafe-type-assertion
```

→ **Regla 22**: `{ignoreVoid:false}` enuncia la regla LITERALMENTE. El dissent #4 de a3 ("haría falta una regla custom, fuera de alcance") es **FALSO**. `[NO-VER]` → `[TOOL]`.
→ **Regla 12**: la cláusula *"la familia `no-unsafe-*` … no [cubre] la doble aserción"* es **FALSA**. `[NO-VER]` → `[TOOL]`.
→ **Legítimo y se queda**: el `[NO-VER]` del predicado mentiroso (regla 11). `no-unsafe-type-assertion` NO lo atrapa. a1 discriminó bien.

### H4 — el hallazgo más filoso: la regla 8 es una promesa que no verifica

`eslint --print-config` imprime **sólo lo configurado explícitamente; los defaults son invisibles.** Dos configs de comportamiento OPUESTO imprimen ambas `no-floating-promises = [2]`. La regla escrita para policiar promesas vacías es ella misma una promesa vacía.

**MI hallazgo emergente (ninguno de los dos críticos lo vio):** el fix de a1 sólo cubre **opciones**, no **reglas ausentes del preset**. Son dos fallas distintas:
- `no-floating-promises` + `ignoreVoid:true` → falla de **opción** ✅ cubierta por su fix
- `no-unsafe-type-assertion` ausente de `strictTypeChecked` → falla de **habilitación** ❌ NO cubierta
Si a3 aplica sólo la mitad, **el gate de la doble aserción no existe** y la regla 12 vuelve a mentir en la otra dirección. La regla 8 debe exigir AMBAS.

### Encargo B — el criterio ya estaba escrito. VERIFICADO por mí, verbatim, en `IA-Programming/README.md`:

> 1. Aplica **siempre** las reglas universales de arquitectura y de código.
> 2. **Añade las reglas de código del lenguaje usado**; una regla de lenguaje **complementa y no reemplaza** una universal.
> 3. Añade un perfil arquitectónico por lenguaje **sólo cuando un ADR o `AGENTS.md` declare que el repo lo adopta**.

**TEST DE ELIMINACIÓN (a1):** segura ⟺ la obligación aterriza en un doc SIEMPRE-ON (`code General`, `arch General`). Insegura si aterriza sólo en el sibling TS, que es OPT-IN.

**El perfil hexagonal lo adopta CERO repos** (verificado por los 3): sin `AGENTS.md`, sin ADR, sin `src/domain|application|ports|adapters|ui`. `repo-AgentsCommander/src/` es feature-sliced.

| Original | architect-1 | architect-2 | Estado |
|---|---|---|---|
| 6 exports con nombre | RESTITUIR REFORM. | RESTITUIR REFORM. | **unánime: restituir** |
| 9 dominio no importa I/O | **BORRAR OK** (→ arch General 4+6, siempre-on) | RESTITUIR REFORM. | **CONFLICTO** → lo dirime el autor |
| 12 TSX no llama Tauri/red | **BORRAR OK cond.** (→ arch General 6) | RESTITUIR REFORM. | **CONFLICTO** → lo dirime el autor |
| 17 API pública + **alias de path** | RESTITUIR REFORM. | RESTITUIR REFORM. | **unánime: restituir** |
| 18 decoder: campo/valor/expectativa | RESTITUIR | RESTITUIR REFORM. | **unánime: restituir** |

**Lo que NO está en NINGÚN doc:** "exports con nombre"; el escape por **alias de `paths`/`baseUrl`** (detalle propio de TS ⇒ el README manda ponerlo en el doc del lenguaje); y el **mensaje del decoder** (campo+valor+expectativa — code General 6 pide "operación, recurso y causa", otra granularidad).

**La 17 es indefendible como eliminación:** a1 corrió `@typescript-eslint/no-restricted-imports` (ya en 8.63.0) y **gatea el import a internals**, dejando pasar el import al `index.js`. a3 eliminó una obligación **gateable hoy sin construir nada**, delegándola a un doc opt-in **cuyo verificador (arch TS 15, "lint de boundaries") tampoco existe**.

### Reglas 31/32/28 — architect-2 las desarmó con runtime

- **31:** `for recreated=b:3,a:4` — objetos NUEVOS con los MISMOS ids de dominio → `<For>` **reconstruyó** las instancias. Cachea por **identidad de valor/referencia**, NO por key de dominio. La redacción de a3 ("el item mantiene identidad") todavía huele a React.
- **32:** dos sinks negativos NUEVOS → `outerHTML` e `insertAdjacentHTML` también dan **ESLint exit 0**. "Asignación DOM equivalente" no tiene gate.
- **28:** un helper async llamado desde un callback síncrono **también** pierde tracking; la redacción sólo cubre el callback marcado `async`.

### Encargo A — citas: 16 VERIFICADAS / 3 MAL

**No es el defecto de Rust.** Allá la afirmación era falsa. Acá **la conducta es REAL** (reproducida en runtime) **pero el link no la respalda.** Se arreglan los links, no las reglas.
- regla 17 `readonly` → la página citada **nunca menciona runtime**. Fix: `/docs/handbook/2/objects.html#readonly-properties`, que lo dice verbatim **y agrega el alias** → la cita correcta FORTALECE la regla.
- reglas 28/29 → las páginas de Solid **no documentan** tracking sólo-síncrono ni registro síncrono de `onCleanup` ("async"/"synchronous": 0 apariciones). **No existe página oficial.** Se sostienen con el runtime que a3 mismo produjo.

### Faltantes con precedente en el Rust publicado (verifiqué ambos)

- **M1 apéndice de config**: Rust cierra con `[workspace.lints]` + `clippy.toml` + qué queda fuera. Su regla 1: *"un lint nombrado en prosa y ausente de la tabla no verifica nada"*. TS nombra ~14 rule IDs en prosa y **no da enable-list**.
- **M2 alcance por sección normativo**: Rust línea 9 — *"Un crate sólo debe las reglas de las secciones que lo alcanzan: un binario sin async ni FFI debe 28 de las 48."* TS pone sufijos pero **no los declara normativos**.

### Calibración que hice y me evitó un falso hallazgo

El README exige *"una regla ocupa una línea y expresa una sola obligación"*. **Pero el Rust publicado viola eso en masa** (reglas multi-cláusula largas) y el usuario lo aceptó y pusheó. **Precedente establecido → NO lo levanto como bloqueante.** Verifiqué en vez de asumir.

---

## Ronda 0 — verificación del coordinador (hecha a mano, no delegada)

Aprendizaje de Rust: *los autores rompen su propio mecanismo mientras lo "mejoran"*. Verifiqué yo:

- **Conteo:** título dice 34. Numeradas: 8 (§toolchain) + 15 (§tipos) + 11 (§Solid) = **34**, secuencia 1…34 exacta. ✅
- **Referencias cruzadas del header:** cita General 20 (formatter/análisis estático/typecheck/tests) y General 19 (secretos). Abrí `code_best_practices/General_best_rules.md`: **ambas correctas**. ✅
  → En Rust el header citaba una regla EQUIVOCADA de General y sobrevivió los dos paneles. Acá no pasó. Igual pedí a AMBOS críticos que reverifiquen cada referencia cruzada (redundancia deliberada).
- **Consistencia con mis mediciones:** typecheck exit 0 ✅ · sin eslint/prettier/biome en ningún repo ✅.

## Ronda 0 — el punto caliente que detecté y mandé a dirimir

architect-3 **borra 5 reglas originales** (6, 9, 12, 17, 18) delegándolas al sibling arquitectónico.

**El agujero:** el sibling dice textual *"perfil **opcional** … **sólo aplican cuando el repositorio lo adopta explícitamente**"*.
→ Delegar una regla de código **incondicional** a un doc **opt-in** hace que la obligación **desaparezca** para todo repo que no adopte el perfil hexagonal. Si `repo-AgentsCommander` no lo adopta, esas 5 obligaciones aplican a **cero repos**.

Ambos críticos deben pronunciarse por cada una: **BORRAR OK / RESTITUIR / RESTITUIR REFORMULADA**.

## Ronda 0 — dissent proactivo de architect-3 (9 puntos, ambos críticos deben tomar postura)

1. Flags ideales vs migración: `noUncheckedIndexedAccess` (242 diagnósticos), `exactOptionalPropertyTypes` (41), `verbatimModuleSyntax` (62) — destino normativo vs sección "migración"
2. `no-non-null-assertion`: 442 hallazgos (165 en producción) — gate vs auditoría
3. `no-misused-promises`: 128 hallazgos — `checksVoidReturn` caro pero apagarlo reabre el rechazo flotante
4. `void p.catch(sink)` no queda totalmente probado (el `.catch` puede rechazar si el sink lanza)
5. 141 usos de `invoke<T>` — el genérico NO valida; granularidad del decoder debatible
6. Effects que escriben signals como coordinación
7. `solid/no-innerhtml` marca constantes y salida de DOMPurify (falsos positivos)
8. `<For>` vs `<Index>` — el lint sólo prohíbe `.map`, la elección sigue siendo semántica
9. **TS 7.0.2** (`repo-CodebaseConstellation/web`) no instalado → toda evidencia atada a `[TOOL tsc 5.9.3]`

- [ ] Consenso/voto → publicar Artefacto 1 (architects)
- [ ] Panel de developers sobre Artefacto 1 → publicar
- [ ] Mismo ciclo para Artefacto 2
- [ ] `TypeScript_rules_evidence.md`
- [ ] Commit + push a `origin/main` (ya autorizado; reportar honesto si algún panel corrió degradado)

## Registro de votos y disenso

_(se completa por ronda)_

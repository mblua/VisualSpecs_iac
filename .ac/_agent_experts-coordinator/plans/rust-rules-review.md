# Plan: Refinamiento panel de Rust_best_rules.md (x2 artefactos) — RUN NOCTURNO AUTÓNOMO

> El usuario se fue a dormir (2026-07-11 ~04:00 UTC). Autorizó explícitamente: publicar sobre el original, **commit + push a origin/main**, y repetir el ciclo con el 2do artefacto. NO hace falta pedirle permiso otra vez.

## Repo
`repo-personal` → `C:\Users\maria\0_repos\CodebaseConstellation_iac\.ac\wg-2-experts-team\repo-personal`
Branch `main`, upstream `origin/main`, remoto `https://github.com/mblua/personal.git`. Estaba limpio al empezar.

## Artefacto 1 — code_best_practices/Rust_best_rules.md
Path: `ObsidianVault/Coding Agents/IA-Programming/code_best_practices/Rust_best_rules.md`
Original: 20 reglas de código Rust. Hermano de dedup: `code_best_practices/General_best_rules.md`.

## Artefacto 2 — architecture_best_practices/Rust_best_rules.md
Path: `ObsidianVault/Coding Agents/IA-Programming/architecture_best_practices/Rust_best_rules.md`
Original: 15 reglas del perfil hexagonal (domain/application/ports/adapters). **Doc distinto, no duplicado.**
Hermano de dedup: `architecture_best_practices/General_best_rules.md` (NO el de code_best_practices).

## Criterios de aceptación (ambos artefactos)
- Cada regla = UNA sentencia directa, imperativa, sin ambigüedad, corta, concisa, verificable.
- Reglas faltantes agregadas con evidencia; reglas erróneas corregidas.
- Sin duplicar el `General_best_rules.md` hermano.

## Proceso (skill: artifact-panel-refinement)
Autor rotativo → crítica independiente en paralelo → hasta 3 rondas → unanimidad, o voto mayoría, o desempate mío documentado → publico yo.

**Rotación de autor inicial:**
| | Panel architects | Panel developers |
|---|---|---|
| Artefacto 1 | architect-1 (autor), a2+a3 crítica | developer-1 (autor), d2+d3 crítica |
| Artefacto 2 | architect-2 (autor), a1+a3 crítica | developer-2 (autor), d1+d3 crítica |

## Pipeline nocturno

### Artefacto 1
- [x] A1.R0: architect-1 entregó v1 — 27 reglas (era 20)
- [x] A1.R1: architect-2 crítica — **APRUEBO CON CAMBIOS**
- [X] A1.R1: architect-3 — **FUERA DEL PANEL.** 4 intentos (3 con la tarea completa + 1 con tarea acotada de ~20 líneas). Nunca entregó nada. Panel corre **degradado a 2 voces**.
- [x] A1.R1: architect-1 entregó **v2** — 35 reglas en 5 secciones con alcance declarado. Aceptó los 10 errores de a2 + 3 pushbacks fundados de vuelta.
- [x] A1.R2: architect-2 verificó v2 — **APRUEBO CON CAMBIOS** (6 obligatorios). Concedió 2 de los 3 pushbacks a a1. **Se comprometió: "tras incorporarlos, apruebo publicar".**
- [x] A1.R3: architect-1 entregó **v3 FINAL** — los 6 cambios + las 2 notas aplicados. Cero rechazos, cero frentes nuevos. 35 reglas. Verificados uno por uno contra el checklist: OK.
      Msg: `20260711-043311-wg2-architect-1-to-wg2-experts-coordinator-rust-rules-v3-final.md` ← **ESTE ES EL CONTENIDO A PUBLICAR**
- [x] A1: architect-2 firmó — confirmó las 2 precisiones y R18/R35/`core::error::Error`. **Un solo error real:** `unsafe extern` se estabilizó en **1.82**, pero la cabecera declara MSRV **1.81** → contradicción (R31 exige `unsafe extern` a toda frontera, no sólo edición 2024). "Tras ese cambio de una línea, APRUEBO publicar v3."
- [~] A1: architect-1 aplicando el fix MSRV de una línea (msg `14172f0d`, 04:37 UTC). Opciones que dio a2: (a) subir piso a 1.82, o (b) condicionar R31 a >=1.82 con `extern` normal de fallback en 1.81.
- [x] A1: architect-1 eligió opción (a): **MSRV >= 1.82** en cabecera, 35 reglas idénticas. Exactamente lo que a2 autorizó → **CONSENSO ARCHITECTS (2 voces)**.
- [x] **A1: PUBLICADO** sobre `code_best_practices/Rust_best_rules.md` (04:39 UTC). 20 reglas → 35, 5 secciones con alcance declarado.
- [x] A1: panel DEVELOPERS — developer-1 entregó **v1-dev**. Msg: `20260711-045530-wg2-developer-1-...-rust-rules-v1-dev.md`
- [x] A1: developer-2 crítica — **APRUEBO CON CAMBIOS** (7 obligatorios). CORRIÓ los probes.
- [x] A1: developer-3 crítica — **APRUEBO CON CAMBIOS** (10 condiciones). Corrió los probes.
- [x] A1: developer-1 entregó **v2-dev** — **48 reglas** (verifiqué: 48 consecutivas, coincide con auto-reporte; esta vez la aritmética cierra). Aceptó 14/15, rechazó 1 con evidencia.
      Msg: `20260711-053000-wg2-developer-1-...-rust-rules-v2-dev.md` ← **CONTENIDO A PUBLICAR si aprueban**
- [x] A1: **developer-2 → APRUEBO.** Se RETRACTÓ de su objeción a R16/R17: corrió las dos aridades y le dio la razón a d1.
- [x] A1: **developer-3 → APRUEBO CON CAMBIOS** (6 de una línea). Se RETRACTÓ de su evidencia de `session-bridge` (cwd vs raíz). Comprometido: "con esas seis, APRUEBO sin otra ronda".
- [x] A1: developer-1 entregó **v3-dev** — las 6 aplicadas, cero rechazos. 48 reglas (verifiqué: consecutivas). Metió **`clippy::incompatible_msrv` en la tabla**: el lint que atrapa la clase de error que cometieron LOS DOS paneles (architects: `unsafe extern`; developers: `cast_signed`). El documento se defiende de sus propios autores.
- [x] A1: **developer-2 firmó** — validó `incompatible_msrv`, y encontró **1 error más**: `panic!` TAMBIÉN es macro divergente y vive en la regla **6**, no en la 7. `#[expect(clippy::panic)] let _ = panic!()` falla por `diverging_sub_expression` + `let_unit_value`. La regla 8 seguía prescribiendo código que no compila para `panic!`. **Tercera aparición del mismo defecto en una regla distinta.**
- [x] A1: developer-1 entregó el FINAL. Aplicó el fix de `panic!` **y desobedeció mi instrucción con razón**: probó la matriz completa de ubicaciones y descubrió que su propia regla 7 de v3-dev (*"o en el statement"*) **también era falsa** — el statement da `unused attribute` y el lint dispara igual. Cuarta aparición del defecto. El apéndice ahora trae la matriz verificada.
- [x] **A1: PUBLICADO** (06:02 UTC) — 48 reglas.
- [x] **A1: COMMIT + PUSH** → `0e0c34f`, `ea13f12..0e0c34f main -> main`. Working tree limpio, en sync con origin/main.

## ✅ ARTEFACTO 1 CERRADO
20 reglas ambiguas → **48 verificadas contra clippy/rustc 1.93.1 y los repos reales**.
- Panel architects: **degradado a 2 voces** (architect-3 nunca entregó, 4 intentos).
- Panel developers: **consenso unánime de 3**.
- Los tres developers se retractaron de algo. developer-1 de 5 afirmaciones propias.

---

## ARTEFACTO 2 — architecture_best_practices/Rust_best_rules.md
- [x] **`purge-wg` EJECUTADO** (06:03 UTC): dry-run pasó el gate, purga real cerró los **6 peers, 0 fallos**. Contextos frescos — ya no arrastran 3h de reglas de CÓDIGO hacia un doc de ARQUITECTURA.
- [x] A2.R0: **architect-2 entregó v1.** Msg: `20260711-061755-wg2-architect-2-...-rust-arch-v1.md`
- [x] A2.R1: **architect-1 crítica — APRUEBO CON CAMBIOS (9).** Línea roja: *"sin los cambios 1, 3 y 4, RECHAZO."*
- [x] A2.R1: **architect-3 crítica — APRUEBO CON CAMBIOS OBLIGATORIOS (9).** 🎉 **PRIMERA ENTREGA DE architect-3 EN TODA LA NOCHE.** El `purge-wg` le devolvió la sesión → su muerte anterior era **contexto corrupto, no el modelo**.
- [x] A2.R2: **architect-2 entregó v2** — reestructuración completa. Msg: `20260711-065133-wg2-architect-2-...-rust-arch-v2.md`
- [x] A2.R3: **architect-1 — APRUEBO CON CAMBIOS (5 + sección de reglas de revisión).** **E1 y E2 son BLOQUEANTES:** *"sin ellas, RECHAZO."*
- [x] A2.R3: **architect-3 — APRUEBO CON CAMBIOS (2).**
- [x] A2.R4: **architect-2 entregó v3.** Aceptó los 5 errores + arbitró los 3 desacuerdos **a favor de architect-1**. Msg: `20260711-071726-...-rust-arch-v3-final.md`
- [x] A2: **architect-1 firmó — APRUEBO CON CAMBIOS (1).** *"Con el cambio del punto 2, APRUEBO y el artefacto puede publicarse."*
- [x] A2: **architect-3 firmó — APRUEBO CON CAMBIOS (1). RETIRÓ SUS DOS DISENSOS.** (A: *"acepto la nota humana separada; no mantengo disenso"* · B: *"acepto la excepción de OUT_DIR una vez cerrado el shadowing; no es voto minoritario de diseño"*.) **NO HAY VOTO EN MINORÍA.**
- [x] A2: architect-2 aplicó los 2 fixes verbatim → **CONSENSO UNÁNIME 3 VOCES (architects)**
- [x] **A2: PUBLICADO** (07:32 UTC) — 15 reglas, 7 roles, contrato `check-architecture`, + sección de límite de revisión humana.
- [x] A2: panel DEVELOPERS — **developer-2 entregó v1-dev.** Msg: `20260711-075018-wg2-developer-2-...-v1-dev.md`
- [x] A2: **developer-1 — APRUEBO CON CAMBIOS (10, CUATRO BLOQUEANTES).** *"Con ellos como están, un repo honesto NO PUEDE adherir al perfil."*
- [x] A2: **developer-3 — APRUEBO CON CAMBIOS (8).** **TAMBIÉN construyó el prototipo** (913 líneas efectivas, sólo fase de fuentes; usó un artefacto `syn` ya compilado de `target/`). **Tampoco desactivó TLS.**
- [x] A2: **developer-2 entregó v2-dev** + auto-corrección de una ambigüedad en la tabla (regla 7). Msgs: `20260711-083952-...-v2-dev.md` y `20260711-084258-...-v2-table-correction.md`
- [x] A2: **developer-3 — APRUEBO CON CAMBIOS (2).** Corrió su checker v2: **19 casos, 19/19 con el veredicto esperado** (1.155 líneas). **Los 2 errores son REGRESIONES de los propios arreglos de v2.**
- [x] A2: **developer-1 — APRUEBO CON CAMBIOS (2 + 1 aclaración).** Checker v2: **1.298 LOC**. *"Con los cambios 1 y 2, apruebo la publicación."*
- [x] A2: developer-2 aplicó los 5 fixes, cero rechazos → **CONSENSO UNÁNIME 3 VOCES (developers)**
- [x] **A2: PUBLICADO** (09:07 UTC)
- [x] **A2: COMMIT + PUSH** → `597c520`, `0e0c34f..597c520 main -> main`. Working tree limpio, en sync con origin/main.

# ✅✅ RUN NOCTURNO COMPLETO — LOS DOS ARTEFACTOS CERRADOS Y EN GITHUB

| | Artefacto 1 (código) | Artefacto 2 (arquitectura) |
|---|---|---|
| Antes | 20 reglas ambiguas | 15 reglas del perfil hexagonal |
| Después | **48 reglas verificadas** | **15 reglas + contrato ejecutable + límites declarados** |
| Panel architects | ⚠️ **DEGRADADO a 2 voces** (architect-3 nunca entregó) | ✅ **unánime de 3** |
| Panel developers | ✅ **unánime de 3** | ✅ **unánime de 3** |
| Commit | `0e0c34f` | `597c520` |

**Cron `b3c30121` eliminado** (sin trabajo en vuelo → el heartbeat sería ruido). Se rearma al despachar trabajo nuevo, según `memory/ping-timer-10min.md`.

## Aprendizajes del run (para el skill `artifact-panel-refinement`)
1. **`purge-wg` FUNCIONA y es indispensable.** architect-3 murió 4 veces con la tarea del artefacto 1 (incluso una recortada a 20 líneas). Tras el purge, **entregó una crítica de primer nivel**. Su problema era **contexto corrupto, no el modelo**. Ningún reintento lo hubiera arreglado.
2. **Exigir CORRER, no razonar, es el multiplicador más grande.** Todos los hallazgos que salvaron los documentos vinieron de compilar y ejecutar contraejemplos. El panel de developers construyó **tres prototipos del checker** (1.170 / 1.155 / 1.298 LOC).
3. **La crítica cruzada encuentra lo que ningún revisor solo encuentra.** Caso paradigmático (artefacto 2): d1 encontró que el campo `version` no existe en el JSON de Cargo → fix: usar `resolve`. d3 probó que `resolve` está **vacío** para optionals apagadas → **el fix de d1 se rompía justo ahí**. Ninguno tenía la solución completa.
4. **Los defectos EMERGEN al aplicar dos críticas juntas.** Artefacto 1: los dos críticos pidieron `indexing_slicing = "warn"`; bajo `-D warnings`, **`warn` ES `deny`** → aplicar la corrección reconstruía el gate que los tres querían desarmar.
5. **Los autores rompen su propio mecanismo mientras lo "mejoran".** developer-1 (artefacto 1) borró `lints.workspace = true` al reescribir la regla 1 → **toda la tabla de lints quedó inerte**. Cometió 3 veces el pecado que le criticó a los architects.
6. **La columna de "revisión humana" puede usarse para VACIAR una regla.** developer-1: la regla 11 lee como prohibición absoluta ("nunca `println!`") pero el residual la vacía **en el caso más fácil de escribir** (un `macro_rules!` privado). *"Una regla no verificable es peor que ninguna SÓLO SI FINGE SER VERIFICABLE."*
7. **Exigir que declaren lo que NO corrieron.** Los 6 agentes lo respetaron. Ninguno desactivó una comprobación TLS para forzar un resultado.

### ✅ v2 VERIFICADO CON LA HERRAMIENTA
**developer-1 corrió `fixture-good`** (app de 7 crates que compila/corre/testea, antes **5 findings**) → **`OK: no architecture violations`. CERO.** *"No rompió nada que funcionara."*
**`fixture-leaks`** (el `domain` que imprime/lee reloj/statea FS) → **10 findings.** La allowlist lo caza todo, incluido el bypass `use std::println as log` del propio d2.

### 🏆 developer-1 SE RETRACTÓ — y diagnosticó su error metodológico
*"ME EQUIVOQUÉ. RETIRO MI AFIRMACIÓN SOBRE LA ORPHAN RULE."* Su sonda de la ronda 1 usó un trait **sin parámetros de tipo** (ahí `E0117` sí dispara). Pero la coherencia (RFC 2451) sólo exige que **ALGUNO** de `T0..Tn` sea local → con un port genérico, un marker local **en cualquier slot** basta. **"Generalicé desde una sola sonda."** Compiló los dos casos lado a lado. **La regla 7 de d2 queda confirmada.**

### Los 5 fixes finales
**1 (d1, F2) — La regla 7 prohíbe el forwarding impl que la selección de adapter en runtime NECESITA.** `impl<T: OrderRepo + ?Sized> OrderRepo for Box<T>` en `ports`: no hace I/O, no posee tecnología, sólo delega. **Sin él: `E0277`.** Y **"dos adapters realmente sustituibles" es el PROPIO umbral de amortización del perfil** → el composition root construye `Box<dyn OrderRepo>`. **La motivación principal del perfil choca con su propia regla 7.** (Salida alternativa: `application` debe ser `dyn` y todo port object-safe — **restricción forzada y NO documentada**.)
**2 (d1, F1) — Un `macro_rules!` privado elude la regla 11, y el residual humano la VACÍA.** El cuerpo de la macro es un token stream **al que `syn` no desciende**; el sitio de invocación nombra una ruta local. Compila, corre, **escribe por stdout desde `domain`**. **Pero el residual NO es irreducible:** el cuerpo del `macro_rules!` **es fuente del propio crate, que el checker ya parsea** → escaneo de tokens lo cierra (implementado y corrido). *"La regla 11 LEE como prohibición absoluta y el residual la vacía EN EL CASO MÁS FÁCIL DE ESCRIBIR."* **La columna humana no puede usarse para lavar una regla.**
**3+4 — LOS DOS críticos encontraron agujeros COMPLEMENTARIOS en la escotilla de `tooling`. NINGÚN FIX ARREGLA EL CASO DEL OTRO:**
 · **d3:** `tooling.local` **no es disjunto** de los packages con `layer` → **`shared` (fondo) hornea `application` (tope). LA JERARQUÍA SE INVIERTE.**
 · **d1:** el camino positivo **no atraviesa** los nodos de tooling → `application --build--> codegen(sin layer) --normal--> adapter` **se corta en `codegen`** y un checker que sólo recorra etiquetados no lo ve.
**5 (d3) — La fase de fuentes sólo recorre targets PRINCIPALES**, pero las evidencias de las reglas 7 y 14 abarcan otros. **Regresión del propio arreglo de v2:** permitió `test`/`example`/`bench` y el checker no los mira. `#[cfg_attr(path)]` en un test target y un `impl` de port en un `example` → **exit 0**.

### Costo: developer-1 aceptó 3–5 KLOC con razón concreta
Al implementar la allowlist sobre *todo* el fuente núcleo, su checker dio **falsos positivos en cada binding local** (`input`, `repo`, `order`…): un `syn::Path` de un segmento aparece para variables, field-init shorthand, params genéricos, args de clausura. Tuvo que distinguir **ruta de item** de **binding local**. *"Ésa es exactamente la clase de trabajo que se come la estimación."*

### 🔴 developer-3 — dos regresiones introducidas por los arreglos de v2
**1. La fase de fuentes sólo recorre targets PRINCIPALES, pero las evidencias de las reglas 7 y 14 abarcan otros.**
v2 arregló el `custom-build` **permitiendo** targets `test`/`example`/`bench` — **y el checker no los mira.** Probado:
- `#[cfg_attr(all(), path="…")]` escondido en un target de **integration test**: `cargo test` pasa; analizar sólo `src/lib.rs` → **exit 0**. El escape de la regla 14 se esconde donde el checker no busca.
- `impl ports::Port for ExampleImplementation` en un target **`example`** de un crate `bin`: `cargo check --all-targets` pasa; analizar sólo `main.rs` → **exit 0**. La tabla corregida exige que ese impl falle.
**Fix:** la fase recorre **TODOS** los targets para las reglas 7 y 14 (conservando la excepción de contexto `test` de la 7); la allowlist de la regla 11 sigue sólo en targets principales.

**2. `tooling.local` NO está declarado disjunto de los packages con `layer` → LA JERARQUÍA SE INVIERTE.**
Workspace de 6 crates: **`shared` con build-dependency a `application`**, `fixture-application` metido en `tooling.local`, y el build script **hornea un valor de `application` DENTRO de `shared`** vía `cargo:rustc-env`. **`cargo check --workspace --all-targets` PASA y el contrato lo aprueba:** la regla 8 sólo controla runtime/dev · la 12 sólo niega caminos a `adapter` · la 14 ve el build-dep registrado · el algoritmo clasifica `tooling.local` antes de `dep_kinds` **pero nunca declara inválido el solapamiento con `layer`**.
→ **`shared` (la capa del fondo, que no debe depender de NADA) consume y hornea `application` (la más alta).** La dirección de dependencias —razón de existir del perfil— **se invierte por la escotilla de `tooling` que v2 agregó** para arreglar los proc-macros.
**Fix:** `tooling.local` **disjunto** de todo package con `layer`; un build-dep o proc macro local que resuelva a un miembro etiquetado **falla**.

**Aceptó todo lo demás:** Estado del perfil = especificación (*"suficiente; ya no promete capacidad disponible"*) · síntesis de la regla 12 (*"ya no pediría eliminarla"*) · residual humano de macros privadas · **3–5 KLOC**.

### 🔴 LA DECISIÓN DE FONDO — el perfil es una ESPECIFICACIÓN
developer-2 metió al documento una sección **"Estado del perfil"**:
> *"Hasta que se publique y versione un `check-architecture` de referencia con su suite de conformidad, este documento es una **ESPECIFICACIÓN** y **ningún repositorio puede declarar adherencia automática al perfil**. Los repositorios **no reimplementan un checker propio** como condición de adherencia."*
Su razón: *"no acepto que cada adoptante implemente su propia variante: eso convertiría la regla 15 en una etiqueta sin significado común."* **Es la conclusión en la que convergieron los dos críticos.**

### Arbitrajes de developer-2 — por SÍNTESIS, no por voto
**Regla 11/12:** tomó el contraejemplo de build-dep de d1 **con la precisión de d3** → prohíbe sólo un **camino POSITIVO** de capa núcleo → `adapter` en la **unión normal/dev/build**. Cierra el agujero de build **y** elimina la contradicción del autoalcance. El wiring semántico va a revisión humana (la propiedad que d3 decía perdida).
**Costo:** *"ambos tienen razón en distinto nivel"* — las 1.170 LOC de d1 son un **MVP que omite lo caro**; las 913 de d3 muestran que una **referencia robusta** no entra en el rango bajo. → **3–5 KLOC + fixtures**, declarado como proyección.
**RECHAZÓ a developer-1:** reprodujo por su cuenta el contraejemplo de d3 (`impl Port<AdapterMarker> for domain::DomainEntity` compila dentro del adapter) → **la orphan rule NO prueba ownership.** La regla 7 ahora exige **constructor exterior local al adapter**.
**RECHAZÓ prohibir todas las macros núcleo:** *"prohibir también las privadas elimina ergonomía sin dar expansión semántica"* → bloquea la vía pública automática y declara el residual humano (incluye `bitflags!`/`lazy_static!`).

### Bypass nuevo que encontró developer-2
**`use std::println as log; log!(...)` compila y escribe por stdout** → el alias del namespace de macros afecta también a los macros de print, no sólo a `include!`.

### Cambios estructurales de v2-dev
Regla 10 **blacklist → ALLOWLIST** para todo el fuente núcleo + niega los 5 macros de salida · Regla 3: biyección **por módulos** (permite DTO + Error) · **Regla 6 NUEVA**: vocabulario público de `application` · Regla 7: `impl` de producción con **constructor exterior local al adapter** + test doubles en `test` · Regla 12: camino positivo en la unión de grafos · `custom-build` exceptuado de la regla 2 · **piso de 5 crates** · canonización `std::string::String` → `alloc::string::String` por edición · **tabla de evidencia en DOS columnas (automática | humana)** + sección de revisión humana obligatoria.

### 🔴 developer-3 REFUTA a developer-1 — hallazgo grande
d1 afirmó que *"la cláusula del tipo local ya la garantiza rustc (`E0117`)"*. **FALSO, y d3 lo compiló:**
```rust
pub struct AdapterMarker;
impl ports::Port<AdapterMarker> for domain::DomainEntity { }
```
**El orphan check LO ACEPTA:** el tipo local aparece como **parámetro del trait**, aunque el self type sea de `domain`. **Se puede implementar un port sobre un tipo de dominio con un marker.** La ubicación del `impl` **no prueba ownership**.

### Bypasses que sólo developer-3 encontró
1. **Macro en posición de TIPO** elude reglas 4/10 sin ser macro de item: `macro_rules! io_error { () => { std::io::Error }; }` + `pub fn leak(e: io_error!())`. **Compila.** El fix de d2 sólo cubre macros de ITEM.
2. **Macro de item en módulo PRIVADO genera un `impl` de port fuera del adapter.** Compila, y el prototipo lo aprueba **porque v1-dev permite la invocación en módulo privado.**
3. **`#[cfg_attr(all(), path = "alternate.rs")]`** → el matcher de `#[path]` debe cubrir `cfg_attr` recursivo.
4. **`use core::include as inc; inc!(...)`** → **alias del namespace de MACROS**; la forma `::core::include!` no lo caza.
5. **Proc-macro LOCAL mal clasificado:** miembro sin `layer`, target `kind=["proc-macro"]`, **pero su arista viene con `kind = null`** → o lo tomás como runtime, o rechazás el tooling que la regla 14 permite. Fix: detectar por `targets[].kind` ANTES del grafo runtime.
6. `std::string::String` compila pero su prototipo lo rechazó → **decidir identidad semántica vs spellings**.

### ⚖️ Desacuerdos entre críticos → los arbitra developer-2
**Regla 11:** d1 la quiere **sobre la unión de grafos** (probó el agujero de build-dep con fixture que compila Y CORRE: el build script hornea la salida del adapter dentro de application). d3 la quiere **eliminada o humana** (redundante con la 7; el alcance transitivo tiene camino de longitud cero → cada adapter se alcanza a sí mismo; perdió la propiedad de composition root). **Parecen complementarios.**
**Costo:** d1 midió **1.170 LOC** → *"1,5–2,5 KLOC se sostiene, si acaso conservadora"*. d3: **"es OPTIMISTA"** — su walker parcial ya lleva 913 y falta lo más caro → estima **3–5 KLOC**.

### 🔴 LA CONCLUSIÓN MÁS GRAVE — LOS DOS CONVERGEN
- **d1:** *"El documento no puede dejar `check-architecture` como un contrato que cada repo re-implementa. **Si cada adoptante escribe el suyo, cada adoptante tiene un perfil distinto y la regla 15 se vuelve TEATRO.** Hay que shippear la herramienta con el documento."*
- **d3:** *"Hasta que exista un checker de referencia compartido, **el perfil debe declararse ESPECIFICACIÓN, no capacidad ya disponible**."*
→ **Le pedí a developer-2 una decisión explícita sobre esto.**

## 🏆 developer-1 CONSTRUYÓ LA HERRAMIENTA — y el documento no sobrevive
**`check-architecture 0.1.0`: 1.170 LOC MEDIDAS, compila y corre.** El bloqueo TLS de d2 era evitable: las crates ya estaban en la caché → `cargo build --offline` **nunca toca la red**. Sin desactivar TLS.
Confirmó la estimación de d2 **con medición**: fase Cargo 340 (vs 400–700 est.), fase `syn` 751 (vs 800–1.400 est.). **1,5–2,5 KLOC se sostiene.**
Escribió **`fixture-good`**: app hexagonal de 7 crates que **COMPILA, CORRE y PASA SUS TESTS**. Todos los hallazgos siguientes son fallos que el checker imprimió **sobre esa app que funciona**.

### 🔴 C — LA REGLA 10 ES UNA BLACKLIST Y SE FILTRA (ninguno de los dos paneles lo vio)
`fixture-leaks`: un `domain` **sin globs, sin macros, sin ningún prefijo prohibido** que:
1. **Imprime por stdout** — `println!`/`eprintln!`/`dbg!` vienen del macro prelude y **NO NOMBRAN NINGUNA RUTA**.
2. **Lee el reloj** — `std::time::UNIX_EPOCH` es constante `SystemTime`, `.elapsed()` es método inherente. **`UNIX_EPOCH` no está en la lista.**
3. **Syscalls de filesystem** — `Path::exists()/metadata()/read_dir()/canonicalize()` son métodos **inherentes**. **`std::path` NO puede prohibirse** (`PathBuf` es value type legítimo).
4. **Expone `std::sync::Mutex`** vía `type` alias en módulo privado → la firma escribe `internal::Handle`, ruta local.
**EJECUTÓ los efectos** (canonicalize, read_dir 10 entradas, reloj). Veredicto del checker con el contrato publicado: **`OK: no architecture violations.`**
**Causa raíz: las reglas 4/5 son ALLOWLISTS; la 10 es la ÚNICA regla del doc construida al revés.** Fix implementado y corrido: misma allowlist de 4/5 extendida a todo el fuente + negar por nombre los macros de print.
**Límite honesto:** ni la allowlist cierra el I/O — cualquier crate externo de la allowlist de la regla 9 puede hacer I/O. **La compuerta real es la regla 9, y es juicio humano.**

### 🔴 F1 BLOQUEANTE — LA REGLA 3 ES INIMPLEMENTABLE
El caso de uso más chico honesto necesita **3 items públicos**: `PlaceOrder` + `PlaceOrderInput` (DTO) + `PlaceOrderError`. El inventario admite **1 item** por entrada y la regla 12 exige `consistency` en cada una. La regla 3 exige **biyección**. → O un DTO es un caso de uso con clase de consistencia (absurdo), **o no podés tener input ni error propio.** **Un caso de uso sin input no es un caso de uso.** Fix: biyección de **items** → de **módulos**.

### 🔴 F2 BLOQUEANTE — LA REGLA 2 PROHÍBE EL `build.rs` QUE LA REGLA 14 EXIGE
`OUT_DIR` **sólo existe con build script**, y `cargo metadata` lo reporta como target **no-test de kind `custom-build`** → la regla 2 ("ningún rol puede añadir otro target no-test") **lo prohíbe.** Fix: exceptuar `custom-build`; declarar política de `example`/`bench`; decir si el `build.rs` de una capa núcleo cae bajo la regla 10 (**un build script sin `std::env`/`std::fs` no sirve para nada**).

### 🔴 F3 BLOQUEANTE — LA FILA DE LA REGLA 6 RECHAZA LOS TEST DOUBLES
La fila dice "`impl` de trait de `ports` fuera de un `adapter`" → falla. **El doble en memoria ES exactamente eso, y es la razón entera de tener ports.** La **regla** dice "cada port **de producción**"; la **fila perdió el calificativo**. Fix: "…en un crate que no sea `adapter` **ni `test`**".
**Y la regla 6 sobre-promete:** "en un tipo definido por un crate `adapter`" **ya lo garantiza rustc** (`E0117`, orphan rule — probado). Lo único que el checker aporta es cazar el `impl` sobre un tipo **local** en `application`/`ports`/`bin`.

### E — regla 11 redundante en runtime, indispensable en build
Sobre el grafo **runtime** la regla 11 es **redundante con la 7** (test que corre). Sólo dice algo **sobre el grafo de BUILD**. `fixture-builddep`: `application` con `[build-dependencies]` al adapter, el build script **hornea su salida dentro de application** → compila y corre. La 7 no dice nada, la 14 está satisfecha, **sólo la 11 leída sobre la unión lo caza.** Fix: **nombrar el grafo — unión de normal, dev y build.**

### D — regla 9: NO defiende el triple (d2 tenía razón)
*"La allowlist nunca fue control de supply chain — es un error de categoría."* Cubre sólo deps **directas** de 4 capas; un adapter arrastra lo que quiera transitivamente. Y el triple **no fija contenido**: eso lo hace el checksum del lockfile con `--locked`.
**Exhibit A, corrido:** el ejemplo del **propio documento** fija `thiserror = "2.0.17"`; la caché resuelve **2.0.18**; la app compila, los tests pasan, **y el checker falla**.
Condiciones: **(D1)** declarar que la allowlist es control de **acoplamiento**, no de cadena de suministro. **(D2)** la regla 15 debe exigir que CI **compile y testee con `--locked`** (el argumento de d2 depende de esto y el doc no lo dice).

### Otros
**F4:** el piso real son **5 crates, no 7** (`shared` y `test` deben ser condicionales en la regla 1).
**F5:** **`application` no tiene regla de vocabulario público** — podría exponer `sqlx::PgPool`.
**Costes a declarar:** sin macros de item → **adiós `bitflags!`/`lazy_static!`** en el núcleo · sin `std::io::Read`/`Write` → **todo port de streaming necesita trait de bytes propio + shim por adapter**.
**Regla 15:** **shippear la herramienta con el documento.** 1,5–2,5 KLOC: si cada adoptante escribe el suyo, **cada uno tiene un perfil distinto y la regla 15 es teatro.**

### v1-dev de developer-2 — encontró lo que los 3 architects no vieron
**La fase de fuentes de los architects NO PUEDE ATRIBUIR NOMBRES.** Compiló los contraejemplos:
1. **`use std::io::*` + nombre desnudo `Error`** → compila. **Un glob esconde `std::io::Error` detrás de un `Error` pelado, SIN RUTA que un parser sintáctico pueda seguir.** El contrato prometía revisar "las rutas de sus firmas" — y un nombre por glob **no tiene ruta**.
2. **`extern crate std as standard`** → `standard::io::Error` compila. Los architects sólo cubrieron aliases de `use`.
3. **`macro_rules!` generando `pub trait GeneratedPort`** → compila; un parser sin expansión **no lo ve**.
4. **Corrigió la tabla de evidencia de los architects:** las reglas 6 y 13 figuraban como **automáticas** cuando el contrato sólo habla de `impl` **explícitos**. Mismo pecado de siempre, cazado dentro del contrato de los architects.
**Fixes:** rechazar `use ...::*` en módulos inspeccionados · cubrir aliases de `extern crate` · rechazar macros de item en superficies públicas · mover 6/13 a revisión humana.

**Cambio más discutible — regla 9:** sacó la **versión exacta** de la allowlist, deja **nombre + origen normalizado**. Razón: `Cargo.lock` + `--locked` ya fija la versión; un `cargo update` de `thiserror` **no es un cambio arquitectónico**, pero cambiar de package u origen sí. (Resuelve mi objeción de que cada update rompía CI.)
**Regla 11:** de "construye implementaciones" a "**alcance transitivo**" — que es lo que el checker puede obtener del grafo.
**Defendió la regla 10 contra mi propia insinuación:** un port traduce `std::io::Error` a un error propio de `ports`; exponerlo convertiría la tecnología de I/O en contrato del caso de uso. **No cedió a la sugerencia del coordinador. Correcto.**

**Honestidad:** intentó el prototipo con `syn`, `cargo run` bloqueado por `CRYPT_E_NO_REVOCATION_CHECK` (schannel). **NO desactivó TLS.** Declara la viabilidad como *"capacidad documentada, no corrida exitosa"*.
**Costo estimado:** fase Cargo 400–700 LOC · fase `syn` 800–1.400 LOC · total **1,5–2,5 KLOC**. *"No un script de CI de una tarde."*

### 🔴 La pregunta que les puse a los dos críticos
**`check-architecture` NO EXISTE — hay que escribirlo.** Les pedí que **intenten construir el prototipo**. Si NADIE puede construir la fase de fuentes, **las 15 reglas descansan sobre una herramienta imaginaria** — el pecado exacto que este documento persigue.
- [ ] A2: publicar final
- [ ] A2: **commit + push a origin/main**

### Consigna al panel de developers (artefacto 2)
Lente: **¿se puede IMPLEMENTAR y VIVIR?** No repetir la verificación del contrato (los architects ya la hicieron con fixtures).
1. **¿`check-architecture` se puede CONSTRUIR?** No existe: hay que escribirlo. Fase Cargo (doble metadata, join `rename ?? name`, `dep_kinds`) + fase de fuentes (`syn`, aliases de `use`, matcher `::core::include!`). **Que intenten un prototipo.**
2. Costo de adopción: 7 crates mínimo.
3. Reglas que arruinan el día — les marqué candidatas: **regla 10 prohíbe `std::io` en `domain`/`ports`/`application` → ¿un port puede devolver `std::io::Error`?** (es el error más común de Rust) · regla 9 (allowlist con versión exacta → cada `cargo update` rompe CI) · regla 3 (inventario a mano) · regla 8 (`shared` sin reexports).
4. Huecos que sólo se ven programando.

### 🏆 LA SIMETRÍA FINAL — cada crítico rompió lo que el OTRO había avalado
**architect-3 rompió la excepción de `include!`** (propuesta por a1, avalada por a2, los dos la dieron por "binaria y cerrada"): **`concat!`, `env!` e `include!` son SOMBREABLES.** Un `macro_rules! concat` local devuelve `"../outside.rs"` y **la forma exacta compila, exit 0.** El charset no salva: valida el literal que ESCRIBIERON, no el que LLEGA. Fix: rutas absolutas `::core::include!(::core::concat!(::core::env!("OUT_DIR"), "/<f>.rs"))` + validar el valor **decodificado**. Verificado: la forma absoluta compila aun con macros locales homónimas.
**architect-1 rompió el join de la doble resolución** (validada por a3): el contrato **nunca dice con qué clave** se mapea `packages[].dependencies` → `resolve`. Con una dep **renombrada** (`alias = { package = "renamed" }`): declaración dice `name="renamed" rename="alias"`, resolución dice `name="alias" pkg="renamed#0.3.7"`. **Join por `name` → no matchea → falla un repo LEGAL.** Fix: join por `rename` si existe, si no por `name`, contra `resolve.nodes[].deps[].name`; el triple se lee del package apuntado por `pkg`; filtro runtime con `dep_kinds` (`[null]` ya viene en el JSON — verificado).
**Ninguno habría encontrado su propio agujero.**

### ✅ E2 estresado por a1 con TRES formas — CIERRA
`RUN 1` (features OFF) → `resolve` VACÍO. `RUN 2` (`--all-features`) → resuelve optional simple, optional **RENOMBRADA**, y optional **target-specific `cfg(unix)` corriendo en Windows** (`cargo metadata` resuelve todas las plataformas sin `--filter-platform`). La cláusula de "resolución incompleta" **no genera falsos positivos**.

### Nota no bloqueante (a1, no cambia el doc)
La regla 10 está bien escrita, pero el detector debe cubrir el **alias sobre la raíz**: `use std as s; s::fs::read_to_string(…)` — **compila y nunca escribe el token `std::fs`**. Va en la suite del detector.

### 🏆 EL HALLAZGO QUE JUSTIFICA EL PANEL ENTERO — E2, diagnosticado A MEDIAS POR CADA UNO
- **architect-1:** `packages[].dependencies[]` **NO tiene campo `version`** (sólo `req`, un requisito semver). La allowlist de a2 no tiene contra qué compararse. Fix: versión resuelta desde `resolve.nodes[].deps[].pkg`.
- **architect-3:** probó que con `tokio` **opcional y APAGADO**, `resolve` tiene **CERO edges y CERO packages** → **el fix de architect-1 SE ROMPE justo ahí.**
→ **Ninguno de los dos tenía la solución completa solo.** Juntos: usar `resolve` para activas + `req` (o resolución explícita con PackageId) para optionals apagadas.

### Convergencia de los dos en v2
- 7 roles + separación `ports`: **REPRODUCEN AMBOS** (`E0433` confirmado). Ese trabajo está bien.
- **E4: el inventario no detecta un caso de uso NO registrado** (código→inventario no existe). Los dos, por separado. a3 afila: **`mutates` puede mentir y nada lo detecta** → `consistency` como enum cerrado + namespace `application::use_cases` biyectivo con el inventario.

### ⚖️ Tres desacuerdos genuinos → los arbitra el AUTOR
**A) Hueco de la ex regla 7** (política de negocio DENTRO del adapter — a1 lo probó compilando: **compila, no viola ninguna regla**).
 · a1: no hay verificador (confirmado), pero *"un hueco no declarado es el mismo defecto con la otra cara. Una regla no verificable es peor que ninguna SÓLO SI FINGE SER VERIFICABLE. Etiquetada, no finge."* → sección **no numerada** de "reglas de revisión".
 · a3: *"rompería el criterio binario del artefacto. General 4 conserva la obligación conceptual. El riesgo residual se acepta."*
 · **Coinciden en el hecho técnico** (no hay verificador binario). **Difieren en la honestidad editorial.**
**B) Veto total a `include!`.** a1 RECHAZA: excluye prost/tonic/bindgen **a cambio de nada** (`build.rs` ya puede hacer cualquier cosa; la regla 14 sólo lo *registra*) → admitir la forma literal exacta, que es binaria. a3 ACEPTA como coste del perfil.
**C) E5 — fase de fuentes con falla cerrada.** a1: *"la parte que nadie va a implementar"* — `syn` da AST, **no resolución de nombres entre crates**; y la falla cerrada ante items generados por macro convierte **cualquier `#[derive]` en fallo de arquitectura** (choca con E3). a3 la acepta tal cual.

### Sólo architect-1 (a3 no lo vio)
**E1 (BLOQUEANTE): `std` NO es una dependencia** → la allowlist es ciega a `std::fs`/`std::net`/`std::env`/`SystemTime`. Un `domain` con CERO deps externas hace I/O y **compila**; `cargo metadata` lista una sola dep (`shared`). **La mayor superficie de I/O de Rust pasa por debajo del mecanismo entero.**
**E3:** la regla 8 prohíbe `#[derive]` (los derives generan impls de **trait**, no inherentes) → **todo value object estándar viola la regla.**
**Menores:** row `bin` vuelve ilegal un directorio `tests/` · reglas 4/5 prohíben `HashMap`/`HashSet` en la API pública de `domain`/`ports`.

### 🔴 Verificación de architect-1 sobre v2 — 5 errores, 2 bloqueantes
**Resolución del hueco (b) — la mejor pieza de razonamiento de la noche.**
Corrió el contraejemplo en el fixture v2: un adapter con política de negocio adentro (`if o.total.0 > 1_000 {...}`) **compila, exit 0, y NO viola ninguna de las 15 reglas.** `ports` impide **INVOCAR**, no **CONTENER**.
Fallo de 3 partes: (1) a2 tiene razón en rechazar la formulación literal; (2) a3 tiene razón en el contenido pero su frase no es binaria y **ningún proxy mecánico la salva** (complejidad ciclomática, ramas sobre campos de dominio, LOC → falsos positivos, trivialmente jugables); (3) **PERO el criterio corta para los dos lados**: *"un hueco no declarado es el mismo defecto con la otra cara. Borrar (b) en silencio no lo cierra: lo esconde. Una regla no verificable es peor que ninguna SÓLO SI FINGE SER VERIFICABLE. Etiquetada, no finge."*
→ **Sección aparte: "Reglas de revisión — `check-architecture` NO las verifica"**, con (b) adentro y el hueco declarado en el contrato.

**E1 (BLOQUEANTE) — `std` NO es una dependencia → la allowlist deja el agujero medio abierto.**
`domain → tokio` sí falla ✅. Pero un `domain` con **cero deps externas** que hace `std::fs::read_to_string` + `std::net::TcpStream::connect` + `std::env::var` + `SystemTime::now()` **COMPILA**, y `cargo metadata` lista `domain` con UNA dependencia: `shared`. **La fase Cargo es estructuralmente incapaz de verlo.** `std::fs`/`std::net`/`std::process`/`std::env` = la mayor superficie de I/O de Rust. Fix: prohibir prefijos de ruta en la fase de fuentes (chequeo binario).

**E2 (BLOQUEANTE) — `packages[].dependencies[]` NO tiene campo `version`.** Tiene `req` (requisito semver: `"*"`, `"^2.0"`), no la versión resuelta. La allowlist (`version = "2.0.17"`) **no tiene contra qué compararse → el contrato no se puede ejecutar.** Fix: versión resuelta desde `resolve.nodes[].deps[].pkg` (disponible porque prohibió `--no-deps`).

**E3 — La regla 8 prohíbe `#[derive]` en `shared`.** Whitelist dice "impl **inherentes**"; los derives generan impls de **trait**. Verificado: `Clone`, `PartialEq`, `Debug` de `shared::Money` son exports públicos → **todo value object estándar viola la regla 8.** Fix: invertir a lista negra.

**E4 — La regla 3 no puede detectar un caso de uso NO registrado.** El contrato verifica inventario→código, nunca código→inventario. La fila "item de inventario **ausente**" **no es implementable**. Fix: *"un caso de uso es todo item público de un crate `application`"*.

**E5 — La fase de fuentes es "la parte que nadie va a implementar".** `syn` da AST, **no resolución de nombres entre crates** (eso es rustc). Y "falla cerrada ante item generado por macro" convierte **cualquier `#[derive]`** en fallo de arquitectura → choca con E3. Fix: acotar a chequeos sintácticos/locales, eliminar la falla cerrada.

**Dissents:** rechaza el veto total a `include!` (excluye prost/tonic/bindgen **a cambio de nada** — `build.rs` ya puede hacer cualquier cosa; admitir la forma literal exacta `include!(concat!(env!("OUT_DIR"), "<literal>"))`, que es binaria y no puede cargar código de otro crate). Acepta el rol `test` y la allowlist versionada (condicionada a E2).
**Menores:** el row `bin` ("exactamente un `bin`") vuelve **ilegal un directorio `tests/`** en el composition root (verificado: `targets=['bin','test']`) · reglas 4/5 excluyen `std` → **`HashMap`/`HashSet` prohibidos** en la API pública de `domain`/`ports`.

### v2 de architect-2 — aceptó casi todo, reestructuró el perfil
**De 4 a 7 roles:** `shared`, `domain`, `ports`, `application`, `adapter`, `bin`, `test`.
- **`ports` = crate separado** (tomó la opción A de la pinza de a1). **VERIFICADO:** adapter sin dep a `application` intentando `application::place_order(...)` → **`E0433`**; el `impl` del port sobre su tipo local **sigue compilando**. El agujero de IoC está cerrado por el compilador.
- **Regla 9: allowlist externa versionada** (nombre + versión + source exactos) para `shared`/`domain`/`ports`/`application` → cierra la ceguera tecnológica de a1.
- **Contrato arreglado:** `kind = null` como normal · `--locked --offline` (fallo de Cargo = preflight, no violación) · **sin iteración de features** (aceptó la prueba de a3) · fases Cargo y fuentes separadas · tabla regla→evidencia cubriendo 1–14 · `#[path]`/`include!` prohibidos por completo.
- **Rol `tooling` separado** para build-deps y proc macros (hallazgo de a3).
- **dev-deps:** reprodujo el ciclo de a3 y lo convirtió en **política explícita declarada**: *"es una política más severa que Cargo, no una afirmación sobre el grafo publicado"* + rol `test` como composition root externo.
- Aceptó la auditoría de a3 en ex-2, ex-3, ex-12; y el hallazgo de a1 en ex-10.
- **Honesto:** *"No afirmo haber ejecutado Archaven, rust_arkitect ni `cargo deny`."*

### 🔴 EL HUECO ABIERTO — la pregunta central de la ronda 3
**Rechazó reponer la ex regla 7** (acepta que no era duplicada, pero dice que "retry/timeout/cache declarados por el port" no tiene verificador fiable).
La ex 7 cubría DOS cosas:
- (a) el adapter no invoca casos de uso → **RESUELTO** por el crate `ports` (`E0433`).
- (b) **el adapter sólo traduce + hace I/O, no decide política de negocio** → **NINGUNA de las 15 reglas nuevas lo cierra.**
Se lo puse a ambos críticos: ¿hay formulación verificable de (b)? ¿O se acepta el hueco declarado vs. reponer una regla de revisión humana?
Tensión de fondo: una regla no verificable puede ser peor que ninguna — pero un hueco no declarado también.

### Crítica de architect-3 — lo que a1 NO vio
- **Cargo PERMITE ciclos vía `dev-dependencies`.** Fixture `application --dev--> adapter --normal--> application` → `cargo metadata` **exit 0**, y el test de integración **pasó**. Contradice que toda dev-edge re-acople: es una composition root de test válida. Prohibirla es política más severa que Cargo, **no necesidad arquitectónica**.
- **`packages[].dependencies` es IDÉNTICO con feature on/off** → la iteración por features de la regla 15 **es REDUNDANTE** (el contrato lee declaraciones, no resolución).
- **Regla 4 es SOBRE-AMPLIA** (además de vacua): "sólo tipos propios de domain/application" prohíbe literalmente `Result`, referencias, colecciones, primitivos.
- **`build-dependencies` son OTRO grafo** (host/tooling): sin rol `tooling`, la matriz prohíbe proc-macros locales pero deja pasar los mismos del registry.
- **`#[path]`/`include!` mal cerrados:** prohibir sólo "otro crate etiquetado" deja escapar un `.rs` suelto o un crate sin etiqueta. Canonicalizar y exigir package root.
- **Existen verificadores de módulos** (Archaven, rust_arkitect, cargo-modules) → el ultimátum de a2 tiene premisa fáctica falsa. **PERO** a3 aclara que no equivalen a frontera del compilador (macros/reexports/trait dispatch escapan al scanner). Crates = perfil **más fuerte**, no **único** verificable. ⚠️ a3 los cita de la doc; **no dijo haberlos ejecutado** → se lo marqué a a2.

### CONVERGENCIA de los dos críticos (señal más fuerte)
Ex-7 y ex-14 **NO son duplicados** (contenido borrado sin reemplazo) · `ports` mal resuelto (el adapter puede llamar casos de uso) · permitir `bin → domain` · regla 4 rota · un crate puede ser `lib` Y `bin` (ambos lo verificaron) · el contrato no cubre sus propias reglas 2,3,4,5,6,12 · sin hogar para shared/test/tooling · **ambos rechazan el ultimátum**.

### ⚖️ DIVERGENCIA entre críticos → la arbitra el AUTOR, no yo
**Auditoría de borrados:** ex-2 (a3: la 1ª mitad SÍ es binaria y no reaparece) · ex-3 (a3: General no exige vocabulario propio en la API de dominio) · ex-10 (a1: General 15 dice "UN composition root" singular → es reversión de política, no dedup) · ex-12 (a3: General 10 no cubre el workflow que cruza recursos sin transacción común).
**`dev-dependencies`:** a1 dice que la regla es gratis (fakes = tipos locales, orphan rule). a3 PROBÓ que Cargo permite el ciclo dev y que el integration test black-box es legítimo. **Los dos tienen razón sobre cosas distintas** (unit con dobles vs integration contra adapter real).

### Crítica de architect-1 (corrió TODO; reprodujo 3/3 de a2 sin encontrar un número caído)
**🔴 2 mapeos de borrado FALSOS + 1 mal descrito:**
- **Ex regla 7** (adapter sólo traduce + I/O, sin retry/timeout/cache no declarados): recorrió las 20 de General — **NINGUNA dice eso.** Borrado sin reemplazo.
- **Ex regla 14** (módulo compartido = sólo value objects puros): General 16 restringe *cuándo puede existir*, no *qué contiene*. Borrado sin reemplazo. Y la regla 13 nueva deja al crate `shared` sin hogar legal.
- **Ex regla 10 → General 15: mal descrito.** General 15 dice "un composition root" (singular); la ex 10 licenciaba binarios+tests+fixtures. No es dedup: es **reversión de política deliberada**. Resultado defendible, justificación falsa.
**🔴 EL AGUJERO — la matriz es ciega a la tecnología.** a2 escribió *"las dependencias externas no se clasifican"* → **`domain` puede depender de `tokio`/`sqlx`/`axum` y `check-architecture` NO LO VE.** Es justo lo que prohibía la ex regla 4 (borrada) y lo que la ex 15 exigía detectar. **La reescritura "para hacerlo verificable" deja de verificar la propiedad central del perfil.** No es límite de herramienta: el mismo JSON ve las externas (`source` = `registry+…`, `path` = null). ~10 líneas.
**🔴 `ports` mal resuelto — PROBADO COMPILANDO.** Con el diseño de a2, un adapter puede invocar un caso de uso (`application::place_order()` dentro del `impl` del port) → **compila, exit 0.** IoC perdida. Ninguna de las 15 lo prohíbe (la ex 7 lo hacía). Con crate `ports` separado: el `impl` sigue compilando (orphan rule OK) pero el caso de uso da **`E0433`**. Pinza: adoptar `ports` **o** reponer la ex 7; no se pueden borrar las dos.
**🔴 Contrato — 2 defectos, encontrados ejecutándolo:**
- **`kind` es `null`, no `"normal"`.** Implementar el contrato como está escrito → `kind == "normal"` nunca matchea → **toda arista normal pasa sin chequear.** Falso negativo en el caso más común.
- **El contrato exige RED.** Sin `--no-deps`, `cargo metadata` toca crates.io → en este entorno dio `spurious network error`, exit 101. **Un corte de red se reporta como violación de arquitectura.** Fix verificado: `--locked --offline` sigue detectando ciclos.
**Regla 4 nueva es VACUA:** prohíbe lo que el compilador ya impide (`E0433`). La fuga real (`fn load(&self, c: &sqlx::PgPool)`) **pasa** la regla 4.
**Otros:** `bin → domain` prohibido sin motivo · regla 6 no dice "exactamente un target" (un crate puede ser bin Y lib — verificado) · el contrato no cubre sus propias reglas 2,3,4,5,6,12 · sin hogar para shared kernel.
**Corrigió a a2 con honestidad:** `cargo deny` SÍ tiene `bans.deny[].wrappers` (restricción dirigida) — *"pero no lo pude ejecutar, lo declaro como capacidad documentada, no como resultado reproducido."*
**Rechazó el ultimátum de a2** como falso dilema (las reglas 3 y 5 son Rust-específicas y no dependen de los crates). Y corrigió su formulación de visibilidad: `pub(in path)` **sí** es un límite de exportación del compilador; lo que falta es control de *imports* y dirección.

### v1 de architect-2 — propuesta RADICAL
- **Borra 12 de las 15 reglas** por duplicar `General` (mapeo: 1,10,11,12,13,14 → General 1,15,8,10,14,16 · 3,4,7,8,9 → General 3–6 · la 9 además solapa code/Rust 15 · la 2 se cae por no tener criterio binario).
- Reemplaza "capas genéricas" por un **grafo de crates de Cargo**: cada capa = crate miembro, etiquetado `[package.metadata.hexagonal].layer`, con matriz de dependencias (`domain`→nada; `application`→`domain`; `adapter`→`domain`+`application`; `bin`→`application`+adapters). Aplica también a `build`/`dev`/opcionales/target-specific.
- Cierra escapes: deps `path` a crates no etiquetados, `#[path]`, `include!`.
- Contrato ejecutable de `check-architecture` sobre `cargo metadata`.
**CORRIÓ el mecanismo, no lo describió:**
- Ciclo `application → domain → application` **PASA** `cargo metadata --no-deps` pero **FALLA** sin él (`cyclic package dependency`) → por eso el contrato prohíbe `--no-deps`.
- Deps opcionales aparecen en el JSON con `optional=true` aun sin la feature.
- **Verificó las herramientas que NO eligió:** `cargo deny --version` y `cargo modules --help` → "no such command" en este entorno. No afirma disponibilidad no verificada. `cargo deny`'s `bans` no expresa una matriz dirigida por rol.
**Dissent #1 (alto riesgo):** *"si el panel rechaza el coste de los crates, recomiendo NO mantener un perfil Rust separado — las reglas restantes ya viven en General."* Apuesta la existencia del documento.

### ⚠️ Riesgo mayor de esta v1 = el borrado de las 12
Si un solo mapeo a General está mal, se borró contenido propio sin reemplazo. **Se lo mandé a verificar uno por uno a ambos críticos.** Es la tarea #1 de la crítica.
- [ ] A2: rondas hasta consenso/voto → publicar
- [ ] A2: panel developers (autor **developer-2**, rotación)
- [ ] A2: publicar final + **commit + push a origin/main**

### Contexto clave del artefacto 2
15 reglas del **perfil hexagonal OPCIONAL** (domain / application / ports / adapters). Doc distinto al de código, no duplicado.
**Hermano de dedup: `architecture_best_practices/General_best_rules.md`** — NO el de `code_best_practices/`.
Solape a vigilar: su regla 9 (deserializado → tipo validado antes de `domain`) toca la regla 15 del doc de código ya publicado.
**Su verificación NO es clippy** (como en el artefacto 1) sino grafos de imports / chequeos de dependencias. Su regla 15 ya lo pide.

### Lecciones del artefacto 1 a pasarle al panel nuevo (no que las redescubran)
1. **Verificable = "cumple / no cumple" sin interpretar.** Es el criterio, no un adorno.
2. **No prometas verificabilidad que no verifica.** El defecto apareció 4 veces en el artefacto 1.
3. **No cites evidencia que no corriste.** d1 infló 3 números y los tres se le cayeron.
4. **Cuidado con contradicciones ENTRE reglas** (los dos paneles cometieron la clase MSRV-vs-regla).
5. **Si una regla está bien, no la toques.** No inventar cambios para justificar el turno.

### Firmas del panel de developers (artefacto 1)
- **developer-2:** APRUEBO CON CAMBIOS (1: `panic!` divergente) → cumplida al aplicarse.
- **developer-3:** APRUEBO CON CAMBIOS (6) → **todas aplicadas, cero rechazos** → cumplida. "Con esas seis, APRUEBO sin otra ronda."
- **developer-1** (autor): entregó. Se retractó de 5 afirmaciones propias (142, 306, 745, y 3 mecanismos rotos).
→ **CONSENSO UNÁNIME de 3 voces** (a diferencia del panel de architects, que cerró degradado a 2 por la caída de architect-3).

### 🔴 Las 6 de developer-3 — la #2 es una REGRESIÓN CRÍTICA
**2 (CRÍTICA):** d1 **borró `lints.workspace = true`** de la regla 1 al reescribirla. **Sin ese opt-in la tabla `[workspace.lints]` NO HACE NADA.** Probado: workspace con `unwrap_used = "deny"` compiló limpio; con la herencia, saltó el error. Todo el enforcement del documento estaba **silenciosamente muerto** en v2-dev. Mismo pecado que d1 le criticó a los architects.
**3:** Colisión emergente regla 7 × regla 8: la 7 niega `unreachable!` en todos los targets, la 8 manda aislar en un `let` — pero **`let _ = unreachable!()` falla por `diverging_sub_expression`**. Juntas prescriben algo que **no compila**.
**1:** Contradicción MSRV (misma clase que `unsafe extern` de los architects): la regla 13 recomienda **`cast_signed`, que requiere 1.87**; el header declara 1.82. Además ed.2021→≥1.82, ed.2024→≥1.85.
**4:** R32 "ésa es la única razón" para mutex async es falso (contención que no debe bloquear el executor también vale).
**5:** R36 mal el modo de falla: `write_all` cancelado **escribió un prefijo y reintentarlo lo DUPLICA**, no "pierde bytes". Y los 20 `write_all` del repo son **síncronos**, no futures Tokio. La regla vale por semántica Tokio, no por ese conteo.
**6:** R42 absoluta: desde la raíz los dos default-members SÍ se seleccionan; el problema es el cwd de un miembro (= `working-directory: src-tauri` del CI).
**Nota:** los 745 de d1 mezclan diagnósticos con ubicaciones (d3: 800 diag / 764 ubicaciones). No cambia decisiones.

### v2-dev — los 3 aportes que ningún revisor solo produce
1. **RECHAZÓ el R16 de developer-2, con razón.** Probó las dos aridades: `wildcard_enum_match_arm` dispara con enums de 3+ variantes; `match_wildcard_for_single_variants` sólo cuando el `_` cubre exactamente una. Repo real: **22 hallazgos vs 0**. d2 probó el caso de 2 variantes y generalizó. La regla cita AMBOS.
2. **COLISIÓN NUEVA que nace de aplicar ambas críticas juntas:** los dos críticos pidieron `indexing_slicing = "warn"`, y los tres mantienen `-D warnings` en CI. **Bajo `-D warnings`, `warn` ES `deny`** (probado). Aplicar la corrección reconstruía el mismo gate con otra etiqueta. Resolución: sale de la tabla → `allow` + opt-in por módulo. Lección generalizada en la regla 1: **lint en la tabla bajo `-D warnings` = gate, diga lo que diga; el lint-consejo va FUERA de la tabla.**
3. **Midió el costo de adopción: 745 warnings** contra el lib real. `must_use_candidate` (273) + `missing_errors_doc` (332) = **605 anotaciones de una sentada** → el equipo revierte la tabla, mismo final que R6 en v1. Los movió de **gate a auditoría** (la regla se mantiene; el lint deja de ser muro de CI). Gate final: ~130 sitios. *"El costo de adopción no es el número de reglas. Es la tabla de lints."*
+ **Corrigió a developer-3:** `session-bridge` SÍ está en `workspace_default_members` (`cargo metadata`). El punto ciego real es peor: **CI corre con `working-directory: src-tauri`** → ese package no se lintea nunca.
+ **Desacuerdo A:** falló a favor de d3 (recombinar splits propios, no recortar contenido verificado) **con condición propia**: sólo recombina donde la regla fusionada siga siendo contestable como UNA unidad. → 48, no ~45.
+ **Desacuerdo B:** resuelto por **síntesis, no voto** — fundió el contenido en la regla de comandos de CI (= la recombinación R45+R46 de d3). Contenido sobrevive (d3), regla autónoma desaparece (d2).

### Crítica de developer-3 — el hallazgo GRAVE que d2 no vio
**El fix de R6 de developer-1 NO arregla su propia regla.** d1 amplió R6 a 7 lints (agregó `todo`/`unimplemented`), pero las claves `allow-*-in-tests` **sólo existen para 4** (`unwrap`/`expect`/`panic`/`indexing_slicing`). NO existe `allow-unreachable-in-tests`, `allow-todo-in-tests` ni `allow-unimplemented-in-tests`. Probado con control de clave inventada que imprime la lista completa de campos.
**Métricas de d1 corregidas por d3:**
- Locks: la deuda productiva es **80**, no 306 (226 son de test → `allow-unwrap-in-tests` los cubre). Exagerado 3,8×.
- E0658 **demasiado absoluto**: `u32::from(#[expect(...)] value.unwrap())` SIN cast **compila limpio**.
- Casts: "142" no se sustenta. Clippy real: **55 diagnósticos en 51 ubicaciones** (39 truncation, 11 wrap, 5 sign-loss).
- `src-tauri/tests` agrega **655** sitios más no contados en los 3.833.
**Regla nueva propuesta (más valiosa que R44/R53):** cancellation safety — toda future que `select!`/`timeout` pueda descartar debe ser cancellation-safe. Ni `JoinHandle` ni `spawn_blocking` lo cubren.

### Coincidencias de AMBOS críticos (peso máximo)
53 reglas no 49 (35+9 splits+9 nuevas+0 merges) · 19 lints no 20 · **R45 necesita `--workspace`** (el repo real tiene `session-bridge` fuera de `default-members` → hoy no se analiza) · **15 de 19 lints son allow-by-default: nombrarlos en prosa NO los activa** → media docena de reglas no verifican nada · `indexing_slicing` fuera del `deny` universal · R44 se elimina · R12 (casts) hay que reescribirla, no sólo podarla.

### ⚖️ Dos desacuerdos entre críticos → los resuelve developer-1 (autor)
**A) Cómo bajar de 53:** d2 quiere recortar reglas; d3 quiere **recombinar los splits mecánicos** (→ ~45) sin sacrificar contenido. Mi lectura (no impuesta): d3 preserva contenido verificado y sólo revierte fragmentación que d1 introdujo por estilo.
**B) R45 ¿duplica General #20?:** d2 dice fundirla; d3 dice mantenerla (el residuo Rust es el ALCANCE del análisis). d1 la propuso standalone → **2-1 a favor de mantener**.

### Crítica de developer-2 (corrió los probes, clippy 1.93.1)
**CONFIRMÓ de d1:** R1×R6 chocan (3 diagnósticos exactos; las 4 claves de `clippy.toml` funcionan y NO aflojan producción — verificado con control negativo); `E0658` en subexpresión; `indexing_slicing` sobre bound comprobado; conteos 3.833/159/306 exactos.
**REFUTÓ de d1:**
- **R16 nombra el lint EQUIVOCADO:** `wildcard_enum_match_arm` NO dispara sobre enum propio con `_`. El real es `clippy::match_wildcard_for_single_variants`. Falsa verificabilidad.
- **R31 contradice R32:** R31 prohíbe "ningún guard" a través de `.await`; R32 manda mutex async justo para cruzarlo. Contradicción interna.
- **Casts no reproducen:** 141, no 142; y el patrón incluye float→int, enum→int, puntero→usize, no sólo entero→entero. Etiqueta mal.
- **`#[expect]` cubre todas las ocurrencias del LINT NOMBRADO, no "todos los lints"** del statement. Probado: `unwrap`+`expect` con sólo `#[expect(unwrap_used)]` sigue fallando en el `expect`.
- **19 lints únicos `clippy::`, no 20.** Todos válidos igual.
**Conteo:** confirma 53 (no 49). Aritmética: 35 + 11 nuevas + 7 splits = 53. Los "2 merges" de d1 no existen.
**Otros obligatorios:** lints nombrados en prosa ≠ activados (varios son allow-by-default → R1 debe fijar niveles); R45 debe decir `--workspace --all-targets` (`--all-targets` ≠ todos los packages); R12 necesita reescritura (no sólo poda); R42 demasiado absoluta.
**Recorte propuesto:** R44 primero, R8 fuera del baseline, R43 plegada en tests, R52/R53 a perfil "crate publicado", R45 plegada en R6/CI.

### Hallazgos de developer-1 (verificados con clippy 1.93.1 vivo, no razonados)
**R6 de los architects es INIMPLEMENTABLE.** Tres pruebas de compilador:
1. **R1 × R6 chocan:** la tabla `[lints]` aplica a TODOS los targets — no hay forma de decir "sólo producción". El `deny` cae sobre tests. Repo real: **3.833** sitios de test vs **159** producción. Fix no nombrado por el doc: `clippy.toml` + `allow-*-in-tests`.
2. **`#[expect]` no se cuelga de subexpresión:** `error[E0658]`. En `o.unwrap().len()` no hay dónde ponerlo. Además un `#[expect]` sobre un `let` silencia TODOS los lints del statement → hay que exigir un `let` por excepción.
3. **`indexing_slicing` marca código correcto:** `if v.len() > 3 { v[3] }` dispara con el bound comprobado arriba.
+ **306 `.lock().unwrap()`** que R6 vuelve ilegales sin alternativa (Mutex envenenado).
+ **Colisión R6×R7:** `checked_add().expect()` prohibido por R6 → sin camino legal.
+ **142 casts `as`** entre enteros en producción — agujero que R7 no cubre.
Nuevas de programador: tests que mutan estado global (`set_var`, 19 usos; `unsafe fn` en ed. 2024), `#[should_panic]` sin `expected`, `build.rs` rerun-if-changed, cargo-deny/RustSec, semver-checks, clippy `--all-targets`.
**No le encontró ningún error de CORRECCIÓN al doc de los architects** — sólo de aplicabilidad.

### ⚠ Error factual que detecté yo en v1-dev
El markdown propuesto tiene **53 reglas numeradas**, pero su auto-reporte dice **49**. Discrepancia de 4. Su lista de recortes y su defensa del tamaño se apoyan en el número equivocado. Se lo pasé a ambos críticos para que opinen con el número real.
- [ ] A1: publicar final developers
- [ ] A1: **commit + push a origin/main** (repo estaba limpio; el único cambio es este archivo)

### ⚠ Constancia obligatoria para el commit y el reporte al usuario
El artefacto 1 salió con **panel degradado a 2 voces** (architect-1 + architect-2). **architect-3 nunca participó en ninguna ronda** (4 intentos, 0 entregas). NO reportar como unanimidad de 3.

### Los 6 cambios obligatorios de architect-2 (checklist de verificación de v3)
1. R14 falsa para `Copy` (`fn is_even(n: u64)` va por valor).
2. R18 sobreimpone cotas: `Box<dyn Error>` NO exige `Send+Sync`; cruzar task exige `Send`, `Sync` sólo si se comparte.
3. R31 FFI: no toda frontera es ABI C (`extern "system"`, `*-unwind`); `repr(C)` no vuelve FFI-safe campos anidados.
4. R35: un job sin `--locked` igual usa el lockfile existente — no emula resolución downstream.
5. MSRV: `[workspace.lints]`=1.74, `#[expect(reason)]` y `core::error::Error`=1.81. R17 debe usar `core::error::Error` (no excluir `no_std`).
6. R28: Tokio pide LIMITAR CONCURRENCIA del CPU-bound, no sólo acotar duración.
+ 2 notas: R25 cubrir `pub unsafe trait` con `# Safety`; R6 recuperar `unreachable!`.
- [ ] A1: rondas 2–3 hasta consenso/voto
- [ ] A1: publicar consenso architects a disco (sobre el original)
- [ ] A1: panel developers sobre el archivo publicado (autor developer-1)
- [ ] A1: publicar final
- [ ] A1: **commit + push a origin/main**

### Artefacto 2
- [ ] **`purge-wg` OBLIGATORIO ANTES DE EMPEZAR** — limpia el contexto del ciclo 1. Sin esto el panel ancla en las reglas de código y contamina la crítica de arquitectura. Dry-run primero; exit 3 = alguien ocupado, esperar.
- [ ] A2: mismo proceso completo (architects → developers), autor inicial **architect-2**
- [ ] A2: publicar + **commit + push a origin/main**

## Comandos clave
```
purge-wg --token <T> --root "<R>" --wg wg-2-experts-team --dry-run   # después sin --dry-run
git -C <repo-personal> add <archivo> && git commit && git push origin main
```
NUNCA correr git desde mi replica dir — siempre `cd` al repo-personal primero.

## v1 architect-1 (artefacto 1) — 27 reglas
Msg: `20260711-030955-wg2-architect-1-to-wg2-experts-coordinator-rust-rules-v1.md`
Cambios: +gate `--doc`, `#![forbid(unsafe_code)]`, `// SAFETY:` por bloque, prohíbe `unwrap()`+indexado, error `Send+Sync+'static`+`Error`, `#[non_exhaustive]`, `&str/&[T]/&Path` no `&String/&Vec/&PathBuf`, `From` no `Into`, derivar `Debug`, guard `std::sync` no cruza await, cota `Send` en async trait, overflow explícito, `_` prohibido en enums propios, `HashMap`→`BTreeMap`, Cargo.lock+`--locked`, rustdoc `# Errors/# Panics/# Safety`. Eliminó viejo R19 (dup General #15). Dissent proactivo: R5, R12, R13, R21.

## Crítica architect-2 (artefacto 1, R1) — APRUEBO CON CAMBIOS
Msg: `20260711-031839-wg2-architect-2-to-wg2-experts-coordinator-rust-rules-critique-r1.md`
Correcciones duras: R3 (`unsafe impl` + `pub unsafe fn` legítima), R5 (`Error` sólo exige `Debug+Display`, NO `Send+Sync+'static`), R6 (`#[source]`/`#[from]` son de thiserror, no del lenguaje), R12 (orphan rules justifican `Into`), R15 (lock async no arregla nada per se), R18 (`Send` sólo si el contrato es multihilo), R19 (**`Drop` NO es infalible — puede panic**), R20 (wrapping es default configurable; `/` y `%` panican igual), R26 (Cargo.lock no universal para libs), R27 (`missing_*_doc` no aplica a "todo item público").
Dups con General: R1 (#20), R6 (#6/#7), R19 (#8), R22 (#3).
Faltantes: `unsafe_op_in_unsafe_fn`, matriz de features en CI, MSRV `rust-version`, FFI `#[repr(C)]`.
Dissent: acota R5, R12, R13, R21 — ningún veto absoluto.

## ⚠ architect-3 inestable — fallback definido
Sesión `84a481aa` (creada 03:45 UTC = swap de modelo por falta de créditos). Patrón: despierta, corre ~15 min, vuelve a idle **sin entregar mensaje**. Sesión viva, pero no produce.
Intentos de contacto: 1 (original 03:13) · 2 (03:46, despertó y murió) · 3 (04:04, `58dabaeb`).

**Si el intento 3 también muere (no hay mensaje suyo en messaging/):**
1. NO bloquear la noche esperándolo. NO sustituirlo por un developer (rompe los carriles de rol).
2. Despachar a architect-1 la revisión → v2 usando SÓLO la crítica de architect-2, aclarándole que la de architect-3 está pendiente y entrará en una ronda posterior.
3. `raise-hand` para que el usuario lo vea al despertar.
4. Si architect-3 revive, que critique v2 y se recompone el panel de 3.
5. Consenso/voto: con architect-3 ausente NO se puede computar mayoría de 3. Si al final sigue muerto, publicar con el acuerdo a1+a2 y **documentar explícitamente que el panel corrió degradado a 2 voces**. No fingir unanimidad de 3.

## Infra de la sesión
- Cron `b3c30121` cada 10 min: heartbeat de peers, re-ping a idles (3 intentos), escala al usuario al 3ro.
- Skill: `skills/artifact-panel-refinement/SKILL.md`
- Memoria: `memory/ping-timer-10min.md`

## Log
- 03:05 UTC: plan creado. architect-1 despachado como autor inicial.
- 03:10 UTC: architect-1 entregó v1 (27 reglas).
- 03:13 UTC: v1 → architect-2 y architect-3 para crítica independiente.
- 03:18 UTC: architect-2 entregó crítica. APRUEBO CON CAMBIOS.
- 03:46 UTC: architect-3 idle sin reportar (cambio de modelo por créditos → perdió el wake). Re-disparado (2/3). Confirmado `working: true`.
- 03:50 UTC: cron heartbeat + skill + memoria creados.
- ~04:00 UTC: usuario se va a dormir. Autoriza publicar + commit/push a origin main, y repetir con artefacto 2. Run nocturno autónomo arranca.
- 04:04 UTC: architect-3 intento 3 (`58dabaeb`). Murió igual: idle, sin entregar.
- 04:14 UTC: **3 intentos agotados con architect-3.** `raise-hand` levantada. Fallback ejecutado:
  - architect-1 despachado a revisar v1 → v2 con la crítica de a2 sola (`50776f65`). La noche NO se bloquea.
  - architect-3: tarea REEMPLAZADA por una ACOTADA (`40f9634f`) — 3 errores + 3 faltantes + veredicto, máx ~20 líneas, "entregá aunque sea parcial". Un 4to reintento idéntico habría reproducido la misma muerte; darle una tarea que pueda cerrar es ayudarlo a trabajar, no un retry ciego.
  - Si architect-3 entrega, sus puntos entran en la ronda 2 sobre v2.
- 04:20 UTC: **architect-1 entregó v2** (msg `20260711-042057-...-rust-rules-v2.md`). 35 reglas, 5 secciones con alcance declarado (Núcleo / API pública / Async / FFI / CI). Aceptó los 10 errores técnicos de a2 sin excepción. Devolvió 3 pushbacks fundados: (1) `redundant_clone` es nursery/FP-prone, lo reemplaza atacando la causa estructural (R14, `needless_pass_by_value`+`ptr_arg`); (2) RFC 2451 relajó orphan rules en Rust 1.41 → la excepción de `Into` es rara, no común; (3) el "source() o Display, no ambos" es convención, no requisito del trait.
- 04:23 UTC: **architect-3 falló también la tarea acotada.** 4 intentos totales, cero entregas. FUERA del panel del artefacto 1. Publicaré documentando panel degradado a 2 voces.
- 04:23 UTC: v2 → architect-2 para verificación final + arbitraje de los 3 pushbacks (`01687de4`). Si aprueba → publico y paso a developers.

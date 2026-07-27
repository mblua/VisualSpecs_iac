# Panel de arquitectura — MiContador con ingreso durable NATS e interpretación LLM

## Objetivo

Verificar y elevar `repo-personal/ObsidianVault/Proyectos/MiContador/mi-contador-architecture.json.md` para que describa una arquitectura implementable y operable donde:

1. NATS JetStream sea obligatorio desde la primera versión, inmediatamente después de todo backend/componente `channel` que recibe mensajes de usuario.
2. El sistema no confirme recepción al usuario/proveedor hasta obtener evidencia de admisión durable, y documente con precisión el límite real de la garantía de no pérdida.
3. `mi-contador-core` reciba exclusivamente comandos estructurados que registran información; nunca mensajes de chat ni instrucciones ambiguas.
4. Todo chat sea interpretado antes del core por un componente LLM, con validación, trazabilidad y un flujo explícito para ambigüedad, baja confianza, aclaración o confirmación.

## Fuente y alcance de publicación

- Artefacto principal: `repo-personal/ObsidianVault/Proyectos/MiContador/mi-contador-architecture.json.md`, leído completo por el coordinador.
- El documento referencia `mi-contador-architecture.con-nats.json` y `mi-contador-architecture.sin-nats.json`. El panel debe inspeccionarlos y proponer cómo mantener el/los canónicos visuales consistentes con NATS obligatorio. No debe dejar dos topologías presentadas como alternativas vigentes si contradicen el requisito.
- El panel puede recomendar actualizar, reemplazar o retirar referencias a artefactos hermanos, pero debe justificarlo. El coordinador será el único escritor final.
- `Architecture.md` ya aparece modificado en el working tree y queda fuera de alcance salvo que el panel demuestre una inconsistencia que deba reportarse; no se sobrescribirá.

## Criterios de aceptación

### Flujo y límites

- Mostrar el recorrido end-to-end de Web/Telegram/WhatsApp desde recepción hasta persistencia y respuesta, con NATS/JetStream como primera frontera durable después del channel.
- Separar inequívocamente: mensaje de usuario crudo, interpretación LLM, comando de escritura canónico, efecto durable, evento de resultado y respuesta al usuario.
- Convertir el core en write-side: sólo comandos de registro con esquema y versión; ubicar lecturas/consultas y coordinación conversacional fuera de esa entrada.
- Definir ownership, dependencias, crates, binarios, procesos y composition roots sin contradicciones.

### Durabilidad y semántica de entrega

- No prometer “cero pérdida” de forma absoluta: declarar el punto exacto desde el cual un mensaje se considera aceptado, la conducta antes/después del Publish ACK y las dependencias en reintentos del cliente/proveedor.
- Especificar JetStream de producción: streams/subjects, almacenamiento y réplicas, retención/límites, durable consumers, ACK explícito tras efecto durable, redelivery/backoff, DLQ o flujo equivalente de terminal failures y recuperación.
- Cubrir idempotencia/deduplicación end-to-end y la atomicidad DB ↔ ACK/eventos (inbox/outbox cuando corresponda), incluidos crash windows.
- Diferenciar disponibilidad, durabilidad y procesamiento exactly-once; cualquier garantía debe estar condicionada y ser verificable.

### Interpretación LLM segura

- Conservar el mensaje original para reproceso/auditoría bajo una política de PII y retención.
- Usar salida estructurada validada contra schema; versionar modelo/prompt/schema y registrar provenance.
- Tratar baja confianza, ambigüedad, datos faltantes, duplicados, timeouts, rate limits y contenido adversarial/prompt injection.
- No permitir que el LLM fabrique identidad/autorización ni que publique comandos privilegiados sin validación determinista y policy checks.
- Definir cuándo se solicita aclaración/confirmación al usuario y cómo se correlaciona con la conversación original.

### Contratos, seguridad y operación

- Proponer envelopes, IDs/correlation/causation/idempotency keys, subjects versionados y ACL de publish/subscribe por servicio.
- Incluir threat boundaries, autenticación de channels, identidad canónica, cifrado/secrets, aislamiento de tenants y minimización de PII.
- Incluir observabilidad end-to-end, métricas de lag/redelivery/terminal failures/LLM, tracing y runbooks de replay.
- Incluir una matriz de fallos, SLO/indicadores y gates de prueba con NATS real y fault injection.
- Basar afirmaciones críticas en evidencia concreta, priorizando documentación oficial de NATS JetStream y contratos documentados de proveedores/canales.

### Calidad del artefacto

- Documento completo, coherente y accionable, no sólo un parche conceptual.
- Eliminar el perfil “sin NATS” como opción vigente o etiquetarlo inequívocamente como histórico/fuera de alcance si existe una razón documental.
- Mantener sincronizados el Markdown y el/los JSON visuales que permanezcan canónicos.
- Identificar decisiones aún abiertas sin usar ninguna de ellas para evadir los requisitos ya fijados por el usuario.

## Panel y rotación

- Panel: `architect-1`, `architect-2`, `architect-3` (nombres FQN se resuelven de nuevo antes de cada envío).
- Autor inicial: `architect-3`, por rotación posterior al panel anterior de MiContador cuyo autor fue `architect-2`.
- Críticos independientes: `architect-1` y `architect-2`.
- Hasta 3 rondas en busca de unanimidad.

## Protocolo

- Ningún especialista modifica archivos del repositorio; entrega propuestas completas por mensajería.
- El autor debe reportar contenido completo listo para publicar, cambios con evidencia y dissent proactivo.
- Cada crítico emite revisión independiente y veredicto explícito.
- Toda asignación requiere reporte explícito de resultado, blockers y verificación.

## Estado

- [x] Título intentado; el CLI lo rechazó porque fue fijado por el usuario, incluido el reintento reglamentario.
- [x] `purge-wg --dry-run` pasó y la purga real terminó con estado `purged` antes del panel.
- [x] Artefacto principal leído completo.
- [x] Peers descubiertos y alcanzables.
- [x] Ronda 0 — `architect-3` entregó propuesta completa en 4 partes, `COMPLETADO`, sin blockers; Markdown completo, JSON completo validado y operación de archivo propuesta (`20260725-034217` a `034220`).
- [x] Ronda 1 — críticas independientes completadas: `architect-1` (`20260725-041148`) y `architect-2` (`20260725-040635`) reportaron `COMPLETADO`, sin blockers, y `APRUEBO CON CAMBIOS`; coincidieron en dirección y bloqueantes de contratos/IDs, inbox, eventos, JetStream/IaC, fallos, status, delivery, autorización y visual.
- [x] Revisión V2 de `architect-3` completada en 6 partes (`20260725-045029` a `045134`): aceptó todos los hallazgos, entregó Markdown/JSON completos, parches hermanos y validación; `COMPLETADO`, sin blockers de arquitectura conocidos.
- [x] Ronda 2 de veredictos completada: ambos críticos `APRUEBO CON CAMBIOS` (`architect-1` `20260725-050845`; `architect-2` `20260725-051059`). Convergieron en 5 cambios: status por intento/aliases, reconciler MaxDeliver owner-scoped con lookup, workflow único writer de status/recovery, provenance/crypto histórico y visual legible/DR correcto.
- [x] Revisión V3/final de `architect-3` completada en 8 partes (`20260725-054807` a `054814`): Markdown final, visual runtime 17/16, vistas derivadas code 28/32 y reliability/DR 35/30, P1 y validación/smoke UI real; `COMPLETADO`, sin blockers documentales conocidos.
- [x] Ronda 3 cerrada: `architect-1` emitió `APRUEBO` / voto SÍ (`20260725-060659`); `architect-2` emitió `APRUEBO CON CAMBIOS` / voto NO (`20260725-061358`); `architect-3` recomendó `APRUEBO` / voto SÍ en la V3 (`20260725-054814`).
- [x] Resultado tras 3 rondas: mayoría 2–1 a favor de publicar V3. Disidente: `architect-2`, por (a) falta de trazabilidad/drill-down de las 173 relaciones V2 en las tres vistas V3 y geometría expandida, y (b) trailing spaces Markdown que harán fallar `git diff --check`. Mayoría conclusive; el coordinador no modifica contenido ni arbitra.
- [x] Publicación P1 aplicada por el coordinador en `repo-personal`: Markdown V3, visual runtime, dos vistas derivadas, archivo `sin-nats`, README histórico y banners/links hermanos.
- [x] Hashes de los cuatro artefactos V3 coinciden exactamente; JSON parse PASS; validator real VisualSpecs PASS (17/16, 28/32, 35/30, sin warnings/read-only); `gran-idea` PASS 11/7.
- [x] Smoke post-write en UI real a 1680×1000 y 1024×768: seis imports iniciales con ink/counts esperados, cero browser errors y export→fresh reimport byte-for-byte PASS.
- [x] Negative-route search PASS; el Markdown sólo menciona Direct/Request-Reply como prohibición.
- [x] Warning/disenso preservado: `git diff --check` del worktree retorna 2 únicamente por cuatro hard-breaks Markdown de dos espacios (tres en el canónico y uno en `Architecture.md`); no se cambian por el voto mayoritario. También queda documentado el disenso sobre trazabilidad/drill-down de 173 relaciones V2. Artefacto final aprobado por mayoría 2–1, sin unanimidad.

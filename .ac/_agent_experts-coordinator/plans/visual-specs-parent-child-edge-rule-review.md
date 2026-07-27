# Panel de arquitectura — relaciones redundantes padre/hijo en canónicos VisualSpecs

## Objetivo

Refinar y publicar una regla en `visual-specs-live-canonical` para evitar aristas redundantes hacia un contenedor padre cuando una arista al componente hijo ya hace implícita esa conexión, y aplicar la regla a:

- `repo-personal/ObsidianVault/Proyectos/MiContador/mi-contador-architecture.con-nats.json`
- `repo-personal/ObsidianVault/Proyectos/MiContador/mi-contador-architecture.sin-nats.json`

## Fuente y alcance

- Skill canónico: `.ac/_agent_experts-coordinator/skills/visual-specs-live-canonical/SKILL.md`.
- Los dos JSON indicados por el usuario.
- No modificar código ni configuración de VisualSpecs.
- El coordinador será el único escritor final; los especialistas sólo propondrán/revisarán.

## Criterios de aceptación

1. La regla queda explícita y operativa en el contrato o flujo del skill, no sólo como comentario del caso NATS.
2. Distingue jerarquía (`parentId`) de relaciones N:M (`edges`) y explica que llegar a un descendiente hace implícita la conectividad estructural con sus ancestros.
3. Evita duplicar una arista al padre cuando sólo repite la conexión ya representada por una arista del mismo actor al hijo; cubre dirección y cadenas de ancestros sin introducir inferencias semánticas falsas.
4. El panel debe resolver explícitamente qué hacer cuando las aristas padre/hijo tienen semánticas distintas (`kind`/`label` diferentes), preservando la intención del usuario y evitando pérdida de hechos arquitectónicos. Debe proponer una redacción verificable, no ambigua.
5. Se auditan todas las aristas de ambos JSON contra sus cadenas `parentId`; sólo se retiran o consolidan relaciones que cumplan la regla acordada.
6. Se documenta exactamente qué IDs de arista cambian y por qué. Si un JSON no corresponde modificarlo, se deja intacto y se justifica.
7. Ambos JSON finales pasan por el importador real `importDoc`; además se verifica integridad referencial, IDs únicos y JSON válido.
8. No se realizan cambios en VisualSpecs ni otros artefactos.

## Panel y rotación

- Autor inicial: `architect-3` (rotación posterior al panel de MiContador cuyo autor fue `architect-2`).
- Críticos independientes: `architect-1` y `architect-2`.
- Hasta 3 rondas, buscando unanimidad.

## Estado

- [x] Skill y ambos JSON leídos completos por el coordinador.
- [x] `purge-wg --dry-run` pasó y `purge-wg` real terminó con estado `purged` antes del panel.
- [x] Ronda 0: `architect-3` entregó propuesta completa, auditoría de 70 aristas y reporte `COMPLETADO` sin blockers (`20260725-012629-wg2-architect-3-to-wg2-experts-coordinator-parent-child-r0-proposal.md`).
- [x] El usuario indicó aplicar directamente la propuesta y no buscar consenso; se cancelaron críticas y rondas adicionales.
- [x] Publicación por el coordinador en el skill canónico.
- [x] Validación final de ambos JSON con `importDoc`, IDs únicos e integridad referencial.

## Decisión final

Por instrucción expresa del usuario se publicó directamente la propuesta de Ronda 0, sin votación ni consenso de panel. La regla elimina una arista al ancestro sólo cuando duplica el mismo hecho dirigido a un descendiente; diferencias de `kind`, `label`, dirección o procedencia obligan a conservar ambas.

Se actualizó `visual-specs-live-canonical/SKILL.md` en el contrato y en el flujo de evolución. La auditoría determinó que no correspondía modificar ninguno de los JSON: en `con-nats`, las cuatro parejas NATS/JetStream representan Request/Reply o publicación Core NATS frente a operaciones durables distintas; en `sin-nats` no existe ninguna pareja candidata. Validación final: `con-nats` 38 nodos/46 aristas y `sin-nats` 25 nodos/24 aristas, ambos `warnings=0`, `readOnly=false`.

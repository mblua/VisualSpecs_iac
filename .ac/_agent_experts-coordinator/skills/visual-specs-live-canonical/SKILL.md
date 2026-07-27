---
name: visual-specs-live-canonical
description: Crear, abrir y mantener un JSON canónico conversacional en VisualSpecs, con componentes y relaciones que se actualizan mientras avanza una charla, sin modificar el código ni la configuración de la aplicación. Usar cuando el usuario quiera visualizar una idea viva en VisualSpecs o pida levantar la app apuntando a un canónico.
---

# VisualSpecs con JSON canónico vivo

## Objetivo

Mantener una especificación visual conversacional en **un único JSON canónico** y abrirla en VisualSpecs para que los cambios aparezcan mientras avanza la charla.

## Límite obligatorio

- **No modificar VisualSpecs**: no editar `src/`, `tests/`, `data/`, configuración, scripts npm ni archivos versionados de la aplicación.
- El único artefacto funcional que cambia es el JSON canónico, ubicado en un área ignorada por Git, normalmente `<repo-VisualSpecs>/.local/<nombre>.json`.
- `node_modules/`, el Chromium local de Playwright y logs ignorados son dependencias/artefactos de ejecución, no cambios de producto.
- No delegar ni contactar al equipo por el solo hecho de activar este skill. Hacerlo únicamente si el usuario lo pide expresamente.
- Si el usuario pide estilos propios para nuevas clases de nodo o arista, aclarar que eso sí requeriría modificar la app y obtener autorización aparte. El vocabulario abierto funciona sin esa modificación mediante el estilo visual de fallback.

## Contrato de trabajo

1. **Un solo archivo es la fuente de verdad.** No mantener copias competidoras.
2. Cada concepto visible es un elemento de `nodes` con `id`, `kind`, `label` y `parentId`.
3. Cada nodo tiene como máximo un padre jerárquico. Las relaciones N:M se expresan en `edges`.
4. **No dupliques una arista sólo para alcanzar el contenedor de su destino.** Definí `ancestros(D)` como toda la cadena transitiva obtenida al seguir `parentId` desde `D` hasta la raíz. Dadas una arista `eD: S → D` y otra `eA: S → A`, donde `A` es un ancestro estricto de `D`, omití `eA` sólo si mantienen la misma dirección —el mismo `sourceId`, con la jerarquía únicamente en `targetId`— y describen el mismo hecho: igual `kind`, igual `label` incluida su ausencia, e igual semántica de `metadata`. No pierdas procedencia: para una deduplicación automática exigí también igualdad de `confidence` y `evidence`, o trasladá/fusioná explícitamente en `eD` la procedencia que se perdería. `parentId` ya expresa que `D` habita dentro de `A`; esto vuelve implícito el alcance del contenedor, no vuelve transitivo el `kind` de la arista ni convierte contención en una relación N:M. Si cambia la dirección, la jerarquía está en `sourceId`, o `kind`, `label`, `metadata`, `confidence` o `evidence` expresan hechos distintos, conservá ambas aristas y documentá el motivo.
5. Los IDs son semánticos y estables. No cambiar un ID por una corrección de texto o etiqueta.
6. `kind` es vocabulario abierto: se pueden usar `idea`, `actor`, `frontend`, `backend`, `service`, `database`, etc.
7. Toda arista declara `confidence`: usar `declared` para decisiones acordadas explícitamente, `resolved` para hechos verificados y `heuristic` solo para inferencias con evidencia.
8. Actualizar el canónico con escritura atómica cuando esté siendo seguido: escribir y validar un temporal en el mismo directorio y luego renombrarlo sobre el destino.
9. Un JSON inválido nunca debe convertirse deliberadamente en la nueva versión canónica.
10. Después de cada cambio, resumir al usuario qué nodos/aristas se agregaron, cambiaron o retiraron.

## Flujo

### 1. Preparar el canónico

- Crear `<repo-VisualSpecs>/.local/` si no existe.
- Copiar el ejemplo de este skill a `.local/gran-idea.json`, o crear otro canónico respetando el mismo contrato.
- Validarlo con el importador real de VisualSpecs, no solo con `JSON.parse`:

```powershell
Set-Location <repo-VisualSpecs>\VisualSpecs
node --input-type=module -e "import {readFileSync} from 'node:fs'; import {importDoc} from './src/contract/load.ts'; const d=importDoc(readFileSync('../.local/gran-idea.json','utf8')); console.log(JSON.stringify({nodes:d.model.nodes.length,edges:d.model.edges.length,warnings:d.warnings.length}))"
```

### 2. Levantar VisualSpecs sin modificarlo

```powershell
Set-Location <repo-VisualSpecs>\VisualSpecs
npm ci
$env:PLAYWRIGHT_BROWSERS_PATH = (Join-Path (Get-Location) '.playwright-cache')
npx playwright install chromium
npm run dev
```

Luego usar **Open JSON temporarily** y elegir el canónico. En `localhost`, VisualSpecs retiene el handle y muestra `Following <archivo> — reloads on change`.

Para una apertura automatizada que siga el archivo sin tocar la app, puede usarse el launcher externo incluido en este skill:

```powershell
node <skill-root>\scripts\launch-visual-specs.mjs `
  --app <repo-VisualSpecs>\VisualSpecs `
  --canonical <repo-VisualSpecs>\.local\gran-idea.json
```

El launcher solo sustituye el selector de archivos dentro de la sesión de navegador controlada y conecta su lectura con el archivo canónico. No escribe ni parchea VisualSpecs.

### 3. Evolucionar durante la charla

Para cada decisión:

1. Identificar si es un nuevo nodo, una nueva relación o una modificación semántica.
2. Reutilizar IDs existentes siempre que la identidad siga siendo la misma.
3. Mantener los hijos directos de una idea dentro de su `parentId`.
4. **Auditar redundancia jerárquica de aristas.** Con todos los `parentId` resueltos, recorrer la cadena completa de ancestros de cada `targetId` y comparar todas las aristas existentes y propuestas que tengan el mismo `sourceId`. Retirar u omitir sólo la arista dirigida al ancestro que cumpla íntegramente la regla de redundancia anterior. Ante una diferencia de dirección, semántica o procedencia, conservar ambas y registrar por qué son hechos distintos. Repetir esta auditoría si cambia cualquier `parentId`, porque puede cambiar toda la cadena de ancestros, no sólo el padre inmediato.
5. Describir los flujos con aristas dirigidas.
6. Validar el documento completo.
7. Reemplazar atómicamente el canónico.
8. Confirmar que VisualSpecs lo recargó y conservó la vista de los nodos sobrevivientes.

## Ejemplo canónico: Gran Idea

Este es el ejemplo inicial del skill. La vista comienza con **un único nodo visible, “Gran Idea”** (`expanded: []`). Al hacer doble clic sobre él aparecen sus tres hijos, dispuestos como **User → Frontend → Backend** y unidos por dos aristas dirigidas.

El archivo distribuido con el skill es `examples/gran-idea.json`; el bloque siguiente debe mantenerse equivalente a ese archivo:

```json
{
  "formatVersion": "1.0",
  "generator": {
    "name": "visual-specs-live-canonical",
    "version": "1.0.0"
  },
  "source": {
    "kind": "conversation",
    "root": "gran-idea"
  },
  "nodes": [
    {
      "id": "idea:gran-idea",
      "kind": "idea",
      "label": "Gran Idea",
      "parentId": null
    },
    {
      "id": "actor:user",
      "kind": "actor",
      "label": "User",
      "parentId": "idea:gran-idea"
    },
    {
      "id": "component:frontend",
      "kind": "frontend",
      "label": "Frontend",
      "parentId": "idea:gran-idea"
    },
    {
      "id": "component:backend",
      "kind": "backend",
      "label": "Backend",
      "parentId": "idea:gran-idea"
    }
  ],
  "edges": [
    {
      "id": "flow:user-to-frontend",
      "kind": "flow",
      "sourceId": "actor:user",
      "targetId": "component:frontend",
      "label": "uses",
      "confidence": "declared"
    },
    {
      "id": "flow:frontend-to-backend",
      "kind": "flow",
      "sourceId": "component:frontend",
      "targetId": "component:backend",
      "label": "calls",
      "confidence": "declared"
    }
  ],
  "view": {
    "positions": {
      "idea:gran-idea": { "x": 500, "y": 260, "pinned": true },
      "actor:user": { "x": 220, "y": 380, "pinned": true },
      "component:frontend": { "x": 500, "y": 380, "pinned": true },
      "component:backend": { "x": 780, "y": 380, "pinned": true }
    },
    "expanded": [],
    "viewport": { "x": 0, "y": 0, "zoom": 0.75 }
  }
}
```

## Criterios de aceptación

- VisualSpecs no tiene cambios versionados.
- El canónico pasa por `importDoc` sin errores.
- Al abrirlo solo se ve `Gran Idea`.
- Al expandirlo se ven `User`, `Frontend` y `Backend` con el flujo indicado.
- La sesión muestra que sigue el archivo, o se declara explícitamente si se usó el fallback de archivo estático.
- Una edición posterior válida se refleja sin volver a seleccionar el archivo.

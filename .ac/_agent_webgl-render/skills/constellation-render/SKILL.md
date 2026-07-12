---
name: constellation-render
description: Non-negotiable performance rules for rendering a 5k-50k node constellation graph in three.js — one draw call for nodes, one for edges, GPU picking, selective bloom, and label culling. Violating any of them costs the frame rate.
when_to_use: Load before writing or reviewing any three.js render code, picking logic, postprocessing pass, or label system in this project.
---

# constellation-render

Target: 5k-50k nodes, 60fps, static hosting, no backend.

## Draw calls

- Nodes: ONE `THREE.Points` with a `ShaderMaterial` and instanced attributes. Never a `Mesh` per node.
- Edges: ONE `THREE.LineSegments` over a merged `BufferGeometry`.

Two draw calls total for the graph. Anything that adds a third needs a reason.

## Picking

GPU picking: render node ids encoded as color into an offscreen render target, read back the pixel under the cursor. Raycasting against 50k points kills the frame.

## Glow

`SelectiveBloomEffect` from pmndrs `postprocessing`. This is where the reference image's look comes from — bloom applied selectively to nodes, not to the whole scene.

## Labels

Hard cap ~200 visible labels, rendered with `troika-three-text` (SDF atlas). Choose which by PageRank × camera distance, then resolve screen-space collisions. Label count is the axis that gets underestimated; the cap is not a suggestion.

## Data transport

Positions and colors arrive as `Float32Array` binary blobs and never as SQL rows or JSON. 50k nodes = 600 KB of xyz. 200k edges = 1.6 MB. Parsing 50k JSON rows costs more than the entire render.

Tooltip metadata is fetched per-node through `wa-sqlite` doing HTTP range requests against the remote `.sqlite`. Only the hovered node's row travels.

## Tooltip fields

`Blockers · Dependents · PageRank · Depth · Betweenness · K-core · Eigen` — all read from the `metrics` table, none computed in the browser.

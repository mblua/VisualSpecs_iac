# Plan 001 — Team shape and build sequencing

Status: agents created, team and workgroup pending.
Stack decisions live in `_memory/MEMORY.md`. This file covers who does what, in what order.

## Team

Four agents. The coordinator is dedicated and holds no implementation lane.

| Agent | Lane |
|---|---|
| `contract-architect` | coordinator, data-contract owner (from `agency:engineering-engineering-software-architect`, trimmed) |
| `rust-ingestion` | rust-analyzer, SCIP/protobuf, rusqlite, git mining |
| `graph-analytics` | networkit, leidenalg, ForceAtlas2 |
| `webgl-render` | three.js, GLSL, GPU picking, postprocessing, troika |

## Why the coordinator owns the contract and nothing else

The whole system is coupled by ONE artifact: the schema plus the blob format. Rust writes it, Python reads and writes it, WebGL reads it. Whoever owns it, coordinates.

A schema owner who also implements a lane biases the contract toward that lane:

- `rust-ingestion` is upstream and would shape the schema like SCIP — the wrong shape for the renderer.
- `graph-analytics` is the best of the three (it both consumes and produces) but never feels the renderer's pain.
- `webgl-render` is the truest judge of data shape, but it is the longest and riskiest lane. Coordinator plus critical lane equals bottleneck.

Fallback if a fourth agent is ever cut: `graph-analytics` coordinates — middle of the chain, touches both contracts, shortest lane. Second-best, not first.

## The serial chain, and how to break it

Nothing analyzes until ingestion emits. Nothing renders until layout exists. Left alone, the team runs serially and two thirds of it idles.

**Day 0, `contract-architect`:** freeze the schema and emit `fixtures/seed.sqlite` — small, but proportionally realistic: nodes, edges, metrics, layout, right ratios between them. Publish `spec/blobs.md` alongside it.

**Day 1:** `graph-analytics` and `webgl-render` both start against the fixture, in parallel, while `rust-ingestion` builds the real thing.

The fixture is what actually coordinates the team. The agent just writes it.

## Day-0 blocker, before anything else

Verify the `touches` edge is not empty on the target repo: does its history reference issue IDs in commit messages or PRs? If not, `touches` dies and the unified-graph feature dies with it. Check this first. It is a hard dependency, not a nice-to-have.

## Governance

Per `role-skill-boundary-audit`:

- Stack decisions live in `_memory/MEMORY.md`, once. Not copied into `Role.md` files.
- Render performance rules live in `.ac/_agent_webgl-render/skills/constellation-render/SKILL.md`, not in that agent's role.
- The schema and blob spec are repo artifacts. `contract-architect`'s role says it owns them; it does not contain them.
- Roles hold identity, lane, ownership, boundaries, escalation. Nothing else.

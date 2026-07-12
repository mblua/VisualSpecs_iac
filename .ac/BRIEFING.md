# WG1 Constellation — Briefing

Read this before anything else. It tells you what is decided, and what is not.

## STOP — do not start building

The tech stack is closed. **The application is not defined.** No lane starts implementing until the user answers the questions at the bottom of this file.

What exists today is an architecture for a shape of system. What does not exist is a product: who uses it, what question it answers, what it points at. Building the pipeline before that is how you get a beautiful renderer nobody opens.

## What was decided (and why)

The conversation so far produced one thing: a stack, argued rather than assumed. Full detail in `_memory/MEMORY.md` at the repo root. The short version:

Ingest a codebase — mostly Rust, modular enough to add other languages — store it in SQLite, render it in a browser as a 3D "constellation": glowing nodes, force-directed cloud, sparse labels, hover tooltip with per-node metrics. Scale target 5k–50k nodes. Code nodes and task/issue nodes live in **one unified graph**.

**The keystone decision is SCIP as the intermediate format.** Tree-sitter gives syntax, not semantic resolution — it cannot resolve `foo::bar` across files, nor traits, nor macros. `rust-analyzer` in SCIP mode can. So:

    per-language adapter  ->  SCIP index  ->  ONE importer  ->  SQLite

Modularity is inherited from SCIP, not designed by us. Adding Python later means running `scip-python`; nothing downstream changes.

The pipeline is deliberately **bilingual**: Rust for ingestion (only thing that truly resolves Rust symbols), Python for analytics (`networkit`, `leidenalg`, ForceAtlas2 — Rust has no sampled betweenness, no Leiden, no mature ForceAtlas2). SQLite is the contract between them. Serving is static: binary blobs for positions and edges, `wa-sqlite` over HTTP range requests for tooltip metadata. No backend.

## Team shape

| Agent | Lane |
|---|---|
| `contract-architect` | coordinator; owns the SQLite schema, the blob format spec, the seed fixture. No implementation lane. |
| `rust-ingestion` | rust-analyzer, SCIP/protobuf, rusqlite, git-history mining |
| `graph-analytics` | networkit, leidenalg, ForceAtlas2 |
| `webgl-render` | three.js, GLSL, GPU picking, selective bloom, troika labels |

The coordinator holds no lane on purpose: a schema owner who also implements would bend the contract toward their own lane.

The three lanes form a serial chain — nothing analyzes until ingestion emits, nothing renders until layout exists. The coordinator breaks it on day 0 by freezing the schema and emitting `fixtures/seed.sqlite`, so analytics and render start in parallel on day 1 against the fixture. **That fixture is what coordinates the team.**

## What is missing: the app

The stack answers *how*. Nobody has answered *what*. These are open, and the user must answer them:

1. **Which codebase gets ingested?** This repo itself? An arbitrary repo the user points at? A fixed one? This decides whether we build a tool or a viewer.
2. **Who looks at it, and what decision does it help them make?** "See the codebase" is not an answer. Find the bottleneck module? Find orphaned code? See which issues touch which subsystems? Onboard a new dev? Each of those changes which metrics matter and what the tooltip shows.
3. **What is the deliverable?** A CLI that emits a static site. A hosted service. A desktop app. Something else.
4. **When does it run?** Once, by hand. Per commit, in CI. On demand.
5. **Where do the task nodes come from?** GitHub Issues and Projects, from which repo? Markdown with frontmatter? Something else entirely?
6. **What happens on click?** Jump to the source line? Filter the graph? Open the issue? Nothing?
7. **What does "done" look like?** The smallest version of this that would be worth using.

## Hard dependency, check before anything

The `touches` edge (issue → file) is what makes the unified graph worth building. It is mined from commits and PRs that reference issue IDs. **If the target repo has no convention of referencing issues in commits, this edge comes back empty and the unified-graph feature dies.**

Verify this against the real target repo before the schema is frozen. Not after.

## Until then

`contract-architect`: do not freeze the schema. The schema encodes what the app is for — `metrics` columns exist because a tooltip shows them, `node.kind` values exist because a user filters on them. Freezing it now means guessing the product.

Everyone else: read `_memory/MEMORY.md`, read your own `Role.md`, and wait.

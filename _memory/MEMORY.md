# MEMORY — CodebaseConstellation

Project decisions. Single source of truth. Do not duplicate these into `Role.md` files.

## What this is

Ingest a codebase (mostly Rust, modular so other languages can be added), store it in SQLite, render it in the browser as a 3D "constellation" graph with three.js: glowing nodes, force-directed cloud, sparse labels, hover tooltip with per-node metrics.

Scale: 5k-50k nodes. The graph is **unified** — code nodes and task/issue nodes live in the same graph.

## Keystone decision: SCIP as the intermediate format

Tree-sitter gives syntax, not semantic resolution. It cannot resolve `foo::bar` across files, nor traits, nor macros. For Rust the correct tool is `rust-analyzer` in SCIP mode.

    per-language adapter  ->  SCIP index  ->  ONE importer  ->  SQLite

Modularity is **inherited, not designed**. Adding Python later means running `scip-python` with zero downstream change. SCIP already has indexers for TypeScript, Python, Java, Go, C++. Languages without one fall back to tree-sitter: syntax-only, degraded edges, declared tier-2.

## Stack (closed)

| Layer | Choice | Why |
|---|---|---|
| Code ingestion | `rust-analyzer scip` + importer in **Rust** | only thing that truly resolves Rust symbols |
| Task ingestion | adapter for GitHub Issues/Projects, or markdown + frontmatter | issue and milestone nodes |
| Cross ingestion | git-history mining (issue refs in commits) | produces the `touches` edge |
| Storage | **SQLite**, single file, WAL | the contract between stages |
| Metrics | **Python** + `networkit` | needs sampled betweenness |
| Clustering | **Python** + Leiden (`leidenalg`) | node colors are communities, not random |
| 3D layout | **Python** + ForceAtlas2, precomputed offline | never in the browser |
| Serving | static; `wa-sqlite` + HTTP range VFS | no backend needed at this scale |
| Render | **vanilla TS** + three.js + pmndrs `postprocessing` | selective bloom |
| Labels | `troika-three-text` (SDF atlas) | only thing that scales |

## Why the pipeline is bilingual

Rust for ingestion, Python for analytics, SQLite as the contract. This gets challenged, so the answer is written down:

Rust has `rustworkx-core` and `petgraph`, enough for PageRank — but no sampled betweenness, no Leiden, no mature ForceAtlas2. Python has all three. At 50k nodes exact betweenness is O(V·E) ≈ 1e10 operations, so the sampled variant is mandatory. Writing sampled Brandes and Leiden by hand in Rust buys nothing: the batch runs once per snapshot, not in a hot path.

All-Rust is viable if the team insists. That is the price. State the trade, don't hide it.

## Serving math

50k nodes = 600 KB of xyz (`Float32Array`). 200k edges = 1.6 MB. Static binary blobs. Tooltip metadata via `wa-sqlite` doing HTTP range requests against the remote `.sqlite`. Pure static hosting, zero server.

**Rule: positions and colors NEVER travel as SQL or JSON.** Parsing 50k JSON rows costs more than the entire render.

## Schema shape (sketched, not frozen — `contract-architect` freezes it)

    nodes(id, kind, name, path, line, loc, lang)
    edges(src, dst, kind, weight)
    metrics(node_id, pagerank, betweenness, eigen, kcore, depth, blockers, dependents)
    layout(node_id, x, y, z, cluster)
    snapshots(id, commit_sha, ts)

Indexes on `edges(src)` and `edges(dst)`. Without them any recursive traversal crawls.

Unified graph = discriminated nodes.

- `node.kind`: `file | module | symbol:fn | symbol:struct | symbol:trait | issue | milestone | epic`
- `edge.kind`: `imports | calls | implements | defines | blocks | depends_on | touches`

`touches` (issue -> file) is the edge that makes the unified graph worth doing. It is mined from commits and PRs that reference issue IDs.

## Risks, ranked

1. Symbol resolution in macro-heavy Rust. rust-analyzer covers most; dense proc-macros degrade. Data-quality risk, not architectural.
2. **`touches` comes back empty** if the repo has no convention of referencing issues in commits. Verify before committing to the unified-graph feature. Hard dependency.
3. Layout stability across snapshots. Re-laying-out from scratch makes the constellation jump and destroys the user's mental map. Needs seeded/incremental layout. Always forgotten.
4. Labels at scale. Always underestimated.
5. Betweenness cost. Mitigated by sampling.

## Do NOT build

SCIP indexers. Graph algorithms. Force layout. SDF text renderer. All exist, all battle-tested.

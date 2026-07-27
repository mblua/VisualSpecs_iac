# VisualSpecs RFC 17 — out-of-focus dimming (`view.focus`)

Context: wg-1, issue #17, repo `VisualSpecs`, branch `feature/17-out-of-focus-dimming`.
Owner of the RFC: `vs-spec-core-lead`. My role: extraction/evidence constructive reviewer **and**
owner of a third artifact — extraction-side non-regression and invariance.
**CLOSED.** PR #22 merged, issue #17 closed, `main` = `67a769e`. Verdict was
`VALIDATED_WITH_CHANGES`, C1–C4 accepted, all three artifacts delivered and accepted. My worktree is
down; my three files are on merged `main`. Nothing queued.

Open follow-ups I do not own but that touch my lane if they move: **#20** suite ~50%
non-deterministic · **#23** Playwright port pin (5175, `--strictPort`) blocks concurrent runs · #18,
#19, #21. #21 must not land before #20.

**Pre-assigned, not yet routed:** if #20 comes to me it is the **`EPERM` half** — the fake-timer half
is `vs-spec-core-lead`'s. Follow-ups sit with the user; nobody is waiting on me. My "three symptoms,
one cause" hypothesis and its caveat are both recorded on #20 as the first thing a taker reads.

My measurement on `67a769e`, offered to #20 and deliberately not concluded: my three files in
isolation 3/3 green (15 cases), whole suite 3/3 green (535/0), **without** `--no-file-parallelism`.
Three green runs do not refute a ~50% flake rate — the plausible trigger is several agents running
`vitest` against one tree, and the tree was quiet, which is when the defect hides. Absence of observed
failures, not absence of the defect. Hypothesis worth checking before three separate fixes get
written: the flake, the `EPERM` on `data/doc.json`, and #23's port pin may be one contention cause
wearing three error messages.

## Delivered

| Commit | What |
|---|---|
| `000e190` | `tests/extractor/focus.test.ts` — I-F9: the extractor never emits `view.focus` (4 cases) |
| `fa76684` | `tests/extractor/focusInvariance.test.ts` — I-F1/I-F2 from outside the domain (5 cases) |
| `052892b` | followed E1: no transparency nobody typed; added the one somebody chose |
| `558b908` | `tests/extractor/observationBoundary.test.ts` — I-F10 as a check, both directions (4 cases) |
| `9f7a9c3` | fixed my own headline claim (see the pattern below); 7 cases, sensitivity stated per case |

Test-only commits after `367a00b` are deliberately NOT in the gate SHA. Red-team mutation counts
reported against `367a00b` will not match my file as it stands.

## Verified on the corpus — trust these (source spans)

Probe: real `AgentsCommander @ 0a3dc5a`, 787 nodes / 1872 edges / 679 tracked files.

| Fact | Where |
|---|---|
| Extractor emits `view: { expanded: [repoId] }` — one key, always | `tools/extractor/extract.ts:158` |
| Extractor hard-codes `formatVersion: '1.0'` | `tools/extractor/extract.ts:136` |
| Extractor validates its OWN output with the app's `importDoc` | `tools/extractor/extract.ts:190` |
| Publication replaces the destination **whole** (temp + rename), never merges | `tools/extractor/output.ts:63-132` |
| Nothing in `tools/extractor/**` ever READS `view` | grep-verified, all files |
| `refresh()` carries `previous.view` from memory, drops only ids the new model lacks | `src/contract/load.ts:137-209` |
| Follow-file auto-reload goes through `refresh()`, so a `--watch` tick does NOT cost marks | `src/app/projectController.ts:1048` → `src/app/controller.ts:172` |
| `validateView` is an ALLOWLIST: copies `positions`/`expanded`/`fitted`/`viewport`, drops the rest | `src/contract/validate.ts:505-597` |
| A 1.2 doc opens on a 1.1 build: `unknown-minor` warning, `raw.view.focus` preserved verbatim | proved empirically |
| Committed corpus is `1.0` with `view={"expanded":["repo:AgentsCommander"]}` | `data/agentscommander.json` |
| Only extractor-side pin of an exact version | `tests/extractor/watch.test.ts:418-419` |
| `scanJson` inspects string VALUES, not keys | `src/contract/json.ts:147-172` |
| No id-count limit exists anywhere | `src/contract/limits.ts:7-37` |

**Extraction never reads `view`, so `view.focus` can never be dropped partially or duplicated — it is
overwritten in full, silently, with every other view key.** Exposure is `npm run extract:agentscommander`
over the committed corpus, and opening a re-extracted file cold. Not the follow-file path.

## The load-bearing insight (don't lose this)

**`metadata` is the only route by which focus could contaminate evidence, and it is a free-form
`Record<string, unknown>` the validator accepts without inspection** — `ownership.ts:129-212`
(`isTest`, `language`, `rootAnchor`, `version`, `libName`), `apps.ts:104-330` (`flavor`, `command`),
`tsimports.ts:175`, `rust/imports.ts:81-262` (`specifier`, `via`). It is **regenerated on every run**.
A focus mark parked there would be (i) indistinguishable from an observation about the code and
(ii) destroyed at the next extraction. Accepted as **I-F9**, two parts: focus lives only under
`view.focus`, never in `nodes[]/edges[].metadata`, `evidence[]`, `unresolved[]`; and no extractor
ever emits `view.focus`. The future temptation is "auto-dim tests / vendor": a machine suggestion
about attention must travel under a different, derived, recomputed key. `focus.marks` means
*a person said so*.

## The pattern worth carrying to every repo (going into ADR-0006 as a method note)

**Assert on the value the system produces, never on one the test rebuilds from inputs the failure
cannot reach.** I made this error twice in one issue, in two costumes, and only caught the second
because I wrote a case designed to fail and was surprised when it passed:

1. **Item 1 costume:** `expect(doc.view.focus).toBeUndefined()` on the *validated* doc. `validateView`
   is an allowlist that drops unknown keys, so it passes even when the extractor emits focus. Fix:
   assert on `JSON.parse(result.text)`, the bytes actually published.
2. **Item 2 costume:** `projectionOf = (s) => project(s.model, s.outline, s.view.expanded)`. No focus
   command touches `expanded`, so it compared `project(E)` with `project(E)` — true by construction,
   blind to a leak reaching the projection inside `derive()`. The cases that appeared to catch that
   leak were catching it on `counts()`, which does go through `derive()`. Fix:
   `projectionOf = (s) => derive(s).graph`, and assert `expanded` before/after separately, which is
   what the recomputed form was really proving.

The recomputed form is the trap precisely because **it looks more rigorous** — rebuilding the value
from first principles reads as independence, and is actually insulation from the defect.

Corollaries, both earned:
- **A case designed to catch a specific defect that PASSES against that defect is a finding, not
  reassurance.** That is the whole reason costume 2 was found.
- **State per-case sensitivity in the file header.** "7 green" gets read as seven proofs of one thing;
  most of my cases have a different subject and are correctly blind to a projection leak.
- **A mutation that finds nothing tells you less than one that finds something** (owner's phrasing,
  after running the same discipline over 24 domain cases and catching nothing).

## Traps — read before writing another test here

- **Asserting on the validated `doc` instead of the emitted bytes is a permanently green test.**
  `validateView` drops unknown keys, so `expect(doc.view.focus).toBeUndefined()` passes *even when
  the extractor emits focus*. Always assert on `JSON.parse(result.text)`.
- **Never substring-search `"focus"` in a document.** A repo may legitimately contain `focus.ts`;
  that node's id is not a mark. Walk the tree, collect paths where `focus` is an object KEY, and
  assert the helper *does* find `$.view.focus` somewhere so absence assertions cannot be vacuous.
- **An absence test nobody has seen fail is an opinion.** Mutate the producer, watch the right cases
  go red, revert before staging. Owner named this the standard for the invariance harness too.
- **The app's loss/warning surface is an allowlist and swallows most of what it computes.**
  `ui/app.ts:1234-1242` shows only `unknown-minor`, `snippet-present`,
  `absolute-path-in-free-form-field` — every `stale-*` is computed and never shown.
  `ui/app.ts:1254-1255` omits `droppedFitted`, invisible since #13. This was my C1 (P1); routed to
  `vs-graph-runtime-dev`, and `droppedFitted` gets surfaced in #17 as a recorded scope addition.
- Extractor tests must pass on a checkout where AgentsCommander is **absent** (§10.7): use
  `makeFixtureRepo()` (`tests/support/fixtureRepo.ts`), never `../../repo-AgentsCommander`. Reading
  the committed `data/agentscommander.json` as a file is fine — precedent in `tests/dataset/`.
- `--out` is confined inside the working root (`assertOutputInsideRoot`); scratch work goes in
  `VisualSpecs/.local/` (gitignored via `*.local`). Clean it up.

## Operational, in this workgroup

- **Never mutate the shared working tree.** Three agents run `vitest` against one checkout. Use
  `git worktree add VisualSpecs/.local/gate-<name> <SHA>` — **under `VisualSpecs/`, not the repo
  root**: there is no `node_modules` at the repo root, and Node only resolves it by walking parent
  directories, so a worktree at the root fails confusingly. `git worktree remove --force` when done.
  (The owner's original instruction said the repo root; my correction went to both red teams.)
- **`EPERM` on `data/doc.json` during extractor tests is contention, not a defect** — several agents
  writing real files from one tree. Re-run before investigating.
- **Never quote bare suite totals.** They include other lanes' uncommitted work. Report what my own
  files do, and attribute anything red before reporting it (`git show HEAD:<file>` vs the working
  copy tells you instantly whose it is).
- Flagging someone's in-flight breakage beats fixing it or reporting "clean". Cost the owner nothing
  both times because he recognised it as his immediately.

## Contract facts that changed under me (E1 and after)

- `export` writes `focus.transparency` **only when it differs from the default or was already
  declared**, and `focus.marks` only when non-empty or already declared. Writing the default turned an
  absence into a value nobody chose, and would pin every touched document to a default it never picked
  if the constant later moved.
- `formatVersion` is raised on the **typed** state being non-default, not on the key appearing in the
  output.
- I-F10 is split, as I proposed: **(a)** `view.*` carries no observations *even when a machine writes
  it* (`extract.ts:158` emits `view.expanded` on every run — the counterexample that would have made
  the unsplit form refutable); **(b)** `view.focus` specifically is a human decision no machine writes.
- Placement accepted: `VisualSpecs/README.md`'s document section (the audience I-F10 protects never
  opens `contract/view.ts`), ARCHITECTURE.md, ADR-0006 — and **not** in the document itself, which
  would break I-F4 and AC 10.

## Design moved after the RFC I reviewed (matters for item 2)

Both accepted from `vs-graph-runtime-dev`, not yet in the frozen plan:

- `RenderNode.dimmed` / `RenderEdge.dimmed` **replaced** by a required `opacity: number` on the
  renderer port, combined as `min(searchOpacity, focusOpacity)`. If item 2 asserts anything about
  scene contents, assert **opacity**, not `dimmed`.
- `FOCUS_TRANSPARENCY_MAX = 78`, `DEFAULT = 70` (RFC said 95 / 80). Contrast floor: at 95 the worst
  element sits at 1.02:1 — invisible but still hit-testable, a clickable ghost.

Neither changes what item 2 asserts. Bit-identical is bit-identical.

---
name: implementation-workflow
description: Canonical Visual Specs delivery workflow. Confirm the change, assign one owner per artifact, use the constructive and adversarial gates, and land an issue-backed branch through a verified PR.
when_to_use: Load for repo work that may become a code change, after task-intake. Do not create a branch until a code change is confirmed and a GitHub issue exists.
---

# implementation-workflow

This is the source of truth for moving a Visual Specs change from request to `origin/main`. Use `task-intake` to distinguish investigation from implementation, `agent-coordination` for peer activation and context, and `git-landing-flow` for repository mechanics.

Routine landing has no user approval gate after the required evidence and gates pass. Escalate only for missing scope, an undecidable product tradeoff, acceptance of material risk, unresolved P0/P1 findings, or an external permission/process blocker.

## Team routing

Use logical roles in plans and resolve the exact current peer FQN with `list-peers-lean` before every message. Never hardcode a workgroup number.

| Logical role | Current owner | Owned artifacts |
| --- | --- | --- |
| Core lead and coordinator | `vs-spec-core-lead` | versioned contracts, canonical domain, identity, invariants, projections, semantic diff, coding-agent change protocol, cross-team arbitration |
| Extraction owner | `vs-extraction-evidence-dev` | language extraction, provenance, evidence, fixtures, repository re-extraction |
| Graph/runtime owner | `vs-graph-runtime-dev` | graph runtime, layout, renderer port implementation, UI, interaction, visual behavior |
| Semantic adversary | `vs-semantic-red-team` | falsification of semantic invariants, identity, lifecycle, projections and contract meaning |
| Resilience adversary | `vs-resilience-red-team` | falsification of operational behavior, failure modes, performance, degradation and cognitive usability |

The core lead coordinates and also implements work in the core lane. Do not route its owned implementation to another agent merely because it is the coordinator.

Each artifact has exactly one constructive owner. Cross-cutting work may have several artifacts, each with its own owner. A decision inside one artifact belongs to its owner while approved invariants remain satisfied. A transverse decision requires support from at least two of the three constructive agents: core lead, extraction owner and graph/runtime owner.

The two red teams remain independent and never implement the productive fix they review.

## Delivery paths

**Investigate** for requests such as check, inspect or diagnose. Investigate, propose and report. Do not create an issue or branch until the user asks to implement or the request already clearly authorizes implementation.

**Lite** only when all of these hold: the change follows a named precedent, is localized to one artifact, adds no dependency or abstraction, changes no schema/API/protocol/persistence rule, and cannot alter an approved P0/P1 invariant. Lite skips the RFC and premortem steps but still requires owner verification and both independent final adversarial gates.

**Full** when any of these hold: a cross-cutting or architectural decision; schema, API, protocol, persistence or identity work; extractor/projection compatibility; performance-critical behavior; three reasonable approaches; or an explicit request for full review. Full uses every step below.

**Narrow delegation** is allowed for a non-delivery task: one specialist investigates, one red team reviews an external artifact in its lane, or the relevant constructive owner runs a documented build. It does not silently become a path to `main`.

State the selected delivery path and artifact owner or owners to the user before the first delivery delegation.

## Delivery map

| Step | Name | Owner | Artifact or gate |
| --- | --- | --- | --- |
| 0 | Sync target repo | core lead | local `main == origin/main` |
| 1 | Confirm change and ownership | core lead plus specialist | no-change report or owned change |
| 2 | Issue and branch | core lead | detailed issue and valid issue branch |
| 3 | Triage path | core lead | investigate, lite, full or narrow |
| 4 | RFC/plan | artifact owner plus constructives | plan under `plan/` and required 2-of-3 decision |
| 5 | Independent premortems | both red teams | semantic and resilience risk reports |
| 6 | Readiness | core lead | `READY_FOR_IMPLEMENTATION` or another round |
| 7 | Implementation | artifact owner or owners | commits on the issue branch |
| 8 | Owner verification | each artifact owner | lane-specific evidence |
| 9 | Independent final gates | both red teams | two explicit adversarial verdicts |
| 10 | Finding resolution | artifact owner plus reviewer | fix, invalidation evidence, or risk decision |
| 11 | Branch currency | core lead plus affected owner | branch contains `origin/main` |
| 12 | PR landing | core lead | merged PR and updated `main` |
| 13 | Final build or deployment | relevant constructive owner | documented target or `N/A` |
| 14 | Completion report | core lead | issue, PR, SHA, evidence and known risk |

## Task title and branch naming

`task-intake` sets the provisional task title. Once Step 2 creates the issue, set the coordinator task title to `#<issue> - <short description>`. Preserve a user-set title if the CLI rejects the update. Follow-up issues may be recorded as ` - FUP: #<issue>, ...`.

Create the branch only after the issue exists and is open. The canonical format is:

`<type>/<issue-number>-<slug>`

Use a lowercase branch category such as `feature`, `fix`, `chore`, `docs`, `refactor`, `test`, `ci`, `build` or `perf`. The issue number is the real GitHub issue identifier; `###` in examples is a placeholder, not a three-digit or zero-padded requirement. The slug is lowercase kebab-case and describes the change.

Examples:

- `chore/123-adapt-implementation-workflow`
- `feature/124-export-change-contract`
- `fix/125-preserve-relation-identity`

## Steps

### 0 - Sync target repo

Run `git-landing-flow` from the appropriate `repo-*` directory and verify local `main` matches `origin/main` before investigation that will lead directly to implementation or before branch creation.

Visual Specs product code belongs in `repo-CodebaseConstellation`. Treat `repo-AgentsCommander` as the real extraction and verification corpus unless the issue explicitly requires changing that repository.

### 1 - Confirm change and ownership

Determine whether code or a versioned product artifact must change. If not, report the evidence and stop without an issue or branch. If a change is required, record the situation, why it matters, intended outcome, affected invariants, repo, artifacts and one owner per artifact.

### 2 - Create issue and branch

Create an English GitHub issue containing the Step 1 summary, acceptance criteria and verification expectations. Update the task title, then create the issue-numbered branch from synchronized `main` using the naming convention above.

### 3 - Pick the delivery path

Choose investigate, lite, full or narrow using the stated criteria. The user may request a stricter path. A path may be escalated when investigation reveals broader impact.

### 4 - RFC/plan (full only)

The artifact owner writes the plan under `plan/` in the working repository, for example `plan/123-export-change-contract.md`. The plan records scope, before state, requested change, expected after state, identity and compatibility effects, invariants, allowed files or systems, verification and rollback or migration consequences.

All three constructive agents validate the initial RFC from their interfaces. The owner decides inside its artifact. A transverse decision records the required 2-of-3 support and any dissent.

Durable architectural decisions must also be recorded using the repository's established ADR convention. Do not use a private agent plan as the only shared specification.

### 5 - Independent premortems (full only)

Send the same requirement and plan independently to both red teams. Independence means each reviewer actively searches for a counterexample and emits its initial findings before seeing or adopting the other reviewer's conclusion. They may inspect the same evidence, but one report must not substitute for the other.

- The semantic red team attacks identity, lifecycle, provenance meaning, schema compatibility, projections, aggregated connections, diff semantics and the coding-agent contract.
- The resilience red team attacks failure behavior, malformed or large inputs, performance, recovery, operational boundaries, observable interaction and cognitive usability.

A blocking objection contains a minimal reproducible case, the violated approved invariant or criterion, evidence, impact and severity. P0/P1 blocks readiness. Preferences without evidence do not.

### 6 - Readiness (full only)

The core lead verifies ownership, constructive support, both premortems and responses. Emit one explicit verdict:

- `READY_FOR_IMPLEMENTATION`
- `NEEDS_ANOTHER_ROUND`

The artifact owner responds to each valid finding with a plan change, evidence that the counterexample is invalid, or an explicit risk proposal. After at most three review-response rounds, the core lead arbitrates within approved invariants or elevates an undecidable product risk to the user. A reproducible P0/P1 is not dismissed merely because the round limit was reached.

### 7 - Implementation

Each constructive owner implements its artifacts on the issue branch. The core lead implements core contracts and domain work when those artifacts are in scope. Preserve the agreed boundaries; scope expansion returns to planning and ownership assignment.

### 8 - Owner verification

Produce evidence appropriate to each lane:

- Core: schema validation, migrations, stable identity, domain invariants, projections, serialization, semantic diff and before/change/expected-after contract tests.
- Extraction: fixtures, provenance and evidence preservation, deterministic or explained output, and re-extraction of the AgentsCommander corpus when applicable.
- Graph/runtime: projection and aggregated-connection correctness, layout and renderer boundaries, interaction tests, visible-state evidence and accessibility or cognitive checks when applicable.
- Cross-cutting vertical slices: export the versioned change contract, consume it, re-extract, compare expected with observed and expose discrepancies.

### 9 - Independent final adversarial gates

Both red teams independently try to falsify the executable increment. This is an evidence-producing review, not sabotage: each team searches for the smallest input, state or interaction that contradicts an approved expectation in its own lane.

Each report ends with `PASS`, `PASS_WITH_NON_BLOCKING_FINDINGS` or `FAIL_P0_P1`, followed by reproducible evidence. Both required reports must exist before landing code. An adversarial reviewer never implements the correction it evaluates.

### 10 - Resolve findings

Route each finding to the constructive owner. Loop owner response back to the finding's reviewer for verification. Cap the review-response cycle at three rounds, then apply the same arbitration and escalation rule as Step 6. Non-blocking findings remain recorded and prioritized.

### 11 - Ensure the branch contains current main

Use `git-landing-flow` to fetch and verify `origin/main` is an ancestor of the issue branch. If stale, the affected constructive owner integrates current main and resolves conflicts. Re-run affected owner tests and focused checks from both red teams on the resolution before landing.

### 12 - Land through a PR

After both final gates pass, required CI succeeds and Step 11 passes, land through the repository's PR path without a routine user approval gate. Never direct-push `main` unless the user literally requests and authorizes that exceptional action.

Ensure the PR closes the issue and contains the owners, constructive decision evidence, both adversarial verdicts, verification results and any accepted non-blocking findings. Finish the post-merge cleanup and verify local `main == origin/main`.

### 13 - Final build or deployment

Run only a build, package or deployment target documented for the repository and change. The constructive owner of the affected runtime performs it; graph/runtime normally owns visual application packaging. If no deployment target exists or the change is non-deployable, record `N/A` rather than inventing a target.

### 14 - Completion report

Verify the issue has a final delivery comment. Report the issue and PR links, final main SHA, owners, summary, tests, both red-team verdicts, build/deployment result or `N/A`, discrepancies and remaining non-blocking risk. Notify the Root Agent only if it expressly contacted this coordinator about the task.

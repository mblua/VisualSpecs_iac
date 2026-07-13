# CodebaseConstellation `main` enforcement — verified facts

Context: wg-4, issue #1 `ci: enforce PR-only main and issue-numbered branches`.
Owner: `vs-spec-core-lead`. My role: extraction/evidence constructive reviewer.
Status as of 2026-07-13: RFC drafted, my `SUPPORT` given, F1-F4 all accepted by owner.
**Awaiting a separate final-gate request after implementation.** Not idle by mistake — owner explicitly holds the next move.

## Verified on the wire (GET only) — trust these

| Fact | Value |
|---|---|
| AC ruleset | id `15279066`, "main: require PR + branch-name check", active, `~DEFAULT_BRANCH` |
| AC bypass actor | `RepositoryRole` id `5` (admin), `bypass_mode: always` ← AC's escape hatch |
| GitHub Actions app | `integration_id` / `app.id` = **15368**, slug `github-actions` (global id, same in both repos) |
| CC pre-enforcement `main` | `b5b272597760c5db2a3bf502f13517e6c5e75eb5` — chosen as the cutoff |
| CC delivery branch head | `5f7543f04f1a83a0347b443285e4198a522a2ffd` |
| CC published check-run | name `validate-branch-name`, conclusion `success`, app 15368 |
| CC Actions | `{"enabled":true,"allowed_actions":"all"}` |
| CC before-state | 0 rulesets (`[]`), no branch protection (404), no `.github/`, 0 open issues, only `main` |

CC ruleset design: `deletion`, `non_fast_forward`, `pull_request` (**0 approvals**), strict `required_status_checks` = `validate-branch-name` only. **No bypass actors** — deliberate, deviates from AC.

## The load-bearing insight (don't lose this)

**Removing the bypass actor changes the risk profile, not just the strictness.** AC tolerates several rough edges *because* its owner can bypass:

1. **Cutoff bootstrap.** AC's cutoff (`aa102adce…`) is *its own enforcement merge commit* — physically unwritable in that same merge, so AC needed a follow-up **direct push to `main`**, only possible via bypass. CC cannot do this. Hence CC's cutoff = *pre-enforcement* `main` (`b5b2725`), committed in-PR. Correct because CC had zero branches to grandfather.
2. **Fork PRs (F1).** Workflow is `on: push` only ⇒ fork head branches push in the *fork*, so the required context never appears on the base PR ⇒ permanently unmergeable. AC forces these through with bypass. **CC has no such escape.** Accepted as documented-unsupported for slice 1; do NOT silently add a `pull_request` trigger later without also handling `github.head_ref` (on `pull_request`, `ref_name` is the merge ref, not the branch).

## What is proven vs what is NOT (rule 2: absence stays absence)

- **PROVEN:** check publishes, goes green, context string matches the required context exactly, app id matches.
- **NOT PROVEN — inert (F2):** the *grandfather* path. Both green runs hit the **null** branch of `readCutoffSha()` (cutoff file not yet on `origin/main`), never the ancestor branch. Fails closed either way. CC has nothing to grandfather, so it is inert by construction. **Never report it as verified.**
- **NOT PROVEN (F4):** termination on failure-after-successful-fetch. CC swapped AC's `die()`/`process.exit(1)` for `fail()`/throw + `process.exitCode = 1` — a *correct and deliberate* fix for the Windows libuv assert after an undici `fetch`, but exit is now deferred to event-loop drain. Assert exit 1 **and prompt termination**, not just rejection.

## Traps I hit — read before touching this repo again

- **`rtk find` shim rejects compound predicates** (`-not`, `-exec`) and my `2>/dev/null` ate the error ⇒ silent empty output read as "file absent". I nearly reported "CC has no package.json / no CI" — **false absence**. Use `git ls-files` for tracked-file inventory. Never trust a bare `find -not` here.
- **Replica clones are shallow (depth 1).** `git rev-parse --is-shallow-repository` → `true`. AC's cutoff SHA reads as `fatal: bad object` locally — a clone artifact, **not** a repo defect. Resolve historical SHAs via `gh api`, not the local clone. (This is also why the workflow's `fetch-depth: 0` is load-bearing.)
- `/commits/<sha>/status` returns `state=pending, contexts=0` — that's the **legacy commit-status** endpoint. Rulesets match **check runs** by name + integration_id. Not a defect; don't "fix" it.

## Validator semantics (identical in both repos)

`PATTERN = /^(bug|chore|ci|docs|feat|feature|fix|refactor|style|test)\/([1-9][0-9]*)-([a-z0-9]+(?:-[a-z0-9]+)*)$/`, slug ≤ 50, issue must be **OPEN** and not a PR.
Exempt: `main`, `release/`, `hotfix/`, `dependabot/`, `revert/`, `gh-readonly-queue/`.
`isGrandfathered` = cutoff **not** an ancestor of branch ⇒ skip. Unresolvable cutoff ⇒ `null` ⇒ **not** grandfathered ⇒ enforce (fail-closed).
`TARGET_REPO` is a **hardcoded constant** — the single most dangerous thing to copy between repos. Cross-repo copy validates branch issue numbers against the *wrong* tracker and passes silently.

---
name: git-landing-flow
description: Git, issue-branch, PR and version mechanics for Visual Specs repositories. Sync main, enforce issue-numbered branch names, keep the feature branch current, land through verified PR checks and clean local state.
when_to_use: Load before branching, refreshing a branch, creating or merging a PR, or making a version decision in a repo.
---

# git-landing-flow

Run these operations only inside an allowed `repo-*` repository. This skill owns repository-state and delivery mechanics; implementation and review ownership come from `implementation-workflow`.

## Branch naming convention

Create a delivery branch only after `implementation-workflow` confirms a change and an open GitHub issue exists.

Canonical format:

`<type>/<issue-number>-<slug>`

- `type`: lowercase branch category such as `feature`, `fix`, `chore`, `docs`, `refactor`, `test`, `ci`, `build` or `perf`.
- `issue-number`: the actual GitHub issue identifier. `###` is only a placeholder and does not require exactly three digits or zero padding.
- `slug`: short lowercase kebab-case description using letters, digits and hyphens.

Examples:

- `chore/123-adapt-implementation-workflow`
- `feature/124-export-change-contract`
- `fix/125-preserve-relation-identity`

If repository automation defines a stricter compatible rule, satisfy it. Do not bypass a failing branch-name check; rename or recreate the feature branch safely and update the remote/PR as appropriate.

## Allowed and forbidden operations

Allowed by this documented flow:

- inspect with `git status`, `git log`, `git diff`, `git branch` and `git merge-base`;
- fetch and fast-forward local `main`;
- create, rename and delete local feature branches;
- push feature branches to `origin`;
- merge `origin/main` into a stale feature branch as described below;
- create and merge a PR after all required gates pass;
- perform post-merge cleanup.

Forbidden unless the user explicitly requests the exceptional action:

- `git reset` or any command that discards uncommitted or committed user work;
- `git rebase` or other history rewriting;
- direct `git push origin main`;
- locally merging a feature branch into `main`;
- bypassing failed CI, branch-name validation or a reproducible P0/P1 gate.

The PR is the audit trail. `main` is never mutated directly by the delivery branch.

## Sync local main before branching

1. Verify the worktree does not contain unrelated user changes that the operation could affect.
2. `git fetch origin`
3. `git checkout main`
4. `git pull --ff-only origin main`
5. Verify `git rev-parse main` equals `git rev-parse origin/main`.

If fast-forward is refused or unrelated changes prevent a safe checkout, stop and report. Never force, reset or discard work. Branch only after main matches origin and the issue is open.

Create the branch with the canonical name, for example:

`git checkout -b chore/123-adapt-implementation-workflow`

## Keep a feature branch current

Before landing:

1. `git fetch origin`
2. Run `git merge-base --is-ancestor origin/main HEAD` from the issue branch.
3. If current, continue.
4. If stale, the affected constructive owner merges `origin/main` into the feature branch with a normal merge commit. Do not rebase by default.
5. The owner resolves conflicts only in its owned artifacts and reruns affected tests.
6. Both red teams perform focused checks of the resolution in their respective lanes.
7. Push the updated feature branch and re-run required CI.

If conflict resolution crosses ownership boundaries, assign each artifact explicitly before editing it.

## Land to main through a PR

Landing starts only after:

- both required final adversarial reports pass or contain only accepted non-blocking findings;
- required owner verification and CI pass;
- the feature branch contains current `origin/main`;
- no unresolved scope, product-risk or external-permission blocker remains.

Then:

1. Push the feature branch.
2. Create a PR whose title follows the repository's Conventional Commit style and references the issue.
3. Include `Closes #<issue>` in the PR body.
4. Summarize artifact owners, constructive decision evidence, both red-team verdicts, tests, expected/observed comparison when applicable, and build/deployment status or `N/A`.
5. Wait for required PR CI. Fix or route failures; never bypass them.
6. Merge using the repository's normal merge method and delete the remote branch.
7. Use an administrative bypass only when repository policy genuinely requires it, all checks and team gates have passed, and the bypass is authorized. Never use admin merge to evade a failing check or missing gate.

A normal CLI merge is typically:

`gh pr merge --merge --delete-branch`

Use squash or rebase only when repository policy or the user explicitly selects it.

Never use `git checkout main`, merge the feature branch locally and push `main`.

## Post-merge cleanup

After the PR merge succeeds, leave the repository on synchronized `main`:

1. Record the merged branch name and PR URL.
2. `git fetch origin --prune`
3. `git checkout main`
4. `git pull --ff-only origin main`
5. Delete the local feature branch with `git branch -d <branch>` if it still exists and Git confirms it is merged.
6. Verify `git status -sb` shows `main` tracking `origin/main`.
7. Verify `git rev-parse main` equals `git rev-parse origin/main`.

If the remote branch unexpectedly remains or cleanup is unsafe, report it rather than forcing deletion.

## Version policy

An ordinary PR landing does not imply a version bump. Change a version only when the issue, release workflow or repository policy explicitly requires it. The owner of the affected versioned artifact performs the change and its compatibility checks; the core lead verifies schema or contract version changes in its lane.

Do not rely on product-specific version memory or a release procedure from another repository. If the target repository lacks a documented release policy, surface that gap before attempting a release.

---
name: task-intake
description: How a coordinator scopes a new request before delegating. Clarifying-question discipline (ask only what lives in the user's head, verify facts yourself) and the default investigate/look-at behavior (investigate, propose, report, wait).
when_to_use: Load at the start of every new user request, before delegating, and whenever the user says "look at", "see", "investigate", "check", "fijate", or "mira".
---

# task-intake

## First action: provisional Task Title

On the first user message of every new task, before questions, investigation, repo commands, or delegation, set a short provisional Task Title derived from that message. Use `& $env:AGENTSCOMMANDER_BINARY_PATH task-set-title --token $env:AGENTSCOMMANDER_TOKEN --root $env:AGENTSCOMMANDER_ROOT --title "<topic>"`. Never carry a prior coordinator-set title; refine it when scope becomes clear. If the CLI reports `Rejected: title set by user`, preserve the current `USER:` title and continue.

## Clarifying questions

Ask the user only about what lives in their head: preferences, intentions, motivations, genuinely ambiguous scope. For any fact you can verify yourself (file exists, what a binary does, env vars, directory contents, what a function implements, what command AC launched), verify it, never ask. Before asking, check: could I verify this with my tools? If yes, do that.

Consider before starting: scope (which agents/files/subsystems are in or out), granularity (one-shot vs recurring), execution model (sync/async/background/scheduled), failure behavior (abort/retry/fallback/warn), triggers and constraints (gates, timeouts, preconditions), and any number the user cites (floor, ceiling, fixed, or placeholder). Catch these at intake, not in later rounds with workgroup members.

## Investigate / look-at default

For "look at", "see", "investigate", "check", "fijate", "mira", or similar: investigate fully, find the root cause, propose a solution the user can evaluate, report findings plus proposal, then WAIT for the user. Never ask "diagnosis only or full fix?": diagnosis plus proposal is the default.

For "implement X" / "add feature Y" requests, switch to `implementation-workflow` — the source of truth for confirming the change and delivering it to `main`.

When the verb is ambiguous (e.g. "fix", "arreglá", "cambiá", "resolvé", "mejorá"), default to the investigate-and-propose side above unless the user clearly asked to build.

## Before first delegation

Classify the request as a new task or a same-task continuation, then apply the context lifecycle in `agent-coordination` before delegating.

---
name: agent-coordination
description: How a coordinator delegates work, manages peer context, and verifies activation beyond the messaging mechanics in AGENTS.md.
when_to_use: Load before delegating to or messaging any workgroup peer.
---

# agent-coordination

## Delegation

Use the current session `AGENTS.md > Inter-Agent Messaging` section as the authoritative source for peer discovery, `--to` values, file-based sending, and CLI syntax. If `list-peers-lean` returns no peers, stop and report it. Include the full repo path when the task touches a repo. State the objective, scope, constraints, and expected reply or artifact, or say explicitly that no reply is needed.

## Context lifecycle

- New task: before the first delegation, run `purge-wg` to reset eligible workgroup peer sessions. Use `--dry-run` to preview the gate table. If a peer emitted output within the quiet period, `purge-wg` exits 3 and resets nobody; stop and close the prior work instead of forcing it. Avoid `--graceful`, which stalls inter-agent messaging daemon-wide.
- Same task: do not run `purge-wg`. Preserve peer context through acknowledgment, report, revision, and review. Reset only a stale or bloated idle peer: try `send --command clear`; if unsupported, use `close-session`, then let the next `send --mode wake` cold-spawn it.

## Activation verification

After sending work, wait 45 seconds and run `list-peers-lean`; `working: true` confirms activation, not completion. If inactive, check for a reply or blocker; if neither exists and the peer is idle and reachable, follow the current Coordinator Context retry and rerouting rules. Once active, do not poll. When waiting, tell the user which peer and expected reply are pending.

---
name: agentscommander-coordinator-messaging
description: Coordinate AgentsCommander file-based messaging and delegation to team peers, including a mandatory clean-context boundary before every new assignment and context preservation for same-task follow-ups. Use whenever a coordinator assigns, delegates, reviews, follows up with, or sends work to a team member.
---

# AgentsCommander coordinator messaging

Use `AGENTSCOMMANDER_BINARY_PATH`; never guess a binary path or peer name. Treat file-based messages as the canonical task record and remote slash commands as housekeeping only.

## Classify the message

- **New task:** a new objective, deliverable, independent review, or work item after the previous assignment closed. Clear first.
- **Same-task follow-up:** a clarification, evidence request, status request, correction, or next instruction while the assignment remains in flight. Do not clear.
- **Busy peer:** never clear a peer with work in flight. Wait for its explicit completion or blocker report.

An explicit completion or blocker report closes the assignment boundary. Any later implementation, independent review, or deliverable is a new task even when it concerns the same artifact.

## Assign a new task

Follow this order exactly.

1. Discover peers immediately before acting:

   ```text
   "<AGENTSCOMMANDER_BINARY_PATH>" list-peers-lean --token <AGENTSCOMMANDER_TOKEN> --root "<AGENTSCOMMANDER_ROOT>"
   ```

2. Use only an exact `name` returned by discovery. Require `reachable: true`. If `working: true` or known work remains in flight, do not clear or assign unrelated work.
3. Clear the idle peer and require exit 0:

   ```text
   "<AGENTSCOMMANDER_BINARY_PATH>" send --token <AGENTSCOMMANDER_TOKEN> --root "<AGENTSCOMMANDER_ROOT>" --to "<peer_name>" --command clear --mode wake --confirm-timeout 90
   ```

   A confirmation timeout does not prove loss. Inspect delivery and peer state instead of retrying blindly.
4. Run `list-peers-lean` again. Confirm the same peer remains reachable and is not working.
5. Write a new Markdown file under the workgroup `messaging/` directory. Use UTC and:

   ```text
   YYYYMMDD-HHMMSS-wg<N>-<sender>-to-wg<N>-<peer>-<slug>.md
   ```

   Keep the slug kebab-case and at most 50 characters. State the objective, scope, constraints, expected artifact, verification, and requirement for an explicit completion or blocker report. Never modify or delete the message afterward.
6. Send the filename only:

   ```text
   "<AGENTSCOMMANDER_BINARY_PATH>" send --token <AGENTSCOMMANDER_TOKEN> --root "<AGENTSCOMMANDER_ROOT>" --to "<peer_name>" --send <filename> --mode wake --confirm-timeout 90
   ```

7. Re-check the peer and verify activation. Do not infer completion from files, logs, or status flags; wait for the explicit report.

## Follow up on the same task

Do not clear. Rediscover the exact peer, write a new canonical message file, and send it with `--send <filename> --mode wake`. Preserve context while the assignment remains in flight.

## Handle failures

- Do not use `--get-output` with `wake`; wait for reply-file notifications.
- Do not guess, silently reassign, or resend blindly after routing or confirmation failure. Re-check peer state and the sender outbox.
- Stop and report a concrete blocker if the peer is busy, unreachable, cannot accept `/clear`, or delivery cannot be proven.
- This workflow applies to team/workgroup coordinators. The Root Agent cannot use remote `--command clear` and must not apply it as written.

---
name: set-task-title-first
description: Set the AgentsCommander workgroup task title before starting or resuming a user task. Use when a coordinator begins a new request, the request changes scope, or a handoff resumes work and the current title is missing or stale.
---

# Set Task Title First

Before any substantive read, edit, build, delegation, or external action, set a title that states the current task outcome.

## Workflow

1. Derive one single-line title from the user's current request. State the outcome, not a private implementation step. Use the user's language when practical; omit secrets, paths, and speculation.
2. Run:

   ```powershell
   & $env:AGENTSCOMMANDER_BINARY_PATH task-set-title `
     --token $env:AGENTSCOMMANDER_TOKEN `
     --root $env:AGENTSCOMMANDER_ROOT `
     --title "<single-line task title>"
   ```

3. One line only. No newline, NUL, or other control characters. Never start it with the reserved `USER:` prefix. Do not put the title in the task body; `task-set-title` is the canonical operation.
4. Confirm the command succeeds before making changes. On failure, inspect `task-set-title --help`, retry once with the same intended title, and report the failure before continuing with mutating work.
5. If the user replaces or materially changes the task, set a new title before acting on the new scope.

## Title quality

Prefer `Verificar y documentar el contrato de autenticación` over `Trabajar en auth`. The title must name the artifact, decision, diagnosis, or delivery being pursued, so a coordinator scanning the workgroup sees what is in flight. Update it when the outcome changes, not for every sub-step.

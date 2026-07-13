---
name: launch-visualspecs
description: Start, verify, and open the local VisualSpecs application from the CodebaseConstellation CodebaseGuide checkout. Use when asked to launch, run, start, reopen, or check VisualSpecs/CodebaseGuide at localhost:5175, including when dependencies may be missing or a prior local instance may already exist.
---

# Launch VisualSpecs

Run the bundled PowerShell launcher. Treat `CodebaseGuide` as VisualSpecs; do not substitute the separate `web` application on port 5173.

```powershell
& "$PSScriptRoot\scripts\launch-visualspecs.ps1"
```

The launcher must:

1. Verify the expected `codebaseguide` package at the configured app path.
2. Reuse port 5175 only when HTTP returns the exact `CodebaseGuide — AgentsCommander` page, serves `/src/main.ts`, and the listener command line belongs to that checkout.
3. Fail without killing anything when another or unhealthy service owns the port.
4. Serialize launcher runs, install locked dependencies with `npm ci` only when Vite is missing, and keep cache/log/state under the repository's ignored `.local` directory.
5. Start Vite hidden, wait for HTTP 200, and open the verified URL in the default browser.

Use `-NoOpen` for verification without opening a tab. Override `-AppPath`, `-Url`, or `-TimeoutSeconds` only when the user supplies a different checkout, URL, or timeout.

Report the URL, whether the server was reused, HTTP and entry-module status, page title, listener PID, and log paths. Never stop an unrelated listener.

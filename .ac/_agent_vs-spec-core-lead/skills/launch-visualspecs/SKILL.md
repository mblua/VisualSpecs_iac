---
name: launch-visualspecs
description: Start, verify, and open the local Visual Specs application from whatever CodebaseConstellation checkout the caller is working in. Use when asked to launch, run, start, reopen, or check Visual Specs, including when dependencies may be missing, another workgroup already holds the port, or a prior local instance may already exist.
---

# Launch Visual Specs

Run the bundled PowerShell launcher. It takes no path: it finds the checkout itself.

```powershell
& "$PSScriptRoot\scripts\launch-visualspecs.ps1"
```

The app is `VisualSpecs/` (package `visual-specs`, title `Visual Specs — …`) inside a
`CodebaseConstellation` checkout. Do not substitute the separate `web` application.

## Discovery, not hardcoding

The launcher walks up from the caller's working directory (falling back to
`AGENTSCOMMANDER_ROOT`) and takes the **nearest** ancestor that either is a checkout
(`<ancestor>/VisualSpecs`) or holds one (`<ancestor>/*/VisualSpecs`, `repo-*` first), keeping
only directories whose `package.json` is named `visual-specs`. Nearest-ancestor-first is what
makes a workgroup replica resolve to its own `repo-*` and never a sibling workgroup's. No
workgroup number, repo path, or user path appears anywhere in the skill. It also works from a
plain clone outside AgentsCommander.

If discovery is ambiguous or empty, the launcher fails and asks for `-AppPath`. Pass `-AppPath`
only when the user names a different checkout.

## Guarantees

1. Port comes from the checkout's own `vite.config.ts` (`5175` if unreadable), and the launcher
   only ever reuses a listener whose **serving root is that same checkout**, proven through
   Vite's fs allow-list error, not guessed from the page.
2. Another workgroup's dev server on the preferred port is expected, not fatal: the launcher
   leaves it running, warns which PID and root hold it, and takes the next free port
   (`-PortSearchLimit`, default 10). `-StrictPort` turns that into a hard failure instead.
3. The server is spawned **detached from the caller**: a hidden `.cmd` runner started through
   `Win32_Process.Create`, so it is parented to the WMI provider host, sits outside the caller's
   process tree and outside any job object the caller lives in, and survives the agent session
   that launched it. `Start-Process` would instead hand it the caller's inheritable handles,
   which both ties it to that PID and hangs anyone who pipes the launcher's output.
4. It never stops a process it did not start. On a failed start it kills only its own tree.
5. Vite is bound to `127.0.0.1` explicitly, because the default binds `::1` only and every
   `localhost` probe then fails against a server that is actually up.
6. `npm ci` runs only when Vite is missing; cache, logs, and state stay under the checkout's
   ignored `.local/`.
7. Health means HTTP 200 `text/html`, a title starting with `Visual Specs`, and `/src/main.ts`
   served as JavaScript. The title is decoded as UTF-8 on purpose: Vite sends no charset and
   Windows PowerShell would otherwise mangle the em dash and never match.

Use `-NoOpen` to verify without opening a tab. `-Port`, `-BindAddress`, and `-TimeoutSeconds`
override the defaults.

## Report back

URL and port (and, when it is not the preferred port, who holds that port), the resolved app
path, whether the server was reused, HTTP and entry-module status, page title, serving root,
listener PID, and log paths.

---
name: decision-prototype
description: Before asking the user to choose between two or more options that differ in anything visual, spatial, or UI/layout-related, first build a quick self-contained HTML artifact that shows the CURRENT state and each option side by side (with a selector to switch), to scale and with honest metrics, so the user decides with the picture in front of them. When to use — any decision question about how something would look, be sized, placed, arranged, or laid out; especially for Visual Specs UI/canvas/layout tradeoffs. Load right before an AskUserQuestion whose options a person could see.
---

# decision-prototype

A decision question about anything a person can *see* is answered better with a picture than with prose. Before asking the user to pick between options that differ visually (layout, sizing, placement, arrangement, before/after states), build a small self-contained HTML artifact that renders the current state and each option, and let them look before they choose.

This is the default for Visual Specs decisions (it is a visual tool), and for any request where the user's likely reaction is "I can't tell from the description — show me."

## When to use / when to skip

- **Use** when the options differ in something spatial or visual: box sizes, control placement, layout density, before/after of a canvas edit, a chart shape, a UI affordance. Also use whenever the user says "I don't understand", "show me", "how would it look", or asks for a mockup/prototype.
- **Skip** for purely non-visual choices (a library name, a retry count, a yes/no with no visible consequence) — a plain AskUserQuestion is better there. Do not manufacture a visual where none exists.

## The recipe

1. **Pin the decision and its 2–4 options.** These are the same options you would put in the AskUserQuestion. Name what each one resigns, not only what it gains.
2. **Model each state faithfully — never decoratively.** Use the *real* constants, geometry, or data from the codebase (read them; do not invent). If you are prototyping a Visual Specs container, use the real `CONTAINER_HEADER`, `CONTAINER_PADDING`, `CHILD_GAP`, leaf sizes, and the real dark canvas colors. A prototype that lies about proportions is worse than no prototype.
3. **Compose current-vs-option.** Left panel = the current/before state, fixed as a reference. Right panel = the selected option, driven by a `<select>` dropdown (or radio/tabs) with 2–4 choices. Both panels share ONE scale so the size comparison is honest.
4. **Make the delta visceral.** Color or outline what changed: wasted space in red, added in green, removed as a ghost. Show one honest metric per state (dimensions, wasted %, count) with `tabular-nums`. The number should make the tradeoff obvious at a glance.
5. **Caption the cost.** Under the selected option, one short line on what it costs (new state, extra round, irreversibility) — the same tradeoff the user is actually deciding.
6. **Publish and hand off.** Write the file to the scratchpad, publish with the `Artifact` tool (load `artifact-design` first, proportionate treatment — this is a utilitarian decision aid, not a landing page), give the user the URL, then ask the decision (or let them pick inside the prototype and report back).

## Build constraints (Artifact CSP)

- Fully self-contained: all CSS/JS inline, no external fonts/scripts/images; embed any asset as a data URI.
- Reproduce the real product's look when prototyping its UI (the Visual Specs canvas is a dark, always-dark surface with purple-bordered boxes — keep that faithful; make the surrounding page chrome theme-aware).
- Compute geometry in JS from named constants at the top of the script, so the model is easy to verify and tweak.
- Responsive and keyboard-usable; respect `prefers-reduced-motion`.

## Keep it proportionate

"Rapidito" is the target: a clear, faithful, single-purpose comparator — not a designed microsite. Spend the effort on geometric honesty and a legible metric, not on flourish. If the user later wants the real thing, that is the implementation, not this.

## Reference implementation

`plan/13-*` in `repo-VisualSpecs` and the fit-to-content comparator built for Issue #13 are the worked example: left = the wasteful current container to scale (87% wasted), right = a dropdown between two fit options (48% vs 0% wasted), same scale, waste shaded red, cost captioned per option. Reuse that structure.

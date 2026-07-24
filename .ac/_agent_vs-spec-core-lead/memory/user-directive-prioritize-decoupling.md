---
name: user-directive-prioritize-decoupling
description: Standing user directive (2026-07-15) — always prioritize decoupling in design and implementation decisions.
type: feedback
---

Al confirmar la feature de watch/auto-reload del extractor, el usuario dio una directiva permanente: **"Siempre priorizá el desacoplamiento."**

**Why:** La arquitectura de Visual Specs (contract/domain/projection/ports/app/ui/adapters/extractor) existe para eso; el usuario la quiere defendida activamente en cada decisión nueva, no solo mantenida.

**How to apply:**
- Toda capability nueva entra detrás de un port; los detalles (FSA, fs, timers, git) quedan confinados en adapters/ o tools/.
- Preferir módulos separables que puedan aterrizar y revertirse de forma independiente (ej.: watch loop orquesta la extracción existente como función; no mezclar watching dentro del core de extracción).
- En RFCs y gates, tratar un acople evitable como finding, no como preferencia.

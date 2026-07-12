---
name: ping-timer-10min
description: Siempre poner un timer de 10 min para re-pinguear a los agentes con trabajo despachado y ver en qué andan.
metadata:
  type: feedback
---

Siempre que despache trabajo a un agente, poner un timer de **10 minutos** para volver a pinguear y ver en qué anda. No esperar pasivamente a que respondan.

**Why:** Los agentes se caen en silencio. Caso real (2026-07-11): a architect-3 se le acabaron los créditos del modelo, el usuario lo cambió a otro modelo, y la sesión nueva perdió el wake del task. Quedó `working: false` / `waitingForInput: true` sin avisar a nadie. Sin heartbeat, el panel se colgaba indefinidamente esperando una crítica que nunca iba a llegar.

**How to apply:**
- Mientras haya trabajo en vuelo, chequear cada 10 min con `list-peers-lean`.
- Señal de agente caído: `working: false` + `waitingForInput: true` en un agente al que le despaché algo.
- Remedio: re-disparar el `send` con el MISMO filename (los archivos de mensaje no se modifican ni se borran).
- Hasta 3 intentos de contacto por agente silencioso antes de escalar al usuario.

Ver [[artifact-panel-refinement]] — el timer es parte del proceso de panel.

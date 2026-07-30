---
name: codex-review
description: Lässt Codex (OpenAI) den aktuellen Feature-Branch gegen main reviewen. Pflicht nach jeder Worker-Implementierung, bevor gegenüber dem User fertig gemeldet wird.
---

# Codex-Review

1. Bevorzugt das Codex-MCP-Tool aufrufen (MCP-Server `codex`) mit dem
   Auftrag: Review aller Änderungen des aktuellen Branches gegenüber `main`
   gemäß AGENTS.md ("Rolle: Reviewer"), Verdict auf Deutsch im dort
   definierten Format, keine Dateien ändern.
2. Fallback, falls der MCP-Server nicht verfügbar ist:

   ```bash
   bash scripts/codex-review.sh main
   ```

3. Bei **⚠️-Verdict**: Die Befunde (Blocker und "Sollte gefixt werden") als
   neue, präzise Aufgabe an den Worker geben (Skill `worker`), danach erneut
   reviewen. Wiederholen, bis Codex ✅ gibt.
4. Das finale Codex-Verdict wörtlich in den Abschlussbericht an den User
   übernehmen — es ist seine einzige inhaltliche Kontrolle, nicht kürzen.

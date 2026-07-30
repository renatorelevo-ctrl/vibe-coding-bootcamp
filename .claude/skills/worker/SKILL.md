---
name: worker
description: Delegiert eine abgegrenzte Implementierungsaufgabe an den günstigen Worker (DeepSeek/GLM) via scripts/worker.sh. Nutzen für Feature-Implementierung aus dem Plan — nicht für Mini-Fixes, die macht die Hauptsession direkt.
---

# Worker-Delegation

1. Sicherstellen, dass du auf einem Feature-Branch bist (nie `main` — das
   Skript verweigert das sonst).
2. Die Aufgabe präzise und in sich abgeschlossen formulieren — der Worker
   kennt den Chat-Verlauf NICHT. Immer angeben: Ziel, betroffene
   Dateien/Bereiche, Akzeptanzkriterien. Auf `PLAN.md` verweisen, falls
   vorhanden.
3. Aufgabe in `.worker-task.md` schreiben (liegt in .gitignore) und starten:

   ```bash
   bash scripts/worker.sh --file .worker-task.md
   ```

4. Die Zusammenfassung des Workers lesen und mit `git log --oneline -3` und
   `git diff --stat main...HEAD` prüfen, ob wirklich committet wurde.
5. Danach IMMER das Codex-Review anstoßen (Skill `codex-review`). Erst nach
   Codex ✅ und grünem Build gegenüber dem User fertig melden.

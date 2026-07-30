# CLAUDE.md — Dev-Team-Workflow (Multi-Model)

## Projekt

Next.js 14 App (Vibe Coding Bootcamp). Wichtige Befehle:

- `npm run dev` — Dev-Server auf localhost:3000
- `npm run build` — Production-Build (Pflicht-Gate vor jedem "fertig")

## Deine Rolle: Planner & Orchestrator

Du planst und koordinierst. Die eigentliche Implementierung übernimmt ein
günstiger Worker (Standard: Codex mit GPT-5.6 Luna, alternativ
DeepSeek/GLM), das Code-Review übernimmt Codex mit einem anderen Modell.
Der User liest keinen Code und keine Diffs — die Qualitätssicherung läuft
vollständig über Codex-Review, Build und die laufende App.

## Modell-Disziplin (Pro-Plan!)

- Opus nur für die Planungsdiskussion. Danach auf Sonnet wechseln und den
  User daran erinnern (`/model`).
- Keine Implementierungs-Subagents auf der Claude-Seite starten (auch nicht
  über Superpowers) — Implementierung geht IMMER an den Worker. Subagent-
  Fan-out verbraucht das Abo-Kontingent um ein Vielfaches.

## Der Loop

1. **Planen**: Feature mit dem User besprechen. Plan als `PLAN.md` auf einem
   Feature-Branch committen (Ziel, Schritte, Akzeptanzkriterien).
2. **Delegieren**: Implementierungs-Tasks einzeln an den Worker geben —
   Skill `worker` (nutzt `scripts/worker.sh`). Der Worker committet auf dem
   Feature-Branch.
3. **Review**: Nach jeder Worker-Implementierung Codex-Review — Skill
   `codex-review` (MCP-Server `codex` oder `scripts/codex-review.sh`).
4. **Nachbessern**: ⚠️-Befunde von Codex als neue Aufgabe zurück an den
   Worker. Schritte 2–4 wiederholen, bis Codex ✅ gibt und
   `npm run build` grün ist.
5. **Berichten**: Abschlussbericht an den User auf Deutsch, nicht-technisch:
   Was wurde gebaut, was hat Codex bemängelt, was wurde gefixt, wie kann er
   es ausprobieren (Dev-Server bzw. Vercel-Preview). Codex-Verdict wörtlich
   zitieren.

## Wann NICHT delegieren

Mini-Änderungen (ein Tippfehler, ein Farbwert, eine Textzeile) machst du
direkt selbst — der Delegations-Umweg lohnt sich erst ab abgegrenzten
Tasks mit mehreren Dateien oder neuer Funktionalität.

## Git-Regeln

- Nie direkt auf `main` arbeiten oder committen. `main` bleibt immer
  deploybar (Vercel Production).
- Pro Feature ein Branch; der Worker arbeitet auf dem aktuellen
  Feature-Branch (das Skript verweigert `main`).
- Wenn etwas schiefgeht: Branch verwerfen statt lange debuggen.

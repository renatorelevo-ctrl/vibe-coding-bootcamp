# Multi-Model Dev-Team — Setup

Dein KI-Dev-Team in Claude Code, auf Budget:

```
Du  ──►  Claude (Opus/Sonnet)  ──►  Worker (DeepSeek/GLM)  ──►  Codex (OpenAI)
         plant & orchestriert       implementiert headless      reviewt & gibt Verdict
         (Claude-Pro-Abo)           (API, Cent-Beträge)         (ChatGPT-Plus-Abo)
                 ▲                                                      │
                 └────────── Befunde zurück, bis Verdict ✅ ────────────┘
```

Du liest keine Diffs: Codex prüft den Code und liefert sein Urteil auf
Deutsch, dein Check ist die laufende App (localhost bzw. Vercel-Preview).

## Einmaliges Setup (lokal, ca. 15 Minuten)

### 1. Worker-Backend (DeepSeek empfohlen für den Start)

1. Account auf [platform.deepseek.com](https://platform.deepseek.com),
   kleines Guthaben aufladen (5 € reichen lange), API-Key erstellen.
2. Im Repo:

   ```bash
   cp .env.devteam.example .env.devteam
   ```

3. In `.env.devteam` den Key eintragen. Die Datei bleibt lokal
   (steht in `.gitignore`).

Alternativ GLM: Key von [z.ai](https://z.ai) (GLM Coding Plan) eintragen
und `WORKER_PROVIDER="glm"` setzen.

### 2. Codex als Checker

```bash
npm install -g @openai/codex
codex login        # öffnet den Browser — mit deinem ChatGPT-Plus-Account anmelden
```

Beim nächsten Start von Claude Code im Repo wirst du gefragt, ob der
MCP-Server `codex` (aus `.mcp.json`) erlaubt werden soll → bestätigen.
Falls `codex mcp-server` bei deiner Version nicht existiert, in
`.mcp.json` die args auf `["mcp"]` ändern (ältere Codex-Versionen).

### 3. Probelauf

```bash
git checkout -b feature/testlauf
bash scripts/worker.sh "Ändere im Footer das Emoji. Danach npm run build prüfen und committen."
bash scripts/codex-review.sh
git checkout main && git branch -D feature/testlauf   # Testlauf wegwerfen
```

Wenn beides durchläuft, steht das Team.

## Arbeiten im Alltag

Einfach wie gewohnt mit Claude Code reden. Die Regeln stehen in `CLAUDE.md`
(liest Claude automatisch) und `AGENTS.md` (liest Codex automatisch):

- **Planung**: per `/model` auf Opus schalten, Feature besprechen — Claude
  schreibt `PLAN.md` auf einen Feature-Branch. Danach zurück auf Sonnet.
- **Implementierung**: Claude delegiert an den Worker (Skill `worker`).
  Dein Claude-Kontingent wird dabei nicht verbraucht.
- **Review**: Claude holt automatisch das Codex-Verdict ein (Skill
  `codex-review`) und lässt Befunde fixen, bis ✅.
- **Dein Part**: Abschlussbericht lesen, App durchklicken, mergen.

## Limits im Blick behalten

- `/usage` in Claude Code: Session- und Wochenlimit, plus was am meisten
  verbraucht (Subagents, lange Kontexte …).
- `npx ccusage` (lokal): Verbrauch pro Tag / 5h-Fenster / Modell aus deinen
  lokalen Session-Daten — gut als Vorher/Nachher-Vergleich.
- Faustregeln: Opus nur zum Planen, parallele Sessions teilen sich EIN
  Kontingent, und Implementierung gehört zum Worker — nicht in
  Claude-Subagents.

## Wenn etwas klemmt

| Problem | Lösung |
|---|---|
| `DEEPSEEK_API_KEY fehlt` | `.env.devteam` anlegen/befüllen (Schritt 1) |
| Worker bricht ab: "nicht auf main" | Erst `git checkout -b feature/...` — Absicht, schützt main |
| `codex: command not found` | Schritt 2: installieren + `codex login` |
| Codex meldet Auth-Fehler | `codex login` erneut ausführen (Login läuft gelegentlich ab) |
| Worker-Ergebnis unbrauchbar | Branch löschen, Aufgabe präziser formulieren, neu delegieren |

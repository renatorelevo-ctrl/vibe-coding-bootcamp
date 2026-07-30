# Multi-Model Dev-Team — Setup

Dein KI-Dev-Team in Claude Code, auf Budget (€40/Monat, keine API-Konten nötig):

```
Du  ──►  Claude (Opus/Sonnet)  ──►  Worker (Codex: GPT-5.6 Luna)  ──►  Checker (Codex: Standardmodell)
         plant & orchestriert       implementiert headless             reviewt & gibt Verdict
         (Claude-Pro-Abo)           (ChatGPT-Plus-Abo)                 (ChatGPT-Plus-Abo)
                 ▲                                                              │
                 └────────────── Befunde zurück, bis Verdict ✅ ────────────────┘
```

Du liest keine Diffs: Der Checker prüft den Code und liefert sein Urteil auf
Deutsch, dein Check ist die laufende App (localhost bzw. Vercel-Preview).
Worker und Checker laufen absichtlich auf **verschiedenen Modellen**, damit
nicht dasselbe Modell seine eigene Arbeit abnickt.

## Einmaliges Setup (lokal, ca. 10 Minuten)

### 1. Codex installieren (Worker + Checker in einem)

```bash
npm install -g @openai/codex
codex login        # öffnet den Browser — mit deinem ChatGPT-Plus-Account anmelden
```

Das war's schon — der Standard-Worker (GPT-5.6 Luna) braucht keinen API-Key.
Luna erfordert Codex CLI ≥ 0.144.0 (`codex --version` prüfen, ggf.
`npm update -g @openai/codex`).

Beim nächsten Start von Claude Code im Repo wirst du gefragt, ob der
MCP-Server `codex` (aus `.mcp.json`) erlaubt werden soll → bestätigen.
Falls `codex mcp-server` bei deiner Version nicht existiert, in
`.mcp.json` die args auf `["mcp"]` ändern (ältere Codex-Versionen).

### 2. Optional: DeepSeek als Fallback-Worker

Für den Fall, dass das OpenAI-Wochenlimit mal erreicht ist (Worker und
Checker teilen sich das Plus-Kontingent):

1. Account auf [platform.deepseek.com](https://platform.deepseek.com),
   kleines Guthaben aufladen (5 € reichen lange), API-Key erstellen.
2. `cp .env.devteam.example .env.devteam`, Key eintragen und bei Bedarf
   `WORKER_PROVIDER="deepseek"` setzen. Die Datei bleibt lokal
   (steht in `.gitignore`).

DeepSeek ist Pay-as-you-go ohne Zeitfenster — dem wird nie der Saft
abgedreht. Alternativ GLM: Key von [z.ai](https://z.ai) und
`WORKER_PROVIDER="glm"`.

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
- `/status` in Codex bzw. das Codex-Usage-Dashboard: dein OpenAI-Kontingent.
  Worker und Checker ziehen aus demselben Plus-Budget — Luna ist dabei
  sparsam, aber bei sehr viel Delegation zuerst hier nachschauen.
- `npx ccusage` (lokal): Claude-Verbrauch pro Tag / 5h-Fenster / Modell —
  gut als Vorher/Nachher-Vergleich.
- Faustregeln: Opus nur zum Planen, parallele Claude-Sessions teilen sich
  EIN Kontingent, Implementierung gehört zum Worker — nicht in
  Claude-Subagents.

## Wenn etwas klemmt

| Problem | Lösung |
|---|---|
| `codex: command not found` | Schritt 1: installieren + `codex login` |
| Codex meldet Auth-Fehler | `codex login` erneut ausführen (Login läuft gelegentlich ab) |
| Luna unbekannt / `-m` schlägt fehl | `npm update -g @openai/codex`; Notlösung: `CODEX_WORKER_MODEL=""` in `.env.devteam` |
| OpenAI-Wochenlimit erreicht | `WORKER_PROVIDER="deepseek"` in `.env.devteam` (Schritt 2) |
| `DEEPSEEK_API_KEY fehlt` | `.env.devteam` anlegen/befüllen (Schritt 2) |
| Worker bricht ab: "nicht auf main" | Erst `git checkout -b feature/...` — Absicht, schützt main |
| Worker-Ergebnis unbrauchbar | Branch löschen, Aufgabe präziser formulieren, neu delegieren |

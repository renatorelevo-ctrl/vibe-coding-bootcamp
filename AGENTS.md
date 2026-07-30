# AGENTS.md

## Projekt

Next.js 14 App (Vibe Coding Bootcamp), TypeScript, Tailwind. Deployment via
Vercel (Production = `main`, Previews = Pull Requests).

Befehle:

- `npm install` — Abhängigkeiten
- `npm run build` — Production-Build; muss fehlerfrei durchlaufen
- `npm run dev` — Dev-Server auf localhost:3000

## Deine Rolle steht im Prompt

Dieses Repo arbeitet mit einem Multi-Model-Team: Claude plant, ein Worker
implementiert, ein Reviewer prüft. Du kannst in beiden Rollen aufgerufen
werden — welche gilt, sagt dir der jeweilige Auftrag.

## Rolle: Worker

Wenn dein Auftrag eine Implementierungsaufgabe ist: Setze genau diese
Aufgabe um, halte dich an eine vorhandene `PLAN.md`, keine ungefragten
Umbauten an fremdem Code. Vor dem Fertigmelden `npm run build` fehlerfrei
durchlaufen lassen und auf dem aktuellen Branch committen (nie auf `main`).

## Rolle: Reviewer

Wenn dein Auftrag ein Code-Review ist, bist du der unabhängige Checker.
Der Projektinhaber liest keinen Code — dein Review ist die einzige
inhaltliche Kontrolle. Sei gründlich und streng, auch (gerade!) wenn die
Änderungen von einem anderen OpenAI-Modell stammen: prüfe sie, als kämen
sie von einem Fremden.

Prüfe die Änderungen des aktuellen Branches gegenüber `main`
(`git diff main...HEAD`) auf:

1. **Plan-Konformität**: Falls `PLAN.md` existiert — wurde umgesetzt, was
   dort steht? Fehlt etwas? Wurde ungefragt Zusätzliches geändert?
2. **Korrektheit**: Offensichtliche Bugs, kaputte Logik, Dinge die zur
   Laufzeit crashen würden. Führe `npm run build` aus.
3. **Sicherheit**: Eingeschleuste Secrets/Keys im Code, unsichere Muster,
   verdächtige neue Abhängigkeiten.
4. **Kollateralschäden**: Wurden bestehende Features beschädigt oder
   Dateien angefasst, die mit der Aufgabe nichts zu tun haben?

## Verdict-Format (Pflicht)

Antworte auf **Deutsch**, für einen Nicht-Programmierer verständlich,
exakt in dieser Struktur:

```
## Codex-Review

**Verdict: ✅ Passt** (oder: **Verdict: ⚠️ Probleme gefunden**)

**Was gebaut wurde:** 1–2 Sätze in einfacher Sprache.

**Befunde:**
- (bei ✅: "Keine.")
- (bei ⚠️: pro Befund eine Zeile: was ist das Problem, wie schlimm ist es
  [Blocker / Sollte gefixt werden / Kleinigkeit], in welcher Datei)

**Build:** npm run build erfolgreich / fehlgeschlagen (mit Kurzgrund)
```

Regeln:

- ⚠️ vergeben, sobald mindestens ein Blocker oder "Sollte gefixt werden"
  dabei ist. Reine Kleinigkeiten allein rechtfertigen noch ein ✅ — dann
  aber mit aufführen.
- Keine Code-Snippets im Verdict, keine Fachbegriffe ohne Erklärung.
- Nichts selbst fixen und keine Dateien ändern — du bist nur der Prüfer.

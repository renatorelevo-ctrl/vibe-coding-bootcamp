# Übergabe: Spec-Paket "GEO-Radar" → eigenständiges Produkt-Repo

**An die übernehmende Claude-Session:** Dieses Dokument ist deine Arbeitsanweisung.

## Quelle

- Repo: `renatorelevo-ctrl/vibe-coding-bootcamp`
- Branch: `claude/orchestrator-subagent-pattern-ofied5`
- Ordner: `hotel-geo/` — 8 Dateien:
  `README.md` (Produkt-Übersicht + **Entscheidungs-Log mit 36 Einträgen** — die verbindliche
  Wahrheit über alle Produktentscheidungen), `01-prd.md`, `02-architecture.md`,
  `03-security-privacy.md`, `04-prompt-spec.md`, `05-implementation-plan.md`,
  `06-visibility-playbook.md`, `07-ota-score-module.md`, plus diese `HANDOVER.md`.

## Was zu tun ist

1. Quell-Repo/Branch zur Session hinzufügen bzw. klonen und die 8 Dateien übernehmen.
2. Im neuen Repo so strukturieren:
   - `README.md` (aus hotel-geo/README.md) ins Repo-Root — Produkt-Übersicht + Entscheidungs-Log
   - übrige Specs nach `docs/` (Dateinamen beibehalten, interne Links prüfen/anpassen)
   - `HANDOVER.md` nicht übernehmen (hat seinen Zweck dann erfüllt)
3. Eine `CLAUDE.md` im Root anlegen mit:
   - Projekt-Einzeiler (siehe unten) und Verweis auf `docs/` + Entscheidungs-Log
   - den **Arbeitsregeln für Executor-Modelle** aus `docs/05-implementation-plan.md` (Abschnitt
     ganz oben) — sie gelten für jede Session in diesem Repo
   - Hinweis: Bei Widerspruch zwischen Spec und Wunsch → Entscheidungs-Log prüfen, dann fragen.
4. Committen und pushen. Danach ist das Repo bauklar; erster Bau-Task ist **P0.1**
   (Repo-Setup: Next.js App Router + TS, Tailwind, shadcn/ui, Vitest, Playwright, CI).

## Projekt-Kontext in 5 Zeilen

Self-Service-Plattform, auf der Hotels ihre Sichtbarkeit in AI-Antworten (ChatGPT, Gemini,
Perplexity, Claude) messen: Gratis-Teaser-Score (X,X/10, anonymer Vergleich mit genau 5
Wettbewerbern, Faktenfehler-Zähler) → Vollreport/Optimierungspaket einmalig → ein Abo
(12 Mon. Mindestlaufzeit, alles inklusive, ein Bericht/Monat) → persönliche Beratung.
Stack: Next.js auf Vercel fra1, Supabase Frankfurt (DB/Auth/Storage), Worker auf Hetzner-Box,
Stripe, Brevo. Alle Details und Begründungen: Entscheidungs-Log im README.

## Status & offene Punkte

- Spec-Paket vollständig, konsistenz-geprüft (User-Sicht, Betreiber-Sicht, Technik, Datenschutz).
- MVP = Phasen P0–P3 (05-implementation-plan.md); Produkt 2 (OTA-Score) = Phase P8 (07).
- **Naming offen:** "GEO-Radar" ist Arbeitstitel. Geprüfte Kandidaten: StayFound, Echora
  (Websuche sauber; Domain-/Markenprüfung durch Registrar + Anwalt steht aus).
- Vor Launch (Gates in 05): Rechtstexte anwaltlich prüfen (B2B-AGB, Booking-Abruf,
  Tracking-Snippet), CostGuard-Lasttest, 3 Pilot-Hotels, Reproduzierbarkeits-Check.
- Neu anzulegende Konten (Log 34): OpenAI-/Perplexity-/Anthropic-API, Stripe, Brevo,
  Turnstile, Domain.

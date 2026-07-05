# Umsetzungsplan — GEO-Radar

Geschrieben so, dass ein kleineres Executor-Modell (Sonnet/Haiku-Klasse) jeden Task **isoliert**
abarbeiten kann. Der Planende (Orchestrator) vergibt Tasks in Reihenfolge, prüft
Akzeptanzkriterien, reviewt Diffs.

## Arbeitsregeln für Executor-Modelle

1. Pro Task genau ein PR-großer Diff. Nichts außerhalb des Task-Scopes anfassen.
2. Vor dem Bauen die referenzierten Spec-Abschnitte lesen (01–04). Bei Widerspruch zwischen Spec
   und Code-Realität: stoppen und fragen, nicht raten.
3. Jeder Task endet mit: Typecheck grün, Lint grün, neue Logik hat Unit-Tests, Akzeptanzkriterien
   im PR-Text abgehakt.
4. Keine echten LLM-API-Calls in Tests — Fixtures/Mocks (`fixtures/llm/*.json`).
5. Modell-IDs, Preise, Gewichte, Budgets: **immer** über `settings`/`config`, nie hartcodiert.
6. Secrets nie committen; `.env.example` aktuell halten.

---

## Phase P0 — Fundament

| # | Task | Akzeptanzkriterien |
|---|---|---|
| P0.1 | Repo-Setup: Next.js (App Router, TS), Tailwind, shadcn/ui, ESLint/Prettier, Vitest, Playwright, CI (Typecheck/Lint/Test) | `pnpm build` + CI grün; Seiten-Skeleton `/` rendert |
| P0.2 | DB: Drizzle + Postgres (EU), Migrations-Setup, alle Tabellen aus 02 §4 als Schema | Migration läuft; Seed-Script legt Demo-Hotel an |
| P0.3 | Job-Queue: `jobs`-Tabelle, `JobRunner`-Interface, Worker-Loop via `/api/jobs/tick` (Cron), Locking, Retry mit Backoff, Dead-Letter-Status | Unit-Tests: Nebenläufigkeit (kein Doppel-Lock), Retry, Idempotenz |
| P0.4 | Adapter-Interfaces + Mocks: `LlmProvider` (query/extract/synthesize), `MailProvider`, `PaymentProvider`; Fixture-Lader | alle Services gegen Mocks kompilierbar |
| P0.5 | `settings`-Service (typed get/set, Cache) + `CostGuard` (Run-Budget, Tagesbudget, Verbuchung in `llm_calls`) | Tests: Budget-Stopp greift vor dem Call; Tagesbudget kumuliert |
| P0.6 | Admin-Auth: Magic-Link für `admin_users`, geschützter `/admin`-Bereich (leer) | E2E: Login-Flow mit Mock-Mail |

## Phase P1 — Audit-Engine

| # | Task | Spec | Akzeptanzkriterien |
|---|---|---|---|
| P1.1 | `CrawlService`: Website-Fetch (fetch + Playwright-Fallback), Seitenauswahl-Heuristik (Start/Zimmer/Preise/Kontakt, max N), Text-Extraktion, `truth_corpus`-Persistenz, robots.txt-Respekt, 30-Tage-Cache | 02 §5.1 | Tests mit HTML-Fixtures; robots-Verweigerung respektiert |
| P1.2 | Booking-Abruf (1 Profilseite, Cache) **+ manueller Fallback** (Admin-Paste-Feld → truth_corpus source=manual) | 03 §6 | Fallback funktioniert ohne Netz |
| P1.3 | `BatteryService`: Generierungs-Prompt (SYNTHESIZER), Matrix-Abdeckung, Validierung (Neutralität: Hotelname-Check!), Versionierung, Mini-Subset-Markierung | 04 §1 | Fixture-Test: 60 Prompts, alle Regeln erfüllt; Subset stabil |
| P1.4 | 4 `LlmProvider`-Implementierungen (OpenAI/Gemini/Perplexity/Anthropic) mit Websuche, Timeout, Kosten-Berechnung aus Usage | 02 §2 | Contract-Tests gegen Fixtures; Kosten-Verbuchung korrekt |
| P1.5 | EXECUTE-Step: Fan-out prompts×provider×language, Parallelitäts-Limit, Teilausfall-Toleranz, `degraded`-Logik | 04 §2 | Test: 20 % Fehler → Run läuft durch, markiert |
| P1.6 | EXTRACT-Step: Extraktions-Prompt, Zod-Schema, Alias-/Fuzzy-Normalisierung im Code, `injection_suspected`-Pfad | 04 §3, 03 §5 | Golden-Tests: 10 Fixture-Antworten → erwartete Mentions/Claims |
| P1.7 | FACTCHECK-Step: Retrieval (Keyword/Abschnitt), Verdikt-Prompt, Preis-Toleranz, Claim-Dedupe | 04 §4 | Golden-Tests inkl. ±15 %-Preisregel |
| P1.8 | `ScoringService`: Formeln 04 §5 deterministisch + `methodology_version` | 04 §5 | Property-Tests (Grenzen 0/100, Gewichts-Summen) |
| P1.9 | COMPETITORS-Step: Kandidaten-Aggregation, Kurations-Prompt, `competitor_links`; Wettbewerber-Scores aus vorhandenen Antworten (keine Extra-Abfragen!) | 04 §6 | Fixture-Flow: auto-Auswahl 3–5, Override bindend, Override → nur Neuberechnung |
| P1.10 | `AuditOrchestrator`: Job-Kette PREPARE→…→NOTIFY, Resume nach Crash, Statusmodell | 02 §5 | Integrationstest (alles gemockt): mini-Run end-to-end < deterministisch grün |
| P1.11 | Technik-Check (H1): robots.txt-AI-Bots, llms.txt, Schema.org-Präsenz, SSR-Lesbarkeit, Latenz → `tech_checks`; deterministisch, keine LLM-Calls | 06 H1 | Fixture-Tests pro Check; Ergebnis im Vollreport-DTO |

## Phase P2 — Funnel & Teaser (erster sichtbarer Wert)

| # | Task | Spec | Akzeptanzkriterien |
|---|---|---|---|
| P2.1 | Landingpage: Nutzenversprechen, Eintrags-Flow (Hotelname→Disambiguierung→E-Mail), Turnstile | 01 §3 | E2E: Eintrag bis "Mail verschickt" |
| P2.2 | Lead-API: Dedupe (Hotel 90-Tage-Regel), Rate-Limits (IP/E-Mail-Domain), Wegwerf-Domain-Liste | 03 §3 | Tests: alle Limits greifen serverseitig |
| P2.3 | Double-Opt-in: Brevo-Adapter, Verify-Flow, erst danach Mini-Audit-Enqueue; Auto-Löschung unverifizierter Leads (30 T) | 03 §2 | E2E mit Mock-Mail; Cron-Löschung getestet |
| P2.4 | Teaser-Report: reduziertes DTO (serverseitige Garantie!), Teaser-Seite (Score, anonym-Balken, Fehler-Zähler), signierte Access-Tokens mit Ablauf | 01 §3.1, 03 §4 | Test: DTO enthält nie Namen/Claim-Texte (Schema-Assertion); E2E Teaser-Ansicht |
| P2.5 | Ergebnis-Mail + Preistabelle/Kaufstufen auf Teaser-Seite (CTAs, noch ohne Checkout) | 01 §3 | Mail-Fixture-Snapshot |
| P2.6 | Rechtsseiten: Impressum, Datenschutz, AGB + Widerruf (Platzhalter-Texte, Struktur final) | 03 §2 | Seiten verlinkt im Footer |

## Phase P3 — Payment & Vollreport (erster Umsatz) → **Ende MVP**

| # | Task | Spec | Akzeptanzkriterien |
|---|---|---|---|
| P3.1 | Stripe Checkout (tier report/optimizer), Webhook (signiert, idempotent), `orders`, Widerrufs-Verzicht-Checkbox | 02 §6, 03 §6 | Stripe-Test-Mode E2E |
| P3.2 | Kauf → Voll-Audit-Job (alle 4 Provider, alle Sprachen, voller Fakten-Check, Wettbewerber-Läufe) | 02 §5 | Integrationstest mit Mocks |
| P3.3 | Vollreport Web: Scores pro Plattform/Sprache, Wettbewerber mit Namen, Faktenfehler im Wortlaut + Quelle, Methodik-Seite | 01 §5 | Report aus Fixture-Run pixel-geprüft (Snapshot) |
| P3.4 | PDF-Export (Playwright-Print des Web-Reports, DE/EN-Templates) | 02 §2 | PDF-Artefakt in CI erzeugt |
| P3.5 | Report-Prosa via SYNTHESIZER (Executive Summary, Empfehlungen) mit Zahlen-Interpolation aus Code | 04 §10 | Golden-Test: keine erfundenen Zahlen (Regex-Assertion gegen Input-Zahlenmenge) |
| P3.6 | Admin v1: Leads/Hotels/Runs/Orders-Listen, Wettbewerber-Override-UI, Run-Detail mit Kosten & Logs, Re-Run-Button, Kosten-Dashboard | 02 §7 | E2E: Override → Folgelauf nutzt manuelle Liste |
| P3.7 | Beratungs-Stufe: "Umsetzung mit Experten"-Sektion + Kontakt-/Terminlink auf Teaser & Report | 01 §3 | vorhanden, DSGVO-konformes Formular |
| P3.8 | Ansprechpartner + AGB: `contacts`-Erfassung im Checkout (Name, Position, E-Mail, Telefon als Pflicht), AGB-Checkbox mit versionierter Protokollierung (`terms_acceptances`) | 01 §3.1 | Test: Kauf ohne Kontakt/AGB unmöglich; Nachweis abfragbar |
| P3.9 | Manuelle Hotel-Anlage (Stufe 0b): Admin-Formular Hotel+Ansprechpartner, Audit-Start per Klick, Ergebnis-Mail optional, `intake=manual` | 01 §3 | E2E: manuell angelegtes Hotel durchläuft identische Pipeline |
| P3.10 | Admin-Dashboard (Startseite): KPI-Kacheln, Aktivitäts-Feed, Handlungsliste; Admin-Benachrichtigungs-Mails (Kauf, Abo, Synthese wartet) | 02 §7 | Dashboard aus Seed-Daten; Mail-Trigger getestet |
| P3.11 | Erklär-Inhalte: `content/explainers/` (Metriken, Hebel H1–H6, Befund-Typen; DE/EN, short/long/faq), Wissensbasis-Seite im Admin, Info-Icons in Report + Admin, Drill-Down Score→Prompts→Original-Antwort | 02 §7c, 01 §5 | Jede Report-Metrik hat Erklärtext; Drill-Down E2E |

## Phase P4 — Optimierungspaket (Stufe 3)

| # | Task | Spec |
|---|---|---|
| P4.0 | Synthese-Warteschlange & Operator-Modus: `synthesis_tasks`, Export-Bundle-Generierung (JSON+Markdown), Admin-Ansicht "Wartende Synthesen", validierter Ergebnis-Import, Modus-Schalter pro Schritt in settings; Claude-Code-Skill (`skills/optimizer-bundle/`) mit Anleitung | 02 §2 |
| P4.1 | `OptimizerService`: Rewrite-Prompt mit GEO-Prinzipien, Faktentreue-Regel (Platzhalter statt Erfindung); läuft in `api`- UND `operator`-Modus (gleiche Prompts im Skill) | 04 §7 |
| P4.2 | Diff-Ansicht Vorher/Nachher + Freigabe-Status pro Item | 01 §4 M3 |
| P4.3 | FAQ-Generator + Schema.org-JSON-LD (deterministisch befüllt, validiert) | 04 §7.2 |
| P4.4 | Maßnahmen-Playbook über alle 6 Hebel (H1–H6): Priorisierung, Plattform-Wirkung, Umsetzer-Zuordnung; speist sich aus tech_checks, Fakten-Check, F-A/F-B (sofern vorhanden) | 06 |
| P4.5 | Artefakt-Downloads (Texte, JSON-LD) + Optimizer-PDF; Upgrade-Pfad 2→3 (Differenzpreis in Stripe) | 01 §3 |

## Phase P5 — Abo, Monitoring, Tracking (Stufe 4)

| # | Task | Spec |
|---|---|---|
| P5.1 | Stripe Billing (Abo), Subscription-Sync via Webhooks, Kündigungs-Flow | 02 §6 |
| P5.2 | Monats-Cron: `monthly`-Runs (stabile Batterie-Version), Trend-Berechnung, Monats-Report (Web+PDF+Mail) | 04 §1.4, 01 §5 |
| P5.3 | Alert-Engine: Diff-Regeln (neuer Fehler, Score-Einbruch), wöchentlicher Light-Check, Alert-Mails | 04 §8 |
| P5.4 | Tracking-Snippet (<2 KB, cookielos) + `/api/track` (Aggregat-Zähler, transientes Rate-Limit) + Einbau-Doku mit Datenschutz-Textbaustein | 03 §7 |
| P5.5 | AI-Traffic-Dashboard im Abo-Report (Referrer-Klassen, Verlauf) + Grenzen-Hinweis | 01 F-H |
| P5.6 | Kundenportal (F-I): `portal_users` + Magic-Link, Dashboard (Score-Verlauf, Fehler-Bilanz, AI-Traffic, Maßnahmen-Checkliste, Report-Archiv), Mandanten-Scope-Helper, Zugang an Abo-Status gekoppelt | 02 §7b |

## Phase P6 — Analyse-Suite

| # | Task | Spec |
|---|---|---|
| P6.1 | Quellen-Analyse: cited_sources-Aggregation, Domain-Ranking, Quellen-Maßnahmen im Report | 04 §9 |
| P6.2 | Review-Wahrnehmung: Stärken/Schwächen-Extraktion, Selbstbild-Abgleich, Report-Sektion | 04 §9 |
| P6.3 | Antwortentwürfe auf kritische Reviews (optional, Feature-Flag) | 01 F-B |

## Phase P7 — Skalierung & Moat

| # | Task | Spec |
|---|---|---|
| P7.1 | Benchmark-Aggregation (k≥5, Segment-Fallback), Admin-Benchmark-Ansicht, Benchmark-Zeile im Report | 03 §8 |
| P7.2 | Portfolio-/Gruppen-Ansicht (mehrere Hotels pro Account) | 01 F-F |
| P7.3 | Content-Hub: Briefing→Entwurf→Freigabe-Workflow, Redaktionsplan | 01 F-C |
| P7.4 | Agentic-Booking-Readiness-Check (Schema-Abdeckung, robots/llms.txt, Buchungsstrecken-Crawl) + Score | 01 F-D |
| P7.5 | Funnel-Website EN; Self-Service-Vorbereitung (Hotel-Accounts) | 01 §6, §8 |

---

## MVP-Schnitt

**MVP = P0 + P1 + P2 + P3.** Damit existiert der komplette Kern-Loop:

> Hotel trägt sich ein → verifiziert E-Mail → Mini-Audit läuft → Teaser lockt → Kauf →
> Voll-Audit → Vollreport (Web+PDF) → Beratungs-CTA. Admin kann alles einsehen und eingreifen.

Bewusst NICHT im MVP: Optimierungspaket (P4 — kurz danach, zweite Umsatzstufe), Abo/Monitoring/
Tracking (P5), Analyse-Suite (P6), Moat-Features (P7). Die Preistabelle im MVP zeigt die
Stufen 3/4 bereits als "demnächst" mit Interessen-Button (validiert Nachfrage, kostet nichts).

**Launch-Gates vor MVP-Go-live:**
1. Rechtstexte anwaltlich geprüft (inkl. Booking-Abruf-Einschätzung, 03 §6).
2. CostGuard-Lasttest: 100 simulierte Gratis-Einträge → Tagesbudget stoppt korrekt.
3. Echtlauf mit 3 realen Pilot-Hotels (bekannte Häuser des Betreibers), Scores plausibilisiert.
4. Reproduzierbarkeits-Check: Demo-Hotel 3× auditiert, composite ±5 Punkte.

## Betriebskosten-Schätzung (Größenordnung, Stand Juli 2026 — CostGuard liefert Ist-Zahlen)

**Pro Einheit im Vollautomatik-Modus:**

| Einheit | API-Kosten |
|---|---|
| Mini-Audit (Gratis-Lead) | < 0,10 € |
| Voll-Audit/Vollreport (~320 Abfragen inkl. Websuche + Extraktion + Fakten-Check + Prosa) | 5–9 € |
| Optimierungspaket vollautomatisch | +1–3 € (im Operator-Modus: 0 €) |
| Abo pro Hotel/Monat (Monats-Re-Audit 4–7 € + wöchentl. Light-Checks 1,50–2 € + Prosa ~0,20 €) | **6–9 €/Monat** → >90 % Rohmarge bei 99–199 € Abo |

Größte Kostenhebel: Anzahl Sprachen (+~50 %/Sprache) und Websuche-/Grounding-Gebühren der
Plattformen. Wettbewerber-Scores kosten nichts extra (gleiche Antworten, 04 §1.4).

**Monatlich gesamt (früh):**

| Posten | Monat |
|---|---|
| Hosting/DB/Mail | 30–60 € |
| 200 Gratis-Leads × <0,10 € + 20 Voll-Audits × ~5–9 € | 120–200 € |
| 10 Abos × 6–9 € | 60–90 € |
| Optimizer im Operator-Modus | 0 € API |
| Stripe | % vom Umsatz |

## Reihenfolge-Empfehlung nach MVP

P4 (zweite Umsatzstufe, geringe Komplexität) → P5 (wiederkehrender Umsatz) → P6 → P7.
Benchmark-DB (P7.1) sammelt aber **ab MVP** still Daten (Aggregations-Job früh mitlaufen lassen),
damit der Moat wächst, während Features gebaut werden.

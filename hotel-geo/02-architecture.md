# Technische Architektur — GEO-Radar

## 1. Leitprinzipien

1. **EU-Datenhaltung** für alle persistenten Daten (→ 03-security-privacy.md).
2. **Orchestrator/Executor-Muster bei LLM-Nutzung:** billige Modelle für Massenarbeit
   (Prompt-Ausführung, Extraktion), starke Modelle nur für Synthese (Report-Texte, Rewrites,
   Batterie-Generierung). Modell-Zuordnung zentral konfigurierbar, nie im Code verstreut.
3. **Kosten sind ein First-Class-Konzern:** jeder LLM-Call wird mit Tokens/Kosten verbucht; jeder
   Audit hat ein hartes Budget; global gibt es ein Tagesbudget.
4. **Provider-Adapter statt Direktaufrufe:** alle externen Dienste (LLMs, Mail, Crawling, Payment)
   hinter Interfaces — austauschbar, testbar, mockbar.
5. **Alles asynchron, alles wiederaufnehmbar:** Audits sind Job-Ketten mit persistiertem Zustand;
   ein abgestürzter Lauf setzt fort statt neu zu starten.

## 2. Stack

| Schicht | Wahl | Begründung |
|---|---|---|
| Web-App | Next.js (App Router, TypeScript) | Funnel + Reports + Admin in einer App; Team-Know-how |
| UI | Tailwind + shadcn/ui | schnell, konsistent |
| DB | PostgreSQL, EU-Region (Neon oder Supabase, Frankfurt) | relationale Audit-Daten, JSONB für LLM-Antworten |
| ORM | Drizzle | typsicher, migrationsfreundlich, gut für kleinere Executor-Modelle |
| Jobs | DB-gestützte Queue (`jobs`-Tabelle) + Worker; Trigger via Vercel Cron/QStash. Interface `JobRunner`, sodass später Inngest/Worker auf Hetzner einsetzbar | kein Vendor-Lock, einfach zu testen |
| Hosting | Vercel (Region fra1) — Alternative: Hetzner + Coolify, falls Worker-Laufzeiten Serverless sprengen | EU, einfach |
| Payment | Stripe (Checkout + Billing für Abo) | Standard, Rechnungen, EU-Steuern via Stripe Tax |
| E-Mail | Brevo (EU-Anbieter) hinter `MailProvider`-Interface | DSGVO-freundlich, Double-Opt-in-Support |
| PDF | Playwright rendert die Web-Report-Seite als PDF (Chromium headless) | ein Template für Web+PDF |
| Crawling | eigener Fetcher (fetch + Playwright-Fallback für JS-Seiten), Cache in DB | Kontrolle über robots/Rate |
| Analytics-Snippet | eigenes Mini-JS (< 2 KB), Beacon-Endpoint in der App | cookielos, First-Party |

**LLM-Provider (hinter `LlmProvider`-Interface):**

| Plattform | API | Websuche |
|---|---|---|
| ChatGPT | OpenAI Responses API | `web_search`-Tool |
| Gemini | Google Gemini API | Grounding with Google Search |
| Perplexity | Perplexity API (sonar) | nativ |
| Claude | Anthropic API | Web-Search-Tool |

**Modell-Ebenen (zentral in `config/models.ts`):**

- `EXECUTOR` (billig, Masse): Audit-Prompt-Ausführung, Extraktion, Klassifikation.
  Beispiele: Haiku-Klasse, gpt-mini-Klasse, Gemini-Flash-Klasse.
- `SYNTHESIZER` (stark, selten): Batterie-Generierung, Report-Prosa, GEO-Rewrites,
  Wettbewerber-Kuration.
- Konkrete Modell-IDs sind Konfiguration, nicht Code — Modelle altern schneller als das Produkt.

**Synthese-Ausführungsmodi (settings, pro Schritt konfigurierbar):**

| Modus | Ablauf | Einsatz |
|---|---|---|
| `api` | vollautomatisch über LLM-API | Default für zeitkritische/unbeaufsichtigte Schritte: Batterie-Generierung, Teaser-/Vollreport-Prosa, Wettbewerber-Kuration |
| `operator` | Job erzeugt ein **Export-Bundle** (JSON + Markdown mit allen Audit-Daten und der Aufgabenbeschreibung) und landet in der Admin-"Synthese-Warteschlange". Der Betreiber arbeitet das Bundle interaktiv mit Claude Code (eigenes Abo, vorbereiteter Projekt-Skill) ab und lädt die Ergebnisse hoch (validierter Import). | Default für hochwertige, niedrigvolumige Deliverables: Optimierungspaket (Rewrites, FAQ, Playbook), optional Monats-Report-Prosa |

Begründung: Massenarbeit (EXECUTE/EXTRACT) **muss** API sein (parallel, unbeaufsichtigt, läuft
über Billigmodelle für Cents). Die teuren Synthesen fallen nur bei bezahlten Bestellungen an —
im `operator`-Modus kosten sie null API-Geld (Abo des Betreibers, interaktiv genutzt) und
bekommen automatisch eine menschliche Qualitätskontrolle vor Kundenauslieferung. Ein Chat-Abo
wird dabei **nie** als automatisiertes Server-Backend angebunden — der Operator-Modus ist
explizit human-in-the-loop. Umschalten auf `api` jederzeit möglich (Skalierungspfad).

## 3. Systemkomponenten

```
┌──────────────────────────── Next.js App ────────────────────────────┐
│  Funnel (public)   │  Report-Viewer (tokenized)  │  Admin (auth)    │
│  Landing, Eintrag, │  Teaser / Vollreport /      │  Hotels, Audits, │
│  E-Mail-Verify     │  Optimierung / Trends       │  Kosten, Preise  │
├──────────────────────────── API-Routen ─────────────────────────────┤
│  /api/leads  /api/audits  /api/checkout  /api/stripe-webhook        │
│  /api/track (Beacon)  /api/jobs/tick (Cron)                         │
├──────────────────────────── Services ───────────────────────────────┤
│  AuditOrchestrator   CompetitorService   FactCheckService           │
│  BatteryService      ScoringService      ReportService              │
│  OptimizerService    AlertService        BenchmarkService           │
│  CrawlService        TrackingService     CostGuard                  │
├──────────────────────────── Adapter ────────────────────────────────┤
│  LlmProvider×4   MailProvider   PaymentProvider   JobRunner         │
└──────────────────────────────┬───────────────────────────────────────┘
                               │
              PostgreSQL (EU) ─┴─ Stripe / Brevo / LLM-APIs
```

## 4. Datenmodell (Kerntabellen)

```
leads            id, email, status(pending|verified|customer), verify_token, created_at,
                 consent_at, utm_json
hotels           id, name, city, country, website_url, booking_url?, category(stars),
                 price_band(1-4), languages[], report_language, owner_lead_id?,
                 intake(self_service|manual), created_at
contacts         id, hotel_id, name, position, email, phone, is_primary, created_at
                 -- Pflicht-Ansprechpartner ab Kauf/Abo bzw. bei manueller Anlage
terms_acceptances id, subject(lead|portal_user), subject_id, terms_version, accepted_at
                 -- revisionssicherer AGB-Nachweis (Checkbox nie vorangekreuzt)
portal_users     id, hotel_id, contact_id, email, status, last_login_at
                 -- Magic-Link-Auth, nur für Abo-Kunden (F-I)
competitor_links hotel_id, competitor_hotel_id, source(auto|manual), rank, active
batteries        id, hotel_id, version, language, prompts_json[], created_by_model, created_at
audit_runs       id, hotel_id, type(mini|full|monthly|light_check), battery_id, status,
                 budget_cents, spent_cents, started_at, finished_at, error?
llm_calls        id, audit_run_id, provider, model, role(query|extract|synthesize),
                 prompt_ref, request_json, response_json, tokens_in, tokens_out, cost_cents,
                 latency_ms, created_at
mentions         id, audit_run_id, prompt_ref, provider, language, hotel_id (wer erwähnt wurde),
                 position, is_recommendation, cited_sources_json
claims           id, audit_run_id, provider, hotel_id, claim_text, category(price|amenity|
                 location|policy|other), verdict(correct|incorrect|unverifiable), evidence_ref
truth_corpus     id, hotel_id, source(website|booking|manual), url, content_text, fetched_at,
                 content_hash
scores           id, audit_run_id, hotel_id, provider?, language?, visibility_score,
                 share_of_voice, fact_accuracy, composite  (NULL provider = Gesamt)
orders           id, lead_id, hotel_id, tier(report|optimizer), stripe_session_id, amount_cents,
                 status, created_at
subscriptions    id, lead_id, hotel_id, stripe_sub_id, status, current_period_end
reports          id, hotel_id, audit_run_id, type(teaser|full|optimizer|monthly), language,
                 access_token, content_json, pdf_path?, published_at
optimizer_items  id, hotel_id, order_id, kind(rewrite|faq|schema_org|action), source_text,
                 result_text, status(draft|approved), language
alerts           id, hotel_id, kind(new_claim|score_drop), payload_json, sent_at
tracking_events  id, hotel_id, day, referrer_class(chatgpt|perplexity|gemini|claude|copilot|
                 other_ai), count            -- nur Tagesaggregate, keine Einzelbesucher
benchmarks       segment_key(category×region×price_band), month, n_hotels, median_score,
                 p25, p75   -- nur wenn n_hotels ≥ 5
tech_checks      id, hotel_id, audit_run_id, check_key(robots_ai_bots|llms_txt|schema_org|
                 ssr_readable|latency), status(pass|fail|warn), details_json, checked_at
synthesis_tasks  id, hotel_id, order_id?, kind(optimizer_bundle|monthly_prose|custom),
                 status(queued|exported|imported|approved), bundle_json, result_json,
                 exported_at, imported_at          -- Operator-Modus (§2)
jobs             id, kind, payload_json, status(queued|running|done|failed), attempts,
                 run_after, locked_by, locked_at, last_error
admin_users      id, email, role(owner|staff), auth via Magic-Link
settings         key, value_json  (Preise, Feature-Flags, Modell-IDs, Budgets)
content_items    id, hotel_id, kind(seasonal|guide|event), brief, draft, status   -- F-C
```

Wichtige Invarianten:

- `reports.type='teaser'` → `content_json` enthält **niemals** Wettbewerbernamen oder
  Claim-Texte; die Teaser-API serialisiert aus einem separaten, reduzierten DTO (serverseitige
  Garantie, kein Frontend-Blur).
- `batteries` sind unveränderlich; Änderungen = neue Version. `audit_runs` referenzieren exakt
  eine Version → Monats-Scores nur innerhalb gleicher Version vergleichbar (Report markiert
  Versionswechsel).
- `llm_calls` ist das vollständige Kosten- und Audit-Log; `spent_cents` auf `audit_runs` ist
  denormalisiertes Summenfeld, das der CostGuard bei jedem Call aktualisiert.

## 5. Audit-Pipeline (AuditOrchestrator)

Job-Kette pro Audit-Run; jeder Schritt idempotent, Zustand in DB:

```
1. PREPARE      Hotel validieren; truth_corpus crawlen/auffrischen (Website: Start- +
                Zimmer-/Preis-/Kontakt-Seiten, max N Seiten; Booking-Profil falls URL vorhanden)
                + TECHCHECK: robots.txt (AI-Bots), llms.txt, Schema.org, SSR-Lesbarkeit,
                Latenz — deterministisch, keine LLM-Kosten (→ 06-visibility-playbook.md H1)
2. BATTERY      Batterie laden (aktive Version) oder generieren (SYNTHESIZER, → 04)
                mini: Subset-Markierung der Batterie (stabiles Subset!)
3. EXECUTE      Fan-out: prompts × provider × language → LlmProvider.query()
                (Websuche an, Temperatur niedrig, Standort-Kontext neutral)
                Parallelität begrenzt (Rate-Limits), Retry mit Backoff, Teilausfall toleriert
4. EXTRACT      pro Antwort ein EXECUTOR-Call: Erwähnungen (wer, Position), Empfehlungs-
                charakter, Faktenaussagen über Zielhotel, zitierte Quellen → JSON (Schema-
                validiert, → 04 §4; Antwort-Text gilt als UNTRUSTED, → 03 §5)
5. COMPETITORS  (nur full/erster Lauf) Kandidaten aggregieren → SYNTHESIZER-Kuration
                (Kategorie/Preis/Region-Match) → competitor_links(source=auto)
                Vergleichs-Scores aus den VORHANDENEN Antworten berechnen (Discovery-Prompts
                sind hotelneutral → enthalten alle Segment-Hotels; keine Extra-Abfragen)
6. FACTCHECK    claims × truth_corpus → EXECUTOR-Verdikt (correct/incorrect/unverifiable)
                mini: nur Website-Korpus, nur Top-Claims
7. SCORE        deterministische Berechnung (kein LLM): visibility, share_of_voice,
                fact_accuracy, composite (→ 04 §5)
8. REPORT       content_json bauen; Prosa-Abschnitte via SYNTHESIZER; PDF-Render (full);
                Teaser-DTO ableiten (reduziert)
9. NOTIFY       Ergebnis-Mail (Teaser-Link bzw. Report-Link); bei monthly: AlertService-Diff
```

**CostGuard:** vor jedem LLM-Call `spent + estimate ≤ budget` prüfen; bei Überschreitung Run
pausieren (`status=budget_exceeded`), Admin-Alert. Globales Tagesbudget analog (settings).

**Laufzeitziele:** mini < 5 Min (Parallelität 8–16), full < 30 Min.

## 6. Funnel-Flows (technisch)

- **Eintrag:** POST /api/leads → Turnstile-Check, Rate-Limit (IP+E-Mail), Hotel-Dedupe
  (bestehendes Hotel? → bestehender Teaser, kein neuer Gratis-Lauf innerhalb 90 Tagen),
  Double-Opt-in-Mail. Verify-Link → Lead `verified` → Mini-Audit-Job enqueued.
- **Teaser-Zugriff:** signierter `access_token` im Mail-Link; kein Login nötig.
- **Kauf:** Stripe Checkout (tier aus settings-Preisen); Webhook `checkout.session.completed` →
  Order anlegen → Voll-Audit-Job (bzw. Optimizer-Jobs) enqueued → Mail bei Fertigstellung.
- **Abo:** Stripe Billing; Webhook-gesteuert `subscriptions` synchron halten; monatlicher Cron
  enqueued `monthly`-Runs für aktive Abos; Light-Check wöchentlich (reduzierte Batterie) für
  Alerts.
- **Tracking:** Snippet sendet `navigator.sendBeacon('/api/track', {h: hotelKey})` nur wenn
  `document.referrer` einer AI-Domain-Liste entspricht; Server inkrementiert Tagesaggregat.
  Keine Cookies, keine IP-Speicherung, kein Fingerprinting (→ 03 §7).

## 7. Admin-Backend

Magic-Link-Auth (nur `admin_users`).

**Startseite = Dashboard (der Betreiber ist visueller Typ — das ist die wichtigste Admin-Seite):**
KPI-Kacheln (neue Leads 7 Tage, Hotels gesamt, aktive Abos, MRR, offene Synthese-Aufgaben,
API-Kosten Monat) + Aktivitäts-Feed (letzte Käufe/Abos/Alerts) + Handlungsliste ("dein Teil":
wartende Synthese-Bundles, Review-fällige Reports).

Weitere Ansichten: Leads/Funnel-Status; Hotels-Liste (Ansprechpartner mit Kontaktdaten,
Abo-Status, letzter Score + Trend-Pfeil) mit Detailseite (Score-Verlaufsgrafik, Audits,
Bestellungen, Kontakthistorie-Notizen); **manuelle Hotel-Anlage** (Stufe 0b: Hotel +
Ansprechpartner + AGB-Vermerk erfassen, Audit starten, Ergebnis-Mail optional); Wettbewerber-
Override; Audit-Runs (Status, Kosten, Logs, Re-Run); Bestellungen/Abos (Stripe-Links);
Synthese-Warteschlange (Operator-Modus); Reports (Vorschau, Regenerieren); Kosten-Dashboard;
Settings; Benchmark-Ansicht.

**Admin-Benachrichtigungen (Mail mit Admin-Direktlink):** neuer Kauf, neues/gekündigtes Abo,
Synthese-Aufgabe wartet, Budget-/Anomalie-Alerts (03 §3). Konfigurierbar in settings.

## 7b. Kundenportal (F-I)

Eigener Bereich `/portal`, Magic-Link-Auth über `portal_users` (nur aktive Abos; Zugang erlischt
mit Abo-Ende, Report-Archiv-Links bleiben gültig). Dashboard: Score-Verlauf (Recharts, pro
Plattform filterbar), Faktenfehler behoben/neu, AI-Traffic (F-H), Wettbewerbs-Ranking anonym/
namentlich je nach gekaufter Stufe, Maßnahmen-Checkliste (Status abhakbar → fließt in
Monats-Report), Report-Archiv. Strikte Mandantentrennung: Queries immer über hotel_id des
eingeloggten portal_users (Drizzle-Helper erzwingt Scope).

## 7c. Erklär-Inhalte (Single Source of Truth)

Modul `content/explainers/` (Markdown/TS, DE+EN): pro Metrik, Hebel (H1–H6), Befund-Typ und
Check ein Eintrag mit `short` (Tooltip), `long` (Glossar/Wissensbasis) und `faq` (typische
Hotelier-Rückfragen + Antworten). Gerendert in Admin (Wissensbasis "Methodik & Hebel" +
Info-Icons), Portal (Tooltips/Glossar) und Reports (Methodik-Seite) — **eine Quelle, überall
identisch**. Drill-Down im Admin: Score → beteiligte Prompts → Original-Antwort (`llm_calls`).

## 8. Konfiguration & Secrets

`.env`: DB-URL, Stripe-Keys + Webhook-Secret, Brevo-Key, 4× LLM-Keys, Turnstile-Keys,
`APP_SECRET` (Token-Signierung). Laufzeit-Settings (Preise, Modelle, Budgets, Prompt-Vorlagen-
Versionen) in `settings`-Tabelle, im Admin editierbar — kein Deploy für Preisänderung.

## 9. Teststrategie

- Adapter gemockt: Golden-File-Tests für Extraktion/Scoring (eingefrorene LLM-Antworten in
  `fixtures/`), deterministische Score-Tests.
- E2E (Playwright): Funnel Eintrag→Verify→Teaser mit gemocktem Audit; Checkout mit Stripe-Test.
- Ein `SEED_DEMO_HOTEL` (fiktives Hotel + fixierte Antworten) für Entwicklung ohne API-Kosten.
- CI: Typecheck, Lint, Unit, E2E-smoke; Migrations-Check.

## 10. Skalierungspfad (bewusst später)

Self-Service-Accounts für Hotels/Agenturen (Auth existiert schon fürs Admin), Worker-Auslagerung
auf Hetzner bei Laufzeit-/Kostendruck, Report-Caching/CDN, Mehrsprachigkeit der Funnel-Site,
White-Label (Betreiber-Branding pro Mandant — Datenmodell hält `settings` bereits generisch).

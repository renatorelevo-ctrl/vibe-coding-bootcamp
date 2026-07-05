# GEO-Radar — AI-Sichtbarkeits-Plattform für Hotels

> **Arbeitstitel.** Finales Naming/Branding offen. Dieses Verzeichnis enthält das vollständige
> Spezifikations-Paket, erstellt als "großer Plan" mit einem starken Planungsmodell, damit die
> Umsetzung anschließend von kleineren Modellen (Sonnet/Haiku-Klasse) task-weise gebaut werden kann.

## Produkt in einem Satz

Eine Self-Service-Website, auf der Hotels ihren Namen eintragen und erfahren, wie sichtbar sie in
AI-Antworten (ChatGPT, Gemini, Perplexity, Claude) sind — mit kostenlosem Teaser-Score als
Lead-Magnet und gestaffelter Paywall für Vollreport, Optimierungspaket, Monitoring-Abo und
persönliche Beratung.

## Dokumente

| Datei | Inhalt |
|---|---|
| [01-prd.md](01-prd.md) | Produktanforderungen: Vision, Funnel, Module/Features A–H, Deliverables, Erfolgskriterien |
| [02-architecture.md](02-architecture.md) | Technische Architektur: Stack, Datenmodell, LLM-Orchestrierung, Jobs, Kostenkontrolle |
| [03-security-privacy.md](03-security-privacy.md) | DSGVO, EU-Hosting, Prompt-Injection-Abwehr, Missbrauchsschutz, Rechtliches |
| [04-prompt-spec.md](04-prompt-spec.md) | Prompt-Batterie, Auswertungs-Prompts, Scoring-Methodik, Rewriter-Prompts |
| [05-implementation-plan.md](05-implementation-plan.md) | Phasenplan P0–P7, Tasks für Executor-Modelle, **MVP-Schnitt** |
| [06-visibility-playbook.md](06-visibility-playbook.md) | Die 6 Sichtbarkeits-Hebel (H1–H6): Technik, Content, Google Business, Reviews, Digital-PR, Entität |

## Entscheidungs-Log (aus der Produktdiskussion)

| # | Entscheidung | Ergebnis |
|---|---|---|
| 1 | Geschäftsmodell | **Self-Service-Funnel** (Pivot vom reinen Berater-Tool): Gratis-Teaser → bezahlte Stufen. Berater-Backend als Admin-Bereich. |
| 2 | Funnel-Stufen | Teaser (gratis) → Vollreport (einmalig) → Optimierungspaket (einmalig) → Monitoring-Abo (monatlich) → persönliche Beratung (Premium-Stufe, sichtbar im Funnel) |
| 3 | Teaser-Inhalt | Score + anonymisierter Vergleich mit 3–5 Hotels gleicher Kategorie/Region + **Anzahl** gefundener Faktenfehler (ohne Inhalt) |
| 4 | E-Mail-Gate | Ja: Ergebnis kommt per E-Mail-Link nach Double-Opt-in (Lead-Gewinnung + Missbrauchsschutz) |
| 5 | Gratis-Tiefe | Mini-Audit (~15–20 Prompts, 2 Plattformen, 1–2 Sprachen, Kostenziel < 0,10 €/Lead); Voll-Audit erst nach Kauf |
| 6 | AI-Plattformen | Kern-4: ChatGPT, Gemini, Perplexity, Claude (per API, Websuche aktiviert, wo verfügbar) |
| 7 | Sprachen | Mehrsprachig international; pro Hotel konfigurierbar (DE+EN immer, weitere nach Gästemix). Reports in DE + EN. |
| 8 | Wettbewerber | Automatisch 3–5 (gleiche Kategorie, Preisklasse, Region), im Admin manuell überschreibbar; Vergleichs-Score; im Teaser anonymisiert |
| 9 | Faktenquellen | Eigene Website + Booking.com-Profil (falls vorhanden) |
| 10 | Featureset | Vollvision A–H (Quellen-Analyse, Review-Wahrnehmung, Alerts, Content-Hub, Booking-Readiness, Benchmark-DB, Portfolio, AI-Traffic-Tracking) |
| 11 | Verwaltung | Eigene Kundenverwaltung im Tool (Admin-Backend), keine externe CRM-Pflicht |
| 12 | Planungsansatz | Kompletter End-to-End-Plan zuerst; MVP-Schnitt am Ende (siehe 05, Abschnitt "MVP-Schnitt") |
| 13 | Hosting/Datenschutz | EU-Datenhaltung, DSGVO-konform, keine Gästedaten im System |
| 14 | Sichtbarkeits-Hebel | Optimierung = Playbook über 6 Hebel (Technik, Content, Google Business, Reviews, Digital-PR, Entität), nicht nur Website (→ 06) |
| 15 | Synthese-Kosten | Hybrid: Massenarbeit über Billig-APIs (Cents); hochwertige Synthesen (Optimierungspaket) im **Operator-Modus** via Claude Code + Abo des Betreibers (human-in-the-loop, 0 € API), pro Schritt auf `api` umschaltbar |
| 16 | Eingangswege | Zwei Wege, eine Pipeline: Self-Service-Funnel **und** manuelle Hotel-Anlage im Admin (Betreiber wird direkt kontaktiert) |
| 17 | Kontaktdaten & AGB | Pflicht-Ansprechpartner (Name, Position, E-Mail, Telefon) ab Kauf/Abo — Gratis-Teaser bewusst nur E-Mail; AGB-Checkbox versioniert protokolliert |
| 18 | Oberflächen | Admin-Dashboard als visuelle Startseite (KPIs, Handlungsliste, Benachrichtigungen an Betreiber bei Kauf/Abo/Synthese); grafisches **Kundenportal** für Abo-Kunden (F-I, Magic-Link) |
| 19 | Report-Design | Ein einheitliches Template im eigenen CI — kein Hotel-Branding, kein White-Label (frühestens P7) |
| 20 | Erklärbarkeit | Produktprinzip: jede Zahl erklärt sich selbst (zentrale Erklär-Inhalte DE/EN, Drill-Down bis zur Original-AI-Antwort, Wissensbasis "Methodik & Hebel" im Admin als Sales-Enablement) |
| 21 | Wettbewerber-Kosten | Wettbewerber-Scores aus denselben Discovery-Antworten (hotelneutrale Prompts) — keine separaten Läufe, halbiert die Audit-Kosten; Abo-COGS im Vollautomatik-Modus ~6–9 €/Hotel/Monat |
| 22 | UI-Sprache gepinnt | DE/EN-Wahl beim Eintrag (Browser-vorbelegt), pinnt Mails/Teaser/Reports/Portal; änderbar, wechselt nie automatisch. Audit-Sprachen getrennt davon |
| 23 | Gästemix-Beratung | Bezahlversion fragt Gäste-Herkunft ab → Playbook empfiehlt Sprachen/Übersetzungen datenbasiert ("22 % US-Gäste, EN-Sichtbarkeit nur 3,1/10") — Abo-Upsell |
| 24 | Score-Skala & Kunden-Wettbewerber | Kundenseitig Booking-Stil **X,X / 10** (intern 0–100); Bezahlkunden wählen eigene Konkurrenten (max 5, Neuberechnung ohne neue Abfragen) + Lücken-Analyse "Aufholpunkte" pro Wettbewerber |
| 25 | Preisarchitektur | *(Preise ersetzt durch Nr. 28; Struktur gilt weiter:)* **ein einziges Abo**: 12 Mon. Mindestlaufzeit + danach 3 Mon. Kündigungsfrist, Report+Optimierung zu Beginn inklusive, fortlaufende Maßnahmen monatlich. Flex-Decoy-Variante bewusst verworfen (Missverständnis-Risiko). 90-Tage-Anrechnung Einmal-Kauf→Abo; B2B-only (Unternehmer-Bestätigung im Checkout) |
| 26 | Wiederkehr-Motor | Stufe 6: 6 Monate nach Einmal-Kauf automatischer Mini-Re-Audit + personalisierte Win-back-Mail ("Score 6,5 → 5,8") — nur mit separater Marketing-Einwilligung |
| 27 | Wettbewerbs-Check | Markt existiert (Otterly/Peec/Scrunch/Profound generisch; Hotelrank/hotelmarketer/RevPARGenius hotel-spezifisch); Differenzierer: Faktenfehler-Check, fertige Deliverables, DACH, Gästemix-Sprachen, Beratung; Bindung offensiv begründen (→ 01 §1b) |
| 28 | Preisniveau & Staffelung | 149 € verworfen (zu günstig): Preisanker ist das SEO-Budget der Hotels (Retainer 1.000–5.000 €/Mon. DE), nicht der Tool-Markt. Staffelung nach Hotelgröße: Abo 249/399/599 €/Mon. (S/M/L), Report 399/499/699 €, Optimierung 899/1.190/1.590 €; "Founding Member"-Rabatt für Pilot-Hotels statt niedriger Startpreise |
| 29 | Infrastruktur | DB + Worker auf der vorhandenen Hetzner-Box des Betreibers (Postgres in Docker, tägliche Off-Site-Backups, Firewall, Restore-Test); App auf Vercel fra1; "Serverstandort Deutschland" als Vertriebsargument. Fallback: Managed Postgres |
| 30 | Liefer-Zusagen & Freigabe | Hotel-Journey mit SLAs (Teaser < 30 Min, Report < 24 h, Operator-Deliverables < 5 Werktage, → 01 §3.3); `report_auto_publish`-Schalter pro Report-Typ: Vollautomatik vs. Freigabe-Gate in der Admin-Handlungsliste |

## Status

- [x] Produktdefinition abgeschlossen
- [x] Spec-Paket geschrieben
- [ ] MVP-Umsetzung (siehe 05-implementation-plan.md, Phasen P0–P3)

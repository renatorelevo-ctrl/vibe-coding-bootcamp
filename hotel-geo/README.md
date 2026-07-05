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

## Status

- [x] Produktdefinition abgeschlossen
- [x] Spec-Paket geschrieben
- [ ] MVP-Umsetzung (siehe 05-implementation-plan.md, Phasen P0–P3)

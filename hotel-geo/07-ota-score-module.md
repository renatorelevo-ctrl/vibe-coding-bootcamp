# Modul-Spec: OTA-Score (Produkt 2, nach MVP)

Zweites Audit-Modul auf derselben Plattform (Entscheidung Log 36). Ersetzt/kannibalisiert
OTA-Listing-Agenturen (Retainer heute 300–1.500 €/Mon.), die Booking-/Expedia-Profile pflegen.
Nutzt die bestehende Audit-Funnel-Maschine: gleiche Hotels-Tabelle, gleicher Funnel, gleiches
Portal, gleiche Abrechnung, gleiche 5er-Wettbewerber-Slots.

## 1. Produktidee

**Der OTA-Score (X,X/10):** Wie gut verkauft dein Booking-/Google-Profil dich wirklich —
im Vergleich zu deinen 5 Wettbewerbern? Mit konkreten, umsetzbaren Verbesserungen.

**Strategische Doppelwirkung (zentrales Verkaufsargument):** OTA-Profile sind zugleich
Hebel H3/H4/H6 des Sichtbarkeits-Playbooks — LLMs zitieren Booking-Inhalte und Bewertungen.
Wer seinen OTA-Score verbessert, verbessert messbar auch seinen AI-Sichtbarkeits-Score.
Im Portal stehen beide Scores nebeneinander; das Abo wird pro Modul wertvoller und schwerer
kündbar.

## 2. Scope

- **v1-Quellen:** Booking.com-Profil (wird für den Fakten-Check bereits gecrawlt) +
  Google-Hotelprofil (Business Profile, öffentliche Ansicht). Expedia/HRS: v2.
- **Kein Preis-/Paritäts-Vergleich in v1** (bräuchte Raten-/Verfügbarkeitsdaten → Scraping-
  Intensität und Rechtslage deutlich kritischer; als v2-Kandidat notiert).
- Rechtsrahmen wie gehabt (03 §6): minimales Crawl-Volumen, Cache, robots-Respekt,
  **Copy-Paste-/Upload-Fallback bleibt Pflicht-Feature**; anwaltliche Einschätzung vor Launch
  des Moduls erneuern (OTA-AGB).

## 3. Score-Dimensionen (deterministisch + LLM-bewertet, intern 0–100, Anzeige X,X/10)

| Dimension | Gewicht (settings) | Messung |
|---|---|---|
| Profil-Vollständigkeit | 25 % | deterministisch: Attribute/Ausstattungen gepflegt, Fotoanzahl, Beschreibungslänge, Richtlinien/FAQ-Felder belegt |
| Content-Qualität | 25 % | LLM-bewertet (EXECUTOR, Rubrik): USPs konkret? faktenreich statt Floskeln? Zielgruppen erkennbar? mehrsprachig gepflegt? |
| Bewertungs-Gesundheit | 30 % | deterministisch: Note, Anzahl, Aktualität (Reviews/90 Tage), Antwortquote des Hotels, Themen-Balance (aus F-B-Extraktion) |
| Konsistenz | 20 % | Abgleich mit Truth-Corpus/Website (H6): Name, Kategorie, Ausstattung, Richtlinien identisch? Widersprüche = Punktabzug + Befund |

Wettbewerbsvergleich: dieselben 5 Slots wie im Kernprodukt; deren öffentliche Profile werden
mit derselben Rubrik bewertet (Mehrkosten: Cent-Bereich, nur Crawl + EXECUTOR-Rubrik).

## 4. Funnel-Integration

- **Teaser (Free):** erweitert den bestehenden Teaser um eine Zeile — "OTA-Score: 5,8/10,
  3 von 5 Wettbewerbern präsentieren sich stärker" + Befund-Zähler ("4 Verbesserungspunkte
  gefunden"), Details hinter der Paywall. Settings-Flag `teaser_show_ota` (Start: aus,
  A/B-fähig — Teaser nicht überladen).
- **Einmalprodukt "OTA-Paket":** Score-Report + Deliverables (siehe §5) für Nicht-Abonnenten;
  Preis nach Größenklasse (Platzhalter: 299/399/499 € S/M/L), 90-Tage-Anrechnung aufs Abo
  wie gehabt.
- **Im Abo inklusive:** OTA-Score wird Teil des Monats-Reports (eigene Sektion + Trend);
  Verbesserungen fließen in die fortlaufenden Maßnahmen. Kein Aufpreis — Bindungs-Feature.

## 5. Deliverables (Optimierungs-Teil)

- Neu geschriebene Booking-Beschreibung (GEO-Prinzipien aus 04 §7.1, faktentreu aus
  Truth-Corpus, in den konfigurierten Sprachen) — copy-paste-fertig für den Extranet-Editor
- Attribut-/Ausstattungs-Checkliste ("diese 12 Felder sind leer, so füllst du sie")
- Foto-Brief (Anzahl/Motive-Empfehlung nach Segment-Benchmark)
- Review-Antwort-Vorlagen für die 5 häufigsten Kritik-Themen (aus F-B)
- Konsistenz-Korrekturliste (Widersprüche Website ↔ Booking ↔ Google)
- Alle Synthesen laufen wie gehabt im `api`- ODER `operator`-Modus (02 §2)

## 6. Technische Wiederverwendung (warum das Modul billig zu bauen ist)

| Baustein | Status |
|---|---|
| Booking-Crawl + Cache + Paste-Fallback | existiert (P1.2) |
| Google-Profil-Check | existiert teilweise (H3-Check, P1.11-Nachbar) — erweitern |
| Wettbewerber-Slots + Auffüll-Regel | existiert (P1.9) |
| Scoring-Framework + 10er-Skala + methodology_version | existiert (P1.8) |
| Rubrik-Bewertung per EXECUTOR | neues Prompt-Set (04-Erweiterung), Muster vorhanden |
| Teaser-DTO, Paywall, Stripe, Portal, Monats-Report | existiert |
| Neue Tabellen | `ota_profiles` (hotel_id, source, content_hash, fetched_at), `ota_scores` (analog scores) |

Geschätzter Zusatzaufwand: **~1 Phase (P8, 6–8 Tasks)** statt eines eigenen Produkts.
Mehrkosten pro Audit: < 0,50 € (Crawl + Rubrik-Calls, keine teuren Websuche-Abfragen).

## 7. Phase P8 — Tasks (nach P5, vor/parallel P6)

| # | Task |
|---|---|
| P8.1 | `ota_profiles`-Crawl (Booking + Google-Profil), Cache, Paste-Fallback erweitern |
| P8.2 | Deterministische Checks: Vollständigkeit, Bewertungs-Gesundheit, Konsistenz (H6-Wiederverwendung) |
| P8.3 | Content-Qualitäts-Rubrik (EXECUTOR-Prompt-Set, Golden-Tests) |
| P8.4 | OTA-Score-Berechnung + Wettbewerber-Vergleich (Scoring-Framework-Erweiterung) |
| P8.5 | Report-Sektion (Monats-Report + Einmal-Report) + Teaser-Zeile hinter Flag |
| P8.6 | Deliverables-Generator (Beschreibung, Checklisten, Review-Vorlagen) in api/operator-Modus |
| P8.7 | Stripe-Produkt "OTA-Paket" + Anrechnungs-Logik + Portal-Sektion |
| P8.8 | Erklär-Inhalte (7c) + Wissensbasis-Seite fürs Modul |

## 8. Voraussetzung im MVP-Bau (damit nichts im Weg steht)

Die Executor-Modelle müssen beim Kernprodukt nur zwei Dinge beachten:
1. `scores` und Report-Sektionen sind **modul-fähig** entworfen (score-Zeilen tragen bereits
   `methodology_version`; Report-`content_json` ist sektioniert — beides schon spezifiziert).
2. Der Booking-Crawl (P1.2) legt Rohinhalte strukturiert in `truth_corpus` ab, sodass P8.1
   darauf aufbauen kann — keine Wegwerf-Extraktion.

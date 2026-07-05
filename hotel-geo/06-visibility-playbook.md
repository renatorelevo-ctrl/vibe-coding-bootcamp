# Sichtbarkeits-Playbook — die 6 Hebel jenseits der Website

Erweitert PRD §4 (M3) und 04-prompt-spec.md §7. Das Optimierungspaket (Stufe 3) ist kein
"Website-Paket", sondern ein **Sichtbarkeits-Playbook** über sechs Hebel-Kategorien. Pro Hebel ist
definiert: was das Tool automatisiert prüft/erzeugt, was es nur empfiehlt, und wo die
Beratungsleistung des Betreibers beginnt (bewusstes Geschäftsmodell: Diagnose + Entwürfe verkauft
das Tool, Umsetzung verkauft die Beratung).

## Warum sechs Hebel: die Plattformen lesen unterschiedliche Quellen

| Plattform | Primäre Signalquellen | Stärkster Hebel |
|---|---|---|
| Gemini | Google Knowledge Graph, Maps/Business Profile, Google-Index, Reviews | H3 (Google Business), H4 |
| ChatGPT (Search) | Bing-Index, Trainingsdaten, zitierfähige Webquellen | H2, H5 |
| Perplexity | Live-Websuche, stark zitatgetrieben (Listicles, Blogs, Presse) | H5, H1 |
| Claude | Websuche, Trainingsdaten | H2, H5 |

Konsequenz für Reports: Maßnahmen werden **pro Plattform-Wirkung** ausgewiesen ("verbessert
primär Gemini-Sichtbarkeit").

## H1 — Website-Technik (Quick Wins, prüfbar in Minuten)

Häufigster stiller Killer: Hotels **blockieren AI-Crawler unwissentlich** (robots.txt via
Agentur-Template) oder liefern JS-only-Seiten, die AI-Crawler nicht rendern.

| Check (automatisiert im Audit) | Maßnahme (im Playbook) |
|---|---|
| robots.txt erlaubt GPTBot, ClaudeBot, PerplexityBot, Google-Extended, OAI-SearchBot? | fertiger robots.txt-Block zum Einbau |
| Kerninhalte ohne JavaScript lesbar (Server-HTML)? | Hinweis + Agentur-Brief |
| llms.txt vorhanden? | generierte llms.txt (aus Truth-Corpus) |
| Schema.org `Hotel` vollständig? | generiertes JSON-LD (04 §7.2) |
| Ladezeit / Erreichbarkeit | Messwert + Schwellen-Hinweis |

→ Neuer Audit-Baustein **"Technik-Check"** (deterministisch, kostenlos — keine LLM-Calls):
läuft schon im Mini-Audit mit, Ergebnis aber erst im Vollreport sichtbar (Teaser: nur
"N technische Hürden gefunden" als weiterer Zähler — optional, settings-Flag).

## H2 — Website-Content

Wie bisher spezifiziert (04 §7): faktenreiche Rewrites, FAQ-Block, Aktualitätssignale,
Entitäten-Klarheit. Tool automatisiert: vollständig (Entwürfe). Beratung: Einbau/Redaktion.

## H3 — Google Business Profile (stärkster Einzelhebel für Gemini)

| Tool automatisiert | Playbook empfiehlt / Beratung setzt um |
|---|---|
| Profil-Vollständigkeits-Check (Kategorien, Attribute, Öffnungszeiten, Fotos-Anzahl, Q&A genutzt?) über öffentliche Ansicht | Attribut-Checkliste fürs Segment (Familien: "Kinderfreundlich", Spa-Attribute …), Foto-Brief, Q&A-Seeding mit generierten Antworten, Google-Posts-Rhythmus |
| Abgleich Profil ↔ Truth-Corpus (Inkonsistenzen = Faktenfehler-Quelle!) | Korrektur-Liste |

## H4 — Bewertungsmanagement

Bewertungen (Google, Booking, TripAdvisor, **HolidayCheck** im DACH-Raum) formen, was die AI über
das Hotel "glaubt" — Menge, Aktualität, Themen und Antworten zählen.

- Tool: Review-Wahrnehmungs-Analyse (F-B) zeigt die Lücke zwischen AI-Bild und Selbstbild;
  generierte, GEO-bewusste Antwortentwürfe auf kritische Reviews (Feature-Flag, P6.3).
- Playbook: Bewertungs-Einladungs-Prozess (nach Abreise), Themen-Steuerung ("bittet Familien
  aktiv um Bewertungen, wenn ihr als Familienhotel wahrgenommen werden wollt").
- Beratung: Prozess-Implementierung im Hotel.

## H5 — Dritt-Erwähnungen / Digital-PR (stärkster Langfrist-Hebel)

Bei Discovery-Anfragen ("bestes Hotel für…") kennt die AI den Hotelnamen nicht — sie zitiert
Listicles, Reiseblogs, Lokalpresse, DMO-/Tourismusverband-Seiten, Reddit/Foren. Präsenz in diesen
Quellen ist das GEO-Pendant zum Linkbuilding.

- Tool: Quellen-Analyse (F-A) liefert die **konkrete Ziel-Liste** — Domains, die die AI im
  Segment zitiert, sortiert nach Empfehlungs-Korrelation; Abgleich "wo sind Wettbewerber
  präsent, wir nicht".
- Playbook: Outreach-Prioritäten (Tourismusverband-Eintrag vervollständigen → regionale
  "Beste Hotels"-Artikel → Fach-/Lokalpresse → Foren-Präsenz), generierte Pitch-Entwürfe.
- Beratung: PR-Umsetzung (hochwertigste Beratungsleistung, wiederkehrend).
- Grundsatz: **keine Fake-Präsenz** (keine gekauften Erwähnungen, keine Astroturfing-Posts) —
  Reputationsrisiko und zunehmend von Plattformen/Modellen erkennbar.

## H6 — Entitäts-Konsistenz

Die AI muss sicher wissen, *wer* das Hotel ist, bevor sie es empfehlen kann. Unterschiedliche
Schreibweisen ("Hotel Alpenhof" vs "Alpenhof Resort & Spa") verwässern die Entität.

- Tool: Konsistenz-Check über Truth-Corpus + Profile (Name/Adresse/Kategorie identisch auf
  Website, Google, Booking?); Alias-Liste als Nebenprodukt der Audit-Extraktion.
- Playbook: kanonische Schreibweise festlegen, überall angleichen; Wikidata-Eintrag anlegen/
  pflegen (wenn Relevanzkriterien erfüllt); konsistente Kategorisierung.

## Priorisierung im Playbook (Default-Reihenfolge der Maßnahmenliste)

1. **Faktenfehler korrigieren** (H2/H3/H6-Ursachen) — Vertrauen zuerst; falsche AI-Aussagen
   kosten heute Buchungen.
2. **H1 Technik-Quick-Wins** — Stunden Aufwand, sofortige Crawler-Wirkung.
3. **H3 Google Business** — schnelle Gemini-Wirkung.
4. **H2 Content-Paket** — Kern des Optimierungspakets.
5. **H4 Bewertungsprozess** — mittelfristig.
6. **H5 Quellen-Präsenz** — langsam, aber größter Moat; Einstieg in die laufende Beratung.

Jede Maßnahme im Report mit: Hebel-Kategorie, erwarteter Plattform-Wirkung, Aufwand (S/M/L),
Umsetzer (Hotel selbst / Webagentur / Beratung).

## Wirkungsnachweis

Das Monitoring (Stufe 4) schließt den Kreis: Maßnahmen-Status (Hotel hakt ab bzw. Betreiber
pflegt) wird im Monats-Report gegen Score-Entwicklung gestellt — "umgesetzte Maßnahmen vs.
Sichtbarkeit" ist die stärkste Abo-Bindung und der Beleg für die Beratung.

## Spec-Auswirkungen

- Audit-Pipeline: neuer deterministischer Schritt `TECHCHECK` (in PREPARE integrierbar) —
  robots/llms.txt/Schema/SSR-Checks, Ergebnis in `tech_checks`-Tabelle (hotel_id, check_key,
  status, details_json, checked_at).
- 04 §7.2 Maßnahmenliste: Kategorien = H1–H6 (ersetzt die bisherige Vierer-Liste).
- Implementierungsplan: P1.11 (Technik-Check), P4.4 erweitert (Playbook statt Maßnahmenliste),
  P6.1/P6.3 liefern H5/H4-Inputs (unverändert).

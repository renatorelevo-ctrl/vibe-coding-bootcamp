# Prompt- & Scoring-Spezifikation — GEO-Radar

Das Herzstück des Produkts. Alle Prompt-Vorlagen liegen versioniert in `prompts/` (Code-Repo) und
werden über `settings` einer Version zugeordnet — Prompt-Änderungen sind damit nachvollziehbar und
Scores bleiben Versionen zuordenbar.

## 1. Prompt-Batterie: Generierung

### 1.1 Dimensionen-Matrix

Die Batterie simuliert echte Reisende. Generiert wird über eine Matrix, damit die Abdeckung
systematisch statt zufällig ist:

| Dimension | Ausprägungen (Beispiele) |
|---|---|
| Persona | Familie mit Kindern, Paar, Geschäftsreisende, Wellness-Suchende, Budget, Luxus, Hundebesitzer, Barrierefreiheit, Gruppe/Feier |
| Intent | "bestes Hotel für…", ausstattungsbezogen (Pool/Spa/Parken), preisgebunden ("unter 150 €"), anlassbezogen (Hochzeitstag, Messe), lagebezogen ("nahe Altstadt/Bahnhof/Skilift") |
| Saison | Sommer, Winter, Nebensaison, konkrete Events der Region |
| Formulierung | kurz/lang, mit/ohne Ortsangabe-Varianten ("am Tegernsee" vs "in der Nähe von München"), Frage vs Auftrag ("plan mir…") |
| Sprache | konfigurierte Hotel-Sprachen |

### 1.2 Generierungs-Prompt (SYNTHESIZER, einmal pro Hotel/Version)

Input: Hotelprofil (Kategorie, Preisband, Lage, Ausstattungs-Schwerpunkte aus dem Truth-Corpus),
Region-Kontext, Sprachliste, Zielanzahl.

Anforderungen an die Ausgabe (JSON-Array):

- **Neutralität:** Prompts erwähnen **niemals den Hotelnamen** — wir messen, ob das Hotel
  organisch empfohlen wird. (Ausnahme: das "Direct-Ask-Set", §1.3.)
- Realistische Nutzersprache, keine SEO-Keywords; pro Sprache muttersprachlich formuliert.
- Jeder Prompt mit Metadaten: `{id, language, persona, intent, season, weight}`.
- Gewichtung `weight` (1–3) nach kommerzieller Relevanz (Buchungsabsicht hoch = 3).
- Dedupe: keine zwei Prompts mit identischem (persona × intent × season × language).

### 1.3 Batterie-Aufbau

| Set | Anteil | Zweck |
|---|---|---|
| Discovery-Set | ~80 % | organische Empfehlungs-Messung (Hotelname unbekannt) |
| Direct-Ask-Set | ~20 % | Fakten-Provokation: "Erzähl mir über [Hotel X] — Preise, Ausstattung, lohnt es sich?" → maximiert extrahierbare Claims für den Fakten-Check |

Größen: **Voll-Audit** 60–120 Prompts (nach Sprachanzahl), **Mini-Audit** = markiertes, stabiles
Subset von 15–20 (höchstgewichtete Discovery-Prompts + 3 Direct-Ask, max. 2 Sprachen).

### 1.4 Versionierung & Vergleichbarkeit

- Batterie unveränderlich pro Version; Monats-Runs nutzen dieselbe Version → Trend vergleichbar.
- Neue Version nur bei: Hotelprofil-Änderung, Prompt-Vorlagen-Update, manuellem Admin-Refresh.
  Report markiert Versionswechsel ("Messmethodik aktualisiert — Vergleich eingeschränkt").
- Wettbewerber-Läufe nutzen **dieselbe Discovery-Batterie** (Direct-Ask entfällt bzw. reduziert),
  sonst wären Vergleichs-Scores unfair.

## 2. Ausführung (EXECUTE)

- Pro (prompt × provider × language) genau ein Query-Call. Provider-Parameter: Websuche **an**
  (wo verfügbar), Temperatur niedrig (0–0.3), keine System-Vorgaben außer neutralem
  Reise-Assistent-Framing, kein Standort-Bias (expliziter neutraler Kontext).
- Ein Lauf pro Monat genügt nicht für statistische Stabilität einzelner Prompts — Stabilität
  entsteht über die **Breite der Batterie** (60–120 Messpunkte), nicht über Wiederholung.
  (Reproduzierbarkeitsziel ±5 Punkte, PRD §7 — im Betrieb via Demo-Hotel monatlich verifizieren.)
- Fehlertoleranz: Provider-Teilausfälle → Score wird über verfügbare Provider berechnet und im
  Report gekennzeichnet; unter 50 % Erfolgsquote → Run `degraded`.

## 3. Extraktion (EXTRACT, EXECUTOR)

Ein Call pro Antwort. Input: die AI-Antwort (untrusted, delimited, → 03 §5), Zielhotel-Name +
Aliasse, Wettbewerber-Kandidatenliste (falls vorhanden). Output (Zod-validiert):

```json
{
  "hotels_mentioned": [
    {"name": "…", "normalized_match": "target|competitor:<id>|unknown",
     "position": 1, "is_recommendation": true,
     "context": "empfohlen für Familien wegen Kinderclub"}
  ],
  "claims_about_target": [
    {"text": "Doppelzimmer ab 120 €", "category": "price"},
    {"text": "hauseigenes Spa mit Innenpool", "category": "amenity"}
  ],
  "cited_sources": [{"domain": "booking.com", "url": "…"}],
  "answer_type": "recommendation_list|single_recommendation|no_recommendation|refusal",
  "injection_suspected": false
}
```

Regeln: `position` = Reihenfolge der Empfehlung (1-basiert); Namens-Normalisierung über
Alias-Liste + Fuzzy-Match im Code (nicht dem LLM überlassen); `unknown`-Hotels werden als
Wettbewerber-Kandidaten gesammelt.

## 4. Fakten-Check (FACTCHECK, EXECUTOR)

Pro Claim: Claim + relevante Truth-Corpus-Ausschnitte (Retrieval über einfache Keyword-/
Abschnitts-Suche, kein Vektor-Store in v1) → Verdikt:

```json
{"verdict": "correct|incorrect|unverifiable",
 "evidence_quote": "…", "evidence_source": "website|booking",
 "severity": "high|medium|low", "explanation_de": "…", "explanation_en": "…"}
```

- `incorrect` + `severity high` (z. B. "geschlossen", falsche Preisklasse, fehlende Kernausstattung)
  sind Alert-würdig (→ §8).
- Preis-Claims: Toleranz ±15 % gegen ausgewiesene Ab-Preise (Saisonpreise machen exakte Vergleiche
  unfair); außerhalb → `incorrect (medium)`.
- Duplikat-Claims (mehrere Provider, gleiche Aussage) werden gemerged, Provider-Liste angehängt.
- Teaser zählt: `incorrect`-Claims (dedupliziert). Nur die Anzahl verlässt die Paywall.

## 5. Scoring (deterministischer Code, kein LLM)

### 5.1 Sichtbarkeits-Score (pro Provider × Sprache)

Pro Discovery-Prompt p mit Gewicht w(p):

```
punkte(p) = 0                wenn nicht erwähnt
          = 0.15             wenn erwähnt, aber keine Empfehlung
          = posWeight(rang)  wenn empfohlen:  rang 1 → 1.0, 2 → 0.7, 3 → 0.5,
                                              4–5 → 0.3, >5 → 0.2
visibility = 100 × Σ w(p)·punkte(p) / Σ w(p)
```

### 5.2 Aggregation

```
visibility(gesamt) = Σ providerGewicht × visibility(provider)
   providerGewichte (settings, Default): ChatGPT 0.5, Gemini 0.25, Perplexity 0.15, Claude 0.10
   (Sprachen innerhalb eines Providers gleichgewichtet, sofern nicht pro Hotel konfiguriert)

share_of_voice = Empfehlungen des Zielhotels / Empfehlungen aller Hotels der Vergleichsgruppe
                 (gleiche Batterie, in %)

fact_accuracy  = correct / (correct + incorrect)   (unverifiable zählt nicht; in % )

composite      = 0.7 × visibility + 0.15 × share_of_voice + 0.15 × fact_accuracy
```

Alle Gewichte sind `settings` — Methodik-Anpassungen ohne Deploy, aber versioniert (Score trägt
`methodology_version`).

### 5.3 Teaser-Darstellung

Composite-Score 0–100 mit Bändern: 0–25 "kaum sichtbar", 26–50 "unterdurchschnittlich",
51–75 "solide", 76–100 "stark". Vergleichsbalken: Zielhotel + anonymisierte Wettbewerber
("Hotel A–E", absteigend sortiert), Aussagen-Template: "N von M vergleichbaren Hotels werden
häufiger empfohlen als Sie."

## 6. Wettbewerber-Erkennung (COMPETITORS, SYNTHESIZER)

1. Kandidaten = alle `unknown`-Hotels aus Extraktionen, sortiert nach Empfehlungshäufigkeit.
2. SYNTHESIZER-Kuration mit Hotelprofil: wähle 3–5 mit gleicher Kategorie (±1 Stern), ähnlichem
   Preisband, gleicher Destination; Ausgabe mit Begründung pro Auswahl (Admin-sichtbar).
3. Persistiert als `competitor_links(source=auto)`; Admin-Override setzt `source=manual` und ist
   für Folge-Audits bindend. Overrides lösen Wettbewerber-Batterie-Lauf für Neue aus.

## 7. GEO-Optimizer-Prompts (SYNTHESIZER)

### 7.1 GEO-Prinzipien (Systemprompt-Kern für alle Rewrites)

1. Konkrete, zitierfähige Fakten statt Marketing-Prosa ("250 m zum Strand" statt "traumhaft nah am Meer").
2. Fragen beantworten, wie Nutzer sie stellen (Frage-Überschriften, direkte erste Antwort-Sätze).
3. Entitäten eindeutig machen (Hotelname, Ort, Kategorie konsistent; Aliasse vermeiden).
4. Zahlen, Listen, strukturierte Abschnitte — maschinenlesbar gliedern.
5. Aktualität signalisieren (Jahresangaben, aktuelle Preise "Stand: …").
6. Alleinstellungsmerkmale explizit benennen (die AI empfiehlt, was sie begründen kann).
7. Nie Fakten erfinden: Rewrites dürfen **ausschließlich** Informationen aus dem Truth-Corpus
   verwenden; fehlende Angaben werden als `[ANGABE ERGÄNZEN: …]`-Platzhalter markiert.

### 7.2 Deliverable-Prompts

- **Rewrite:** Input Originaltext + Truth-Corpus + Zielsprache → Output Neutext + Änderungs-Notizen
  (was/warum) für die Diff-Ansicht.
- **FAQ-Generator:** aus Truth-Corpus 10–15 Q&A-Paare (echte Nutzerfragen der Batterie als
  Inspirationsquelle!), Antworten 2–4 Sätze, faktentreu.
- **Schema.org:** `Hotel`-JSON-LD-Template deterministisch aus Strukturdaten befüllt
  (Name, Adresse, Sterne, Amenities, Geo, Preisspanne); LLM nur für Amenity-Mapping auf
  Schema-Vokabular. Validierung gegen JSON-LD-Schema im Code.
- **Maßnahmenliste:** aus Audit-Ergebnissen priorisierte Aktionen (Impact × Aufwand), Kategorien:
  Website-Text, strukturierte Daten, Profile (Google/Booking), Quellen-Präsenz (aus F-A), llms.txt.

## 8. Monitoring-Diff & Alerts

Nach jedem `monthly`/`light_check`-Run, deterministisch:

| Trigger | Bedingung (Defaults, settings) | Alert |
|---|---|---|
| Neuer Faktenfehler | neuer deduplizierter `incorrect`-Claim, severity ≥ medium | sofort |
| Score-Einbruch | composite −10 Punkte ggü. Vormonat (gleiche Batterie-Version) | sofort |
| Wettbewerber-Sprung | Wettbewerber überholt Zielhotel im Ranking | im Monats-Report |
| Fehler behoben | vorheriger `incorrect`-Claim jetzt `correct`/verschwunden | im Monats-Report (positiv!) |

## 9. Quellen-Analyse (F-A) & Review-Wahrnehmung (F-B)

- **F-A:** `cited_sources` aller Antworten des Segments aggregieren → Domain-Ranking mit
  Empfehlungs-Korrelation ("Hotels, die empfohlen werden, sind auf X präsent"). SYNTHESIZER
  formuliert daraus die Quellen-Maßnahmenliste. Vollreport: Top-Quellen; Abo: Trend.
- **F-B:** Direct-Ask-Antworten + Discovery-Kontexte ("empfohlen wegen…", "Kritik an…") →
  EXECUTOR extrahiert wahrgenommene Stärken/Schwächen mit Häufigkeit → Gegenüberstellung mit
  Selbstbild (Website). Output: "Die AI hält Sie für ein Business-Hotel — Sie positionieren sich
  als Familienhotel."

## 10. Report-Prosa (SYNTHESIZER)

Input: strukturierte Ergebnisse (Scores, Claims, Wettbewerber, Quellen) — **niemals Roh-Antworten**
(Injection-Schutz + Kostenkontrolle). Output: Executive Summary (max 1 Seite), Abschnitts-
Einleitungen, Handlungsempfehlungen — in Report-Sprache (DE/EN), Ton: klar, faktenbasiert,
für Hoteliers ohne Tech-Vorwissen. Alle Zahlen kommen aus dem Code und werden ins Template
interpoliert — das LLM formuliert um Zahlen herum, erfindet aber keine.

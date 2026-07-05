# PRD — GEO-Radar (Arbeitstitel)

## 1. Problem & Vision

Hotels haben 15 Jahre in Google-SEO investiert. Reisende fragen aber zunehmend AI-Assistenten
("Bestes Familienhotel am Tegernsee?"). In einer AI-Antwort gibt es keine Seite 1 mit zehn
Treffern — es gibt 3–5 Empfehlungen. Wer dort nicht auftaucht, existiert für den Reisenden nicht.
Zusätzlich verbreiten AI-Modelle teils **falsche Fakten** über Hotels (Preise, Ausstattung,
Öffnungszeiten), ohne dass die Hotels davon wissen.

**Vision:** Die Plattform, mit der jedes Hotel in Minuten erfährt, wie sichtbar es in AI-Antworten
ist, was die AI Falsches behauptet — und die den Weg zur Verbesserung verkauft: vom Report über
konkrete Optimierung bis zu laufendem Monitoring und persönlicher Beratung.

**Positionierung:** "SEO war gestern. Wir zeigen dir, ob ChatGPT dich empfiehlt — und sorgen dafür,
dass es das tut."

## 2. Zielgruppen

| Persona | Rolle | Bedürfnis |
|---|---|---|
| Hotelier / GF (Individualhotel, 20–150 Zimmer) | Käufer | "Werde ich von AI empfohlen? Was sagt sie über mich? Was muss ich tun?" |
| Marketing-Manager (Hotel/Gruppe) | Nutzer | Reports für die GF, konkrete Maßnahmen für die Webagentur, ROI-Nachweis |
| Betreiber (Founder/Hotelberater) | Admin | Leads sehen, Audits steuern, Wettbewerber kuratieren, Beratung verkaufen |
| Hotelgruppe / Kette | Käufer (später) | Portfolio-Übersicht über alle Häuser |

**Explizit keine Zielgruppe des Datenmodells:** Hotelgäste. Das System verarbeitet keinerlei
Gästedaten (→ 03-security-privacy.md).

## 3. Der Funnel (Kernmechanik des Produkts)

```
Stufe 0  EINTRAG        Hotelname + Ort eingeben, E-Mail bestätigen (Double-Opt-in)
Stufe 1  TEASER         gratis  — Score, anonymer Wettbewerbsvergleich, Fehler-ANZAHL
Stufe 2  VOLLREPORT     bezahlt — alles mit Namen und Wortlaut
Stufe 3  OPTIMIERUNG    bezahlt — konkrete Verbesserungen (Texte, FAQ, Schema.org)
Stufe 4  MONITORING     Abo     — monatlicher Report, Alerts, AI-Traffic-Tracking
Stufe 5  BERATUNG       Premium — persönliche Umsetzung mit Experten (Termin-Buchung)
```

### Stufe 0 — Eintrag

- Landingpage mit einem einzigen Eingabefeld-Flow: Hotelname → Autovervollständigung/Disambiguierung
  (Ort, Website-URL bestätigen) → E-Mail-Adresse.
- Double-Opt-in-Mail ("Bestätige, dann startet deine Analyse"). Erst nach Bestätigung startet der
  Mini-Audit. Das ist zugleich Lead-Capture und Missbrauchsschutz.
- Der Audit läuft asynchron (2–10 Min). Ergebnis-Mail mit Link zur Teaser-Seite.
- **Datensparsam by design:** Auf dieser Stufe wird ausschließlich die E-Mail verlangt — jedes
  weitere Pflichtfeld kostet Conversion. Vollständige Ansprechpartner-Daten werden erst beim
  Kauf Pflicht (→ §3.1).

### Stufe 0b — Zweiter Eingangsweg: über den Betreiber

Hotels, die den Betreiber direkt kontaktieren (Telefon, Messe, Empfehlung), werden im
Admin manuell angelegt: Hotel + Ansprechpartner erfassen → Audit per Klick starten →
wahlweise Ergebnis-Link automatisch per Mail versenden oder manuell weitergeben.
Identische Pipeline, identische Reports — nur der Eingang unterscheidet sich
(`hotels.intake = self_service | manual`).

### §3.1 Ansprechpartner & AGB (Pflichtdaten bei Kauf/Abo)

- Pro Hotel genau ein **Pflicht-Ansprechpartner**: Name, Position, E-Mail, Telefonnummer.
  Erhoben beim Checkout (Stufen 2–4) bzw. bei manueller Anlage durch den Betreiber; beim
  Gratis-Teaser bewusst nicht (nur E-Mail).
- **AGB-Zustimmung:** nicht vorangekreuzte Checkbox bei Checkout und Portal-Registrierung;
  protokolliert mit Zeitstempel, AGB-Version und Konto — revisionssicherer Nachweis.
- **Betreiber-Benachrichtigungen:** sofortige E-Mail an den Admin bei neuem Kauf, neuem/
  gekündigtem Abo und jeder wartenden Synthese-Aufgabe (Operator-Modus), jeweils mit
  Direktlink in den Admin.

### Stufe 1 — Teaser (die Neugier-Lücke)

Zeigt genau drei Dinge, nicht mehr:

1. **AI-Sichtbarkeits-Score** (0–100) mit Ampel-Einordnung ("Ihr Hotel wird bei X% der relevanten
   Anfragen empfohlen").
2. **Anonymer Wettbewerbsvergleich:** Balkendiagramm mit "Hotel A–E" (3–5 Hotels gleicher
   Kategorie/Preisklasse/Region). Aussage: "3 von 5 vergleichbaren Hotels werden häufiger
   empfohlen als Sie."
3. **Fehler-Zähler:** "Wir haben **N potenziell falsche Aussagen** über Ihr Hotel in AI-Antworten
   gefunden." Nur die Zahl — nie der Inhalt, nie die Plattform.

Regeln: Wettbewerbernamen und Fehlerinhalte sind **hart serverseitig** von der Teaser-Ansicht
ausgeschlossen (nicht nur ausgeblendet). Darunter die Kaufstufen als Preistabelle.

### Stufen 2–5 — Bezahlangebote

| Stufe | Produkt | Inhalt | Preis (Platzhalter, final vom Betreiber) |
|---|---|---|---|
| 2 | **Vollreport** | Voll-Audit (alle 4 Plattformen, alle konfigurierten Sprachen), Wettbewerber mit Namen + Scores, Faktenfehler im Wortlaut mit Quelle (welche AI, welche Aussage), Score pro Plattform/Sprache, PDF + Web | 149–299 € einmalig |
| 3 | **Optimierungspaket** | Alles aus Stufe 2 + GEO-Rewrites der Website-Texte (Diff-Ansicht), generierter FAQ-Block, Schema.org-JSON-LD, priorisierte Maßnahmenliste ("Quick Wins zuerst"), übergabefertig für die Webagentur | 399–699 € einmalig (inkl. Stufe 2) |
| 4 | **Monitoring-Abo** | Monatlicher Re-Audit (gleiche Prompt-Batterie → vergleichbare Scores), Trend-Report, Alerts bei neuen Faktenfehlern/Score-Einbrüchen, AI-Traffic-Tracking-Snippet + Dashboard | 99–199 €/Monat |
| 5 | **Beratung** | "Persönliche Umsetzung mit Experten": Kontaktformular/Termin-Link, individuelles Angebot | individuell |

Upgrade-Pfade: 2→3 (Differenzpreis), 2/3→4 (Abo-CTA in jedem Report), überall →5.

## 4. Module & Features (Vollvision)

### M1 — Audit-Engine (Kern)

- **Prompt-Batterie:** automatisch generierte, realistische Reise-Anfragen für das Hotel-Segment
  (Personas × Anlässe × Saisons × Sprachen). Mini-Audit ~15–20 Prompts, Voll-Audit 60–120.
  Batterie ist pro Hotel **versioniert und stabil** für Monats-Vergleichbarkeit (→ 04-prompt-spec.md).
- **Multi-LLM-Ausführung:** ChatGPT, Gemini, Perplexity, Claude — per API, Websuche aktiviert wo
  verfügbar. Mini-Audit: 2 Plattformen (ChatGPT + Gemini).
- **Auswertung:** Erwähnung ja/nein, Position, empfohlene Wettbewerber, extrahierte Faktenaussagen,
  zitierte Quellen.
- **Scoring:** Sichtbarkeits-Score 0–100 (Formel → 04-prompt-spec.md), pro Plattform/Sprache und
  als gewichteter Gesamtscore; identische Batterie für Wettbewerber → Vergleichs-Scores.
- **Fakten-Check:** extrahierte AI-Aussagen gegen Wahrheitskorpus (gecrawlte Hotel-Website +
  Booking.com-Profil, falls vorhanden) → korrekt / falsch / nicht verifizierbar.
- **Messehrlichkeit:** API-Antworten ≠ 1:1 Consumer-App-Antworten. Reports weisen transparent aus,
  was gemessen wurde ("gemessen über offizielle APIs mit aktivierter Websuche").

### M2 — Wettbewerbs-Modul

- Auto-Erkennung: Kandidaten aus den Audit-Antworten (wer wird stattdessen empfohlen?) +
  LLM-Filter auf gleiche Kategorie, Preisklasse, Region → 3–5 Wettbewerber.
- Admin kann Wettbewerber ersetzen/ergänzen (Hotels nennen oft ihre eigenen).
- Wettbewerber durchlaufen dieselbe Prompt-Batterie → Score-Vergleich ("Sie: 34, Median der
  Vergleichsgruppe: 51").
- Teaser: anonymisiert. Vollreport: mit Namen.

### M3 — GEO-Optimizer (Stufe 3)

- Input: gecrawlte Website-Texte (Fallback: Copy-Paste-Feld).
- Output: (a) GEO-optimierte Rewrites mit Vorher/Nachher-Diff, (b) FAQ-Block aus den Inhalten,
  (c) Schema.org-`Hotel`-JSON-LD, (d) priorisierte Maßnahmenliste inkl. Nicht-Text-Maßnahmen
  (Profile aktualisieren, llms.txt, strukturierte Daten einbauen).
- Alle Texte in den konfigurierten Hotel-Sprachen generierbar.

### M4 — Monitoring & Alerts (Stufe 4)

- Monatlicher Re-Audit per Cron mit stabiler Batterie; Trend-Darstellung (Score-Verlauf,
  behobene/neue Fehler, Wettbewerber-Bewegung).
- **Alerts** zwischen den Monatsläufen (optional wöchentlicher Light-Check): neue Faktenfehler
  oder Score-Einbruch > Schwellwert → sofortige E-Mail.

### F-A — Quellen-Analyse

Aus zitierenden Plattformen (Perplexity, ChatGPT-Search, Gemini-Grounding) die Quellen der
Empfehlungen extrahieren und aggregieren: Welche Portale/Blogs/Presse treiben die Empfehlungen im
Segment? → Maßnahmenliste "Werde hier erwähnt/besser bewertet" (GEO-Pendant zum Linkbuilding).
Teil des Vollreports (Basis) und des Abos (laufend).

### F-B — Review-Wahrnehmungs-Analyse

Was "glaubt" die AI über das Hotel (Stärken/Schwächen laut Modellantworten), gespiegelt gegen die
tatsächlichen Bewertungsthemen. Optional: GEO-bewusste Antwortentwürfe auf kritische Reviews.

### F-C — Content-Hub

Laufende GEO-optimierte Content-Erstellung (saisonale Seiten, Umgebungs-Guides, Event-Content) als
Upsell nach Stufe 3; Redaktionsplan + generierte Entwürfe zur Freigabe.

### F-D — Agentic-Booking-Readiness

Check, ob AI-Agenten die Buchungsstrecke maschinell bedienen können: strukturierte Verfügbarkeits-
daten, Schema.org-Abdeckung, robots/llms.txt, keine blockierenden Popups. Als Score + Maßnahmen.

### F-E — Benchmark-Datenbank (Daten-Moat)

Jeder Audit füttert anonymisierte Aggregate (Segment = Kategorie × Region × Preisklasse).
Ab ausreichender Segmentgröße (k ≥ 5): Branchen-Benchmarks für Reports, PR, Studien.

### F-F — Portfolio-/Gruppen-Ansicht

Mehrere Hotels unter einem Account (Hotelgruppen); für den Admin: alle Kunden mit Scores,
Abo-Status, anstehenden Reports, Umsatz.

### F-G — Admin-Backend (Betreiber)

Leads/Hotels/Audits/Bestellungen einsehen, Wettbewerber überschreiben, Audits manuell starten,
Reports freigeben/regenerieren, Kostenübersicht (API-Ausgaben pro Audit/Monat), Preise & Feature-
Flags konfigurieren.

### F-I — Kundenportal (für Abo-Kunden)

Abo-Kunden erhalten einen Login (Magic-Link, passwortlos) zu einem **grafischen Dashboard**:
Score-Verlauf (Kurve, pro Plattform filterbar), behobene vs. neue Faktenfehler,
AI-Traffic-Zahlen (F-H), Wettbewerbs-Ranking-Verlauf, Maßnahmen-Status (abhakbar) und
Report-Archiv (alle Monats-PDFs). Einmal-Käufer (Stufe 2/3) brauchen kein Konto — sie behalten
ihren tokenisierten Report-Link. Das Portal ist ein aktives Verkaufsargument fürs Abo und die
Basis für spätere Self-Service-Erweiterung (PRD §8 bleibt: kein Self-Service-Audit in v1).

### F-H — AI-Traffic-Tracking

Ein Ein-Zeilen-JavaScript-Snippet für die Hotel-Website: zählt Besucher mit AI-Referrer
(chatgpt.com, perplexity.ai, gemini.google.com, claude.ai, copilot.microsoft.com) — cookielos,
ohne personenbezogene Daten. Dashboard im Abo: "47 Besucher über ChatGPT diesen Monat."
Zusätzlich (optional, Anleitung): Server-Log-Auswertung der AI-Crawler (GPTBot, ClaudeBot,
PerplexityBot) als Frühindikator. **Grenzen ehrlich ausweisen:** Erwähnungen ohne Klick und Klicks
zu OTAs sind nicht messbar; dafür ist der Audit-Score der Proxy.

## 5. Reports (Deliverables)

| Report | Kontext | Form |
|---|---|---|
| Teaser | Stufe 1 | Web-Seite (Mail-Link), bewusst reduziert |
| Vollreport | Stufe 2 | Web + PDF (gebrandet), DE oder EN pro Hotel wählbar |
| Optimierungspaket | Stufe 3 | Web (Diff-Ansicht) + PDF + Download der Artefakte (Texte, JSON-LD) |
| Monats-Report | Stufe 4 | Web + PDF + Mail-Zusammenfassung; Trend-fokussiert, kompakt |

Report-Grundsätze: Für Hoteliers geschrieben (kein AI-Jargon), jede Erkenntnis mit konkreter
Handlungsempfehlung, Methodik-Seite (was wurde wie gemessen), Betreiber-Branding + Beratungs-CTA.

## 6. Sprachen

- **Audit-Sprachen:** pro Hotel konfigurierbar; Default DE + EN, zusätzlich FR/IT/NL/ES je
  Gästemix. Mini-Audit: max. 2 Sprachen.
- **Report-/UI-Sprachen:** DE + EN (pro Hotel wählbar). Funnel-Website zunächst DE, EN folgt.

## 7. Erfolgskriterien

| Metrik | Ziel (erste 6 Monate nach Launch) |
|---|---|
| Conversion Eintrag → verifizierter Lead | > 60 % |
| Conversion Lead → zahlender Kunde (Stufe 2+) | > 5 % |
| API-Kosten Mini-Audit | < 0,10 € |
| API-Kosten Voll-Audit | < 5 € |
| Audit-Laufzeit Mini | < 5 Min bis Ergebnis-Mail |
| Abo-Churn | < 5 %/Monat |
| Score-Reproduzierbarkeit (gleiche Batterie, gleicher Tag) | ± 5 Punkte |

## 8. Nicht-Ziele

- Keine Verarbeitung von Gästedaten, keine PMS-/Channel-Manager-Integration.
- Keine eigene Buchungsstrecke; wir optimieren, buchen nicht.
- Kein Anspruch, Consumer-App-Antworten exakt zu reproduzieren (Messmethodik transparent machen
  statt Scheingenauigkeit).
- Kein Multi-Mandanten-Self-Service für Agenturen in v1 (Architektur hält die Tür offen, F-F).

## 9. Offene Punkte (bewusst später)

- Finales Naming/Domain/Branding.
- Finale Preise (Platzhalter in §3; Betreiber-Entscheidung, im Admin konfigurierbar).
- Funnel-Website EN-Version: Zeitpunkt.
- Rechtsprüfung Booking.com-Abruf und Tracking-Snippet (→ 03-security-privacy.md §6/§7).

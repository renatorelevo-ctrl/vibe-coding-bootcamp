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

## 1b. Markt & Wettbewerb (Stand Juli 2026)

Generische AI-Visibility-Tools: Otterly (ab ~$29/Mon., Budget), Peec AI (€89–199/Mon.),
Scrunch (~$250–300/Mon.), Profound (ab $499/Mon., Enterprise). Hotel-spezifisch: Hotelrank.ai
(Staffelung nach Hotelanzahl, Optimierungs-Aktionen nur im Pro-Plan), hotelmarketer.ai
(ein Preis, alles inklusive, "no lock-in", Framing "weniger als eine Booking-Kommission/Monat"),
RevPARGenius (kostenloser Scan als Lead-Magnet, 5 Engines).

Preisreferenzen: SEO-Retainer DE 1.000–5.000 €/Mon. (kleine Mandate ab 800–1.500 €) —
der eigentliche Vergleichsmaßstab, nicht die Tool-Abos.

Ableitungen:
- **Preisanker ist das SEO-Budget, nicht der Tool-Markt:** Wir sind Software + fertige
  Deliverables + Beratungszugang — Preise nach Hotelgröße 249–599 €/Mon. (→ §3), immer noch
  weit unter dem kleinsten SEO-Retainer. Doppel-Framing: "Bruchteil des SEO-Budgets" +
  "eine einzige Direktbuchung pro Monat zahlt das Abo" (OTA-Kommission ~15–18 %).
- **Gratis-Scan ist Branchenstandard** — der Teaser allein differenziert nicht.
- **Unsere Differenzierer:** (1) Faktenfehler-Check als emotionaler Kaufauslöser (bewirbt kein
  Wettbewerber prominent), (2) fertige Deliverables statt nur Empfehlungen (Rewrites, FAQ,
  Schema-Code), (3) DACH/deutschsprachig (Wettbewerb ist US/EN-fokussiert), (4) Mehrsprachigkeit
  nach Gästemix, (5) persönliche Beratung als Premium-Stufe, (6) Benchmark-DB als Daten-Moat.
- **12-Monats-Bindung offensiv begründen** (Wettbewerber wirbt mit "no lock-in"): Pricing-Seite
  erklärt die Bindung mit den inkludierten Deliverables im Wert von 599 €.

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
2. **Anonymer Wettbewerbsvergleich:** Balkendiagramm mit "Hotel A–E" (immer genau 5 Hotels gleicher
   Kategorie/Preisklasse/Region). Aussage: "3 von 5 vergleichbaren Hotels werden häufiger
   empfohlen als Sie."
3. **Fehler-Zähler:** "Wir haben **N potenziell falsche Aussagen** über Ihr Hotel in AI-Antworten
   gefunden." Nur die Zahl — nie der Inhalt, nie die Plattform.

Regeln: Wettbewerbernamen und Fehlerinhalte sind **hart serverseitig** von der Teaser-Ansicht
ausgeschlossen (nicht nur ausgeblendet). Darunter die Kaufstufen als Preistabelle.

### Stufen 2–5 — Bezahlangebote

**Preisreferenz statt Tool-Vergleich:** Hotels zahlen für SEO-Retainer 1.000–5.000 €/Monat
(DE; kleine Mandate ab 800–1.500 €) — für einen schrumpfenden Kanal. Wir positionieren uns als
dessen Nachfolger, nicht als weiteres Tool-Abo: **"Ein Bruchteil Ihres SEO-Budgets — für den
Kanal, der es ablöst."** Preise nach Hotelgröße gestaffelt (so kaufen Hotels ein: PMS/Channel-
Manager werden pro Zimmer bepreist).

| Angebot | S (≤25 Zi.) | M (26–75 Zi.) | L (76+ Zi./Gruppen) |
|---|---|---|---|
| **Vollreport** (Stufe 2, einmalig) | 399 € | 499 € | 699 € |
| **Optimierungspaket** (Stufe 3, einmalig, inkl. Stufe 2) | 899 € | 1.190 € | 1.590 € |
| **Das Abo** (Stufe 4, einziges Abo) | 249 €/Mon. | 399 €/Mon. | 599 €/Mon. bzw. individuell |
| **Beratung** (Stufe 5) | individuell | individuell | individuell |

(Alle Preise Platzhalter, im Admin pro Größenklasse konfigurierbar; Größenklasse wird bei der
Hotel-Anlage erfasst bzw. aus dem Truth-Corpus geschätzt und beim Checkout bestätigt.)

**Das Abo enthält:** Vollreport + Optimierungspaket sofort zu Beginn, dann laufendes Monitoring
(monatlicher Re-Audit, Trend, Alerts, Portal, AI-Traffic-Tracking) **+ fortlaufende
Optimierung**: fällt im Monats-Audit etwas auf (neuer Faktenfehler, neue Lücke, neue Quelle),
liefert der Monats-Report direkt die passende Maßnahme/den Textentwurf mit.

**Der Abo-Rhythmus (Erwartungssetzung, so auch auf Pricing-Seite/AGB):**
- **Monatlich — DER Bericht:** kompletter Re-Audit, Score-Stand vs. Wettbewerber (X,X/10),
  Veränderungen, klare Verbesserungspunkte für den Folgemonat. Das ist das sichtbare
  Kern-Deliverable; ein fester Bericht pro Monat.
- **Wöchentlich — stiller Wach-Check:** reduzierte Batterie, erzeugt **keinerlei Mail** —
  außer bei kritischem Fund (neuer schwerer Faktenfehler, Score-Einbruch): dann Sofort-Alert.
  Verkaufsargument: "Wir überwachen kontinuierlich — Sie hören von uns nur, wenn es wichtig
  ist." Keine Mail-Flut.

**Sprachen im Abo inklusive — fixe Struktur, 5 Slots, alle frei belegbar:** Start-Belegung
Landessprache + EN, jeder Slot austauschbar (z. B. KO/ZH/JA/FR/IT) — jederzeit im Portal, ohne Aufpreis
(Mehrkosten für uns: ~2–3 €/Sprache/Monat). Ablauf: Sprache aktivieren → System generiert
muttersprachliche Prompt-Batterie (eigene Batterie-Version nur für diese Sprache; bestehende
Sprachen bleiben vergleichbar) → ab dem nächsten Monats-Audit inklusive Sprach-Sektion im
Bericht ("Sichtbarkeit bei koreanischen Anfragen: 2,1/10") + passende Playbook-Maßnahmen.
Der Bericht selbst erscheint weiterhin in der gepinnten UI-Sprache (DE/EN).
**Laufzeit:** 12 Monate Mindestlaufzeit, danach kündbar mit 3 Monaten Frist zum Monatsende;
optional Jahres-Vorauszahlung mit Rabatt. **Launch-Taktik:** hoch starten, Pilot-Hotels erhalten
einen ausgewiesenen "Founding Member"-Rabatt (Preise später zu erhöhen ist schwer, zu senken
leicht).

**Preisarchitektur-Logik:**
- **Ein einziges Abo — bewusst keine Varianten:** Eine frühere Flex-Variante (monatlich
  kündbar, ohne Deliverables) wurde verworfen: zu hohes Missverständnis-/Support-Risiko
  ("teurer und trotzdem kein Report?"). Ein Abo, ein Versprechen: "Wir kümmern uns dauerhaft."
- **Kein Kündigungs-Exploit:** Die inkludierten Deliverables sind durch die 12-Monats-
  Mindestlaufzeit gedeckt; "abschließen, Report abgreifen, kündigen" ist unmöglich.
- **Anrechnung statt Doppelzahlung:** Einmal-Käufer (Stufe 2/3), die binnen 90 Tagen ins Abo
  wechseln, bekommen den Kaufpreis voll angerechnet → Einmal-Produkte werden Abo-Türöffner.
- **B2B-only:** AGB beschränken das Angebot explizit auf Unternehmer → Mindestlaufzeit und
  3-Monats-Kündigungsfrist zulässig, Verbraucher-Regeln greifen nicht (→ 03 §6).
- **Vergänglichkeit kommunizieren:** Jeder Einmal-Report trägt prominent Messdatum + Hinweis,
  dass AI-Antworten sich laufend ändern und Maßnahmen erst nach 4–8 Wochen wirken —
  Nachmessung (= Abo) ist der einzige Wirkungsnachweis.

Upgrade-Pfade: 2→3 (Differenzpreis), 2/3→4 (Anrechnung), überall →5.

### §3.3 Hotel-Journey: Wer bekommt was wann (verbindliche Liefer-Zusagen)

| Moment | Was das Hotel bekommt | Zusage |
|---|---|---|
| Eintrag (Min. 0) | Bestätigungs-Mail (Double-Opt-in), Sprachwahl wirkt ab sofort | sofort |
| Nach Bestätigung | Teaser-Mail mit Ergebnis-Link | < 30 Min (Ziel: < 5 Min) |
| Kauf Vollreport | Report-Mail (Web-Link + PDF) | < 24 h (i. d. R. wenige Stunden) |
| Kauf Optimierungspaket | Report wie oben + alle Optimierungs-Deliverables | Vollautomatik: < 24 h; Operator-Modus: < 5 Werktage (auf Pricing-Seite ausgewiesen) |
| Abo-Start | Portal-Zugang (Magic-Link-Mail) sofort; Report + Optimierungspaket wie oben; Tracking-Snippet + Einbauanleitung | sofort / < 24 h / < 5 Werktage |
| Laufendes Abo | Monats-Report (Mail + Portal) am Monatsanfang; Alerts sofort bei Fund; neue Maßnahmen im Monats-Report | monatlich + ereignisgesteuert |
| 6 Monate nach Einmal-Kauf | Win-back-Vergleichsmail (nur mit Marketing-Einwilligung) | automatisch |

### Stufe 6 — Wiederkehr-Motor (Win-back, automatisch)

6 Monate nach einem Einmal-Kauf (Stufe 2/3) läuft automatisch ein Mini-Re-Audit (Kosten:
Cents) und erzeugt eine personalisierte Win-back-Mail: "Ihr Score im Januar: 6,5 — heute: 5,8.
2 behobene Faktenfehler sind zurückgekehrt, [anonymisiert: ein Wettbewerber] hat Sie überholt."
CTA: das Abo. Voraussetzung: separate Marketing-Einwilligung beim Checkout (Checkbox, nicht
vorangekreuzt). Ohne Einwilligung: kein Re-Audit, keine Mail.

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

**Fixe Struktur, kundenseitig wie im Backend: immer genau 5 Wettbewerber-Slots.**

- **Free (automatisch):** Das System wählt automatisch 5 Wettbewerber (aus den Audit-Antworten:
  wer wird stattdessen empfohlen? + LLM-Filter auf gleiche Kategorie, Preisklasse, Region).
  Findet das Segment weniger als 5 Kandidaten, wird mit den nächstähnlichen aufgefüllt.
  Teaser zeigt sie nur anonymisiert; keine manuelle Wahl in der Free-Version.
- **Bezahlversion (manuell umstellbar):** Käufer/Abo-Kunden können jeden der 5 Slots manuell
  ersetzen (im Portal bzw. nach Report-Kauf); zusätzlich Admin-Override. Änderungen kosten
  keine neuen Abfragen — Scores werden aus den vorhandenen Antworten neu berechnet.
- **Score-Vergleich im Booking-Stil:** kundenseitig überall 10-Punkte-Skala mit einer
  Dezimalstelle ("Sie: 6,5 / 10 — [Wettbewerber]: 7,5 / 10").
- **Lücken-Analyse (Bezahlversion):** pro Wettbewerber die Aufholpunkte, hergeleitet aus dem
  Prompt-Vergleich: bei welchen Anfrage-Typen (Persona/Intent/Sprache) wird der Wettbewerber
  empfohlen und das eigene Hotel nicht → verknüpft mit konkreten Playbook-Maßnahmen
  ("Hier sind die Punkte, mit denen Sie aufholen").

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

**Design-Grundsatz — ein Template, unser CI:** Alle Reports nutzen ein einziges, hochwertiges
Design im CI der Plattform. Hotelspezifisch sind nur Inhalte (Name, Daten), nie das Design.
Kein Hotel-Branding, kein White-Label (frühestens P7 als Agentur-Feature). Vorteile:
Wiedererkennbarkeit der Marke, Vergleichbarkeit, minimaler Pflegeaufwand.

**Erklärbarkeits-Grundsatz — jede Zahl erklärt sich selbst:**
1. Zentrale Erklär-Inhalte (DE/EN, eine Quelle im Code): jede Metrik, jeder Hebel, jeder
   Befund hat einen Kurz-Erklärtext + "Woher kommt das?" — identisch angezeigt in Admin,
   Portal und Reports (Tooltip/Info-Icon bzw. Glossar-Seite).
2. Drill-Down im Admin: Score → beteiligte Prompts → Original-AI-Antwort im Wortlaut.
   Der Betreiber kann jede Zahl bis zur Quelle belegen.
3. Wissensbasis "Methodik & Hebel" im Admin: pro Hebel H1–H6 eine Klartext-Seite (was er
   macht, warum er wirkt, welche Plattform, typische Hotelier-Rückfragen mit Antworten) —
   zugleich Sales-Enablement für Beratungsgespräche.

## 6. Sprachen

- **UI-/Report-Sprache (gepinnt):** Beim Eintrag (Stufe 0) wählt der Nutzer DE oder EN
  (vorbelegt aus Browser-Sprache). Das Hotel wird darauf **gepinnt**: alle Mails, Teaser,
  Reports, Portal erscheinen konsistent in dieser Sprache. Änderbar im Portal/Admin, wechselt
  nie automatisch.
- **Audit-Sprachen (davon getrennt) — fixe Struktur: 5 Slots.**
  **Free:** 2 Slots, automatisch belegt mit **Landessprache des Hotels + Englisch**
  (DACH-Hotel: DE+EN; italienisches Hotel: IT+EN), keine Wahlmöglichkeit.
  **Ab Kauf/Abo:** alle 5 Slots **frei belegbar** — auch die Defaults sind austauschbar
  (ein Hotel mit rein internationalem Publikum braucht ggf. kein Deutsch). Sprachen:
  KO/ZH/JA/FR/IT/NL/ES/DA/PL/….
- **Gästemix-Sprachberatung (Bezahlversion):** Beim Kauf/Abo wird der Gästemix abgefragt
  ("Woher kommen Ihre Gäste hauptsächlich?"). Das Playbook vergleicht Gästemix mit
  Sichtbarkeit pro Sprache und empfiehlt konkret: Inhalte in Sprache X erstellen/übersetzen,
  Sprache Y ins Monitoring aufnehmen ("22 % US-Gäste, aber Sichtbarkeit bei englischen
  Anfragen nur 3,1/10"). Maßnahmentyp unter Hebel H2; natürlicher Abo-Upsell.
- Funnel-Website zunächst DE, EN folgt.

## 7. Erfolgskriterien

| Metrik | Ziel (erste 6 Monate nach Launch) |
|---|---|
| Conversion Eintrag → verifizierter Lead | > 60 % |
| Conversion Lead → zahlender Kunde (Stufe 2+) | > 5 % |
| API-Kosten Mini-Audit | < 0,10 € |
| API-Kosten Voll-Audit | < 9 € |
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

---
layout: default
title: BaseApp Basic User Guide
---

<div class="hero-section">
  <h1>⚙️ walter75 - BaseApp Basic User Guide</h1>
  <p class="hero-tagline">Comprehensive foundation app for all business areas</p>
  <div class="badge-container">
    <span class="badge">v27.0</span>
    <span class="badge">Foundation</span>
    <span class="badge">Cloud</span>
  </div>
</div>

---

## 📋 Overview

Die **walter75 - BaseApp Basic** ist die Basis-Erweiterung für Microsoft Dynamics 365 Business Central. Sie bietet umfangreiche Funktionen zur Optimierung von Geschäftsprozessen in allen Unternehmensbereichen.

<div class="info-box info-box-primary">
  <p><strong>Systemvoraussetzungen:</strong></p>
  <ul>
    <li><strong>Version:</strong> 27.0 oder höher</li>
    <li><strong>Plattform:</strong> Cloud</li>
    <li><strong>Runtime:</strong> 16.0</li>
    <li><strong>ID Range:</strong> 80000-80099</li>
  </ul>
</div>

## 🎯 Hauptfunktionen im Überblick

<div class="feature-grid">
  <div class="feature-card">
    <h3>💼 Vertrieb</h3>
    <p>Kundengruppen, Warnhinweise, automatische Stücklistenauflösung, Verfügbarkeitsprüfung, Dokumenttexte</p>
  </div>
  <div class="feature-card">
    <h3>🛒 Einkauf</h3>
    <p>Lieferantenwarnungen, erweiterte Bestellberichte</p>
  </div>
  <div class="feature-card">
    <h3>💰 Finanzen</h3>
    <p>Kontenzweck-Dokumentation, erweiterte Mahnungsberichte</p>
  </div>
  <div class="feature-card">
    <h3>📦 Lager</h3>
    <p>Regalplatzverwaltung, erweiterte Trackingfelder</p>
  </div>
  <div class="feature-card">
    <h3>🏭 Produktion</h3>
    <p>Automatische Stücklisten- und Arbeitspläne, Arbeitsgangstatistiken</p>
  </div>
  <div class="feature-card">
    <h3>👥 CRM</h3>
    <p>Automatische Gebietszuordnung, Kontaktverwaltung, Verkäuferverteilung</p>
  </div>
  <div class="feature-card">
    <h3>📊 Dimensionen</h3>
    <p>Automatische Dimensionswerte aus Stammdaten</p>
  </div>
  <div class="feature-card">
    <h3>⚙️ Administration</h3>
    <p>Zentrale Benutzerverwaltung, Unternehmensbranding</p>
  </div>
</div>

---

## 📚 Inhaltsverzeichnis

<div class="toc-grid">
  <div class="toc-section">
    <h4>📦 Geschäftsbereiche</h4>
    <ul>
      <li><a href="#vertrieb">Vertrieb</a></li>
      <li><a href="#einkauf">Einkauf</a></li>
      <li><a href="#finanzen">Finanzen</a></li>
      <li><a href="#lager">Lager</a></li>
      <li><a href="#produktion">Produktion</a></li>
    </ul>
  </div>
  <div class="toc-section">
    <h4>👥 Erweiterte Funktionen</h4>
    <ul>
      <li><a href="#crm--kontakte">CRM & Kontakte</a></li>
      <li><a href="#automatische-dimensionen">Automatische Dimensionen</a></li>
      <li><a href="#administration">Administration</a></li>
      <li><a href="#systemeinstellungen">Systemeinstellungen</a></li>
    </ul>
  </div>
</div>

---

## Vertrieb

### 1. Kundengruppen

**Funktion:** Kategorisieren Sie Ihre Kunden in individuelle Gruppen für besseres Reporting und Filterung.

**So verwenden Sie Kundengruppen:**

1. Suchen Sie nach **"Kundengruppen"** in Business Central
2. Legen Sie neue Kundengruppen mit Code und Beschreibung an
3. Öffnen Sie die **Debitorenkarte**
4. Weisen Sie die gewünschte Kundengruppe zu

![Screenshot: Kundengruppen-Liste]
*Platzhalter für Screenshot der Kundengruppenübersicht*

![Screenshot: Kundengruppe auf Debitorenkarte]
*Platzhalter für Screenshot der Kundengruppenzuweisung auf der Debitorenkarte*

**Vorteile:**
- Segmentierung für Marketing und Vertrieb
- Verbesserte Filterung in Listen und Berichten
- Individuelle Analysen nach Kundengruppen

---

### 2. Kundenwarnungen

**Funktion:** Zeigen Sie automatische Warnmeldungen an, wenn ein Debitor in einem Verkaufsbeleg ausgewählt wird.

**Einrichtung:**

1. Öffnen Sie die **Debitorenkarte**
2. Im Reiter **Allgemein** finden Sie das Feld **"Warntext"**
3. Geben Sie einen mehrzeiligen Warntext ein
4. Speichern Sie die Karte

![Screenshot: Warntext auf Debitorenkarte]
*Platzhalter für Screenshot des Warntextfeldes*

**Verwendung:**

- Beim Auswählen eines Debitors mit Warntext in einem Verkaufsauftrag erscheint automatisch eine Warnmeldung
- Der Benutzer wird über wichtige Informationen informiert (z.B. Zahlungsverzug, Lieferbeschränkungen)

![Screenshot: Warnmeldung bei Debitorenauswahl]
*Platzhalter für Screenshot der Warnmeldung im Verkaufsauftrag*

---

### 3. Debitor Masterstammnummer

**Funktion:** Verwalten Sie Debitorenhierarchien durch Verknüpfung von Unterdebitoren mit einem Masterdebitor.

**So verwenden Sie die Funktion:**

1. Öffnen Sie die **Debitorenkarte**
2. Nach dem Feld **"Suchbegriff"** finden Sie das Feld **"Masterstamm-Nr."**
3. Wählen Sie den übergeordneten Debitor aus
4. Das System verknüpft beide Debitoren für Reporting und Analysen

![Screenshot: Masterstammnummer auf Debitorenkarte]
*Platzhalter für Screenshot der Masterstammnummer*

**Anwendungsfälle:**
- Konzernstrukturen abbilden
- Filialverwaltung
- Konzernweite Umsatzanalysen

---

### 4. Artikelverkaufshistorie (Debitor-Infobox)

**Funktion:** Sehen Sie direkt auf der Debitorenkarte, welche Artikel der Kunde bereits gekauft hat.

**So nutzen Sie die Funktion:**

1. Öffnen Sie die **Debitorenkarte**
2. Im rechten Infobox-Bereich finden Sie **"Artikelverkaufshistorie"**
3. Die Liste zeigt alle fakturierten Artikel mit Mengen
4. Klicken Sie auf einen Artikel für weitere Details

![Screenshot: Artikelverkaufshistorie Infobox]
*Platzhalter für Screenshot der Infobox mit Verkaufshistorie*

**Vorteile:**
- Schneller Überblick über Kaufverhalten
- Unterstützung bei Nachbestellungen
- Cross-Selling-Potenziale erkennen

---

### 5. Automatische Stücklistenauflösung

**Funktion:** Lösen Sie Montagestücklisten automatisch auf, ohne manuelle Bestätigung.

**Einrichtung:**

1. Öffnen Sie die **Artikelkarte**
2. Aktivieren Sie die Checkbox **"Automatische Stücklistenauflösung"**
3. Speichern Sie die Änderungen

![Screenshot: Auto-Explode Checkbox auf Artikelkarte]
*Platzhalter für Screenshot der Checkbox auf der Artikelkarte*

**Verwendung:**

- Beim Hinzufügen des Artikels zu einer Verkaufsauftragszeile wird die Montagestückliste automatisch aufgelöst
- Keine manuelle Bestätigung erforderlich
- Beschleunigt den Auftragseingangsprozess

![Screenshot: Aufgelöste Stückliste im Verkaufsauftrag]
*Platzhalter für Screenshot des Verkaufsauftrags mit aufgelöster Stückliste*

---

### 6. Letztes Rechnungsdatum (Artikel)

**Funktion:** Zeigt das Datum der letzten Rechnung für jeden Artikel an.

**So nutzen Sie die Funktion:**

1. Öffnen Sie die **Artikelliste** oder **Artikelkarte**
2. Das Feld **"Datum letzte Rechnung"** wird automatisch berechnet
3. Nutzen Sie es für Filterung und Analysen

![Screenshot: Datum letzte Rechnung in Artikelliste]
*Platzhalter für Screenshot der Artikelliste mit dem Datumsfeld*

**Anwendungsfälle:**
- Identifikation von Ladenhütern
- Sortimentsbereinigung
- Bestandsoptimierung

---

### 7. Rahmenauftragsverfolgung

**Funktion:** Zeigen Sie Rahmenauftragsnummern und -mengen direkt im Verkaufsauftrag an.

**So nutzen Sie die Funktion:**

1. Öffnen Sie einen **Verkaufsauftrag**
2. Vor dem Feld **"Status"** sehen Sie das Feld **"Rahmenauftragsnr."**
3. In den Verkaufszeilen wird die **"Menge im Rahmenauftrag"** angezeigt
4. Behalten Sie den Überblick über verknüpfte Rahmenaufträge

![Screenshot: Rahmenauftrag im Verkaufsauftrag]
*Platzhalter für Screenshot der Rahmenauftragsinformationen*

---

### 8. Dokumenttexte für Verkaufsbelege

**Funktion:** Verwalten Sie wiederverwendbare Textbausteine für Verkaufsbelege mit Sprach-, Datums- und E-Mail-Unterstützung.

**Einrichtung:**

1. Suchen Sie nach **"Dokumenttext Verkauf"**
2. Erstellen Sie neue Texteinträge
3. Definieren Sie:
   - **Belegart** (Angebot, Auftrag, Rechnung, etc.)
   - **Sprachcode** (für mehrsprachige Dokumente)
   - **Position** (Kopf oder Fuß)
   - **Sortierung** (Reihenfolge bei mehreren Texten)
   - **Gültig von/bis** (zeitliche Einschränkung)
   - **E-Mail-Variante** (nur beim E-Mail-Versand verwenden)
   - **Text** (bis zu 250 Zeichen pro Zeile, bis zu 6 Zeilen)

![Screenshot: Dokumenttext Verkauf Liste]
*Platzhalter für Screenshot der Dokumenttext-Verwaltung*

![Screenshot: Dokumenttext Detail]
*Platzhalter für Screenshot eines einzelnen Dokumenttexteintrags*

**Verwendung:**

- Texte werden automatisch in Verkaufsberichte (Rechnung, Angebot, Auftragsbestätigung, Lieferschein, Gutschrift) eingebunden
- Bis zu 6 Kopftexte und 6 Fußtexte pro Dokument
- Sprachabhängige Ausgabe
- Zeitgesteuerte Texte (z.B. Weihnachtsgrüße, Betriebsurlaub)

![Screenshot: Dokumenttext in Rechnung]
*Platzhalter für Screenshot einer gedruckten Rechnung mit Dokumenttexten*

---

### 9. Lieferadressenliste

**Funktion:** Erweiterte Übersicht über alle Lieferadressen.

**So nutzen Sie die Funktion:**

1. Suchen Sie nach **"Lieferadressenliste"**
2. Sehen Sie alle Lieferadressen aller Debitoren auf einen Blick
3. Filtern und durchsuchen Sie die Liste nach Bedarf

![Screenshot: Lieferadressenliste]
*Platzhalter für Screenshot der Lieferadressenliste*

---

### 10. Debitorenbemerkungen Schnellzugriff

**Funktion:** Direkter Zugriff auf Debitorenbemerkungen aus dem Verkaufsauftrag.

**So nutzen Sie die Funktion:**

1. Öffnen Sie einen **Verkaufsauftrag**
2. Gehen Sie zu **Aktionen** → **Debitor** → **Debitorenbemerkungen**
3. Sehen und bearbeiten Sie Bemerkungen ohne die Debitorenkarte zu öffnen

![Screenshot: Debitorenbemerkungen im Verkaufsauftrag]
*Platzhalter für Screenshot des Aktionsmenüs*

---

### 11. Sales Line Availability Management (Verfügbarkeitsprüfung)

**Funktion:** Automatische farbige Markierung von Verkaufszeilen basierend auf Bestandsprüfungen.

**Farbcodierung der Zeilen:**

| Style | Farbe | Bedeutung | Bedingung |
|-------|-------|-----------|-----------|
| **Unfavorable** | 🔴 Rot | Nicht ausreichend verfügbar | Verfügbare Menge < 0 |
| **Favorable** | 🟢 Grün (fett) | Meldebestand unterschritten | Verfügbare Menge < Meldebestand |
| **AttentionAccent** | 🟠 Orange | Lagerbestand unzureichend | Lagerbestand < Auftragsmenge |
| **Ambiguous** | ⚫ Grau | Maximalbestand überschritten | Lager + Bestellung - Aufträge > Maximalbestand **UND Artikelnummer beginnt mit '1'** |
| **None** | ⚪ Standard | Alles in Ordnung | Keine Warnung |

**Priorität und tatsächliches Verhalten der Prüfungen:**

Die Prüfungen werden wie folgt durchgeführt:

1. **ROT**: Negative Verfügbarkeit → Artikel nicht lieferbar (wird sofort angewendet und beendet die Prüfung)
2. **GRÜN**: Meldebestand unterschritten → Nachbestellung erforderlich (wird immer angewendet, wenn die Bedingung erfüllt ist, auch wenn andere Warnungen wie ORANGE zutreffen würden)
3. **ORANGE**: Aktueller Lagerbestand < benötigte Menge → Teillieferung möglich (wird nur angewendet, wenn noch kein Stil gesetzt wurde)
4. **GRAU**: Maximalbestand würde überschritten → Überbestand-Warnung (wird nur angewendet, wenn noch kein Stil gesetzt wurde)
5. **STANDARD**: Keine Probleme (wenn keine der obigen Bedingungen zutrifft)

**Hinweis:** In der tatsächlichen Implementierung überschreibt die GRÜN-Prüfung (Meldebestand unterschritten) andere Warnungen wie ORANGE oder GRAU, falls ihre Bedingung erfüllt ist. Das bedeutet, dass z.B. bei gleichzeitigem Unterschreiten des Meldebestands und unzureichendem Lagerbestand immer GRÜN angezeigt wird.
**Automatische Aktualisierung:**

- Beim Laden der Verkaufszeilen
- Sofort nach Änderung der Menge (beim Verlassen des Feldes)

**Beispiel-Szenarien:**

Ein Kunde bestellt 100 Stück Artikel "10001":

| Bestand | Bestellung | Aufträge | Meldebestand | Maximum | Ergebnis |
|---------|------------|----------|--------------|---------|----------|
| 50 | 0 | 0 | 20 | 200 | 🟠 Orange (Bestand < Menge) |
| 150 | 0 | 0 | 20 | 200 | ⚪ Normal (alles OK) |
| 10 | 0 | 0 | 20 | 200 | 🟢 Grün (Meldebestand) |
| 0 | 0 | 0 | 20 | 200 | 🔴 Rot (nicht verfügbar) |
| 50 | 300 | 0 | 20 | 200 | ⚫ Grau (Maximum überschritten) |

**Vorteile:**
- Sofortige Sichtbarkeit der Verfügbarkeit
- Proaktive Nachbestellungen
- Vermeidung von Überbeständen
- Verbesserte Liefertreue

---

### 12. Erweiterte Verkaufsberichte

**Funktion:** Professionell gestaltete Verkaufsberichte mit Unternehmensbranding und erweiterten Informationen.

**Enthaltene Berichte:**
- Verkaufsrechnung
- Verkaufsangebot
- Verkaufsauftragsbestätigung
- Verkaufslieferschein
- Verkaufsgutschrift

**Erweiterte Funktionen:**

- **Unternehmensbranding:**
  - Firmenlogos (bis zu 5 verschiedene Bilder)
  - Firmenfarben (2 Hauptfarben + 2 Schriftfarben)
  - Benutzerdefinierte Schriftarten (40+ Schriftarten verfügbar)

- **Mehrere Bankverbindungen:**
  - Bis zu 3 Bankverbindungen pro Bericht
  - Bankname, IBAN, SWIFT-Code

- **Dokumenttexte:**
  - Bis zu 6 Kopftexte
  - Bis zu 6 Fußtexte
  - Sprachabhängig

- **Erweiterte Kontaktinformationen:**
  - Ansprechpartner-Anrede
  - Verkäufer-Kontaktdaten
  - Spediteurdetails

- **Versandinformationen:**
  - Lieferadresse prominent dargestellt
  - Zolltarifnummern (nach Einstellung)
  - Ursprungsland (nach Einstellung)

![Screenshot: Erweiterte Verkaufsrechnung]
*Platzhalter für Screenshot einer gedruckten Verkaufsrechnung mit allen Erweiterungen*

![Screenshot: Verkaufsangebot mit Branding]
*Platzhalter für Screenshot eines Verkaufsangebots*

---

## Einkauf

### 12. Lieferantenwarnungen

**Funktion:** Zeigen Sie automatische Warnmeldungen an, wenn ein Lieferant in einem Einkaufsbeleg ausgewählt wird.

**Einrichtung:**

1. Öffnen Sie die **Kreditorenkarte**
2. Im Reiter **Allgemein** finden Sie das Feld **"Warntext"**
3. Geben Sie einen Warntext ein
4. Speichern Sie die Karte

![Screenshot: Warntext auf Kreditorenkarte]
*Platzhalter für Screenshot des Warntextfeldes auf der Kreditorenkarte*

**Verwendung:**

- Beim Auswählen eines Kreditors mit Warntext erscheint eine Meldung
- Wichtige Hinweise (z.B. Lieferbedingungen, Mindestbestellmengen) werden kommuniziert

![Screenshot: Kreditorenwarnung]
*Platzhalter für Screenshot der Warnmeldung*

---

### 13. Kreditor Suchbeschreibung

**Funktion:** Automatisch generierte Suchbegriffe für schnellere Kreditorensuche.

**Verwendung:**

- Das System erstellt automatisch eine Suchbeschreibung aus Kreditorenname und Postleitzahl
- Verbessert die Suchgeschwindigkeit und Treffergenauigkeit
- Wird bei Änderungen automatisch aktualisiert
- Hintergrundprozess - keine Benutzeraktion erforderlich

---

### 14. Erweiterter Bestellbericht

**Funktion:** Professionell gestaltete Bestellberichte mit Unternehmensbranding.

**Funktionen:**

- Firmenlogos und Farben
- Strukturierte Darstellung
- Vollständige Artikelinformationen
- Lieferantendaten

![Screenshot: Erweiterter Bestellbericht]
*Platzhalter für Screenshot einer gedruckten Bestellung*

---

## Finanzen

### 15. Sachkontenzweck

**Funktion:** Dokumentieren Sie den Zweck und die Verwendung von Sachkonten.

**Einrichtung:**

1. Öffnen Sie den **Sachkontenplan**
2. Öffnen Sie eine **Sachkontenkarte**
3. Füllen Sie das Feld **"Kontenzweck"** (bis zu 250 Zeichen)
4. Beschreiben Sie die Verwendung des Kontos

![Screenshot: Kontenzweck auf Sachkontenkarte]
*Platzhalter für Screenshot des Kontenzweckfeldes*

**Vorteile:**
- Bessere Dokumentation des Kontenrahmens
- Einarbeitung neuer Mitarbeiter erleichtern
- Kontenverwendung standardisieren

---

### 16. Erweiterter Mahnungsbericht

**Funktion:** Professionell gestaltete Mahnungsberichte mit Unternehmensbranding.

**Funktionen:**

- Firmenlogos und Farben
- Mehrere Mahnstufen
- Debitorendaten und offene Posten
- Zahlungsbedingungen

![Screenshot: Erweiterter Mahnungsbericht]
*Platzhalter für Screenshot einer Mahnung*

---

## Lager

### 17. Erweiterte Tracking-Felder im Artikel Buch.-Blatt

**Funktion:** Zusätzliche Felder für detailliertes Tracking von Lagerbeständen.

**Verfügbare Felder:**

1. **Chargennummer**
2. **Seriennummer**
3. **Paketnummer**
4. **Ablaufdatum**

**So nutzen Sie die Felder:**

1. Öffnen Sie das **Artikel Buch.-Blatt**
2. Füllen Sie die zusätzlichen Tracking-Felder in den Zeilen aus
3. Buchen Sie das Buch.-Blatt

![Screenshot: Tracking-Felder im Artikel Buch.-Blatt]
*Platzhalter für Screenshot des Artikelbuchblatts mit Tracking-Feldern*

**Vorteile:**
- Detaillierte Nachverfolgbarkeit
- Verbesserte Qualitätskontrolle
- Rückverfolgbarkeit für Audits

---

### 18. Regalplatzverwaltung

**Funktion:** Verwalten Sie Regalplätze für Artikel und zeigen Sie diese auf Lieferscheinen an.

**Einrichtung:**

1. Öffnen Sie die **Lagereinrichtung**
2. Aktivieren Sie **"Regalplatz verwenden"**
3. Öffnen Sie die **Artikelkarte**
4. Geben Sie den **Regalplatz** ein

![Screenshot: Regalplatz-Einstellung in Lagereinrichtung]
*Platzhalter für Screenshot der Lagereinrichtung*

![Screenshot: Regalplatz auf Artikelkarte]
*Platzhalter für Screenshot des Regalplatzfeldes auf der Artikelkarte*

**Verwendung:**

- Der Regalplatz wird automatisch auf Verkaufslieferscheine übertragen
- Kommissionierung wird vereinfacht
- Lagerplätze sind sofort ersichtlich

![Screenshot: Regalplatz auf Lieferschein]
*Platzhalter für Screenshot des Lieferscheins mit Regalplatz*

---

### 19. Erweiterte Lagerberichte

**Funktion:** Optimierte Berichte für Lagervorgänge.

**Enthaltene Berichte:**
- Umlagerungsauftrag
- Kommissionieranweisung

**Funktionen:**

- Übersichtliche Darstellung
- Artikeldetails
- Mengen und Lagerorte
- Unternehmensbranding

![Screenshot: Umlagerungsauftragsbericht]
*Platzhalter für Screenshot eines Umlagerungsauftragsberichts*

---

## Produktion

### 20. Letztes Produktionsdatum (Artikel)

**Funktion:** Zeigt das Datum der letzten Produktion für jeden Artikel an.

**So nutzen Sie die Funktion:**

1. Öffnen Sie die **Artikelliste** oder **Artikelkarte**
2. Das Feld **"Datum letzte Produktion"** wird automatisch aus Fertigungsauftragszeilen berechnet
3. Nutzen Sie es zur Produktionsanalyse

![Screenshot: Datum letzte Produktion]
*Platzhalter für Screenshot des Datumsfeldes auf der Artikelkarte*

**Anwendungsfälle:**
- Produktionsplanung optimieren
- Maschinenlaufzeiten analysieren
- Produktionsfrequenz ermitteln

---

### 21. Automatische Stücklisten- und Arbeitsplanerstellung

**Funktion:** Erstellen Sie automatisch Fertigungsstücklisten und Arbeitspläne beim Umstellen auf "Prod. Auftrag".

**So nutzen Sie die Funktion:**

1. Öffnen Sie die **Artikelkarte**
2. Ändern Sie das **Beschaffungsverfahren** auf **"Prod. Auftrag"**
3. Das System erstellt automatisch:
   - Einen neuen Fertigungsstücklistenkopf
   - Einen neuen Arbeitsplankopf
   - Verknüpft beide mit dem Artikel

![Screenshot: Beschaffungsverfahren auf Artikelkarte]
*Platzhalter für Screenshot des Beschaffungsverfahrens*

![Screenshot: Automatisch erstellte Stückliste]
*Platzhalter für Screenshot der neuen Fertigungsstückliste*

**Vorteile:**
- Zeitersparnis bei der Anlage
- Konsistente Struktur
- Sofortige Produktionsbereitschaft

---

### 22. Arbeitsplatzstatistiken

**Funktion:** Zeigen Sie die Anzahl der Arbeitsgänge nach Status direkt in der Arbeitsplatzliste an.

**Verfügbare Statistiken:**

1. **Anzahl Maschinenzentren** (verknüpft mit diesem Arbeitsplatz)
2. **Anzahl Arbeitsgänge Geplant**
3. **Anzahl Arbeitsgänge Fest Geplant**
4. **Anzahl Arbeitsgänge Freigegeben**

**So nutzen Sie die Funktion:**

1. Öffnen Sie die **Arbeitsplatzliste**
2. Die Statistikfelder werden automatisch berechnet
3. Nutzen Sie die Informationen für Kapazitätsplanung

![Screenshot: Arbeitsplatzstatistiken]
*Platzhalter für Screenshot der Arbeitsplatzliste mit Statistikfeldern*

**Vorteile:**
- Schneller Überblick über Auslastung
- Kapazitätsengpässe erkennen
- Produktionsplanung optimieren

---

### 23. Maschinenplatzstatistiken

**Funktion:** Zeigen Sie die Anzahl der Arbeitsgänge nach Status für Maschinenplätze an.

**Verfügbare Statistiken:**

1. **Anzahl Arbeitsgänge Geplant**
2. **Anzahl Arbeitsgänge Fest Geplant**
3. **Anzahl Arbeitsgänge Freigegeben**

**So nutzen Sie die Funktion:**

1. Öffnen Sie die **Maschinenplatzliste**
2. Die Statistikfelder werden automatisch berechnet
3. Überwachen Sie die Maschinenauslastung

![Screenshot: Maschinenplatzstatistiken]
*Platzhalter für Screenshot der Maschinenplatzliste mit Statistiken*

---

### 24. Produktionsarbeitsgangsliste

**Funktion:** Umfassende Übersicht über alle Arbeitsgänge in allen Fertigungsaufträgen.

**So nutzen Sie die Funktion:**

1. Suchen Sie nach **"Produktionsarbeitsgangsliste"**
2. Sehen Sie alle Arbeitsgänge über alle FA hinweg
3. Filtern Sie nach:
   - Arbeitsplatz/Maschinenplatz
   - Status
   - Fertigungsauftragsnummer
   - Datum

![Screenshot: Produktionsarbeitsgangsliste]
*Platzhalter für Screenshot der Produktionsarbeitsgangsliste*

**Vorteile:**
- Zentrale Übersicht über alle Arbeitsgänge
- Verbesserte Produktionssteuerung
- Schnellere Problemerkennung

---

## CRM & Kontakte

### 25. Automatische Gebietszuordnung

**Funktion:** Weisen Sie Debitoren und Kontakten automatisch Gebiete, Servicezonen und Verkäufer basierend auf Postleitzahl oder Land zu.

**Einrichtung:**

#### Schritt 1: Gebiete mit Verkäufern verknüpfen

1. Öffnen Sie die **Gebietsliste**
2. Wählen Sie ein Gebiet aus
3. Füllen Sie das Feld **"Verkäufer/Einkäufer"** aus

![Screenshot: Gebiet mit Verkäufer]
*Platzhalter für Screenshot der Gebietskarte mit Verkäuferfeld*

#### Schritt 2: Postleitzahlen einrichten

1. Öffnen Sie die **Postleitzahlenliste**
2. Für jede Postleitzahl weisen Sie zu:
   - **Gebietscode**
   - **Servicegebietscode**
3. Speichern Sie die Änderungen

![Screenshot: Postleitzahl mit Gebieten]
*Platzhalter für Screenshot der Postleitzahlenkarte mit Gebietszuweisung*

#### Schritt 3: Länder einrichten (Alternative für Ausland)

1. Öffnen Sie **Länder/Regionen**
2. Für jedes Land weisen Sie zu:
   - **Gebietscode**
   - **Servicegebietscode**
3. Wird verwendet, wenn keine spezifische Postleitzahl gefunden wird

![Screenshot: Land mit Gebieten]
*Platzhalter für Screenshot der Länder-/Regionskarte*

**Verwendung:**

- Beim Anlegen oder Ändern eines Debitors/Kontakts werden automatisch zugewiesen:
  - Gebiet (aus PLZ oder Land)
  - Servicegebiet (aus PLZ oder Land)
  - Verkäufer (aus Gebiet)

- **Manuelle Überschreibung möglich:**
  - Auf der Debitorenkarte finden Sie Checkboxen:
    - "Gebiet manuell"
    - "Servicegebiet manuell"
    - "Verkäufer manuell"
  - Aktivieren Sie diese, um die automatische Zuweisung zu deaktivieren

![Screenshot: Debitorenkarte mit automatischer Gebietszuweisung]
*Platzhalter für Screenshot der Debitorenkarte mit Gebietsfeldern*

![Screenshot: Manuelle Überschreibung Checkboxen]
*Platzhalter für Screenshot der manuellen Überschreibungscheckboxen*

**Vorteile:**
- Konsistente Gebietszuweisung
- Automatische Verkäuferzuordnung
- Zeitersparnis bei Stammdatenpflege
- Klare Verantwortlichkeiten

---

### 26. Massen-Update von Verkäufern in Gebieten

**Funktion:** Aktualisieren Sie alle Kontakte und Debitoren in einem Gebiet mit einem neuen Verkäufer in einem Vorgang.

**So nutzen Sie die Funktion:**

1. Öffnen Sie die **Gebietsliste**
2. Wählen Sie das Gebiet aus
3. Ändern Sie den **Verkäufer/Einkäufer**
4. Klicken Sie auf **Aktionen** → **"Verkäufer aktualisieren"**
5. Wählen Sie aus:
   - Kontakte aktualisieren
   - Debitoren aktualisieren
   - Offene Verkaufsaufträge aktualisieren
   - Offene Verkaufsangebote aktualisieren

![Screenshot: Verkäufer aktualisieren Aktion]
*Platzhalter für Screenshot der Aktion in der Gebietsliste*

![Screenshot: Update-Dialog]
*Platzhalter für Screenshot des Dialogs mit Optionen*

**Anwendungsfälle:**
- Verkäufergebiete neu zuordnen
- Nachfolge bei Mitarbeiterwechsel
- Urlaubsvertretungen einrichten

---

### 27. Fehlende Postleitzahlen aus Kontakten erstellen

**Funktion:** Scannen Sie alle Kontakte und erstellen Sie automatisch fehlende Postleitzahleneinträge.

**So nutzen Sie die Funktion:**

1. Führen Sie die Codeunit **80023 "SEW Territories Processing"** aus
2. Funktion: **CreatePostCodesFromContacts**
3. Das System durchsucht alle Kontakte
4. Fehlende Postleitzahlen werden angelegt

![Screenshot: Codeunit Ausführung]
*Platzhalter für Screenshot der Codeunit-Ausführung*

**Vorteile:**
- Vollständiger Postleitzahlenstamm
- Basis für automatische Gebietszuordnung
- Einmalige Datenpflegeaktion

---

### 28. Kontakttitel

**Funktion:** Erweitern Sie die Standardanrede um individuelle Kontakttitel.

**Einrichtung:**

1. Suchen Sie nach **"Kontakttitel"**
2. Legen Sie neue Titel an (z.B. "Prof. Dr.", "Dipl.-Ing.", "MBA")
3. Geben Sie Code und Beschreibung ein

![Screenshot: Kontakttitel-Liste]
*Platzhalter für Screenshot der Kontakttitelliste*

**Verwendung:**

1. Öffnen Sie die **Kontaktkarte**
2. Wählen Sie den **Kontakttitel** aus der Liste
3. Der Titel wird in Berichten und Anschreiben verwendet

![Screenshot: Kontakttitel auf Kontaktkarte]
*Platzhalter für Screenshot des Titelfeldes auf der Kontaktkarte*

**Vorteile:**
- Professionelle Ansprache
- Akademische Grade berücksichtigen
- Personalisierte Kommunikation

---

### 29. Kontakt-Debitor/Kreditor-Verknüpfungen

**Funktion:** Sehen Sie die verknüpften Debitoren-/Kreditorennummern direkt auf der Kontaktkarte mit Drill-Down.

**So nutzen Sie die Funktion:**

1. Öffnen Sie eine **Kontaktkarte** (Firma)
2. Im Bereich **"Debitor / Kreditor"** sehen Sie:
   - **Debitorennr.** (falls verknüpft)
   - **Kreditorennr.** (falls verknüpft)
3. Klicken Sie auf die Nummer für Drill-Down zur Debitor-/Kreditorenkarte

![Screenshot: Debitor/Kreditor-Verknüpfung auf Kontaktkarte]
*Platzhalter für Screenshot der Verknüpfungsfelder*

![Screenshot: Drill-Down zur Debitorenkarte]
*Platzhalter für Screenshot des Drill-Downs*

**Vorteile:**
- Schneller Zugriff auf Geschäftsbeziehungen
- Keine Navigation über Menüs notwendig
- Klare Sicht auf CRM-ERP-Verbindungen

---

### 30. Kontaktpersonen-Schnellerfassung

**Funktion:** Erstellen Sie neue Kontaktpersonen direkt aus der Kontaktkarte (Firma) mit Teilformular.

**So nutzen Sie die Funktion:**

1. Öffnen Sie eine **Kontaktkarte** (Typ: Firma)
2. Scrollen Sie zum Teilformular **"Kontaktpersonen"**
3. Sehen Sie alle verknüpften Kontaktpersonen
4. Klicken Sie auf **Aktionen** → **"Kontaktperson erstellen"**
5. Das System legt eine neue Person mit Verknüpfung zur Firma an

![Screenshot: Kontaktpersonen-Teilformular]
*Platzhalter für Screenshot des Teilformulars auf der Kontaktkarte*

![Screenshot: Kontaktperson erstellen Aktion]
*Platzhalter für Screenshot der Aktion*

**Vorteile:**
- Schnellere Erfassung von Ansprechpartnern
- Automatische Verknüpfung zur Firma
- Übersichtliche Darstellung aller Personen

---

### 31. Kontaktsuche nach Nachnamen

**Funktion:** Optimierte Suchfunktion durch zusätzlichen Index auf Nachname.

**Verwendung:**

- Bei der Kontaktsuche wird automatisch auch nach Nachnamen durchsucht
- Verbesserte Performance bei großen Kontaktdatenbanken
- Hintergrundoptimierung - keine Benutzeraktion erforderlich

---

## Automatische Dimensionen

### 32. Automatische Dimensionsverwaltung

**Funktion:** Erstellen und aktualisieren Sie Dimensionswerte automatisch aus Stammdaten (Debitoren, Gebiete, Artikel, Artikelkategorien, Verkäufer, Kampagnen).

**Einrichtung:**

1. Suchen Sie nach **"Automatische Dimensionseinrichtung"**
2. Legen Sie die Zuordnung fest:
   - **Debitorendimensionscode** (z.B. "KUNDE")
   - **Gebietsdimensionscode** (z.B. "GEBIET")
   - **Artikeldimensionscode** (z.B. "ARTIKEL")
   - **Artikelkategoriedimensionscode** (z.B. "WARENGRUPPE")
   - **Kampagnendimensionscode** (z.B. "KAMPAGNE")
   - **Verkäufer-/Einkäuferdimensionscode** (z.B. "VERKAEUFER")

![Screenshot: Automatische Dimensionseinrichtung]
*Platzhalter für Screenshot der Einrichtungsseite*

**Funktionen:**

#### Dimensionswerte erstellen/aktualisieren (alle)

1. Öffnen Sie **"Automatische Dimensionseinrichtung"**
2. Klicken Sie auf **Aktionen** → **"Dimensionen erstellen/aktualisieren"**
3. Das System:
   - Erstellt fehlende Dimensionswerte aus allen Stammdaten
   - Aktualisiert Beschreibungen bei Änderungen
   - Synchronisiert alle konfigurierten Dimensionen

![Screenshot: Dimensionen erstellen Aktion]
*Platzhalter für Screenshot der Aktion*

#### Gebietsdimensionen aktualisieren

1. Klicken Sie auf **"Gebietsdimensionen erstellen/aktualisieren"**
2. Aktualisiert nur Dimensionswerte für Gebiete

#### Artikeldimensionen aktualisieren

1. Klicken Sie auf **"Artikeldimensionen erstellen/aktualisieren"**
2. Aktualisiert nur Dimensionswerte für Artikel und Artikelkategorien

**Automatische Aktualisierung:**

- Bei Änderung von Stammdaten (Name, Beschreibung) werden Dimensionswerte automatisch aktualisiert
- Bei Löschen von Stammdaten werden zugehörige Dimensionswerte bereinigt
- Keine manuelle Nachpflege erforderlich

![Screenshot: Dimensionswerte-Liste]
*Platzhalter für Screenshot der automatisch erstellten Dimensionswerte*

**Vorteile:**
- Konsistente Dimensionswerte
- Zeitersparnis bei Stammdatenpflege
- Automatische Synchronisation
- Vermeidung von Tippfehlern
- Vollständige Dimensionsabdeckung

**Anwendungsfälle:**
- Umsatzanalyse nach Debitoren (automatisch aus Debitorenstamm)
- Deckungsbeitragsrechnung nach Artikeln (automatisch aus Artikelstamm)
- Vertriebsauswertung nach Gebieten (automatisch aus Gebietsstamm)
- Kampagnencontrolling (automatisch aus Kampagnenstamm)

---

## Administration

### 33. Benutzerverwaltung (Übersicht)

**Funktion:** Zentrale Übersicht über alle benutzerbezogenen Einrichtungen in einem Fenster.

**So nutzen Sie die Funktion:**

1. Suchen Sie nach **"Benutzerverwaltung"**
2. Sehen Sie alle Benutzereinrichtungen auf einen Blick:
   - **Benutzereinrichtung** (allgemeine Einstellungen)
   - **Buchhaltungseinrichtung** (Finanzeinstellungen)
   - **Genehmigungsbenutzereinrichtung**
   - **Lagerortbenutzer**
   - **Anlagenbenutzereinrichtung**
   - **Ressourcenbenutzereinrichtung**
   - **Mitarbeitereinrichtung**
   - **Verkäufer/Einkäufer**
3. Drill-Down zu den jeweiligen Einrichtungsseiten durch Klick

![Screenshot: Benutzerverwaltung Übersicht]
*Platzhalter für Screenshot der Benutzerverwaltungsseite*

**Vorteile:**
- Zentrale Anlaufstelle für alle Benutzereinrichtungen
- Schneller Überblick über Berechtigungen
- Kein Suchen in verschiedenen Menüs
- Ideal für Administratoren

---

### 34. Erweiterte Postleitzahlenverwaltung

**Funktion:** Erweiterte Postleitzahlenseite mit zusätzlichen Feldern für Gebiete und Servicezonen.

**So nutzen Sie die Funktion:**

1. Öffnen Sie die **Postleitzahlenliste**
2. Zusätzliche Felder verfügbar (siehe [Automatische Gebietszuordnung](#25-automatische-gebietszuordnung))

---

## Systemeinstellungen

### 35. Toolbox-Einrichtung (Feature-Schalter)

**Funktion:** Zentrale Steuerung zum Aktivieren/Deaktivieren von Feature-Modulen.

**So nutzen Sie die Funktion:**

1. Suchen Sie nach **"Toolbox-Einrichtung"**
2. Aktivieren oder deaktivieren Sie Feature-Gruppen:
   - **CRM aktivieren** (Gebiete, Kontakte, Verkäufer)
   - **Finanzen aktivieren** (Kontenzweck, Mahnungen)
   - **Lager aktivieren** (Regalplätze, Tracking)
   - **Produktion aktivieren** (Stücklisten, Arbeitsgänge)
   - **Einkauf aktivieren** (Lieferantenwarnungen)
   - **Verkauf aktivieren** (Kundengruppen, Dokumenttexte)

![Screenshot: Toolbox-Einrichtung]
*Platzhalter für Screenshot der Toolbox-Einrichtungsseite*

**Vorteile:**
- Aktivieren Sie nur benötigte Funktionen
- Vereinfachte Benutzeroberfläche
- Performance-Optimierung
- Individuelle Systemanpassung

---

### 36. Erweiterte Unternehmensinformationen

**Funktion:** Umfangreiche Firmeninformationen für professionelle Berichte und Dokumente.

**Einrichtung:**

1. Öffnen Sie die **Unternehmensinformationen**
2. Füllen Sie die erweiterten Felder aus:

#### Dokumenttexte (für alle Berichte)

- **6 Kopftexte** (Dokumentkopftext 01-06)
- **6 Fußtexte** (Dokumentfußtext 01-06)
- Jeweils bis zu 250 Zeichen

![Screenshot: Dokumenttexte in Unternehmensinformationen]
*Platzhalter für Screenshot der Dokumenttextfelder*

#### Bankverbindungen

- **Bank 02:**
  - Bankname 02
  - Bankleitzahl 02
  - Kontonummer 02
  - IBAN 02
  - SWIFT-Code 02
- **Bank 03:**
  - Bankname 03
  - Bankleitzahl 03
  - Kontonummer 03
  - IBAN 03
  - SWIFT-Code 03

![Screenshot: Bankverbindungen]
*Platzhalter für Screenshot der Bankverbindungsfelder*

#### Firmenbilder (bis zu 5 Logos)

- **Firmenbild 02**
- **Firmenbild 03**
- **Firmenbild 04**
- **Firmenbild 05**
- Nutzen Sie verschiedene Logos für unterschiedliche Dokumenttypen

![Screenshot: Firmenbilder]
*Platzhalter für Screenshot der Bildfelder*

#### Firmenfarben & Schriftarten

- **Firmenfarbe 01** (RGB-Code, z.B. "0;120;215")
- **Firmenfarbe 02**
- **Schriftfarbe 01**
- **Schriftfarbe 02**
- **Firmenschriftart 01** (aus über 40 Schriftarten wählen)
- **Firmenschriftart 02**

![Screenshot: Farben und Schriftarten]
*Platzhalter für Screenshot der Branding-Felder*

#### Rechtliche Informationen

- **Handelsregister** (z.B. "Amtsgericht München HRB 123456")
- **Geschäftsführer** (Namen der Geschäftsführung)
- **URL AGB** (Link zu allgemeinen Geschäftsbedingungen)
- **URL Datenschutz** (Link zu Datenschutzerklärung)

![Screenshot: Rechtliche Informationen]
*Platzhalter für Screenshot der rechtlichen Felder*

**Verwendung:**

- Alle Informationen werden automatisch in Berichte übernommen
- Konsistentes Corporate Design
- Professionelle Dokumentengestaltung
- Einmalige Einrichtung, überall verfügbar

---

### 37. Report-Schriftarten (Enumeration)

**Funktion:** Standardisierte Schriftartenauswahl für alle Berichte.

**Verfügbare Schriftarten (Auswahl):**

- Aptos
- Aptos Display
- Arial
- Calibri
- Cambria
- Courier New
- Georgia
- Helvetica
- Segoe UI
- Tahoma
- Times New Roman
- Verdana
- ... und über 30 weitere

**Verwendung:**

- In Unternehmensinformationen wählen Sie die gewünschten Schriftarten
- Alle Berichte verwenden diese konsistent
- Erweiterbar durch andere Apps

---

### 38. Report-Hilfsfunktionen

**Funktion:** Zentrale Hilfsfunktionen für alle Berichte.

**Enthaltene Funktionen:**

1. **Lieferadressengleichheit prüfen**
   - Vergleicht Lieferadresse mit Rechnungsadresse
   - Unterdrückt redundante Adressausgabe

2. **Dokumenttext abrufen**
   - Ruft passende Dokumenttexte für Berichte ab
   - Berücksichtigt Sprache, Datum, Belegart

3. **Kontaktanrede**
   - Generiert korrekte Anrede für Kontakte
   - Berücksichtigt Titel und Geschlecht

4. **Schriftartname auflösen**
   - Konvertiert Schriftarten-Enum in Schriftartnamen

5. **Zolltarifnummerndruck steuern**
   - Prüft, ob Tarifnummern gedruckt werden sollen
   - Basiert auf MwSt.-Geschäftsbuchungsgruppe

**Verwendung:**

- Automatisch in allen erweiterten Berichten integriert
- Keine manuelle Konfiguration erforderlich

---

### 39. MwSt.-Geschäftsbuchungsgruppen-Drucksteuerung

**Funktion:** Steuern Sie, ob Zolltarifnummern und Ursprungsländer auf Belegen gedruckt werden.

**Einrichtung:**

1. Öffnen Sie **MwSt.-Geschäftsbuchungsgruppen**
2. Für jede Gruppe konfigurieren Sie:
   - **Zolltarifnummer drucken (Lieferschein)**
   - **Zolltarifnummer drucken (Rechnung)**
   - **Ursprungsland drucken (Lieferschein)**
   - **Ursprungsland drucken (Rechnung)**

![Screenshot: MwSt.-Geschäftsbuchungsgruppe mit Drucksteuerung]
*Platzhalter für Screenshot der Drucksteuerungsfelder*

**Anwendungsfälle:**
- Inlandslieferungen: Keine Tarifnummern erforderlich
- EU-Lieferungen: Tarifnummern und Ursprungsland erforderlich
- Drittländer: Vollständige Zollangaben

**Verwendung:**

- Basierend auf der MwSt.-Geschäftsbuchungsgruppe des Debitors werden die Felder automatisch ein-/ausgeblendet
- Automatische Steuerung in allen Verkaufsberichten

---

### 40. Regalplatz auf Verkaufslieferschein

**Funktion:** Automatisches Kopieren des Artikelregalplatzes auf Verkaufslieferscheinzeilen.

**Verwendung:**

- Beim Buchen eines Verkaufsauftrags wird der Regalplatz vom Artikel auf die Lieferscheinzeile kopiert
- Kommissionierer sehen den Lagerort direkt auf dem Lieferschein
- Automatischer Hintergrundprozess

![Screenshot: Regalplatz auf Lieferschein]
*Platzhalter für Screenshot eines gebuchten Lieferscheins mit Regalplatz*

---

## 📖 Weitere Dokumentation

<div class="doc-links">
  <a href="baseapp.html" class="doc-link">
    <span class="doc-icon">📚</span>
    <div>
      <strong>Technische Dokumentation</strong>
      <p>Architektur, API-Details und Entwickler-Guide</p>
    </div>
  </a>
  <a href="../../CHANGELOG.md" class="doc-link">
    <span class="doc-icon">📋</span>
    <div>
      <strong>Änderungsprotokoll</strong>
      <p>Versionshistorie und Release Notes</p>
    </div>
  </a>
  <a href="../../index.html" class="doc-link">
    <span class="doc-icon">🏠</span>
    <div>
      <strong>Alle Erweiterungen</strong>
      <p>Zurück zur Übersicht</p>
    </div>
  </a>
</div>

---

<div class="footer-info">
  <p><strong>Version:</strong> 27.0.0.0 | <strong>Publisher:</strong> walter75 - München</p>
  <p><strong>Support:</strong> <a href="https://www.walter75.de">www.walter75.de</a> | <a href="https://github.com/walter75-Consulting/Business-Central-Apps/issues">GitHub Issues</a></p>
  <p><strong>© 2024 walter75 - München.</strong> Alle Rechte vorbehalten.</p>
</div>

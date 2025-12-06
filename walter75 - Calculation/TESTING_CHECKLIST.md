# Testing Checklist - Phase 0 Foundation

## ⚙️ Voraussetzungen

- [ ] AL-Go Container läuft (`.\localDevEnv.ps1` aus `.AL-Go` Ordner)
- [ ] walter75 - Calculation App im Container deployed
- [ ] Sales & Receivables Setup geöffnet

---

## 1️⃣ Number Series Konfiguration

### Sales & Receivables Setup
- [ ] Sales Setup öffnen (Suche: "Sales & Receivables Setup")
- [ ] Neues FastTab "SEW Calculation" sichtbar
- [ ] Feld "SEW Calc Nos." vorhanden
- [ ] Number Series auswählen (z.B. "CALC" anlegen via Number Series)
  - [ ] Neue Number Series "CALC" erstellen
  - [ ] Starting No.: CALC0001
  - [ ] Ending No.: CALC9999
  - [ ] Increment-by No.: 1
- [ ] "SEW Calc Nos." = "CALC" setzen und speichern

**Erwartetes Ergebnis:** ✅ Konfiguration gespeichert ohne Fehler

---

## 2️⃣ Variables (Variablen)

### Variable Liste öffnen
- [ ] Suche: "SEW Calc Variables" oder "Calculation Variables"
- [ ] Page öffnet sich (List Page)
- [ ] Actions: New, Edit, Delete sichtbar

### Neue Variable erstellen - Prozentual
- [ ] **New** klicken
- [ ] Code: `MARGE-1`
- [ ] Description: `Margin Percentage`
- [ ] Type: `Percentage`
- [ ] Value: `25` (= 25%)
- [ ] Base: `Total Cost`
- [ ] Valid From Date: `01.01.2025`
- [ ] Valid To Date: `31.12.2025`
- [ ] Global: `Yes`
- [ ] Speichern

**Erwartetes Ergebnis:** ✅ Variable gespeichert, in Liste sichtbar

### Neue Variable erstellen - Absolut
- [ ] **New** klicken
- [ ] Code: `SETUP-FIX`
- [ ] Description: `Setup Cost Fixed`
- [ ] Type: `Absolute Value`
- [ ] Value: `150.00`
- [ ] Base: `None`
- [ ] Valid From Date: `01.01.2025`
- [ ] Global: `Yes`
- [ ] Speichern

**Erwartetes Ergebnis:** ✅ Variable gespeichert, in Liste sichtbar

### Neue Variable erstellen - Factor
- [ ] **New** klicken
- [ ] Code: `OVERHEAD-FACTOR`
- [ ] Description: `Overhead Multiplier`
- [ ] Type: `Factor`
- [ ] Value: `1.2` (= 20% Aufschlag)
- [ ] Base: `Overhead`
- [ ] Global: `Yes`
- [ ] Speichern

**Erwartetes Ergebnis:** ✅ Variable gespeichert, Liste zeigt 3 Variablen

---

## 3️⃣ Templates (Vorlagen)

### Template Liste öffnen
- [ ] Suche: "SEW Calc Templates" oder "Calculation Templates"
- [ ] Page öffnet sich (List Page)
- [ ] Actions: New, Edit, Delete sichtbar

### Neues Template erstellen - Einfache Kalkulation
- [ ] **New** klicken → Template Card öffnet sich
- [ ] Code: `STANDARD`
- [ ] Description: `Standard Calculation Template`
- [ ] Price Source Item: `Unit Cost`
- [ ] Price Source Capacity: `Work Center Direct Unit Cost`
- [ ] Include Material: `Yes`
- [ ] Include Labor: `Yes`
- [ ] Include Overhead: `Yes`
- [ ] Status: `Draft`
- [ ] Speichern

**Erwartetes Ergebnis:** ✅ Template Card gespeichert, SubPage (Lines) sichtbar

### Template Lines hinzufügen

#### Line 1 - Header
- [ ] Im SubPage "Lines": **New Line**
- [ ] Line No.: `10000`
- [ ] Type: `Header`
- [ ] Description: `Material Costs`
- [ ] Bold: `Yes`
- [ ] Show in Report: `Yes`
- [ ] Speichern

#### Line 2 - Material
- [ ] **New Line**
- [ ] Line No.: `20000`
- [ ] Type: `Material`
- [ ] Description: `Raw Materials`
- [ ] Indentation: `1`
- [ ] Show in Report: `Yes`
- [ ] Speichern

#### Line 3 - Sum Line
- [ ] **New Line**
- [ ] Line No.: `30000`
- [ ] Type: `Sum Line`
- [ ] Description: `Total Material`
- [ ] Bold: `Yes`
- [ ] Show in Report: `Yes`
- [ ] Speichern

#### Line 4 - Header
- [ ] **New Line**
- [ ] Line No.: `40000`
- [ ] Type: `Header`
- [ ] Description: `Labor Costs`
- [ ] Bold: `Yes`
- [ ] Show in Report: `Yes`
- [ ] Speichern

#### Line 5 - Labor
- [ ] **New Line**
- [ ] Line No.: `50000`
- [ ] Type: `Labor`
- [ ] Description: `Work Center Costs`
- [ ] Indentation: `1`
- [ ] Show in Report: `Yes`
- [ ] Speichern

#### Line 6 - Formula with Variable
- [ ] **New Line**
- [ ] Line No.: `60000`
- [ ] Type: `Formula`
- [ ] Description: `Overhead Calculation`
- [ ] Formula: `OVERHEAD * {OVERHEAD-FACTOR}`
- [ ] Variable Code: `OVERHEAD-FACTOR`
- [ ] Show in Report: `Yes`
- [ ] Speichern

**Erwartetes Ergebnis:** ✅ 6 Lines im SubPage sichtbar, Tree-Struktur mit Einrückungen erkennbar

### Template Status ändern
- [ ] Template Card: Actions → **Release**
- [ ] Status wechselt zu `Released`
- [ ] Template ist nicht mehr editierbar (außer Description)

**Erwartetes Ergebnis:** ✅ Status = Released, Felder schreibgeschützt

- [ ] Actions → **Reopen**
- [ ] Status wechselt zu `Draft`
- [ ] Template wieder editierbar

**Erwartetes Ergebnis:** ✅ Status = Draft, Felder editierbar

---

## 4️⃣ Calculations (Kalkulationen)

### Calculation Liste öffnen
- [ ] Suche: "SEW Calc Headers" oder "Calculations"
- [ ] Page öffnet sich (List Page)
- [ ] Actions: New, Edit, Delete sichtbar

### Neue Calculation erstellen
- [ ] **New** klicken → Calculation Card öffnet sich
- [ ] "No." Feld: AssistEdit Button (drei Punkte) klicken
  - [ ] Number Series Dialog öffnet sich
  - [ ] "CALC" Series auswählbar
  - [ ] OK klicken
- [ ] Automatische Nummer vergeben (z.B. CALC0001)
- [ ] Template Code: `STANDARD` auswählen (Lookup)
- [ ] Item No.: Beliebigen Item auswählen (z.B. "1000")
- [ ] Calculation Date: Heutiges Datum (automatisch)
- [ ] Lot Size: `100`
- [ ] Status: `Draft` (automatisch)
- [ ] Speichern

**Erwartetes Ergebnis:** 
- ✅ Calculation gespeichert
- ✅ No. automatisch vergeben
- ✅ Template Code übernommen
- ✅ SubPage "Lines" ist leer (Phase 1: Copy Logic fehlt noch)

### Felder prüfen - General Group
- [ ] No.: CALC0001 (schreibgeschützt nach Speichern)
- [ ] No. Series: CALC (schreibgeschützt)
- [ ] Template Code: STANDARD
- [ ] Item No.: 1000
- [ ] Calculation Date: 06.12.2025
- [ ] Lot Size: 100
- [ ] Status: Draft

### Felder prüfen - Production Info Group
- [ ] Production BOM No.: Leer (optional)
- [ ] Routing No.: Leer (optional)
- [ ] Production BOM Version: Leer (optional)
- [ ] Routing Version: Leer (optional)

### Felder prüfen - Totals Group
- [ ] Total Material Cost: 0.00 (Phase 1: Calculation Engine fehlt)
- [ ] Total Labor Cost: 0.00
- [ ] Total Overhead Cost: 0.00
- [ ] Total Cost: 0.00

### Felder prüfen - Pricing Group
- [ ] Target Sales Price: 0.00 (manuell editierbar)
- [ ] Margin %: 0.00 (berechnet)

**Erwartetes Ergebnis:** ✅ Alle Felder sichtbar und korrekt beschriftet

### Zweite Calculation für gleichen Item
- [ ] **New** in Liste
- [ ] AssistEdit für No.: CALC0002 wird vergeben
- [ ] Template Code: `STANDARD`
- [ ] Item No.: `1000` (gleicher Item)
- [ ] Lot Size: `500` (andere Menge)
- [ ] Speichern

**Erwartetes Ergebnis:** ✅ Zwei Calculations für gleichen Item möglich

---

## 5️⃣ Datenintegrität & Relationen

### Template → Calculation Relation
- [ ] Template Card "STANDARD" öffnen
- [ ] Versuchen zu löschen → **Fehler erwartet**: "Cannot delete, used by calculations"

**Erwartetes Ergebnis:** ✅ Deletion blocked (wenn Calculation existiert)

### Variable → Template Line Relation
- [ ] Variable `OVERHEAD-FACTOR` löschen versuchen
- [ ] Falls in Template Line verwendet: **Fehler erwartet**

**Erwartetes Ergebnis:** ✅ Deletion blocked (wenn Template Line verwendet)

### Number Series Validation
- [ ] Sales Setup öffnen
- [ ] "SEW Calc Nos." leeren und speichern
- [ ] Neue Calculation erstellen ohne Template Code
- [ ] **Fehler erwartet**: "SEW Calc Nos. must have a value"

**Erwartetes Ergebnis:** ✅ TestField validiert Number Series

---

## 6️⃣ Permission Set

### Permission Prüfung
- [ ] Permission Set "SEW Calc" (90899) öffnen
- [ ] Folgende Permissions vorhanden:
  - [ ] SEW Calc Template (90800) - RMID
  - [ ] SEW Calc Template Line (90801) - RMID
  - [ ] SEW Calc Variable (90802) - RMID
  - [ ] SEW Calc Header (90803) - RMID
  - [ ] SEW Calc Line (90804) - RMID
  - [ ] SEW Calc Templates (90820) - R
  - [ ] SEW Calc Template Card (90821) - R
  - [ ] SEW Calc Template Lines (90822) - R
  - [ ] SEW Calc Variables (90823) - R
  - [ ] SEW Calc Headers (90830) - R
  - [ ] SEW Calc Card (90831) - R
  - [ ] SEW Calc Lines (90832) - R

**Erwartetes Ergebnis:** ✅ Alle Permissions korrekt definiert

---

## 7️⃣ UI/UX Testing

### Navigation
- [ ] Von Template List → Template Card (Doppelklick)
- [ ] Von Template Card → zurück zu List (Back Button)
- [ ] Von Calculation List → Calculation Card
- [ ] Von Variable List → Variable öffnen/editieren

**Erwartetes Ergebnis:** ✅ Navigation funktioniert reibungslos

### Tree View in Template Lines
- [ ] Template Card mit Lines öffnen
- [ ] Einrückung visuell erkennbar (Indentation = 1)
- [ ] Bold Lines sind fett dargestellt
- [ ] Line Types haben unterschiedliche Farben/Symbole (falls Standard BC)

**Erwartetes Ergebnis:** ✅ Hierarchie visuell erkennbar

### Lookups
- [ ] Template Code Lookup in Calculation Card
- [ ] Item No. Lookup in Calculation Card
- [ ] Variable Code Lookup in Template Lines
- [ ] Number Series Lookup in Sales Setup

**Erwartetes Ergebnis:** ✅ Alle Lookups funktionieren

---

## 8️⃣ Edge Cases

### Datumsgültigkeit Variables
- [ ] Variable mit Valid To Date in Vergangenheit erstellen
- [ ] Variable mit Valid From Date in Zukunft erstellen
- [ ] Beide in Template Line verwenden (sollte möglich sein, Validierung in Phase 1)

**Erwartetes Ergebnis:** ✅ Speichern möglich (keine Validierung in Phase 0)

### Negative Werte
- [ ] Variable mit negativem Value erstellen (z.B. -10)
- [ ] Lot Size mit negativer Zahl in Calculation (sollte möglich sein)

**Erwartetes Ergebnis:** ✅ Speichern möglich (Business Logic in Phase 1)

### Lange Texte
- [ ] Template Description mit 100 Zeichen
- [ ] Template Line Description mit 250 Zeichen
- [ ] Variable Description mit 100 Zeichen

**Erwartetes Ergebnis:** ✅ Alle Texte gespeichert ohne Truncation

---

## 9️⃣ Compilation & Code Analysis

### VS Code AL Extension
- [ ] AL Extension zeigt keine Errors
- [ ] AL Extension zeigt keine Warnings
- [ ] Download Symbols erfolgreich

**Erwartetes Ergebnis:** ✅ 0 Errors, 0 Warnings

### Build in Container
- [ ] AL-Go Workflow lokal triggern (falls möglich)
- [ ] App kompiliert ohne Fehler
- [ ] .app Datei wird generiert

**Erwartetes Ergebnis:** ✅ Build erfolgreich

---

## 🎯 Zusammenfassung Phase 0

### ✅ Funktioniert
- [ ] Number Series Konfiguration
- [ ] Variable CRUD (Create, Read, Update, Delete)
- [ ] Template CRUD mit Lines
- [ ] Template Status (Draft ↔ Released)
- [ ] Calculation CRUD mit Number Series
- [ ] Relations zwischen Objekten
- [ ] Permission Set vollständig
- [ ] UI Navigation

### ⏳ Nicht implementiert (Phase 1)
- [ ] Calculation Engine (Copy Template → Calculation Lines)
- [ ] Formula Parser & Evaluation
- [ ] BOM/Routing Cost Retrieval
- [ ] Price Calculation (Target Sales Price, Margin)
- [ ] Totals Calculation (Material/Labor/Overhead)

### 🐛 Bugs/Issues gefunden
- [ ] _Notizen hier eintragen_

---

## 📝 Testing Protokoll

**Tester:** ___________________  
**Datum:** 06.12.2025  
**BC Version:** ___________________  
**Container:** ___________________  
**Dauer:** _____Minuten  

**Gesamtergebnis Phase 0:**  
- [ ] ✅ Alle Tests bestanden  
- [ ] ⚠️ Tests bestanden mit kleineren Anmerkungen  
- [ ] ❌ Kritische Fehler gefunden  

**Bemerkungen:**  
_____________________________________  
_____________________________________  
_____________________________________

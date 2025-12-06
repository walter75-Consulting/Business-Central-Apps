# Testing Checklist - Phase 1 MVP Core Features

## ⚙️ Prerequisites

- [ ] AL-Go Container running (`.\localDevEnv.ps1` from `.AL-Go` folder)
- [ ] walter75 - Calculation App deployed to container (F5)
- [ ] Phase 0 setup completed (Number Series, Variables, Templates)
- [ ] Test Item with Production BOM and Routing created

---

## 1️⃣ Test Data Setup

### Create Test Item with BOM and Routing
- [ ] Create new Item (e.g., "TEST-CALC-001")
  - [ ] Replenishment System: `Prod. Order`
  - [ ] Unit Cost: Leave empty (will be calculated)
  - [ ] Production BOM No.: Create new BOM
  - [ ] Routing No.: Create new Routing

### Create Production BOM
- [ ] Search: "Production BOM"
- [ ] Create new BOM: "BOM-TEST-001"
- [ ] Add lines:
  - [ ] Line 1: Type = Item, No. = Any item, Quantity = 2, Unit Cost = 10.00
  - [ ] Line 2: Type = Item, No. = Another item, Quantity = 1, Unit Cost = 15.00
- [ ] Status: Certified
- [ ] Assign to Test Item

**Expected BOM Cost:** 2 × 10.00 + 1 × 15.00 = 35.00

### Create Routing
- [ ] Search: "Routing"
- [ ] Create new Routing: "RTG-TEST-001"
- [ ] Add lines:
  - [ ] Operation 10: Work Center, Setup Time = 15 min, Run Time = 5 min
  - [ ] Operation 20: Machine Center, Setup Time = 10 min, Run Time = 3 min
- [ ] Status: Certified
- [ ] Assign to Test Item
- [ ] Note Work Center and Machine Center costs for verification

### Create Test Variables (if not from Phase 0)
- [ ] Variable Code: `OVERHEAD`
  - [ ] Type: Percentage
  - [ ] Value: 20 (= 20%)
  - [ ] Global: Yes
- [ ] Variable Code: `SETUP-FEE`
  - [ ] Type: Absolute Value
  - [ ] Value: 50.00
  - [ ] Global: Yes

---

## 2️⃣ Formula Parser Testing

### Open Calculation Card
- [ ] Search: "SEW Calc Headers" or "Calculations"
- [ ] Create new Calculation (No. should auto-assign: CALC0001)
- [ ] Description: "Formula Parser Test"

### Test Basic Math Operations
- [ ] Add Calculation Line
  - [ ] Description: `Basic Addition`
  - [ ] Formula: `10 + 5`
  - [ ] Expected Result: 15.00
- [ ] Add Calculation Line
  - [ ] Description: `Multiplication Priority`
  - [ ] Formula: `10 + 5 * 2`
  - [ ] Expected Result: 20.00 (not 30)
- [ ] Add Calculation Line
  - [ ] Description: `Parentheses`
  - [ ] Formula: `(10 + 5) * 2`
  - [ ] Expected Result: 30.00
- [ ] Add Calculation Line
  - [ ] Description: `Division`
  - [ ] Formula: `100 / 4`
  - [ ] Expected Result: 25.00

**Expected Result:** ✅ All formulas calculate correctly respecting operator precedence

### Test System Variables
- [ ] Add Calculation Line
  - [ ] Description: `Material Cost Reference`
  - [ ] Formula: `{MATERIAL} * 1.5`
  - [ ] Note: MATERIAL should resolve from BOM (35.00)
  - [ ] Expected Result: 52.50
- [ ] Add Calculation Line
  - [ ] Description: `Labor Cost Reference`
  - [ ] Formula: `{LABOR} + 100`
  - [ ] Note: LABOR should resolve from Routing
- [ ] Add Calculation Line
  - [ ] Description: `Total Cost Formula`
  - [ ] Formula: `{TOTALCOST} * 1.25`
  - [ ] Note: Should use sum of all costs

**Expected Result:** ✅ System variables resolve to correct BOM/Routing values

### Test Custom Variables
- [ ] Add Calculation Line
  - [ ] Description: `Overhead Calculation`
  - [ ] Formula: `100 * {OVERHEAD}`
  - [ ] Expected Result: 20.00 (100 × 0.20)
- [ ] Add Calculation Line
  - [ ] Description: `Setup Fee Addition`
  - [ ] Formula: `100 + {SETUP-FEE}`
  - [ ] Expected Result: 150.00

**Expected Result:** ✅ Custom variables resolve correctly (percentage as decimal, absolute as-is)

### Test Formula Validation
- [ ] Add Calculation Line with invalid formula
  - [ ] Formula: `10 + * 5` (syntax error)
  - [ ] Try to validate/calculate
  - [ ] Expected: Error message about invalid formula
- [ ] Add Calculation Line with missing variable
  - [ ] Formula: `100 * {NOTEXIST}`
  - [ ] Try to calculate
  - [ ] Expected: Error or 0 (undefined variable handling)

**Expected Result:** ✅ Invalid formulas are caught with clear error messages

---

## 3️⃣ BOM/Routing Integration Testing

### Test BOM Cost Retrieval
- [ ] Create new Calculation: "BOM Integration Test"
- [ ] Link to Item: TEST-CALC-001
- [ ] Action: **Get BOM Cost** (if action exists) or use formula `{MATERIAL}`
- [ ] Verify Material Cost line shows: 35.00 (from BOM)
- [ ] Check calculation components:
  - [ ] Item 1: Qty 2 × 10.00 = 20.00
  - [ ] Item 2: Qty 1 × 15.00 = 15.00

**Expected Result:** ✅ BOM components retrieved correctly with quantities and costs

### Test Routing Cost Retrieval
- [ ] In same Calculation
- [ ] Action: **Get Routing Cost** (if exists) or use formula `{LABOR}`
- [ ] Verify Labor Cost line calculated from:
  - [ ] Work Center: (Setup Time + Run Time) × Hourly Rate
  - [ ] Machine Center: (Setup Time + Run Time) × Hourly Rate
- [ ] Check Work Center overhead applied correctly
- [ ] Check Machine Center overhead applied correctly

**Expected Result:** ✅ Routing operations retrieved with time × rate calculations

### Test Price Source Selection
- [ ] Open SEW Calc Setup (if exists) or use default
- [ ] Test different price sources:
  - [ ] Item Unit Cost
  - [ ] Item Last Direct Cost
  - [ ] Item Standard Cost
  - [ ] Work Center Direct Cost
  - [ ] Work Center Overhead Rate
  - [ ] Machine Center Direct Cost
  - [ ] Machine Center Overhead Rate
- [ ] Recalculate and verify costs change based on source

**Expected Result:** ✅ Different price sources yield different but correct results

---

## 4️⃣ Template Integration Testing

### Test Template to Calculation Copy
- [ ] Search: "SEW Calc Templates"
- [ ] Open existing template (from Phase 0): "STANDARD"
- [ ] Note template structure (lines, formulas, variables)
- [ ] Create new Calculation: "Template Test"
- [ ] Action: **Copy from Template** or set Template Code field
- [ ] Select template: "STANDARD"
- [ ] Execute copy

**Expected Result:** ✅ All template lines copied to calculation with formulas intact

### Verify Template Lines
- [ ] Check all template lines present in calculation
- [ ] Verify Formula fields copied correctly
- [ ] Verify Variable Code fields copied
- [ ] Verify Bold and Show in Report flags copied
- [ ] Verify Source Type set to Formula (not Template - fixed in code)

**Expected Result:** ✅ All template properties preserved in calculation lines

### Test Template Formula Evaluation
- [ ] In calculation created from template
- [ ] Trigger calculation (Action: **Calculate** if exists)
- [ ] Verify formulas evaluate using current item's BOM/Routing
- [ ] Check that variables resolve correctly
- [ ] Verify calculated amounts populate

**Expected Result:** ✅ Template formulas work identically to manually entered formulas

---

## 5️⃣ Item Card Integration Testing

### Test Item Card Extension
- [ ] Open Item Card: TEST-CALC-001
- [ ] Verify new fields visible:
  - [ ] SEW Last Calc No. (field exists)
  - [ ] SEW Default Template Code (field exists)
- [ ] Set SEW Default Template Code: "STANDARD"
- [ ] Verify actions visible in ribbon:
  - [ ] **New Calculation**
  - [ ] **Calculations**
  - [ ] **Last Calculation**

**Expected Result:** ✅ New fields and actions present on Item Card

### Test New Calculation Action
- [ ] From Item Card, click: **New Calculation**
- [ ] Verify:
  - [ ] New calculation created automatically
  - [ ] Calculation No. auto-assigned
  - [ ] Item No. pre-filled with current item
  - [ ] Default Template (if set) applied automatically
  - [ ] Calculation Card opens

**Expected Result:** ✅ One-click calculation creation from Item Card

### Test Calculations List Action
- [ ] From Item Card, click: **Calculations**
- [ ] Verify:
  - [ ] List filtered to show only this item's calculations
  - [ ] Multiple calculations visible (if created)
  - [ ] Can drill down into each calculation

**Expected Result:** ✅ Item-specific calculation list filtered correctly

### Test Last Calculation Action
- [ ] Create calculation from Item Card
- [ ] Close and return to Item Card
- [ ] Click: **Last Calculation**
- [ ] Verify:
  - [ ] Most recent calculation opens
  - [ ] SEW Last Calc No. field updated on Item

**Expected Result:** ✅ Last calculation link working, field updated

---

## 6️⃣ Calculation Engine Core Testing

### Test Full Calculation Workflow
- [ ] Create new Calculation: "Full Workflow Test"
- [ ] Link to Item: TEST-CALC-001
- [ ] Add lines manually or from template
- [ ] Action: **Calculate** (trigger main calculation engine)
- [ ] Verify:
  - [ ] All formula lines evaluated
  - [ ] BOM costs retrieved
  - [ ] Routing costs retrieved
  - [ ] Variables substituted
  - [ ] Amounts calculated
  - [ ] Totals summed correctly

**Expected Result:** ✅ Complete calculation executes without errors

### Test Transfer to Item
- [ ] In calculated calculation
- [ ] Verify current Item Unit Cost (before transfer)
- [ ] Action: **Transfer to Item** (if exists, Codeunit 90850)
- [ ] Confirm transfer
- [ ] Check Item Card:
  - [ ] Unit Cost updated to calculation total
  - [ ] Last Direct Cost updated (if applicable)
  - [ ] Standard Cost updated (if applicable)
- [ ] Verify SEW Last Calc No. updated on Item

**Expected Result:** ✅ Calculated costs written to Item master data

### Test Validation
- [ ] Create calculation with missing data:
  - [ ] No Item linked
  - [ ] Empty formula lines
  - [ ] Invalid formulas
- [ ] Action: **Validate Calculation** (Codeunit 90850)
- [ ] Verify validation errors reported:
  - [ ] Missing required fields
  - [ ] Invalid formula syntax
  - [ ] Undefined variables

**Expected Result:** ✅ Validation catches issues before calculation/transfer

---

## 7️⃣ Status Workflow Testing

### Test Release Calculation
- [ ] Create new Calculation: "Status Test"
- [ ] Add valid lines and calculate
- [ ] Status should be: Draft
- [ ] Action: **Release** (Codeunit 90853)
- [ ] Verify:
  - [ ] Status changes to: Released
  - [ ] Released Date populated
  - [ ] Released By populated
  - [ ] Lines become read-only (if implemented)

**Expected Result:** ✅ Calculation released, editing restricted

### Test Reopen Calculation
- [ ] From released calculation
- [ ] Action: **Reopen** (Codeunit 90853)
- [ ] Verify:
  - [ ] Status changes back to: Draft
  - [ ] Lines become editable again

**Expected Result:** ✅ Calculation reopened for editing

### Test Archive Calculation
- [ ] Release calculation again
- [ ] Action: **Archive** (Codeunit 90853)
- [ ] Verify:
  - [ ] Status changes to: Archived
  - [ ] Archived Date populated
  - [ ] Archived By populated
  - [ ] Calculation fully read-only

**Expected Result:** ✅ Calculation archived for history

---

## 8️⃣ Report Testing

### Test Calculation Report
- [ ] Open completed Calculation
- [ ] Action: **Print** or **Preview** (Report 90885)
- [ ] Report Request Page opens
- [ ] Options:
  - [ ] Show Variables: Yes/No
  - [ ] Show Details: Yes/No
  - [ ] Show Components: Yes/No
- [ ] Click Preview

**Expected Result:** ✅ Report displays in preview with calculation breakdown

### Verify Report Content
- [ ] Report shows:
  - [ ] Calculation Header (No., Description, Item)
  - [ ] Calculation Lines with formulas
  - [ ] Calculated amounts
  - [ ] Variables used (if Show Variables = Yes)
  - [ ] BOM components (if Show Components = Yes)
  - [ ] Routing operations (if Show Details = Yes)
  - [ ] Totals (Material, Labor, Overhead, Total Cost)
- [ ] Bold lines render in bold (if formatting implemented)
- [ ] Lines with "Show in Report" = No are hidden

**Expected Result:** ✅ Report renders correctly with all data formatted properly

### Test Report Print
- [ ] From preview, click: **Print**
- [ ] Send to printer or PDF
- [ ] Verify PDF/printout quality

**Expected Result:** ✅ Report prints/exports successfully

---

## 9️⃣ Permission Testing

### Test Permission Set
- [ ] Search: "Permission Sets"
- [ ] Find: "SEW CALC FULL"
- [ ] Verify permissions include:
  - [ ] Tables: 90800-90899 (Read, Insert, Modify, Delete)
  - [ ] Pages: 90800-90899 (Execute)
  - [ ] Codeunits: 90850-90853 (Execute)
  - [ ] Reports: 90885 (Execute)

### Test User with Permissions
- [ ] Assign "SEW CALC FULL" to test user
- [ ] Login as test user (or use current user)
- [ ] Verify all operations work:
  - [ ] Create/edit calculations
  - [ ] Run formulas
  - [ ] Transfer to items
  - [ ] Print reports

**Expected Result:** ✅ All operations work with correct permissions

---

## 🎯 Summary Checklist

### Core Functionality
- [ ] Formula parser evaluates math correctly (operator precedence)
- [ ] System variables resolve to BOM/Routing values
- [ ] Custom variables substitute correctly (percentage, absolute, factor)
- [ ] BOM cost retrieval works with all components
- [ ] Routing cost calculation includes setup + run time
- [ ] Price source selection changes costs appropriately
- [ ] Template copy preserves all line properties
- [ ] Template formulas evaluate identically to manual formulas

### Integration
- [ ] Item Card shows new fields and actions
- [ ] New Calculation action creates linked calculation
- [ ] Calculations list filters by item
- [ ] Last Calculation action opens recent calc
- [ ] Transfer to Item updates Item costs correctly

### Workflow
- [ ] Draft → Released status change
- [ ] Released → Reopen → Draft
- [ ] Released → Archived (read-only)
- [ ] Validation catches errors before processing

### Reporting
- [ ] Report displays all calculation data
- [ ] Report options filter content correctly
- [ ] Report exports/prints successfully

### Quality
- [ ] No compilation errors
- [ ] No runtime errors during operations
- [ ] Error messages clear and helpful
- [ ] Performance acceptable (calculations complete quickly)

---

## 📝 Test Results

**Tested by:** _________________  
**Date:** _________________  
**Container:** bc27dev01  
**App Version:** 27.0.0.0  

**Issues Found:**
1. _________________
2. _________________
3. _________________

**Overall Status:** ⬜ PASS | ⬜ FAIL | ⬜ PARTIAL

**Notes:**
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

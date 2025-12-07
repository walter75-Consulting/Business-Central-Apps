# Testing Checklist - walter75 - Calculation App

**Version:** 27.0.0.0  
**Last Updated:** December 7, 2025  
**Purpose:** Comprehensive manual testing guide for Calculation app features

---

## 📋 Table of Contents

1. [Prerequisites & Setup](#prerequisites)
2. [Phase 0: Foundation Testing](#phase-0)
3. [Phase 1: Core Features Testing](#phase-1)
4. [Regression Testing](#regression)
5. [Test Results Documentation](#results)

---

<a name="prerequisites"></a>
## ⚙️ Prerequisites & Environment Setup

### Development Environment
- [ ] AL-Go Container running (`.\localDevEnv.ps1` from `.AL-Go` folder)
- [ ] walter75 - Calculation App deployed to container (F5 in VS Code)
- [ ] AL Language Extension installed and symbols downloaded
- [ ] No compilation errors or warnings

### Test Data Requirements
- [ ] Test items created (minimum 3 items)
- [ ] Production BOMs certified for test items
- [ ] Routings certified for test items
- [ ] Work Centers configured with hourly rates
- [ ] Machine Centers configured with hourly rates
- [ ] Number Series configured for calculations

### User Permissions
- [ ] Test user has "SEW Calc Full" permission set (90899)
- [ ] Can access all pages (90820-90838)
- [ ] Can execute all codeunits (90850-90857)

---

<a name="phase-0"></a>
## 🔧 Phase 0: Foundation Testing

### 1. Number Series Configuration

### 2. Calculation Variables

#### Create Percentage Variable
- [ ] Search: "Calculation Variables" or "SEW Calc Variables"
- [ ] Click: **New**
- [ ] Fill fields:
  - [ ] Code: `OVERHEAD-PCT`
  - [ ] Description: `Overhead Percentage`
  - [ ] Type: `Percentage`
  - [ ] Value: `20` (represents 20%)
  - [ ] Base: `Material`
  - [ ] Valid From Date: `01.01.2025`
  - [ ] Global: `Yes` (available in all calculations)
- [ ] Save

**Expected Result:** ✅ Variable saved and appears in list

#### Create Absolute Value Variable
- [ ] Click: **New**
- [ ] Fill fields:
  - [ ] Code: `SETUP-FIXED`
  - [ ] Description: `Fixed Setup Cost`
  - [ ] Type: `Absolute Value`
  - [ ] Value: `150.00` (fixed currency amount)
  - [ ] Valid From Date: `01.01.2025`
  - [ ] Global: `Yes`
- [ ] Save

**Expected Result:** ✅ Variable saved, list shows 2 variables

#### Create Factor Variable
- [ ] Click: **New**
- [ ] Fill fields:
  - [ ] Code: `OVERHEAD-FACTOR`
  - [ ] Description: `Overhead Multiplier`
  - [ ] Type: `Factor`
  - [ ] Value: `1.2` (represents 20% markup)
  - [ ] Base: `Overhead`
  - [ ] Global: `Yes`
- [ ] Save

**Expected Result:** ✅ Variable saved, list shows 3 variables

#### Test Variable Validation
- [ ] Try to create variable with existing code → **Error expected**
- [ ] Try to save variable with empty description → **Error expected**
- [ ] Try to delete variable used in template → **Deletion blocked**

**Expected Result:** ✅ All validations working correctly

---

### 3. Calculation Templates

#### Create Standard Template
- [ ] Search: "Calculation Templates" or "SEW Calc Templates"
- [ ] Click: **New** → Template Card opens
- [ ] Fill header:
  - [ ] Code: `STANDARD`
  - [ ] Description: `Standard Calculation Template`
  - [ ] Price Source Item: `Unit Cost`
  - [ ] Price Source Capacity: `Work Center Direct Unit Cost`
  - [ ] Include Material: `Yes`
  - [ ] Include Labor: `Yes`
  - [ ] Include Overhead: `Yes`
  - [ ] Status: `Draft`
- [ ] Save

**Expected Result:** ✅ Template header saved, Lines subpage visible

#### Add Template Lines - Material Section
- [ ] In Lines subpage, click: **New Line**
- [ ] Line 10000 - Header:
  - [ ] Type: `Header`
  - [ ] Description: `Material Costs`
  - [ ] Bold: `Yes`
  - [ ] Show in Report: `Yes`
- [ ] Line 20000 - Material Cost:
  - [ ] Type: `Material`
  - [ ] Description: `Raw Materials from BOM`
  - [ ] Formula: `{MATERIAL}`
  - [ ] Indentation: `1`
  - [ ] Show in Report: `Yes`
- [ ] Line 30000 - Material Overhead:
  - [ ] Type: `Formula`
  - [ ] Description: `Material Overhead`
  - [ ] Formula: `{MATERIAL} * {OVERHEAD-PCT}`
  - [ ] Variable Code: `OVERHEAD-PCT`
  - [ ] Indentation: `1`
  - [ ] Show in Report: `Yes`
- [ ] Line 40000 - Sum Line:
  - [ ] Type: `Sum Line`
  - [ ] Description: `Total Material`
  - [ ] Bold: `Yes`
  - [ ] Show in Report: `Yes`

**Expected Result:** ✅ 4 lines created with proper hierarchy

#### Add Template Lines - Labor Section
- [ ] Line 50000 - Header:
  - [ ] Type: `Header`
  - [ ] Description: `Labor Costs`
  - [ ] Bold: `Yes`
  - [ ] Show in Report: `Yes`
- [ ] Line 60000 - Labor Cost:
  - [ ] Type: `Labor`
  - [ ] Description: `Work Center Costs from Routing`
  - [ ] Formula: `{LABOR}`
  - [ ] Indentation: `1`
  - [ ] Show in Report: `Yes`
- [ ] Line 70000 - Setup Cost:
  - [ ] Type: `Formula`
  - [ ] Description: `Fixed Setup Cost`
  - [ ] Formula: `{SETUP-FIXED}`
  - [ ] Variable Code: `SETUP-FIXED`
  - [ ] Indentation: `1`
  - [ ] Show in Report: `Yes`

**Expected Result:** ✅ 7 total lines with complete structure

#### Test Template Status Workflow
- [ ] Click action: **Release**
- [ ] Status changes to: `Released`
- [ ] Lines become read-only
- [ ] Released Date and Released By populated

**Expected Result:** ✅ Template released successfully

- [ ] Click action: **Reopen**
- [ ] Status changes back to: `Draft`
- [ ] Lines become editable again

**Expected Result:** ✅ Template reopened for editing

---

### 4. Test Item Setup

#### Create Test Item with Production BOM
- [ ] Search: "Items"
- [ ] Click: **New**
- [ ] Fill fields:
  - [ ] No.: `TEST-CALC-001`
  - [ ] Description: `Test Item for Calculation`
  - [ ] Replenishment System: `Prod. Order`
  - [ ] Unit Cost: Leave empty (will be calculated)

#### Create Production BOM
- [ ] Search: "Production BOM"
- [ ] Click: **New**
- [ ] Header:
  - [ ] No.: `BOM-TEST-001`
  - [ ] Description: `Test BOM for Calculation`
  - [ ] Unit of Measure Code: `PCS`
- [ ] Lines:
  - [ ] Line 10000: Type = `Item`, No. = (any component), Quantity = `2.00`, Unit Cost = `10.00`
  - [ ] Line 20000: Type = `Item`, No. = (another component), Quantity = `1.00`, Unit Cost = `15.00`
- [ ] Click action: **Certify**
- [ ] Status changes to: `Certified`
- [ ] Return to Item Card, assign: Production BOM No. = `BOM-TEST-001`

**Expected BOM Cost:** 2 × 10.00 + 1 × 15.00 = **35.00 EUR**

#### Create Routing
- [ ] Search: "Routings"
- [ ] Click: **New**
- [ ] Header:
  - [ ] No.: `RTG-TEST-001`
  - [ ] Description: `Test Routing for Calculation`
- [ ] Lines:
  - [ ] Operation No.: `10`, Type: `Work Center`, No.: (select work center), Setup Time: `15` min, Run Time: `5` min/piece
  - [ ] Operation No.: `20`, Type: `Machine Center`, No.: (select machine center), Setup Time: `10` min, Run Time: `3` min/piece
- [ ] Click action: **Certify**
- [ ] Status changes to: `Certified`
- [ ] Return to Item Card, assign: Routing No. = `RTG-TEST-001`

**Note:** Record Work Center and Machine Center hourly rates for cost verification

**Expected Labor Cost (for 100 pieces):**
- Operation 10: (15 + 100×5) / 60 × Work Center Rate
- Operation 20: (10 + 100×3) / 60 × Machine Center Rate

---

<a name="phase-1"></a>
## 🚀 Phase 1: Core Features Testing

### 1. Calculation Creation & Basic Workflow

#### Create New Calculation
- [ ] Search: "Calculations" or "SEW Calc Headers"
- [ ] Click: **New** → Calculation Card opens
- [ ] No. field: Click AssistEdit (...) to generate number
- [ ] Dialog opens, select series "CALC", click OK
- [ ] No. automatically assigned: `CALC0001`
- [ ] Fill fields:
  - [ ] Template Code: `STANDARD` (lookup)
  - [ ] Item No.: `TEST-CALC-001` (lookup)
  - [ ] Description: Auto-fills from item (editable)
  - [ ] Calculation Date: Defaults to today
  - [ ] Lot Size: `100`
  - [ ] Status: `Draft` (automatic)
- [ ] Save

**Expected Result:** ✅ Calculation saved, Lines subpage empty (before Calculate action)

#### Apply Template and Calculate
- [ ] Click action: **Calculate from Template** (or similar)
- [ ] Template lines copied to calculation
- [ ] Formulas evaluated
- [ ] BOM costs retrieved
- [ ] Routing costs retrieved
- [ ] Variables substituted
- [ ] Check Lines subpage:
  - [ ] All template lines present
  - [ ] Amounts populated in Amount fields
  - [ ] Hierarchy preserved (indentation, bold)

**Expected Result:** ✅ All template lines copied, costs calculated

#### Verify Totals
- [ ] Check Totals group on card:
  - [ ] Total Material Cost: ~35.00 + overhead (verify calculation)
  - [ ] Total Labor Cost: (from routing + setup fee)
  - [ ] Total Overhead Cost: (from overhead formulas)
  - [ ] Total Cost: Sum of above

**Expected Result:** ✅ Totals match line-by-line calculation

---

### 2. Formula Parser Testing

#### Test Basic Math Operations
- [ ] Create new Calculation: "Formula Parser Test"
- [ ] Manually add lines (without template) to test parser:
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

#### Test System Variables
- [ ] Line 10: Description: `Material Reference`, Formula: `{MATERIAL} * 1.5`
  - [ ] MATERIAL should resolve from BOM: 35.00
  - [ ] Expected Result: **52.50**
- [ ] Line 20: Description: `Labor Reference`, Formula: `{LABOR} + 100`
  - [ ] LABOR should resolve from Routing (verify against actual)
  - [ ] Expected Result: **Routing Cost + 100**
- [ ] Line 30: Description: `Overhead Reference`, Formula: `{OVERHEAD}`
  - [ ] OVERHEAD should be sum of all overhead lines
- [ ] Line 40: Description: `Total Reference`, Formula: `{TOTALCOST} * 1.25`
  - [ ] TOTALCOST should be grand total of all costs
  - [ ] Expected Result: **Total × 1.25**

**Expected Result:** ✅ All system variables resolve to correct calculated values

#### Test Custom Variables
- [ ] Add Calculation Line
  - [ ] Description: `Overhead Calculation`
  - [ ] Formula: `100 * {OVERHEAD}`
  - [ ] Expected Result: 20.00 (100 × 0.20)
- [ ] Add Calculation Line
  - [ ] Description: `Setup Fee Addition`
  - [ ] Formula: `100 + {SETUP-FEE}`
  - [ ] Expected Result: 150.00

**Expected Result:** ✅ Custom variables resolve correctly (percentage as decimal, absolute as-is)

#### Test Formula Validation (Error Handling)
- [ ] Add line with invalid syntax: Formula: `10 + * 5`
  - [ ] Try to calculate
  - [ ] **Expected:** Error message "Invalid formula syntax"
- [ ] Add line with undefined variable: Formula: `100 * {NOTEXIST}`
  - [ ] Try to calculate
  - [ ] **Expected:** Error message "Variable not found: NOTEXIST"
- [ ] Add line with mismatched parentheses: Formula: `(10 + 5 * 2`
  - [ ] Try to calculate
  - [ ] **Expected:** Error message about unbalanced parentheses
- [ ] Add line with division by zero: Formula: `100 / 0`
  - [ ] Try to calculate
  - [ ] **Expected:** Error message or infinity handling

**Expected Result:** ✅ All invalid formulas caught with clear, helpful error messages

---

### 3. BOM & Routing Integration Testing

#### Test BOM Cost Retrieval
- [ ] Create new Calculation: "BOM Integration Test"
- [ ] Link to Item: TEST-CALC-001
- [ ] Action: **Get BOM Cost** (if action exists) or use formula `{MATERIAL}`
- [ ] Verify Material Cost line shows: 35.00 (from BOM)
- [ ] Check calculation components:
  - [ ] Item 1: Qty 2 × 10.00 = 20.00
  - [ ] Item 2: Qty 1 × 15.00 = 15.00

**Expected Result:** ✅ BOM components retrieved correctly with quantities and costs

#### Test Routing Cost Retrieval
- [ ] Create calculation: "Routing Integration Test"
- [ ] Link to Item: `TEST-CALC-001`
- [ ] Use formula `{LABOR}` or action **Get Routing Cost**
- [ ] Verify Labor Cost line shows correct calculation:
  - [ ] **Operation 10:** (Setup 15min + Run 5min×100pcs) / 60 × Work Center Rate
  - [ ] **Operation 20:** (Setup 10min + Run 3min×100pcs) / 60 × Machine Center Rate
  - [ ] **Total Labor:** Sum of both operations
- [ ] Check that overhead rates applied correctly:
  - [ ] Work Center Overhead Rate added if configured
  - [ ] Machine Center Overhead Rate added if configured

**Manual Verification:**
- [ ] Calculate expected labor cost manually
- [ ] Compare with calculated amount
- [ ] Difference should be < 0.01 EUR (rounding)

**Expected Result:** ✅ Routing operations retrieved with accurate time × rate calculations

#### Test Price Source Selection
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

### 4. Template Integration Testing

#### Test Template Application
- [ ] Search: "SEW Calc Templates"
- [ ] Open existing template (from Phase 0): "STANDARD"
- [ ] Note template structure (lines, formulas, variables)
- [ ] Create new Calculation: "Template Test"
- [ ] Action: **Copy from Template** or set Template Code field
- [ ] Select template: "STANDARD"
- [ ] Execute copy

**Expected Result:** ✅ All template lines copied to calculation with formulas intact

#### Verify Template Line Properties
- [ ] All template lines present: Count matches template
- [ ] Formula fields copied correctly: Check 3+ formulas
- [ ] Variable Code fields copied: Check variables referenced
- [ ] Bold flags preserved: Check header lines are bold
- [ ] Show in Report flags preserved: Check all lines
- [ ] Indentation preserved: Check hierarchy structure
- [ ] Line No. sequence preserved: Check numbering (10000, 20000, etc.)

**Expected Result:** ✅ 100% fidelity between template and calculation lines

#### Test Template Formula Evaluation
- [ ] In calculation created from template
- [ ] Trigger calculation (Action: **Calculate** if exists)
- [ ] Verify formulas evaluate using current item's BOM/Routing
- [ ] Check that variables resolve correctly
- [ ] Verify calculated amounts populate

**Expected Result:** ✅ Template formulas work identically to manually entered formulas

---

### 5. Item Card Integration Testing

#### Verify Item Card Extensions
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

#### Test New Calculation Action
- [ ] From Item Card, click action: **New Calculation**
- [ ] New calculation created automatically:
  - [ ] Calculation No. auto-assigned (e.g., CALC0002)
  - [ ] Item No. pre-filled with current item
  - [ ] Default Template applied if SEW Default Template Code set
  - [ ] Calculation Card opens immediately
  - [ ] Status = Draft
- [ ] Verify in Calculations list that new calc exists

**Expected Result:** ✅ One-click calculation creation with all context pre-filled

#### Test Calculations List Action
- [ ] From Item Card, click: **Calculations**
- [ ] Verify:
  - [ ] List filtered to show only this item's calculations
  - [ ] Multiple calculations visible (if created)
  - [ ] Can drill down into each calculation

**Expected Result:** ✅ Item-specific calculation list filtered correctly

#### Test Last Calculation Action
- [ ] Create calculation from Item Card
- [ ] Close and return to Item Card
- [ ] Click: **Last Calculation**
- [ ] Verify:
  - [ ] Most recent calculation opens
  - [ ] SEW Last Calc No. field updated on Item

**Expected Result:** ✅ Last calculation link working, field updated

---

### 6. Calculation Engine Testing

#### Test Complete Calculation Flow
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

#### Test Transfer to Item
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

#### Test Calculation Validation
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

### 7. Status Workflow Testing

#### Test Release Workflow
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

#### Test Reopen Workflow
- [ ] From released calculation
- [ ] Action: **Reopen** (Codeunit 90853)
- [ ] Verify:
  - [ ] Status changes back to: Draft
  - [ ] Lines become editable again

**Expected Result:** ✅ Calculation reopened for editing

#### Test Archive Workflow
- [ ] Release calculation again
- [ ] Action: **Archive** (Codeunit 90853)
- [ ] Verify:
  - [ ] Status changes to: Archived
  - [ ] Archived Date populated
  - [ ] Archived By populated
  - [ ] Calculation fully read-only

**Expected Result:** ✅ Calculation archived for history

---

### 8. Report Testing

#### Test Calculation Report
- [ ] Open completed Calculation
- [ ] Action: **Print** or **Preview** (Report 90885)
- [ ] Report Request Page opens
- [ ] Options:
  - [ ] Show Variables: Yes/No
  - [ ] Show Details: Yes/No
  - [ ] Show Components: Yes/No
- [ ] Click Preview

**Expected Result:** ✅ Report displays in preview with calculation breakdown

#### Verify Report Content
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

#### Test Report Print/Export
- [ ] From preview, click: **Print**
- [ ] Send to printer or PDF
- [ ] Verify PDF/printout quality

**Expected Result:** ✅ Report prints/exports successfully

---

### 9. Permission & Security Testing

#### Verify Permission Set
- [ ] Search: "Permission Sets"
- [ ] Find: "SEW CALC FULL"
- [ ] Verify permissions include:
  - [ ] Tables: 90800-90899 (Read, Insert, Modify, Delete)
  - [ ] Pages: 90800-90899 (Execute)
  - [ ] Codeunits: 90850-90853 (Execute)
  - [ ] Reports: 90885 (Execute)

#### Test User with Full Permissions
- [ ] Assign "SEW CALC FULL" to test user
- [ ] Login as test user (or use current user)
- [ ] Verify all operations work:
  - [ ] Create/edit calculations
  - [ ] Run formulas
  - [ ] Transfer to items
  - [ ] Print reports

**Expected Result:** ✅ All operations work with correct permissions

#### Test User with Read-Only Permissions
- [ ] Create test user with "SEW CALC READ" permission set (90898)
- [ ] Login as read-only user
- [ ] Verify restrictions:
  - [ ] Can view calculations, templates, variables
  - [ ] Cannot create new calculations
  - [ ] Cannot edit existing calculations
  - [ ] Cannot delete calculations
  - [ ] Cannot release/reopen/archive
  - [ ] Cannot transfer to items

**Expected Result:** ✅ Read-only access properly enforced

---

<a name="regression"></a>
## 🔄 Regression Testing

### Test After Code Changes
Run these tests after any code modification to ensure no regressions:

#### Quick Smoke Test (5 minutes)
- [ ] Formula parser evaluates math correctly (operator precedence)
- [ ] System variables resolve to BOM/Routing values
- [ ] Custom variables substitute correctly (percentage, absolute, factor)
- [ ] BOM cost retrieval works with all components
- [ ] Routing cost calculation includes setup + run time
- [ ] Price source selection changes costs appropriately
- [ ] Template copy preserves all line properties
- [ ] Template formulas evaluate identically to manual formulas

- [ ] Create new calculation with template
- [ ] Verify template applied and calculated
- [ ] Check totals are correct
- [ ] Release calculation
- [ ] Transfer to item
- [ ] Print report

**Expected Result:** ✅ All basic operations work without errors

#### Full Regression Test (30 minutes)
- [ ] Run all Phase 0 tests
- [ ] Run all Phase 1 tests
- [ ] Test all edge cases
- [ ] Verify all reports
- [ ] Test all permissions

**Expected Result:** ✅ All tests pass identically to previous test run

---

<a name="results"></a>
## 📊 Test Results Documentation

### Test Execution Summary

**Test Date:** __________________  
**Tester Name:** __________________  
**BC Version:** 27.0.0.0  
**App Version:** __________________  
**Container:** __________________  
**Test Duration:** ______ minutes

### Test Coverage

| Category | Tests Planned | Tests Passed | Tests Failed | Pass Rate |
|----------|---------------|--------------|--------------|-----------|
| Phase 0: Foundation | ___ | ___ | ___ | ___% |
| Phase 1: Core Features | ___ | ___ | ___ | ___% |
| Integration Tests | ___ | ___ | ___ | ___% |
| Regression Tests | ___ | ___ | ___ | ___% |
| **TOTAL** | **___** | **___** | **___** | **___%** |

### Critical Issues Found

#### Issue #1
- **Severity:** ⬜ Critical | ⬜ High | ⬜ Medium | ⬜ Low
- **Description:** _______________________________________
- **Steps to Reproduce:** _______________________________________
- **Expected Behavior:** _______________________________________
- **Actual Behavior:** _______________________________________
- **Workaround:** _______________________________________

#### Issue #2
- **Severity:** ⬜ Critical | ⬜ High | ⬜ Medium | ⬜ Low
- **Description:** _______________________________________

_(Add more issues as needed)_

### Minor Issues / Observations
1. _______________________________________
2. _______________________________________
3. _______________________________________

### Performance Observations
- **Calculation Engine Speed:** ⬜ Fast | ⬜ Acceptable | ⬜ Slow
- **Report Generation:** ⬜ Fast | ⬜ Acceptable | ⬜ Slow
- **Page Load Times:** ⬜ Fast | ⬜ Acceptable | ⬜ Slow
- **Formula Parser:** ⬜ Fast | ⬜ Acceptable | ⬜ Slow

### Overall Test Result
- [ ] ✅ **PASS** - All critical tests passed, ready for release
- [ ] ⚠️ **PASS WITH ISSUES** - Passed with minor issues, release possible
- [ ] ❌ **FAIL** - Critical issues found, release blocked

### Recommendations
_______________________________________
_______________________________________
_______________________________________

### Tester Sign-Off
**Signature:** __________________  
**Date:** __________________

---

## 📋 Quick Reference

### Test Item Configuration
- **Item No.:** TEST-CALC-001
- **BOM No.:** BOM-TEST-001 (Expected Cost: 35.00 EUR)
- **Routing No.:** RTG-TEST-001 (Expected Cost: varies by lot size)

### Test Variables
- **OVERHEAD-PCT:** 20% (Type: Percentage, Base: Material)
- **SETUP-FIXED:** 150.00 EUR (Type: Absolute Value)
- **OVERHEAD-FACTOR:** 1.2 (Type: Factor, Base: Overhead)

### Test Templates
- **STANDARD:** Standard calculation with material + labor + overhead

### Expected Results for 100 pieces
- **Material Cost:** 35.00 EUR (from BOM)
- **Material Overhead:** 35.00 × 0.20 = 7.00 EUR
- **Labor Cost:** (varies by work center rates)
- **Setup Cost:** 150.00 EUR
- **Total:** Calculate based on actual rates

---

## 🆘 Troubleshooting

### Common Issues

**Issue:** "Cannot calculate, template not found"
- **Solution:** Ensure template is Released status

**Issue:** "Variable not found in formula"
- **Solution:** Check variable code spelling, ensure variable exists and is Global

**Issue:** "BOM cost is 0.00"
- **Solution:** Verify BOM is Certified, components have Unit Cost

**Issue:** "Labor cost is 0.00"
- **Solution:** Verify Routing is Certified, Work Centers have hourly rates

**Issue:** "Cannot release calculation"
- **Solution:** Ensure calculation has lines and totals are calculated

**Issue:** "Transfer to Item doesn't update cost"
- **Solution:** Check permissions, ensure calculation is Released

---

**End of Testing Checklist**

---

## 📝 Appendix: Test Data Templates

### Additional Test Items Template
```
Item No.: TEST-CALC-002
Description: Complex Assembly Test
BOM: Multiple levels (2-3 levels deep)
Routing: 5+ operations with various work centers
Expected: Tests complex calculation scenarios
```

### Performance Test Template
```
Create 50 calculations
Calculate all 50 simultaneously
Measure total time
Expected: < 30 seconds for batch calculation
```

### Edge Case Test Template
```
Test with:
- Empty BOM (material = 0)
- Empty Routing (labor = 0)
- Lot Size = 1
- Lot Size = 10000
- Very small decimals (0.001)
- Very large numbers (999999.99)
```

---

## 🔗 Related Documentation
- [User Guide](docs/apps/calculation-user-guide.md)
- [Technical Documentation](docs/apps/calculation.md)
- [CHANGELOG](CHANGELOG.md)
- [Copilot Instructions](../.github/copilot-instructions.md)
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

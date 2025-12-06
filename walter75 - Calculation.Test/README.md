# walter75 - Calculation.Test

Automated test framework for the walter75 - Calculation app using Business Central Test Framework.

## Overview

This test app provides comprehensive test coverage for:
- Formula Parser (arithmetic operations, operator precedence, variables)
- Variable System (percentage, absolute, factor types)
- BOM/Routing Integration (cost retrieval and calculation)
- Template Management (copy, validation)
- Calculation Engine (full workflow)
- Item Card Integration

## Object ID Range

**90950-90999** - Test objects

| Range | Usage |
|-------|-------|
| 90950-90969 | Test Codeunits |
| 90970-90979 | Helper Codeunits |
| 90980-90999 | Reserved (Permission Set) |

## Test Codeunits

### 90950 - SEW Calc Formula Parser Test
Tests for mathematical expression evaluation:
- Basic arithmetic (+, -, *, /)
- Operator precedence
- Parentheses handling
- Variable substitution (system and custom)
- Decimal number support
- Error handling (invalid formulas, division by zero)

**Coverage Goal:** 95%+

### 90970 - SEW Calc Test Helper
Utility codeunit for test data creation:
- `CreateTestItemWithBOMAndRouting()` - Complete test item setup
- `CreateTestVariable()` - Variable creation
- `CreateTestTemplate()` - Template with predefined lines
- `CreateTestCalculation()` - Calculation header
- `CreateTestCalculationLine()` - Calculation line
- `CleanupTestData()` - Remove all test data

## Prerequisites

### Required Test Library Packages

This test app depends on Microsoft test libraries. These must be available in the `.alpackages` folder:

1. **Microsoft Any** (27.0.0.0)
2. **Microsoft Library Assert** (27.0.0.0)
3. **Microsoft Library - Lower Permissions** (27.0.0.0)

### How to Download Test Libraries

#### Option A: Using AL-Go Container (Recommended)
```powershell
# From .AL-Go folder
.\localDevEnv.ps1

# Test libraries will be automatically downloaded
```

#### Option B: Using VS Code
1. Press `F5` to start debugging in BC container
2. Wait for symbols to download
3. Test libraries will be in `.alpackages` folder

#### Option C: Manual Download from BC Container
```powershell
# Connect to BC container
$containerName = "bc27dev01"

# Download test libraries
Get-BcContainerAppInfo -containerName $containerName | 
    Where-Object { $_.Name -like "*Library*" -or $_.Name -eq "Any" } |
    ForEach-Object {
        Copy-BcContainerApp -containerName $containerName -appName $_.Name -publisher "Microsoft" -destination "..\.alpackages"
    }
```

## Running Tests

### Run All Tests (Locally)
1. Ensure test libraries are available (see Prerequisites)
2. Press `F5` to deploy to BC container
3. In BC Web Client:
   - Search: "Test Tool"
   - Select test codeunit: "SEW Calc Formula Parser Test"
   - Click "Run All"

### Run Individual Test
1. Open Test Tool
2. Select test codeunit
3. Select specific test procedure
4. Click "Run Selected"

### Run Tests via AL-Go (CI/CD)
Tests run automatically on every pull request when configured in `.github/AL-Go-Settings.json`:

```json
{
  "testFolders": [
    "walter75 - Calculation.Test"
  ],
  "doNotRunTests": false,
  "testResultsFormat": "JUnit"
}
```

## Test Results

After running tests, results are available:
- **Test Tool:** Visual results with pass/fail indicators
- **Output Log:** Detailed error messages
- **CI/CD:** GitHub Actions test results in PR checks
- **JUnit XML:** Exported test results for reporting

## Writing New Tests

### Test Method Pattern (GIVEN-WHEN-THEN)
```al
[Test]
procedure TestFeatureName()
var
    SEWCalcHeader: Record "SEW Calc Header";
    Result: Decimal;
begin
    // [GIVEN] Setup test data
    SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);
    
    // [WHEN] Execute the action
    Result := SEWCalcFormulaParser.EvaluateFormula('10 + 5', SEWCalcHeader);
    
    // [THEN] Verify expected outcome
    LibraryAssert.AreEqual(15, Result, 'Addition should work');
    
    // [CLEANUP] Remove test data
    SEWCalcHeader.Delete(true);
end;
```

### Best Practices
1. **Independent tests:** Each test should be self-contained
2. **Use test helper:** For consistent test data creation
3. **Clean up:** Always delete test data after test
4. **Meaningful names:** Test names should describe what is tested
5. **Clear assertions:** Error messages should aid debugging
6. **Test both paths:** Happy path and error scenarios

## Current Status

### ✅ Completed
- [x] Test app structure created
- [x] app.json with correct dependencies
- [x] Test helper codeunit implemented
- [x] Formula parser tests implemented
- [x] Variable naming conventions fixed
- [x] Method signatures corrected
- [x] Permission set created

### ⏳ Pending
- [ ] Download test library packages
- [ ] Run tests to verify all pass
- [ ] Add more test codeunits:
  - SEW Calc Variable Test (90951)
  - SEW Calc BOM Routing Test (90952)
  - SEW Calc Template Test (90953)
  - SEW Calc Engine Test (90954)
  - SEW Calc Integration Test (90955)

### ❌ Known Issues
- Test libraries not yet available in .alpackages
- Cannot compile until test libraries are present
- ValidateFormula tests may need adjustment (method is internal)

## Troubleshooting

### "Library Assert is missing"
**Solution:** Download test library packages (see Prerequisites)

### "Permission set not found"
**Solution:** Permission set 90999 "SEW CALC TEST" is included in this app

### Tests fail with "No data found"
**Solution:** Ensure SEW Calc Test Helper creates all required test data

### Tests affect production data
**Solution:** All test data uses "TEST-" prefix. Use `CleanupTestData()` to remove.

## Support

For issues or questions:
- Check TESTING_CHECKLIST.md for manual testing procedures
- Review Issue #19 for test automation roadmap
- See master issue #15 for overall project status

## Version

- **App Version:** 27.0.0.0
- **Platform:** 27.0.0.0
- **Runtime:** 16.0
- **Target:** Cloud
- **Publisher:** walter75 - München

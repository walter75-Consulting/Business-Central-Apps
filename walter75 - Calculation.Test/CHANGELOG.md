# Changelog

All notable changes to **walter75 - Calculation.Test** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Sales Integration Tests (90956)** - 8 comprehensive tests for Phase 2 Sales Quote Integration (#10)
  - TestSalesHeaderExtensionFields - Validates template and auto-calc storage
  - TestSalesLineExtensionFields - Tests calculation linking and cost fields
  - TestMarginCalculation - Verifies 25% margin calculation accuracy
  - TestCalculateSalesLinePrice - Tests manual calculation with number series
  - TestAutoCalculateOnItemSelection - Validates EventSubscriber auto-calculation trigger
  - TestValidateMarginAboveTarget - Tests margin validation above 15% threshold
  - TestValidateMarginBelowTarget - Tests margin validation below threshold
  - TestCostBreakdownFlowFields - Validates cost component FlowField calculations
- Complete test automation framework for Calculation app (#19)
- Test Helper Codeunit (90970) for shared test utilities and data creation (#19)
- Formula Parser Tests (90950) - 16 tests for arithmetic operations and precedence (#19)
- Variable Tests (90951) - 10 tests for variable types and date-based lookup (#19)
- BOM/Routing Tests (90952) - 3 tests for production cost calculation (#19)
- Template Tests (90953) - 2 tests for template validation and copying (#19)
- Engine Tests (90954) - 10 tests for calculation engine functionality (#19)
- Integration Tests (90955) - 11 tests for end-to-end scenarios (#19)
- Test Assert Codeunit (90971) for test validation utilities (#19)

### Changed
- CalcTestHelper enhanced with InitializeSetup() for automatic number series configuration (#10)
- CalcTestHelper now creates test customers with both Sell-to and Bill-to assignments for BC27 compatibility (#10)
- CalcTestHelper now assigns Gen. Product Posting Group and Inventory Posting Group to test items (#10)
- Test templates now created with Status::Released for TableRelation compatibility (#10)
- TestAssert enhanced with AreNotEqual() and AreNearlyEqual() methods for decimal comparison (#10)

### Fixed
- Tests now use Validate() instead of direct field assignment to trigger EventSubscribers (#10)
- Number series setup now creates both No. Series record and No. Series Line (#10)
- Test items now include all required posting groups for BC27 Sales Line validation (#10)

### Technical Details
- Total Tests: 60 (100% pass rate achieved)
- Sales Integration Tests: 8 (added in Phase 2)
- Object ID Range: 90950-90999
- Test Execution Time: ~1.0 seconds for full suite
- Container: BC27dev01 (HTTP, BC 27.0.38460.43154 DE)
- Test Framework: CAL Test Tool, AL Test Runner 10.15.2
- Dependencies: walter75 - Calculation 26.1.0.99999

### Test Coverage
- ✅ Arithmetic operations (+, -, *, /)
- ✅ Operator precedence and parentheses
- ✅ Decimal number handling
- ✅ Variable substitution (Percentage, Absolute, Factor)
- ✅ Date-based variable lookup with three-tier strategy
- ✅ BOM/Routing cost calculation
- ✅ Template validation and copying
- ✅ Status workflow (Draft → Released → Archived)
- ✅ Item card integration
- ✅ End-to-end calculation scenarios
- ✅ **Sales Quote integration with auto-calculation**
- ✅ **Margin calculation and validation (25% target, 15% minimum)**
- ✅ **Cost breakdown FlowFields**

---

## [27.0.0.0] - 2024-12-06

### Added
- Initial test app structure
- Test framework setup

### Technical Details
- Platform: Business Central Cloud 27.0
- App Type: Test App
- Test Runner: AL Test Runner extension

---

## How to Update This Changelog

When making changes to this app:

1. Add your changes under the `[Unreleased]` section
2. Use the appropriate subsection: Added, Changed, Fixed
3. Write in clear, technical language
4. Include the issue/PR number: `- Test description (#123)`
5. When releasing, move Unreleased items to a new version section with the date

### Example Entry
```markdown
## [Unreleased]

### Added
- Performance profiling tests for large calculation sets (#456)

### Fixed
- Flaky test in variable date range validation (#789)
```

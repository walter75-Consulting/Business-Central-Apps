# Changelog

All notable changes to **walter75 - Calculation.Test** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Complete test automation framework for Calculation app (#19)
- Test Helper Codeunit (90970) for shared test utilities and data creation (#19)
- Formula Parser Tests (90950) - 16 tests for arithmetic operations and precedence (#19)
- Variable Tests (90951) - 10 tests for variable types and date-based lookup (#19)
- BOM/Routing Tests (90952) - 3 tests for production cost calculation (#19)
- Template Tests (90953) - 2 tests for template validation and copying (#19)
- Engine Tests (90954) - 10 tests for calculation engine functionality (#19)
- Integration Tests (90955) - 11 tests for end-to-end scenarios (#19)
- Test Assert Codeunit (90971) for test validation utilities (#19)

### Technical Details
- Total Tests: 52 (100% pass rate achieved)
- Object ID Range: 90950-90999
- Test Execution Time: ~0.7 seconds for full suite
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

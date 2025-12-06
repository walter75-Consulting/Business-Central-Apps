# Changelog

All notable changes to **walter75 - Calculation** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Comprehensive test automation support with dedicated test app (#19)
- Three-tier variable lookup strategy for date-based variable handling (#19)
- ValidFromDate parameter support in variable creation (#19)

### Changed
- Extended ValidateFormula to accept variable placeholder characters ({, }, A-Z, a-z) (#19)
- Simplified ValidateTemplate to return boolean directly (syntax-only validation) (#19)
- Enhanced CalcFormulaParser with improved Code filter maintenance using Reset+SetRange pattern (#19)

### Fixed
- System variable name conflicts in formula parser (MATERIAL, LABOR, OVERHEAD, TOTALCOST) (#19)
- SetRange clearing Code filter during variable lookup - now preserves filter correctly (#19)
- CalcDate error when handling 0D dates in variable validation (#19)
- "Unhandled UI" errors by removing Message() display in template validation (#19)

### Technical Details
- Test Framework: 52 automated tests across 6 test codeunits (100% pass rate)
- Object ID Range Tests: 90950-90999
- Platform: Business Central Cloud 27.0
- Test Execution Time: ~0.7 seconds for full suite

---

## [26.1.0.99999] - 2024-XX-XX

### Added
- Initial calculation functionality
- Formula parser with arithmetic operations (+, -, *, /, parentheses)
- Variable support (Percentage, Absolute Value, Factor types)
- Date-based variable validity
- Template system for calculation structures
- BOM/Routing cost integration
- Status workflow (Draft, Released, Archived)
- Item card integration

### Technical Details
- Object ID Range: 90800-90899
- Dependencies: BaseApp Basic
- Platform: Business Central Cloud 27.0

---

## How to Update This Changelog

When making changes to this app:

1. Add your changes under the `[Unreleased]` section
2. Use the appropriate subsection: Added, Changed, Fixed, Deprecated, Removed, Security
3. Write in clear, user-focused language
4. Include the issue/PR number: `- Feature description (#123)`
5. When releasing, move Unreleased items to a new version section with the date

### Example Entry
```markdown
## [Unreleased]

### Added
- Multi-level formula nesting support (#456)

### Fixed
- Division by zero error handling (#789)
```

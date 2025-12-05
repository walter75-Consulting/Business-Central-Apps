# Changelog

All notable changes to **walter75 - Packages** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- 

### Changed
- 

### Fixed
- 

### Deprecated
- 

### Removed
- 

### Security
- 

## [26.2.0.0] - 2024-XX-XX

### Added
- Initial packing station functionality
- Barcode scanning support
- Integration with PrintNode for label printing
- Integration with SendCloud for shipping
- German translations

### Technical Details
- Object ID Range: 90700-90799
- Dependencies: walter75 - PrintNode, walter75 - SendCloud
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
- Multi-package scanning support for batch processing (#123)

### Fixed
- Resolved barcode scanner timeout issue (#134)
```

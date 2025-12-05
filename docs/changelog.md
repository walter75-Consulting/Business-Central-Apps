---
layout: default
title: Changelog
---

# 📝 Changelog

All notable changes to Business Central Apps will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [27.0.0] - 2025-12-05

### 🎉 Initial Open Source Release

This is the first public release of the walter75 Business Central Apps suite.

### Added

**Documentation:**
- ✨ Complete user guides for all 10 apps
- ✨ GitHub Pages documentation site with Jekyll
- ✨ Improved documentation structure with `docs/apps/` folder
- ✨ Screenshot placeholders ready for visual guides
- ✨ Navigation bar with dropdown menus
- ✨ Version documentation structure
- ✨ Centralized changelog

**Open Source:**
- 🔓 MIT License - free and open source
- 🤝 Community contributions welcome
- 📋 Issue templates (Bug Report, Feature Request)
- 📋 Pull request template
- 🔒 Security policy (SECURITY.md)
- 📖 Contributing guidelines (CONTRIBUTING.md)
- 📖 Code of conduct (CODE_OF_CONDUCT.md)
- 🛟 Support documentation (SUPPORT.md)
- 👥 CODEOWNERS file

**GitHub Integration:**
- 🚀 AL-Go for GitHub v8.1
- 🔄 Automated CI/CD workflows
- 📦 Automatic releases and versioning
- 📊 CodeQL security scanning
- 🏷️ Automatic PR/issue labeling

**Apps Included:**
- 🔐 OAuth 2.0 (ID: 90000-90099)
- ⚙️ BaseApp Basic (ID: 80000-80099)
- 📦 Packages (ID: 90700-90799)
- 🏭 BDE Terminal (ID: 90600-90699)
- 🚚 Freight Prices (ID: 91400-91499)
- 🖨️ PrintNode (ID: 92700-92799)
- 📮 Sendcloud (ID: 95700-95799)
- 🎨 Color Master (ID: 91600-91699)
- 👥 Contact Relations (ID: 91300-91399)
- 📄 XML Import (ID: 60500-60799)

### Changed

**Documentation Structure:**
- Reorganized documentation to `docs/apps/` for cleaner URLs
- Light READMEs in app folders with links to full documentation
- All user documentation centralized in `docs/apps/*-user-guide.md`

**Website:**
- Professional landing page with app cards
- User guides section with grid layout
- Technical documentation links
- Mobile-responsive navigation

---

## App-Specific Changelogs

For detailed changes in individual apps, see:

### Core Extensions
- [OAuth 2.0 Changelog](../walter75%20-%20OAuth%202.0/CHANGELOG.html)
- [BaseApp Basic Changelog](../walter75%20-%20BaseApp%20Basic/CHANGELOG.html)

### Logistics & Warehouse
- [Packages Changelog](../walter75%20-%20Packages/CHANGELOG.html)
- BDE Terminal Changelog *(Coming soon)*
- Freight Prices Changelog *(Coming soon)*

### Integration Extensions
- PrintNode Changelog *(Coming soon)*
- Sendcloud Changelog *(Coming soon)*

### Business Features
- Color Master Changelog *(Coming soon)*
- Contact Relations Changelog *(Coming soon)*
- XML Import Changelog *(Coming soon)*

---

## Release Process

### Version Numbering

We follow semantic versioning: `MAJOR.MINOR.PATCH.BUILD`

- **MAJOR**: Business Central platform version (e.g., 27 for BC 27.0)
- **MINOR**: Feature releases (backwards compatible)
- **PATCH**: Bug fixes and minor improvements
- **BUILD**: Build number (auto-incremented)

Example: `27.1.2.45`
- BC 27.0 compatible
- Feature release 1
- Patch 2
- Build 45

### Release Types

**Major Release** (e.g., 27.0.0 → 28.0.0):
- New Business Central platform version
- May contain breaking changes
- Requires migration steps

**Minor Release** (e.g., 27.0.0 → 27.1.0):
- New features and enhancements
- Backwards compatible
- No migration required

**Patch Release** (e.g., 27.0.0 → 27.0.1):
- Bug fixes
- Security updates
- Performance improvements
- Backwards compatible

---

## Upgrade Guides

### Upgrading to v27.0

**Prerequisites:**
- Business Central 27.0 or higher
- AL Runtime 16.0

**Installation Steps:**
1. Install BaseApp Basic first (if using dependent apps)
2. Install other apps in any order
3. No data migration required (initial release)

**Breaking Changes:**
- None (initial release)

---

## Roadmap

### Planned for v27.1

- Additional screenshot examples in user guides
- Video tutorials for complex workflows
- Integration guides for common app combinations
- Enhanced search functionality
- Community contribution showcase

### Under Consideration

- Additional apps for specialized industries
- Enhanced API documentation
- Interactive demos
- Localization for additional languages

---

## Contributing

We welcome contributions! See our [Contributing Guidelines](../CONTRIBUTING.html) for:
- How to report bugs
- How to suggest features
- How to submit pull requests
- Code style guidelines

---

## Support

- **Issues**: [GitHub Issues](https://github.com/walter75-Consulting/Business-Central-Apps/issues)
- **Discussions**: [GitHub Discussions](https://github.com/walter75-Consulting/Business-Central-Apps/discussions)
- **Email**: [info@walter75.de](mailto:info@walter75.de)
- **Website**: [www.walter75.de](https://www.walter75.de)

---

[← Back to Documentation](apps/) | [View Versions](versions/)

# Release Notes v27.1.0 - Calculation App Launch

**Release Date**: December 7, 2025  
**Type**: Minor Release (New Feature - Calculation App)

## 🎉 New Application

### walter75 - Calculation (ID Range: 90800-90899)

Complete manufacturing calculation and costing system with advanced features:

#### Core Features
- **Phase 0**: Foundation with Setup, Status tracking, and Permission Sets
- **Phase 1**: Core calculation engine with Item integration and comprehensive reporting
- **Phase 2**: Sales Quote integration with automated calculation workflows
- **Phase 3**: Lot Size Simulation & Optimization with constraint management
- **Phase 4**: Advanced features including:
  - Calculation History with versioning
  - Production Order integration
  - Post-Calculation analysis
  - Excel Export functionality
- **Phase 5a**: Role Center Extension for Order Processor with Cue tiles and KPIs

#### Technical Highlights
- ✅ **100% Test Coverage** - Comprehensive test automation (#20)
- ✅ **Zero Code Quality Warnings** - All LinterCop warnings resolved (#28, #30)
- ✅ **Complete Documentation** - Technical and user guides (#29)
- ✅ **BC Cloud Platform 27.0** compatible
- ✅ **Runtime 16.0** with NoImplicitWith
- ✅ **German Translation** - Full de-DE.xlf support

## 📝 Code Quality Improvements

### All Apps
- **#28**: Fixed 800+ LC warnings across codebase
- **#30**: Resolved remaining LC warnings in Calculation app post-merge
  - Fixed CalcActivities, OrderProcessorRCExt, CalcCue, CalcStatus enum
  - Added proper DataClassification and ToolTips
  - Corrected SIFT key implementation in CalcHeader

## 📚 Documentation Updates

### GitHub Pages Enhancements
- Added Calculation app to navigation menu
- Featured Calculation app on homepage
- **Legal Compliance**: Removed all commercial language across documentation
  - Updated README.md, SUPPORT.md, SECURITY.md, CODE_OF_CONDUCT.md
  - Clear disclaimer: Personal open-source project, not a commercial entity
  - Improved footer contrast for better readability

## 🔧 Technical Changes

### Calculation App Structure
- **Tables**: 10 core tables (Setup, Header, Line, Status, History, etc.)
- **Pages**: 15 pages including Card, List, Role Center Extension
- **Codeunits**: 8 codeunits (Engine, Management, Export, Post-Calc)
- **Enums**: 4 enums (Status, Price Base, Constraint Type, Scan Action)
- **Reports**: 2 reports (Calculation Report, Price Analysis)
- **Permission Sets**: CALC-FULL, CALC-VIEW

## 📦 Breaking Changes

None - This is a feature release with no breaking changes to existing apps.

## 🐛 Known Issues

- None reported at release time

## 📥 Installation

### From Release
1. Download `walter75 - München_walter75 - Calculation_27.1.0.0.app` from [Releases](https://github.com/walter75-Consulting/Business-Central-Apps/releases/tag/27.1.0)
2. Install via Business Central Extension Management
3. No dependencies required (standalone app)

### From Source
```bash
git clone https://github.com/walter75-Consulting/Business-Central-Apps.git
git checkout 27.1.0
```

## 🔄 Upgrade Path

- **From v27.0.0**: Direct upgrade, no migration required
- **New Installation**: Install directly from .app file

## 📖 Documentation

- **Technical Docs**: `walter75 - Calculation/TECHNICAL_DOCUMENTATION.md`
- **User Guide**: Available on [GitHub Pages](https://walter75-consulting.github.io/Business-Central-Apps/docs/apps/calculation-user-guide.html)
- **Testing Checklist**: `walter75 - Calculation/TESTING_CHECKLIST.md`
- **Changelog**: `walter75 - Calculation/CHANGELOG.md`

## 🙏 Acknowledgments

This release includes contributions from:
- Core development and testing
- Documentation improvements
- Code quality enhancements
- Community feedback

## 🔗 Links

- **GitHub Repository**: https://github.com/walter75-Consulting/Business-Central-Apps
- **Issues**: https://github.com/walter75-Consulting/Business-Central-Apps/issues
- **Discussions**: https://github.com/walter75-Consulting/Business-Central-Apps/discussions
- **Documentation**: https://walter75-consulting.github.io/Business-Central-Apps/

---

**License**: MIT License  
**Support**: Community support via GitHub Issues only  
**Project Type**: Personal open-source project (not a commercial service)

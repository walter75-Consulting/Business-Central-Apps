# Business Central Apps by walter75 Consulting

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Business Central](https://img.shields.io/badge/Business%20Central-27.0-00838F.svg)](https://dynamics.microsoft.com/business-central/)
[![CI/CD](https://github.com/walter75-Consulting/Business-Central-Apps/actions/workflows/CICD.yaml/badge.svg)](https://github.com/walter75-Consulting/Business-Central-Apps/actions)
[![GitHub Pages](https://img.shields.io/badge/docs-GitHub%20Pages-00838F)](https://walter75-consulting.github.io/Business-Central-Apps/)
[![Contributors](https://img.shields.io/github/contributors/walter75-Consulting/Business-Central-Apps)](https://github.com/walter75-Consulting/Business-Central-Apps/graphs/contributors)
[![Last Commit](https://img.shields.io/github/last-commit/walter75-Consulting/Business-Central-Apps)](https://github.com/walter75-Consulting/Business-Central-Apps/commits/main)
[![Issues](https://img.shields.io/github/issues/walter75-Consulting/Business-Central-Apps)](https://github.com/walter75-Consulting/Business-Central-Apps/issues)
[![Stars](https://img.shields.io/github/stars/walter75-Consulting/Business-Central-Apps)](https://github.com/walter75-Consulting/Business-Central-Apps/stargazers)

A collection of open-source extensions for Microsoft Dynamics 365 Business Central - Production-ready apps for logistics, manufacturing, and business management.

## ✨ Key Features

### 🔗 Core Platform
- **🔐 OAuth 2.0** - Secure API authentication framework for external integrations
- **⚙️ BaseApp Basic** - Foundation layer with shared utilities and functionality

### 📦 Logistics & Warehouse
- **📦 Packages** - Barcode scanning workflow with PrintNode and SendCloud integration
- **🚚 Freight Prices** - Zone-based pricing with carrier management
- **🏭 BDE Terminal** - Shop floor data entry with touch-optimized UI

### 🔌 Integration Extensions
- **🖨️ PrintNode** - Silent printing to thermal label printers
- **📮 SendCloud** - 80+ carrier integration with tracking
- **📄 XML Import** - Flexible data import with transformation

### 💼 Business Management
- **🎨 Color Master** - Formula management and color matching
- **👥 Contact Relations** - Relationship mapping and hierarchies

## 🚀 Getting Started

### Prerequisites
- Microsoft Dynamics 365 Business Central (version 27.0 or higher)
- Visual Studio Code with AL Language extension
- AL-Go for GitHub (for development)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/walter75-Consulting/Business-Central-Apps.git
```

2. Open the workspace in VS Code:
```bash
code BC-Apps.code-workspace
```

3. Each app folder contains its own `app.json` and source code
4. Review individual app documentation in their respective folders

### Building Apps

This repository uses AL-Go for GitHub for automated builds and deployments. The workflow configurations are located in `.github/workflows/`.

## 📖 Documentation

Each app contains detailed documentation:
- `TECHNICAL_DOCUMENTATION.md` - Technical implementation details
- `USER_DOCUMENTATION.md` - End-user guides and features
- `CHANGELOG.md` - Version history and changes

## 🌐 WordPress Integration

Display these extensions on your WordPress website with the dedicated WordPress plugin:

**[walter75-bc-extensions](https://github.com/walter75-Consulting/WP-Plugins)** - WordPress plugin for showcasing BC Extensions with GitHub stats, releases, and app cards.

Features:
- Beautiful app cards with BC branding
- Live GitHub statistics
- Latest releases display
- Responsive widgets for sidebars
- 4 easy-to-use shortcodes

[→ View WordPress Plugin Repository](https://github.com/walter75-Consulting/WP-Plugins)

## 💬 Community

- **💡 Discussions** - Join our [GitHub Discussions](https://github.com/walter75-Consulting/Business-Central-Apps/discussions) for questions, ideas, and community support
- **🐛 Issues** - Report bugs or request features via [GitHub Issues](https://github.com/walter75-Consulting/Business-Central-Apps/issues)
- **❤️ Sponsor** - Support this project via [GitHub Sponsors](https://github.com/sponsors/walter75-Consulting)

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to contribute to this project.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔒 Security

For security concerns, please see [SECURITY.md](SECURITY.md).

## 💬 Support

For support and questions, please see [SUPPORT.md](SUPPORT.md).

## 🌐 About walter75 Consulting

walter75 Consulting specializes in Microsoft Dynamics 365 Business Central solutions, providing custom extensions and consulting services.

- Website: [www.walter75.de](https://www.walter75.de)
- Location: München, Germany

## 🙏 Acknowledgments

This project uses [AL-Go for GitHub](https://github.com/microsoft/AL-Go) for automated builds and deployments.

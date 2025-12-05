# Business Central Apps v27.0.0 - Initial Public Release 🎉

We're excited to announce the first public release of our Business Central extensions collection! This release marks the transition of our professional Business Central apps to open source under the MIT License.

## 📦 Available Apps

### Core Extensions
- **walter75 - OAuth 2.0** (90000-90099) - OAuth 2.0 authentication framework for external API integrations
- **walter75 - BaseApp Basic** (80000-80099) - Foundation app with shared functionality across multiple business areas

### Logistics & Warehouse Management
- **walter75 - Packages** (90700-90799) - Comprehensive packing station solution with barcode scanning, PrintNode and SendCloud integration
- **walter75 - BDE Terminal** (90600-90699) - Manufacturing data entry terminals with custom button controls
- **walter75 - Freight Prices** (91400-91499) - Advanced freight pricing management

### Integration Extensions
- **walter75 - PrintNode** - Print service integration for label printing and thermal printers
- **walter75 - Sendcloud** - Shipping carrier integration for automated label creation and tracking

### Business Features
- **walter75 - Color Master** (91600-91699) - Color management system for manufacturing
- **walter75 - Contact Relations** (91300-91399) - Enhanced contact relationship management
- **walter75 - XML Import** - XML data import functionality for external system integration

## 🚀 Platform Information

- **Business Central Version**: 27.0.0.0
- **AL Runtime**: 16.0
- **Target Platform**: Cloud
- **Development Framework**: AL-Go for GitHub

## 📖 Documentation

Each app includes comprehensive documentation:
- `TECHNICAL_DOCUMENTATION.md` - Implementation details and architecture
- `USER_DOCUMENTATION.md` - End-user guides (where applicable)
- `CHANGELOG.md` - Version history and changes

## 🤝 Contributing

We welcome contributions from the community! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details on:
- How to report issues
- Development setup
- Code standards and best practices
- Pull request process

## 📄 License

All apps are licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 🔒 Security

For security concerns, please refer to our [Security Policy](SECURITY.md).

## 💬 Support

- **Community Support**: GitHub Issues and Discussions
- **Commercial Support**: Available through walter75 Consulting
- **Website**: [www.walter75.de](https://www.walter75.de)

## 🙏 Acknowledgments

Special thanks to:
- Microsoft for the AL-Go for GitHub framework
- The Business Central community for inspiration and feedback
- Our customers who helped shape these solutions

## 📝 Release Notes

This is the initial public release containing production-ready apps that have been used in commercial Business Central environments. All apps have been tested with Business Central version 27.0.

### What's New in This Release

- Open source release under MIT License
- Complete documentation for all apps
- GitHub Actions workflows for CI/CD
- Issue templates for bug reports and feature requests
- Code of Conduct and Contributing Guidelines

### Installation

1. Clone the repository or download the release artifacts
2. Review individual app documentation in their respective folders
3. Install apps through Business Central extension management
4. Configure apps according to their setup documentation

### Dependencies

Some apps have dependencies on other walter75 apps:
- **Packages** depends on: PrintNode, Sendcloud
- Multiple apps depend on: BaseApp Basic

Please ensure dependencies are installed in the correct order.

---

**Full Changelog**: https://github.com/walter75-Consulting/Business-Central-Apps/commits/v27.0.0

For questions or support, please open an issue or visit our website.

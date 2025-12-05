---
layout: default
title: Home
---

# Business Central Apps by walter75 Consulting

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Business Central](https://img.shields.io/badge/Business%20Central-27.0-blue.svg)](https://dynamics.microsoft.com/business-central/)
[![GitHub Release](https://img.shields.io/github/v/release/walter75-Consulting/Business-Central-Apps)](https://github.com/walter75-Consulting/Business-Central-Apps/releases)

Open-source extensions for Microsoft Dynamics 365 Business Central - Production-ready apps for logistics, manufacturing, and business management.

---

## 📦 Available Apps

### Core Extensions

<div class="app-card">
  <h4>🔐 walter75 - OAuth 2.0</h4>
  <p>OAuth 2.0 authentication framework for external API integrations</p>
  <p><strong>ID Range:</strong> 90000-90099</p>
  <a href="docs/apps/oauth.html">Learn More →</a>
</div>

<div class="app-card">
  <h4>⚙️ walter75 - BaseApp Basic</h4>
  <p>Foundation app with shared functionality across multiple business areas</p>
  <p><strong>ID Range:</strong> 80000-80099</p>
  <a href="docs/apps/baseapp.html">Learn More →</a> | 
  <a href="walter75%20-%20BaseApp%20Basic/USER_DOCUMENTATION.html">User Guide</a>
</div>

### Logistics & Warehouse

<div class="app-card">
  <h4>📦 walter75 - Packages</h4>
  <p>Comprehensive packing station solution with barcode scanning, PrintNode and SendCloud integration</p>
  <p><strong>ID Range:</strong> 90700-90799</p>
  <a href="docs/apps/packages.html">Learn More →</a> | 
  <a href="walter75%20-%20Packages/USER_DOCUMENTATION.html">User Guide</a>
</div>

<div class="app-card">
  <h4>🏭 walter75 - BDE Terminal</h4>
  <p>Manufacturing data entry terminals with custom button controls</p>
  <p><strong>ID Range:</strong> 90600-90699</p>
  <a href="docs/apps/bde-terminal.html">Learn More →</a>
</div>

<div class="app-card">
  <h4>🚚 walter75 - Freight Prices</h4>
  <p>Advanced freight pricing management</p>
  <p><strong>ID Range:</strong> 91400-91499</p>
  <a href="docs/apps/freight-prices.html">Learn More →</a>
</div>

### Integration Extensions

<div class="app-card">
  <h4>🖨️ walter75 - PrintNode</h4>
  <p>Print service integration for label printing and thermal printers</p>
  <p><strong>ID Range:</strong> 92700-92799</p>
  <a href="docs/apps/printnode.html">Learn More →</a>
</div>

<div class="app-card">
  <h4>📮 walter75 - Sendcloud</h4>
  <p>Shipping carrier integration for automated label creation and tracking</p>
  <p><strong>ID Range:</strong> 95700-95799</p>
  <a href="docs/apps/sendcloud.html">Learn More →</a>
</div>

### Business Features

<div class="app-card">
  <h4>🎨 walter75 - Color Master</h4>
  <p>Color management system for manufacturing</p>
  <p><strong>ID Range:</strong> 91600-91699</p>
  <a href="docs/apps/color-master.html">Learn More →</a>
</div>

<div class="app-card">
  <h4>👥 walter75 - Contact Relations</h4>
  <p>Enhanced contact relationship management</p>
  <p><strong>ID Range:</strong> 91300-91399</p>
  <a href="docs/apps/contact-relations.html">Learn More →</a>
</div>

<div class="app-card">
  <h4>📄 walter75 - XML Import</h4>
  <p>XML data import functionality for external system integration</p>
  <p><strong>ID Range:</strong> 60500-60799</p>
  <a href="docs/apps/xml-import.html">Learn More →</a>
</div>

---

## 🚀 Quick Start

### Prerequisites
- Microsoft Dynamics 365 Business Central (version 27.0 or higher)
- Visual Studio Code with AL Language extension
- AL-Go for GitHub (for development)

### Installation

```bash
# Clone the repository
git clone https://github.com/walter75-Consulting/Business-Central-Apps.git

# Open in VS Code
code BC-Apps.code-workspace
```

Each app folder contains its own `app.json` and source code. Review individual app documentation for specific setup instructions.

---

## 📖 Documentation

### 📚 User Guides

Complete setup and usage instructions for each app:

<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1rem; margin: 1rem 0;">
  <a href="docs/apps/oauth-user-guide.html" class="doc-link">🔐 OAuth 2.0 Guide</a>
  <a href="docs/apps/baseapp-user-guide.html" class="doc-link">⚙️ BaseApp Basic Guide</a>
  <a href="docs/apps/packages-user-guide.html" class="doc-link">📦 Packages Guide</a>
  <a href="docs/apps/bde-terminal-user-guide.html" class="doc-link">🏭 BDE Terminal Guide</a>
  <a href="docs/apps/freight-prices-user-guide.html" class="doc-link">🚚 Freight Prices Guide</a>
  <a href="docs/apps/printnode-user-guide.html" class="doc-link">🖨️ PrintNode Guide</a>
  <a href="docs/apps/sendcloud-user-guide.html" class="doc-link">📮 Sendcloud Guide</a>
  <a href="docs/apps/color-master-user-guide.html" class="doc-link">🎨 Color Master Guide</a>
  <a href="docs/apps/contact-relations-user-guide.html" class="doc-link">👥 Contact Relations Guide</a>
  <a href="docs/apps/xml-import-user-guide.html" class="doc-link">📄 XML Import Guide</a>
</div>

### 📘 Technical Documentation

App overviews and technical details:
- [All Apps Overview](docs/apps/) - Complete list with technical specs
- [Changelog](docs/changelog.html) - Release history and version updates

### 📖 Project Documentation
- [Contributing Guidelines](CONTRIBUTING.html)
- [Code of Conduct](CODE_OF_CONDUCT.html)
- [Security Policy](SECURITY.html)
- [Support](SUPPORT.html)

### 👨‍💻 Developer Documentation
- [AL Reference Documentation](reference/) - API documentation for developers (generated via AL-Go)

---

## 🤝 Contributing

We welcome contributions from the community! Whether you're fixing bugs, adding features, or improving documentation, your help is appreciated.

**How to contribute:**
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

See our [Contributing Guidelines](CONTRIBUTING.html) for detailed instructions.

---

## 🔒 Security & Support

- **Security Issues:** Please review our [Security Policy](SECURITY.html)
- **Community Support:** [GitHub Issues](https://github.com/walter75-Consulting/Business-Central-Apps/issues) and Discussions
- **Commercial Support:** Available through walter75 Consulting

---

## 🌐 About walter75 Consulting

walter75 Consulting specializes in Microsoft Dynamics 365 Business Central solutions, providing custom extensions and consulting services.

- 🌐 **Website:** [www.walter75.de](https://www.walter75.de)
- 📍 **Location:** München, Germany
- 📧 **Contact:** info@walter75.de

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.html) file for details.

---

## 🙏 Acknowledgments

Special thanks to:
- Microsoft for the AL-Go for GitHub framework
- The Business Central community for inspiration and feedback
- Our customers who helped shape these solutions

---

<div style="text-align: center; margin-top: 3rem; padding: 2rem; background: #f5f5f5; border-radius: 8px;">
  <h3>⭐ Star us on GitHub!</h3>
  <p>If you find these apps useful, please consider starring the repository.</p>
  <a href="https://github.com/walter75-Consulting/Business-Central-Apps" class="btn">View on GitHub</a>
</div>

<style>
.app-card {
  background: #f8f9fa;
  border-left: 4px solid #0366d6;
  padding: 1rem;
  margin: 1rem 0;
  border-radius: 4px;
}

.app-card h4 {
  margin-top: 0;
  color: #0366d6;
}

.app-card p {
  margin: 0.5rem 0;
}

.app-card a {
  color: #0366d6;
  text-decoration: none;
  font-weight: 500;
}

.app-card a:hover {
  text-decoration: underline;
}

.btn {
  display: inline-block;
  padding: 0.75rem 1.5rem;
  background: #0366d6;
  color: white !important;
  text-decoration: none;
  border-radius: 4px;
  font-weight: 500;
  margin-top: 1rem;
}

.btn:hover {
  background: #0256c7;
  text-decoration: none;
}

.doc-link {
  display: block;
  padding: 1rem;
  background: white;
  border: 2px solid #e1e4e8;
  border-radius: 6px;
  color: #0366d6 !important;
  text-decoration: none;
  font-weight: 500;
  text-align: center;
  transition: all 0.2s;
}

.doc-link:hover {
  border-color: #0366d6;
  box-shadow: 0 4px 8px rgba(3, 102, 214, 0.1);
  transform: translateY(-2px);
  text-decoration: none;
}
</style>

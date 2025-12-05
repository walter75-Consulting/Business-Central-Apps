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
  <a href="walter75%20-%20OAuth%202.0/TECHNICAL_DOCUMENTATION.html">Technical Docs</a>
</div>

<div class="app-card">
  <h4>⚙️ walter75 - BaseApp Basic</h4>
  <p>Foundation app with shared functionality across multiple business areas</p>
  <p><strong>ID Range:</strong> 80000-80099</p>
  <a href="walter75%20-%20BaseApp%20Basic/TECHNICAL_DOCUMENTATION.html">Technical Docs</a> | 
  <a href="walter75%20-%20BaseApp%20Basic/USER_DOCUMENTATION.html">User Guide</a>
</div>

### Logistics & Warehouse

<div class="app-card">
  <h4>📦 walter75 - Packages</h4>
  <p>Comprehensive packing station solution with barcode scanning, PrintNode and SendCloud integration</p>
  <p><strong>ID Range:</strong> 90700-90799</p>
  <a href="walter75%20-%20Packages/TECHNICAL_DOCUMENTATION.html">Technical Docs</a> | 
  <a href="walter75%20-%20Packages/USER_DOCUMENTATION.html">User Guide</a>
</div>

<div class="app-card">
  <h4>🏭 walter75 - BDE Terminal</h4>
  <p>Manufacturing data entry terminals with custom button controls</p>
  <p><strong>ID Range:</strong> 90600-90699</p>
  <a href="walter75%20-%20BDE%20Terminal/TECHNICAL_DOCUMENTATION.html">Technical Docs</a>
</div>

<div class="app-card">
  <h4>🚚 walter75 - Freight Prices</h4>
  <p>Advanced freight pricing management</p>
  <p><strong>ID Range:</strong> 91400-91499</p>
  <a href="walter75%20-%20Freight%20Prices/TECHNICAL_DOCUMENTATION.html">Technical Docs</a>
</div>

### Integration Extensions

<div class="app-card">
  <h4>🖨️ walter75 - PrintNode</h4>
  <p>Print service integration for label printing and thermal printers</p>
  <p><strong>ID Range:</strong> 92700-92799</p>
  <a href="walter75%20-%20PrintNode/TECHNICAL_DOCUMENTATION.html">Technical Docs</a>
</div>

<div class="app-card">
  <h4>📮 walter75 - Sendcloud</h4>
  <p>Shipping carrier integration for automated label creation and tracking</p>
  <p><strong>ID Range:</strong> 95700-95799</p>
  <a href="walter75%20-%20Sendcloud/TECHNICAL_DOCUMENTATION.html">Technical Docs</a>
</div>

### Business Features

<div class="app-card">
  <h4>🎨 walter75 - Color Master</h4>
  <p>Color management system for manufacturing</p>
  <p><strong>ID Range:</strong> 91600-91699</p>
  <a href="walter75%20-%20Color%20Master/TECHNICAL_DOCUMENTATION.html">Technical Docs</a>
</div>

<div class="app-card">
  <h4>👥 walter75 - Contact Relations</h4>
  <p>Enhanced contact relationship management</p>
  <p><strong>ID Range:</strong> 91300-91399</p>
  <a href="walter75%20-%20Contact%20Relations/TECHNICAL_DOCUMENTATION.html">Technical Docs</a>
</div>

<div class="app-card">
  <h4>📄 walter75 - XML Import</h4>
  <p>XML data import functionality for external system integration</p>
  <p><strong>ID Range:</strong> 60500-60799</p>
  <a href="walter75%20-%20XML%20Import/TECHNICAL_DOCUMENTATION.html">Technical Docs</a>
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

### User Documentation
- [Contributing Guidelines](CONTRIBUTING.html)
- [Code of Conduct](CODE_OF_CONDUCT.html)
- [Security Policy](SECURITY.html)
- [Support](SUPPORT.html)
- [Release Notes v27.0.0](RELEASE_NOTES_v27.0.0.html)

### Developer Documentation
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
</style>

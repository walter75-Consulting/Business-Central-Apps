# WordPress Post: Calculation App Launch

---

## Title
🚀 Neue Business Central Extension: Calculation App für Manufacturing & Costing

## Slug
`calculation-app-business-central-launch`

## Excerpt
Die neue Calculation App für Microsoft Dynamics 365 Business Central ist da! Umfassendes Manufacturing Calculation und Costing System mit Lot Size Simulation, Sales Quote Integration und Excel Export. Open Source unter MIT License.

## Categories
- Business Central Extensions
- Manufacturing
- Open Source

## Tags
- Business Central
- Microsoft Dynamics 365
- Manufacturing
- Calculation
- Costing
- Pricing
- Open Source
- AL Language
- ERP Extension

## Featured Image
Suggestion: Screenshot of Calculation Card or Role Center Extension

---

## Post Content

### Einleitung

Ich freue mich, die **walter75 - Calculation App** vorzustellen – eine umfassende Business Central Extension für Manufacturing Calculation und Costing, die ich in den letzten Monaten entwickelt habe. Die App ist ab sofort als Open Source unter MIT License verfügbar!

**GitHub Repository**: [walter75-Consulting/Business-Central-Apps](https://github.com/walter75-Consulting/Business-Central-Apps)

---

### 🎯 Was ist die Calculation App?

Die Calculation App ist ein vollständiges System zur Kalkulation von Fertigungskosten, Preisermittlung und Angebotserstellung in Microsoft Dynamics 365 Business Central. Sie richtet sich an produzierende Unternehmen, die:

- **Komplexe Kalkulationen** mit mehreren Preisbasen durchführen
- **Verschiedene Losgrößen simulieren** und optimieren möchten
- **Sales Quotes automatisch** aus Kalkulationen generieren wollen
- **Kalkulationshistorie** mit Versionierung benötigen
- **Excel-Exporte** für externe Analysen nutzen

---

### ✨ Kernfeatures

#### 📊 Calculation Engine (Phase 1)
- Flexible Preisbasen: Einkaufspreis, Einstandspreis, Verkaufspreis
- Auf-/Abschläge in Prozent oder absoluten Werten
- Automatische Item-Integration
- Umfassende Reports

#### 📝 Sales Quote Integration (Phase 2)
- Ein-Klick-Generierung von Verkaufsangeboten
- Automatische Übertragung aller Kalkulationszeilen
- Bidirektionale Synchronisation

#### 🔄 Lot Size Simulation (Phase 3)
- Simulation verschiedener Losgrößen
- Min/Max Constraints
- Optimierungsvorschläge
- Kostenvergleich

#### 🚀 Advanced Features (Phase 4)
- **Calculation History**: Vollständige Versionierung aller Kalkulationen
- **Production Integration**: Direkte Anbindung an Fertigungsaufträge
- **Post-Calculation**: Nachkalkulation mit Soll/Ist-Vergleich
- **Excel Export**: Flexible Datenexporte für externe Analysen

#### 📈 Role Center Extension (Phase 5a)
- Order Processor Dashboard mit Cue Tiles
- KPI-Übersicht: Offene Kalkulationen, Verkaufsangebote, Simulationen
- Direktzugriff auf alle wichtigen Funktionen

---

### 🏗️ Technische Highlights

Die App wurde nach **Best Practices** entwickelt und erfüllt höchste Qualitätsstandards:

✅ **100% Test Coverage** – Comprehensive Test Automation  
✅ **Zero Code Quality Warnings** – Alle LinterCop-Regeln erfüllt  
✅ **Complete Documentation** – Technical & User Guides  
✅ **Cloud-Ready** – BC Platform 27.0, Runtime 16.0  
✅ **German Translation** – Vollständige de-DE.xlf Unterstützung  
✅ **NoImplicitWith** – Moderne AL Code Patterns  

**Object ID Range**: 90800-90899  
**Dependencies**: Keine – Standalone App

---

### 📦 App-Struktur

```
walter75 - Calculation/
  ├── Tables (10)      → Setup, Header, Line, Status, History, etc.
  ├── Pages (15)       → Card, List, Role Center Extension
  ├── Codeunits (8)    → Engine, Management, Export, Post-Calc
  ├── Enums (4)        → Status, Price Base, Constraint Types
  ├── Reports (2)      → Calculation Report, Price Analysis
  └── Permissions (2)  → CALC-FULL, CALC-VIEW
```

---

### 🎓 Development Journey

Die Entwicklung erfolgte in **strukturierten Phasen**:

1. **Phase 0**: Foundation – Setup, Status Management, Permissions
2. **Phase 1**: MVP – Core Calculation Engine + Item Integration
3. **Phase 2**: Sales Integration – Quote Generation & Sync
4. **Phase 3**: Optimization – Lot Size Simulation
5. **Phase 4**: Advanced – History, Production, Post-Calc, Export
6. **Phase 5a**: UX – Role Center Extension & KPIs

Jede Phase wurde vollständig getestet, dokumentiert und in separaten Pull Requests gemerged.

#### 🤖 AI-Assisted Development

Ein besonderer Aspekt dieses Projekts: **Die gesamte Entwicklung erfolgte in Zusammenarbeit mit GitHub Copilot**. Dies ist ein perfektes Beispiel für den aktuellen Trend im Software Engineering – **Human-AI Collaboration**.

**Wie sah die Zusammenarbeit aus?**

- **Ich (Sebastian)**: Anforderungen, Architektur-Entscheidungen, Code-Reviews, Testing-Strategie, Business-Logik
- **GitHub Copilot**: Code-Generation, Best-Practice-Patterns, Dokumentation, Test-Automation, Refactoring

**Was hat AI-Assisted Development gebracht?**

✅ **Deutlich höhere Entwicklungsgeschwindigkeit** – Komplette App in wenigen Wochen  
✅ **Bessere Code-Qualität** – Konsistente Patterns, vollständige Dokumentation  
✅ **100% Test Coverage** – AI-generierte Tests mit allen Edge Cases  
✅ **Zero Warnings** – Copilot kennt alle LinterCop-Regeln  
✅ **Umfassende Docs** – Technical & User Documentation automatisch mitwachsend  

**Mein Fazit**: AI ist kein Ersatz für Entwickler, sondern ein **Produktivitäts-Multiplier**. Die Kombination aus menschlicher Expertise (Business-Wissen, Architektur) und AI-Unterstützung (Code-Patterns, Best Practices) ist extrem leistungsfähig.

Dieser Trend wird die Software-Entwicklung fundamental verändern – und dieses Projekt ist ein Beweis dafür! 🚀

---

### 📚 Dokumentation

Die App kommt mit **umfassender Dokumentation**:

- **Technical Documentation**: Architektur, Datenmodell, API
- **User Guide**: End-User Features und Workflows
- **Testing Checklist**: Komplette Test-Szenarien
- **CHANGELOG.md**: Detaillierte Versionshistorie

**Online verfügbar**: [GitHub Pages Documentation](https://walter75-consulting.github.io/Business-Central-Apps/docs/apps/calculation.html)

---

### 🔧 Installation

#### Option 1: Pre-Built App (Empfohlen)
1. Download `.app` file from [GitHub Releases](https://github.com/walter75-Consulting/Business-Central-Apps/releases)
2. Install via Business Central Extension Management
3. Fertig! Keine Dependencies erforderlich

#### Option 2: From Source
```bash
git clone https://github.com/walter75-Consulting/Business-Central-Apps.git
cd "walter75 - Calculation"
# Build with AL-Go oder VS Code AL Language Extension
```

---

### 🌐 Open Source & Community

Die Calculation App ist Teil meines **Open Source Business Central Projekts**. Das gesamte Repository enthält mehrere Production-Ready Extensions:

- 🔐 **OAuth 2.0** – API Authentication Framework
- 📦 **Packages** – Barcode Scanning & Shipping Integration
- 🚚 **Freight Prices** – Zone-based Carrier Pricing
- 🖨️ **PrintNode** – Silent Thermal Label Printing
- 📮 **SendCloud** – Multi-Carrier Shipping
- 🏭 **BDE Terminal** – Shop Floor Data Entry
- 🧮 **Calculation** – Manufacturing Costing (NEU!)
- ...und weitere

**License**: MIT License – Free to use, modify, and distribute  
**Support**: Community-Support via GitHub Issues/Discussions

---

### 🤝 Contribution Welcome

Das Projekt lebt von **Community-Beiträgen**:

- 🐛 **Bug Reports** via GitHub Issues
- 💡 **Feature Requests** via GitHub Discussions
- 🔧 **Pull Requests** sind willkommen!
- ⭐ **GitHub Star** wenn die App dir gefällt

---

### 🎯 Nächste Schritte

Du möchtest die App ausprobieren?

1. **⭐ Star auf GitHub**: [walter75-Consulting/Business-Central-Apps](https://github.com/walter75-Consulting/Business-Central-Apps)
2. **📥 Download Release**: [v27.1.0](https://github.com/walter75-Consulting/Business-Central-Apps/releases)
3. **📖 Lies die Docs**: [GitHub Pages](https://walter75-consulting.github.io/Business-Central-Apps/)
4. **💬 Join Discussion**: [Community Forum](https://github.com/walter75-Consulting/Business-Central-Apps/discussions)

---

### 🙏 Feedback & Austausch

Ich freue mich über **Feedback, Fragen und Erfahrungsberichte**!

Besonders interessiert mich:
- **Eure Erfahrungen mit der App** in produktiven Umgebungen
- **AI-Assisted Development**: Nutzt ihr auch GitHub Copilot oder andere AI-Tools?
- **Feature Requests**: Was fehlt euch noch?

**Kontakt:**
- **GitHub Issues**: [Report Bugs or Request Features](https://github.com/walter75-Consulting/Business-Central-Apps/issues)
- **GitHub Discussions**: [Ask Questions](https://github.com/walter75-Consulting/Business-Central-Apps/discussions)
- **Personal Contact**: sebastian@walter75.de (für private Anfragen)

---

### 📌 Disclaimer

Dies ist ein **persönliches Open-Source-Projekt**, keine kommerzielle Dienstleistung. Die App wird "as-is" unter MIT License bereitgestellt. Community-Support erfolgt auf freiwilliger Basis über GitHub.

---

## Call-to-Action

**[⬇️ Download v27.1.0](https://github.com/walter75-Consulting/Business-Central-Apps/releases)** | **[📖 Documentation](https://walter75-consulting.github.io/Business-Central-Apps/)** | **[⭐ Star on GitHub](https://github.com/walter75-Consulting/Business-Central-Apps)**

---

## Related Posts (Suggestions)
- "How to Build Business Central Extensions with AL-Go"
- "AI-Assisted Development: Meine Erfahrungen mit GitHub Copilot"
- "Best Practices für AL Language Development"
- "Open Source Business Central Apps – Meine Erfahrungen"
- "Manufacturing Calculation Patterns in Business Central"
- "Human-AI Collaboration im Software Engineering"

---

## Social Media Snippets

### Twitter/X
🚀 Neue #BusinessCentral Extension: Calculation App für Manufacturing & Costing ist live!

✅ Lot Size Simulation
✅ Sales Quote Integration  
✅ Excel Export
✅ 100% Test Coverage
✅ Open Source (MIT)

[Link to post]

#MSDyn365BC #ALLanguage #OpenSource

### LinkedIn
I'm excited to announce the launch of the Calculation App for Microsoft Dynamics 365 Business Central! 🚀

This open-source extension provides comprehensive manufacturing calculation and costing capabilities, including:

• Flexible pricing with multiple base options
• Lot size simulation & optimization
• Automated sales quote generation
• Production order integration
• Excel export for external analysis

Built with best practices: 100% test coverage, zero code warnings, complete documentation, and cloud-ready for BC 27.0.

**What makes this special?** The entire app was developed using AI-assisted development with GitHub Copilot – a perfect example of human-AI collaboration. This approach delivered higher quality code in a fraction of the time.

The app is part of my open-source Business Central project, available under MIT License.

Check it out: [GitHub link]

#BusinessCentral #MSDyn365 #Manufacturing #OpenSource #ERP #AI #GitHubCopilot #AIAssistedDevelopment

---

**Publish Date**: December 7, 2025  
**Status**: Ready to Publish  
**Author**: Sebastian Walter

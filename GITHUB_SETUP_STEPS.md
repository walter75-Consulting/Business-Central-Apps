# GitHub Repository Setup - Manuelle Schritte

## ✅ Bereits erledigt:
- [x] MIT License hinzugefügt
- [x] README.md aktualisiert
- [x] Alle Open-Source Dateien erstellt
- [x] Code committed und gepusht
- [x] Release-Tag v27.0.0 erstellt und gepusht
- [x] Release Notes vorbereitet

## 📋 Manuelle Schritte auf GitHub

### 1. GitHub Release erstellen

**URL**: https://github.com/walter75-Consulting/Business-Central-Apps/releases/new

**Schritte**:
1. Klicke auf "Choose a tag" → wähle `v27.0.0`
2. Release Title: `Business Central Apps v27.0.0 - Initial Public Release 🎉`
3. Description: Kopiere den kompletten Inhalt aus `RELEASE_NOTES_v27.0.0.md`
4. ✅ Häkchen bei "Set as the latest release"
5. Klicke "Publish release"

---

### 2. Repository About-Section konfigurieren

**Location**: Hauptseite des Repos → rechts oben → ⚙️ (Settings Icon neben "About")

**Konfiguration**:
- **Description**: 
  ```
  Open-source Business Central extensions for logistics, manufacturing, and business management
  ```

- **Website**: 
  ```
  https://www.walter75.de
  ```

- **Topics** (8 Topics empfohlen):
  - `businesscentral`
  - `dynamics365`
  - `al-language`
  - `erp`
  - `pte`
  - `warehouse`
  - `logistics`
  - `microsoft`

- **Checkboxes**:
  - ✅ Include in the home page

---

### 3. Repository Features aktivieren

**URL**: https://github.com/walter75-Consulting/Business-Central-Apps/settings

**Im Tab "General" → Features**:

- ✅ **Wikis** (optional - für erweiterte Dokumentation)
- ✅ **Issues** (bereits aktiv)
- ✅ **Sponsorships** (optional - falls du Sponsoring ermöglichen möchtest)
- ✅ **Discussions** (empfohlen für Community-Fragen)

Scrolle nach unten und klicke "Save changes"

---

### 3a. GitHub Pages aktivieren (AL-Go Integration)

**URL**: https://github.com/walter75-Consulting/Business-Central-Apps/settings/pages

**Schritte**:
1. **Source**: Wähle "GitHub Actions"
2. Nach dem nächsten Push wird automatisch deployed
3. Deine Website wird verfügbar sein unter: `https://walter75-consulting.github.io/Business-Central-Apps/`

**Was wurde vorbereitet**:
- ✅ Jekyll Konfiguration (`_config.yml`)
- ✅ Professionelle Landing Page (`index.md`)
- ✅ Automatisches Deployment via GitHub Actions (`pages.yml`)
- ✅ Responsive Design mit App-Karten
- ✅ Verlinkung zu allen Dokumentationen
- ✅ Integration mit AL-Go Reference Documentation Workflow

**Zwei Dokumentations-Ebenen**:
1. **Haupt-Website** (Jekyll) - Automatisch bei Push zu `main`
   - User-Dokumentation, App-Showcase, Contributing Guides
   - URL: `https://walter75-consulting.github.io/Business-Central-Apps/`

2. **AL Reference Docs** (AL-Go) - Manuell via Workflow
   - API-Dokumentation für Entwickler aus AL-Code generiert
   - URL: `https://walter75-consulting.github.io/Business-Central-Apps/reference/`
   - Workflow: Actions → "Deploy Reference Documentation" → Run workflow

Beide Workflows arbeiten harmonisch zusammen und nutzen dasselbe GitHub Pages Environment.

---

### 4. Branch Protection Rules (Empfohlen für main Branch)

**URL**: https://github.com/walter75-Consulting/Business-Central-Apps/settings/branches

**Schritte**:
1. Klicke "Add rule" oder "Add branch protection rule"
2. Branch name pattern: `main`

**Empfohlene Einstellungen**:
- ✅ **Require a pull request before merging**
  - ✅ Require approvals: 1
  - ✅ Dismiss stale pull request approvals when new commits are pushed
  - ✅ Require review from Code Owners
- ✅ **Require status checks to pass before merging**
  - ✅ Require branches to be up to date before merging
  - Status checks: Wähle "CICD" (nach erstem Workflow-Run verfügbar)
- ✅ **Require conversation resolution before merging**
- ✅ **Do not allow bypassing the above settings**

3. Klicke "Create" oder "Save changes"

---

### 5. GitHub Discussions aktivieren und konfigurieren

**URL**: https://github.com/walter75-Consulting/Business-Central-Apps/settings

**Im Tab "General" → Features**:
1. ✅ Aktiviere "Discussions"
2. Nach Aktivierung: Gehe zu Discussions Tab
3. Erstelle Kategorien:
   - 💬 General (Q&A)
   - 💡 Ideas (für Feature Requests)
   - 🙏 Q&A (für Fragen)
   - 📣 Announcements (für Releases)

---

### 6. Social Preview Image (Optional aber empfohlen)

**URL**: https://github.com/walter75-Consulting/Business-Central-Apps/settings

**Im Tab "General" → Social Preview**:
1. Klicke "Edit"
2. Lade ein Bild hoch (Empfohlen: 1280x640px)
   - Kann das walter75 Logo mit "Business Central Apps" Text sein
   - Wird auf Social Media verwendet beim Teilen des Repos

---

### 7. README Badges aktualisieren (Optional)

Falls du weitere Badges hinzufügen möchtest, bearbeite die README.md:

```markdown
[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Business Central](https://img.shields.io/badge/Business%20Central-27.0-blue.svg)](https://dynamics.microsoft.com/business-central/)
[![GitHub Release](https://img.shields.io/github/v/release/walter75-Consulting/Business-Central-Apps)](https://github.com/walter75-Consulting/Business-Central-Apps/releases)
[![GitHub Stars](https://img.shields.io/github/stars/walter75-Consulting/Business-Central-Apps?style=social)](https://github.com/walter75-Consulting/Business-Central-Apps)
```

---

## 🎯 Reihenfolge der Durchführung

1. **Zuerst**: Release erstellen (Schritt 1) - Das ist das Wichtigste!
2. **Dann**: About-Section konfigurieren (Schritt 2)
3. **Danach**: Features aktivieren (Schritt 3)
4. **Optional**: Branch Protection (Schritt 4) - kann später gemacht werden
5. **Optional**: Discussions konfigurieren (Schritt 5)
6. **Optional**: Social Preview & Badges (Schritte 6-7)

---

## 📢 Marketing & Kommunikation (Optional)

Nach Abschluss der GitHub-Einrichtung:

### LinkedIn Post Vorlage:
```
🎉 Exciting News! We're open-sourcing our Business Central extensions!

Today, we're releasing our collection of Microsoft Dynamics 365 Business Central apps 
under the MIT License. These production-ready extensions include:

📦 Logistics & Warehouse Management
🏭 Manufacturing Terminals
🔗 Integration Tools (PrintNode, SendCloud)
🎨 Business Features

All apps are built on BC 27.0 and include comprehensive documentation.

Check it out: https://github.com/walter75-Consulting/Business-Central-Apps

#BusinessCentral #Dynamics365 #OpenSource #ERP #Microsoft
```

### Twitter/X Post:
```
🚀 Just released our #BusinessCentral extensions as open source!

10 production-ready apps for logistics, manufacturing & more.
Built on BC 27.0 | MIT License

https://github.com/walter75-Consulting/Business-Central-Apps

#Dynamics365 #OpenSource #ERP
```

---

## ✅ Checkliste

Nach Abschluss aller Schritte, stelle sicher dass:

- [ ] Release v27.0.0 ist erstellt und published
- [ ] About-Section zeigt Description, Website und Topics
- [ ] Discussions sind aktiviert
- [ ] Repository zeigt "Public" Status
- [ ] README.md ist korrekt formatiert auf der Hauptseite
- [ ] LICENSE Badge ist grün/sichtbar

---

**Viel Erfolg mit der Open-Source Veröffentlichung! 🎉**

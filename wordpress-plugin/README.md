# Walter75 GitHub Integration - WordPress Plugin

Ein WordPress-Plugin zur Integration der Business Central Apps von GitHub auf walter75.de.

## 🎯 Features

- **BC Apps Übersicht** - Zeigt alle 10 Business Central Extensions mit Beschreibungen
- **GitHub Repository Card** - Anzeige von Repository-Informationen
- **Latest Releases** - Liste der neuesten Releases
- **Statistiken** - Stars, Forks, Issues, Contributors
- **BC Brand Design** - Vollständig im Business Central Farbschema (#00838F)
- **Responsive** - Mobile-friendly Design
- **Dark Mode** - Automatische Unterstützung
- **Caching** - 1 Stunde Cache für GitHub API Calls

## 📦 Installation

### Methode 1: Manueller Upload

1. ZIP-Datei erstellen:
   ```bash
   cd wordpress-plugin
   zip -r walter75-github-integration.zip . -x "*.git*" -x "README.md"
   ```

2. In WordPress:
   - Gehe zu **Plugins → Installieren → Plugin hochladen**
   - ZIP-Datei hochladen
   - Plugin aktivieren

### Methode 2: FTP Upload

1. Lade den `wordpress-plugin` Ordner nach `/wp-content/plugins/walter75-github-integration/`
2. Gehe zu **Plugins** in WordPress
3. Aktiviere "Walter75 GitHub Integration"

### Methode 3: GitHub Direct

```bash
cd /wp-content/plugins/
git clone https://github.com/walter75-Consulting/Business-Central-Apps.git walter75-github-integration
cd walter75-github-integration
git sparse-checkout set wordpress-plugin
```

## 🚀 Verwendung

Das Plugin stellt 4 Shortcodes bereit:

### 1. BC Apps Übersicht (Hauptfeature)

```
[bc_apps]
```

**Parameter:**
- `show_docs="true"` - Zeigt Dokumentations-Button (Standard: true)
- `show_stats="true"` - Zeigt GitHub-Statistiken (Standard: true)

**Beispiele:**
```
[bc_apps]
[bc_apps show_docs="false"]
[bc_apps show_stats="false"]
```

**Zeigt an:**
- Hero Section mit GitHub Stats
- Alle 10 BC Extensions als Cards
- Features pro App
- Links zur Dokumentation
- Footer mit Lizenz-Info

---

### 2. GitHub Repository Card

```
[github_repo_card]
```

**Parameter:**
- `owner="walter75-Consulting"` - GitHub Owner (Standard)
- `repo="Business-Central-Apps"` - Repository Name (Standard)

**Beispiele:**
```
[github_repo_card]
[github_repo_card owner="microsoft" repo="vscode"]
```

**Zeigt an:**
- Repository Name & Beschreibung
- Stars, Forks, Watchers
- Programmiersprache
- Lizenz
- Links zu GitHub & Docs

---

### 3. Latest Releases

```
[github_releases]
```

**Parameter:**
- `owner="walter75-Consulting"` - GitHub Owner (Standard)
- `repo="Business-Central-Apps"` - Repository Name (Standard)
- `limit="5"` - Anzahl der Releases (Standard: 5)

**Beispiele:**
```
[github_releases]
[github_releases limit="3"]
```

**Zeigt an:**
- Release Name & Tag
- Veröffentlichungsdatum
- Release Notes (gekürzt)
- Autor
- Anzahl der Assets
- Link zum Release

---

### 4. GitHub Statistiken

```
[github_stats]
```

**Parameter:**
- `owner="walter75-Consulting"` - GitHub Owner (Standard)
- `repo="Business-Central-Apps"` - Repository Name (Standard)

**Beispiele:**
```
[github_stats]
```

**Zeigt an:**
- Stars
- Forks
- Open Issues
- Contributors

## 📝 Seiten-Beispiele

### Homepage mit voller Übersicht

```html
<h1>Business Central Extensions</h1>

[bc_apps]

<h2>Neueste Releases</h2>
[github_releases limit="3"]
```

### Projekt-Seite

```html
<h1>Über das Projekt</h1>

<p>Willkommen bei meinen Business Central Extensions...</p>

[github_repo_card]

[github_stats]

<h2>Alle Extensions</h2>
[bc_apps show_stats="false"]
```

### Einfache Integration

```html
[bc_apps]
```

Das reicht für eine vollständige Übersicht!

## 🎨 Anpassung

### Farben ändern

Bearbeite `assets/style.css`:

```css
:root {
    --bc-primary: #00838F;    /* Deine Primärfarbe */
    --bc-secondary: #006973;  /* Deine Sekundärfarbe */
    --bc-accent: #00BCD4;     /* Deine Akzentfarbe */
}
```

### Apps-Liste anpassen

Bearbeite `walter75-github-integration.php` ab Zeile 159:

```php
$apps = [
    [
        'name' => 'Deine App',
        'icon' => '🚀',
        'description' => 'Beschreibung',
        'features' => ['Feature 1', 'Feature 2'],
        'doc_url' => 'https://...'
    ],
    // ...
];
```

### Cache-Dauer ändern

In `walter75-github-integration.php` Zeile 20:

```php
private $cache_duration = 3600; // Sekunden (Standard: 1 Stunde)
```

## 🔧 Technische Details

**Anforderungen:**
- WordPress 5.0+
- PHP 7.4+
- WP HTTP API aktiviert

**Features:**
- Transient API für Caching (1 Stunde)
- GitHub API v3 ohne Token (60 Requests/Stunde)
- Responsive CSS Grid
- Dark Mode Support
- Sanitized Output (wp_kses_post, esc_html, esc_url)

**Performance:**
- Caching reduziert API-Calls auf max. 1x pro Stunde
- Optimierte CSS (keine externen Dependencies)
- Lazy Loading möglich durch WordPress

## 🔐 GitHub API Token (Optional)

Für mehr als 60 API Requests pro Stunde:

1. Erstelle einen [GitHub Personal Access Token](https://github.com/settings/tokens)
2. Füge in `walter75-github-integration.php` hinzu (Zeile 50):

```php
'headers' => [
    'Accept' => 'application/vnd.github.v3+json',
    'User-Agent' => 'WordPress-Walter75-Plugin',
    'Authorization' => 'token DEIN_GITHUB_TOKEN' // Neu
]
```

**Wichtig:** Token nie in Public Repos commiten! Nutze WordPress Constants:

```php
// wp-config.php
define('WALTER75_GITHUB_TOKEN', 'ghp_...');

// Im Plugin:
'Authorization' => 'token ' . WALTER75_GITHUB_TOKEN
```

## 🧹 Cache löschen

Cache manuell löschen (wenn Updates nicht erscheinen):

```php
// In WordPress Admin -> Tools -> Site Health -> Info -> Transients
// Oder per Code:
delete_transient('walter75_github_' . md5('repos/walter75-Consulting/Business-Central-Apps'));
```

Oder einfach 1 Stunde warten! 😊

## 📱 Responsive Breakpoints

- **Desktop:** >768px - Grid mit 3 Spalten
- **Tablet:** 768px - Grid mit 2 Spalten
- **Mobile:** <768px - 1 Spalte, Stack Layout

## 🎯 SEO & Performance

- Semantisches HTML5
- Optimierte CSS (kein externes Framework)
- Lazy Loading kompatibel
- Alt-Tags für wichtige Inhalte
- Schema.org Markup möglich (erweiterbar)

## 🔄 Updates

Das Plugin prüft keine automatischen Updates. Um zu aktualisieren:

1. ZIP herunterladen
2. Altes Plugin deaktivieren
3. Neues hochladen
4. Aktivieren

Oder bei Git-Installation:

```bash
cd /wp-content/plugins/walter75-github-integration/
git pull origin main
```

## 🆘 Support

- [GitHub Issues](https://github.com/walter75-Consulting/Business-Central-Apps/issues)
- [GitHub Discussions](https://github.com/walter75-Consulting/Business-Central-Apps/discussions)
- [walter75.de](https://www.walter75.de)

## 📄 Lizenz

MIT License - siehe [LICENSE](../LICENSE)

## 👤 Autor

**Sebastian Walter (@walter75)**
- Website: [walter75.de](https://www.walter75.de)
- GitHub: [@walter75-Consulting](https://github.com/walter75-Consulting)

---

**Personal open-source project - not a commercial service**

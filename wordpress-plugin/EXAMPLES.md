# Beispiel-Seiten für walter75.de

Hier sind fertige Seiten-Templates, die du direkt in WordPress verwenden kannst.

## 📄 Seite 1: Homepage / Projekte-Seite

**URL:** `walter75.de/projekte` oder Homepage

```html
<!-- WordPress Page Editor - HTML Block oder Classic Editor -->

<div style="max-width: 1200px; margin: 0 auto;">
  
<h1>Open-Source Business Central Extensions</h1>

<p style="font-size: 1.1em; color: #666; max-width: 800px; margin: 20px auto;">
  Professionelle Extensions für Microsoft Dynamics 365 Business Central. 
  Alle Lösungen sind open-source, gut dokumentiert und in produktiven Umgebungen im Einsatz.
</p>

[bc_apps]

<hr style="margin: 60px 0; border: none; border-top: 2px solid #e0e0e0;">

<h2>🆕 Neueste Releases</h2>

[github_releases limit="3"]

<div style="text-align: center; margin: 40px 0;">
  <a href="https://github.com/walter75-Consulting/Business-Central-Apps" 
     style="display: inline-block; padding: 15px 30px; background: #00838F; color: white; text-decoration: none; border-radius: 8px; font-weight: 600;">
    📦 Alle Releases auf GitHub ansehen
  </a>
</div>

</div>
```

---

## 📄 Seite 2: Über das Projekt

**URL:** `walter75.de/business-central`

```html
<div style="max-width: 1000px; margin: 0 auto;">

<h1>Business Central Extensions Projekt</h1>

<p style="font-size: 1.1em; line-height: 1.8; color: #555;">
  Seit mehreren Jahren entwickle ich professionelle Extensions für Microsoft Dynamics 365 Business Central. 
  Alle Lösungen sind als Open-Source verfügbar und folgen modernen Best Practices.
</p>

<h2>📊 Projekt-Übersicht</h2>

[github_repo_card]

<div style="margin: 40px 0;">
  [github_stats]
</div>

<h2>🎯 Philosophie</h2>

<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin: 30px 0;">
  
  <div style="padding: 25px; background: #f5f5f5; border-radius: 8px; border-left: 4px solid #00838F;">
    <h3 style="margin-top: 0;">🔓 Open Source</h3>
    <p>Alle Extensions sind unter MIT-Lizenz verfügbar. Transparenz und Community-Beiträge sind willkommen.</p>
  </div>
  
  <div style="padding: 25px; background: #f5f5f5; border-radius: 8px; border-left: 4px solid #00838F;">
    <h3 style="margin-top: 0;">📚 Dokumentation</h3>
    <p>Umfassende technische und Nutzer-Dokumentation für jede Extension.</p>
  </div>
  
  <div style="padding: 25px; background: #f5f5f5; border-radius: 8px; border-left: 4px solid #00838F;">
    <h3 style="margin-top: 0;">🔄 AL-Go CI/CD</h3>
    <p>Automatisierte Builds, Tests und Releases mit Microsoft AL-Go Framework.</p>
  </div>
  
  <div style="padding: 25px; background: #f5f5f5; border-radius: 8px; border-left: 4px solid #00838F;">
    <h3 style="margin-top: 0;">🌍 Mehrsprachig</h3>
    <p>Englisch und Deutsch vollständig unterstützt durch .xlf Translation Files.</p>
  </div>

</div>

<h2>🚀 Verfügbare Extensions</h2>

[bc_apps show_stats="false"]

<h2>💬 Kontakt & Support</h2>

<div style="background: #f5f5f5; padding: 30px; border-radius: 8px; margin: 30px 0;">
  <p style="margin: 0 0 15px 0;">
    <strong>Fragen, Anregungen oder Probleme?</strong>
  </p>
  <ul style="list-style: none; padding: 0; margin: 0;">
    <li style="margin: 10px 0;">
      🐛 <a href="https://github.com/walter75-Consulting/Business-Central-Apps/issues">Bug Reports & Feature Requests</a>
    </li>
    <li style="margin: 10px 0;">
      💬 <a href="https://github.com/walter75-Consulting/Business-Central-Apps/discussions">Community Discussions</a>
    </li>
    <li style="margin: 10px 0;">
      📚 <a href="https://walter75-consulting.github.io/Business-Central-Apps/">Vollständige Dokumentation</a>
    </li>
    <li style="margin: 10px 0;">
      📧 <a href="/kontakt">Direkter Kontakt</a>
    </li>
  </ul>
</div>

</div>
```

---

## 📄 Seite 3: Kompakte Widget-Seite

**URL:** Sidebar Widget oder Footer

### Variante A: Nur Stats (sehr kompakt)

```html
<!-- WordPress Widget: Custom HTML -->

<div style="background: white; padding: 15px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
  <h3 style="margin-top: 0; margin-bottom: 15px; color: #00838F; font-size: 1.1em;">
    📦 BC Extensions
  </h3>
  
  [github_stats]
  
  <div style="margin-top: 15px; text-align: center;">
    <a href="/business-central-apps" 
       style="display: inline-block; padding: 8px 16px; background: #00838F; color: white; text-decoration: none; border-radius: 6px; font-size: 0.85em; font-weight: 600;">
      Mehr erfahren →
    </a>
  </div>
</div>
```

### Variante B: Stats + Neueste Releases (kompakt)

```html
<!-- WordPress Widget: Custom HTML -->

<div style="background: white; padding: 15px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
  <h3 style="margin-top: 0; margin-bottom: 15px; color: #00838F; font-size: 1.1em;">
    📦 BC Extensions
  </h3>
  
  [github_stats]
  
  <h4 style="margin: 20px 0 10px 0; color: #004D56; font-size: 0.95em; border-left: 3px solid #00838F; padding-left: 8px;">
    🆕 Neueste Releases
  </h4>
  
  [github_releases limit="2"]
  
  <div style="margin-top: 15px; text-align: center;">
    <a href="/business-central-apps" 
       style="display: inline-block; padding: 8px 16px; background: #00838F; color: white; text-decoration: none; border-radius: 6px; font-size: 0.85em; font-weight: 600;">
      Alle Extensions ansehen →
    </a>
  </div>
</div>
```

---

## 📄 Seite 4: Blog Post / Ankündigung

**URL:** Blog-Beitrag

```html
<h1>Neue Business Central Extensions verfügbar</h1>

<p style="font-size: 1.1em; color: #666;">
  Veröffentlicht am: [Datum] | Kategorie: Business Central, Open Source
</p>

<p>
  Ich freue mich, die neuesten Updates meiner Business Central Extensions anzukündigen...
</p>

[github_releases limit="5"]

<h2>Alle verfügbaren Extensions</h2>

[bc_apps show_stats="false"]

<hr style="margin: 40px 0;">

<p>
  <strong>Möchten Sie mehr erfahren?</strong><br>
  Besuchen Sie die <a href="https://walter75-consulting.github.io/Business-Central-Apps/">vollständige Dokumentation</a> 
  oder öffnen Sie ein <a href="https://github.com/walter75-Consulting/Business-Central-Apps/discussions">GitHub Discussion</a>.
</p>
```

---

## 📄 Seite 5: Portfolio / Leistungen

**URL:** `walter75.de/leistungen`

```html
<h1>Business Central Entwicklung</h1>

<div style="max-width: 1000px; margin: 0 auto;">

<p style="font-size: 1.1em; line-height: 1.8; color: #555;">
  Professionelle Entwicklung von Microsoft Dynamics 365 Business Central Extensions 
  mit Fokus auf Automatisierung, Integration und Benutzerfreundlichkeit.
</p>

<h2>🛠️ Technologien & Tools</h2>

<div style="display: flex; flex-wrap: wrap; gap: 15px; margin: 25px 0;">
  <span style="padding: 8px 16px; background: #00838F; color: white; border-radius: 20px;">AL Language</span>
  <span style="padding: 8px 16px; background: #00838F; color: white; border-radius: 20px;">Business Central</span>
  <span style="padding: 8px 16px; background: #00838F; color: white; border-radius: 20px;">AL-Go CI/CD</span>
  <span style="padding: 8px 16px; background: #00838F; color: white; border-radius: 20px;">Git / GitHub</span>
  <span style="padding: 8px 16px; background: #00838F; color: white; border-radius: 20px;">OAuth 2.0</span>
  <span style="padding: 8px 16px; background: #00838F; color: white; border-radius: 20px;">API Integration</span>
  <span style="padding: 8px 16px; background: #00838F; color: white; border-radius: 20px;">Docker</span>
</div>

<h2>📦 Referenz-Projekte (Open Source)</h2>

[bc_apps]

<h2>📊 Projekt-Statistiken</h2>

[github_stats]

<div style="background: #f5f5f5; padding: 30px; border-radius: 8px; margin: 40px 0; text-align: center;">
  <h3 style="margin-top: 0;">Interesse an einer Zusammenarbeit?</h3>
  <p>Kontaktieren Sie mich für Business Central Entwicklung, Beratung oder Code Reviews.</p>
  <a href="/kontakt" 
     style="display: inline-block; padding: 15px 30px; background: #00838F; color: white; text-decoration: none; border-radius: 8px; font-weight: 600; margin-top: 10px;">
    Jetzt Kontakt aufnehmen
  </a>
</div>

</div>
```

---

## 🎨 Custom CSS für dein Theme

Falls du zusätzliches Styling brauchst, füge das in **Design → Customizer → Zusätzliches CSS** ein:

```css
/* Walter75 BC Brand Anpassungen */
.walter75-github-container {
  margin: 40px 0;
}

/* Links im BC Stil */
.entry-content a:not(.bc-button):not(.bc-app-link) {
  color: #00838F;
  transition: color 0.3s ease;
}

.entry-content a:not(.bc-button):not(.bc-app-link):hover {
  color: #00BCD4;
}

/* Überschriften im BC Stil */
.entry-content h2,
.entry-content h3 {
  color: #004D56;
  border-left: 4px solid #00838F;
  padding-left: 15px;
}
```

---

## 🚀 Schnellstart

1. **Plugin installieren und aktivieren**
2. **Neue Seite erstellen** in WordPress
3. **HTML-Block einfügen** (oder Classic Editor verwenden)
4. **Template-Code kopieren** (z.B. Homepage-Template)
5. **Veröffentlichen** und ansehen!

Die Shortcodes werden automatisch gerendert. Kein weiteres Setup nötig! 🎉

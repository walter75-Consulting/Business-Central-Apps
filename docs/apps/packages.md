---
layout: default
title: Packages Extension
---

<div class="hero-section">
  <h1>📦 walter75 - Packages</h1>
  <p class="hero-tagline">Complete warehouse packing station with barcode scanning and shipping integration</p>
  <div class="badge-container">
    <span class="badge">Warehouse</span>
    <span class="badge">Barcode</span>
    <span class="badge">Shipping</span>
    <span class="badge">PrintNode</span>
    <span class="badge">SendCloud</span>
  </div>
</div>

---

## 📋 Overview

A complete warehouse packing station system designed for efficient order fulfillment. Features barcode scanning workflows, automated label printing via PrintNode, and shipping integration through SendCloud. Optimized for high-volume packing operations with real-time validation and error handling.

<div class="feature-grid">
  <div class="feature-card">
    <h3>📱 Barcode Scanning</h3>
    <p>Fast and accurate item scanning with real-time validation</p>
  </div>
  <div class="feature-card">
    <h3>🏭 Station Management</h3>
    <p>Configure multiple packing stations with custom workflows</p>
  </div>
  <div class="feature-card">
    <h3>🖨️ Auto Printing</h3>
    <p>Automatic label printing to thermal printers via PrintNode</p>
  </div>
  <div class="feature-card">
    <h3>📮 Shipping Integration</h3>
    <p>Automated shipping label creation and tracking with SendCloud</p>
  </div>
  <div class="feature-card">
    <h3>📦 Multi-Package</h3>
    <p>Handle orders with multiple packages efficiently</p>
  </div>
  <div class="feature-card">
    <h3>⚡ Real-time Validation</h3>
    <p>Instant feedback on scanning errors and issues</p>
  </div>
</div>

## 🔢 Technical Details

<div class="info-box info-box-primary">
  <p><strong>Object ID Range:</strong> 90700-90799</p>
  <p><strong>Dependencies:</strong> PrintNode, SendCloud</p>
  <p><strong>Target Platform:</strong> Business Central Cloud 27.0+</p>
</div>

## 📦 Installation

<div class="step-container">
  <div class="step">
    <div class="step-number">1</div>
    <div class="step-content">
      <h4>Install Dependencies</h4>
      <p>First install <strong>walter75 - PrintNode</strong> and <strong>walter75 - SendCloud</strong></p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">2</div>
    <div class="step-content">
      <h4>Download Extension</h4>
      <p>Download the latest <code>.app</code> file from <a href="https://github.com/walter75-Consulting/Business-Central-Apps/releases">Releases</a></p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">3</div>
    <div class="step-content">
      <h4>Install in Business Central</h4>
      <p>Install via <strong>Extension Management</strong> in Business Central</p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">4</div>
    <div class="step-content">
      <h4>Configure</h4>
      <p>Set up packing stations and test the scanning workflow</p>
    </div>
  </div>
</div>

## 🔗 Dependencies

<div class="info-box info-box-warning">
  <p>This extension requires:</p>
  <ul>
    <li><strong>walter75 - PrintNode</strong> (ca1ab169-0517-4532-a393-46610dd0372c)</li>
    <li><strong>walter75 - SendCloud</strong> (1b3a8485-c38c-4802-9ce8-1f83c8a75f2e)</li>
  </ul>
</div>

## 🛠️ Configuration

<div class="info-box">
  <h4>Quick Setup Guide</h4>
  <ol>
    <li>Open <strong>Packing Stations</strong> page</li>
    <li>Create a new packing station</li>
    <li>Configure scan input field behavior</li>
    <li>Set up PrintNode printer association</li>
    <li>Configure SendCloud shipping options</li>
    <li>Test the scanning workflow</li>
  </ol>
</div>

## 🏗️ Architecture

<div class="feature-grid" style="grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));">
  <div class="feature-card">
    <h3>SEW Packing Card</h3>
    <p>Main UI for packing operations</p>
  </div>
  <div class="feature-card">
    <h3>SEW PK Actions Page</h3>
    <p>Business logic codeunit</p>
  </div>
  <div class="feature-card">
    <h3>SEW PK Single Instance</h3>
    <p>Session-scoped state management</p>
  </div>
  <div class="feature-card">
    <h3>Control Add-ins</h3>
    <p>Custom JavaScript components</p>
  </div>
</div>

## 📚 Documentation

<div class="doc-links">
  <a href="packages-user-guide.html" class="doc-link">
    <span class="doc-icon">📖</span>
    <div>
      <strong>User Guide</strong>
      <p>Complete setup and usage instructions</p>
    </div>
  </a>
  
  <a href="../../" class="doc-link">
    <span class="doc-icon">🏠</span>
    <div>
      <strong>Main Documentation</strong>
      <p>Overview of all available apps</p>
    </div>
  </a>
  
  <a href="../../CONTRIBUTING.html" class="doc-link">
    <span class="doc-icon">🤝</span>
    <div>
      <strong>Contributing</strong>
      <p>Guidelines for contributors</p>
    </div>
  </a>
</div>

---

<div class="footer-info">
  <p><strong>License:</strong> MIT License - see <a href="../../LICENSE">LICENSE</a> file for details</p>
  <p><strong>Author:</strong> Sebastian Walter (@walter75) | <strong>Support:</strong> <a href="https://github.com/walter75-Consulting/Business-Central-Apps/issues">GitHub Issues</a> | <a href="https://www.walter75.de">walter75.de</a></p>
  <p style="font-size: 0.9em; color: #666; margin-top: 10px;">Personal open-source project - not a commercial service</p>
</div>

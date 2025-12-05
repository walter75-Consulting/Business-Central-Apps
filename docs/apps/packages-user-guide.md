---
layout: default
title: Packages User Guide
---

<div class="hero-section">
  <h1>📦 walter75 - Packages User Guide</h1>
  <p class="hero-tagline">Complete guide to warehouse packing operations with barcode scanning</p>
  <div class="badge-container">
    <span class="badge">v26.2.0</span>
    <span class="badge">Warehouse</span>
    <span class="badge">Barcode</span>
  </div>
</div>

---

## 📋 Overview

The **walter75 - Packtisch (Packing Station)** app is a comprehensive packing solution for Microsoft Dynamics 365 Business Central. It streamlines warehouse operations by providing an intuitive barcode scanning interface for packing items from inventory pick orders into parcels for shipment.

<div class="info-box info-box-primary">
  <p><strong>Integrations:</strong></p>
  <ul>
    <li><strong>walter75 - PrintNode:</strong> For printing shipping labels</li>
    <li><strong>walter75 - SendCloud:</strong> For shipping carrier integration</li>
  </ul>
</div>

## 🎯 Key Benefits

<div class="feature-grid">
  <div class="feature-card">
    <h3>📱 Scan-Based Workflow</h3>
    <p>Reduce manual entry errors with barcode scanning</p>
  </div>
  <div class="feature-card">
    <h3>📊 Real-Time Tracking</h3>
    <p>See what's packed and what's remaining instantly</p>
  </div>
  <div class="feature-card">
    <h3>📦 Multi-Parcel Support</h3>
    <p>Split orders across multiple packages easily</p>
  </div>
  <div class="feature-card">
    <h3>🖨️ Integrated Printing</h3>
    <p>Direct label and document printing</p>
  </div>
  <div class="feature-card">
    <h3>📏 Package Tracking</h3>
    <p>Record box dimensions and weights</p>
  </div>
  <div class="feature-card">
    <h3>✅ Quality Control</h3>
    <p>Verify items before shipping</p>
  </div>
</div>

## 🛠️ Setup

<div class="step-container">
  <div class="step">
    <div class="step-number">1</div>
    <div class="step-content">
      <h4>Package Setup</h4>
      <p>Search for <strong>"Package Setup"</strong> - Main configuration page for the packing module</p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">2</div>
    <div class="step-content">
      <h4>Configure Package Materials</h4>
      <p>Search for <strong>"Package Material List"</strong> and define packaging materials:</p>
      <ul>
        <li><strong>Code:</strong> Unique identifier (e.g., "BOX-S", "BOX-M")</li>
        <li><strong>Description:</strong> Name (e.g., "Small Box", "Medium Box")</li>
        <li><strong>Dimensions:</strong> Length/Width/Height in cm</li>
        <li><strong>Weight kg:</strong> Weight of empty package</li>
      </ul>
      <div class="info-box">
        <p>💡 <strong>Tip:</strong> Assign barcodes to package materials for quick scanning</p>
      </div>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">3</div>
    <div class="step-content">
      <h4>Set Up Packing Stations</h4>
      <p>Search for <strong>"Packing Station List"</strong> and configure stations:</p>
      <ul>
        <li><strong>Station ID:</strong> Unique number</li>
        <li><strong>Station Name:</strong> Descriptive name (e.g., "Packing Station 1")</li>
        <li><strong>Label PrinterID:</strong> PrintNode printer for labels</li>
        <li><strong>Package Material Usage:</strong> Require scanning materials</li>
        <li><strong>Use Scale:</strong> Enable if station has connected scale</li>
        <li><strong>Delivery Note per Parcel:</strong> Print note for each parcel</li>
      </ul>
    </div>
  </div>
</div>

## 📦 Packing Process

<div class="step-container">
  <div class="step">
    <div class="step-number">1</div>
    <div class="step-content">
      <h4>Open Packing Card</h4>
      <p>Search for <strong>"Packing Card"</strong> or scan packing station barcode</p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">2</div>
    <div class="step-content">
      <h4>Scan Pick Order</h4>
      <p>Scan the inventory pick document barcode to load items</p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">3</div>
    <div class="step-content">
      <h4>Scan Package Material</h4>
      <p>Scan box/envelope barcode to select package type</p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">4</div>
    <div class="step-content">
      <h4>Scan Items</h4>
      <p>Scan each item to pack - system tracks quantities automatically</p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">5</div>
    <div class="step-content">
      <h4>Complete Package</h4>
      <p>Finalize package, print labels, and continue with next parcel if needed</p>
    </div>
  </div>
</div>

## 🔍 Troubleshooting

<div class="feature-grid">
  <div class="feature-card">
    <h3>🚨 Barcode Not Scanning</h3>
    <ul>
      <li>Check barcode format matches configuration</li>
      <li>Verify scanner is connected and working</li>
      <li>Test with manual entry</li>
    </ul>
  </div>
  <div class="feature-card">
    <h3>🖨️ Labels Not Printing</h3>
    <ul>
      <li>Verify PrintNode client is running</li>
      <li>Check printer assignment in station setup</li>
      <li>Test printer connection in PrintNode</li>
    </ul>
  </div>
  <div class="feature-card">
    <h3>❌ Item Not Found</h3>
    <ul>
      <li>Verify item is on the pick order</li>
      <li>Check item number/barcode is correct</li>
      <li>Ensure pick order is released</li>
    </ul>
  </div>
  <div class="feature-card">
    <h3>⚖️ Scale Not Reading</h3>
    <ul>
      <li>Check scale connection and power</li>
      <li>Verify scale ID in station setup</li>
      <li>Test scale with calibration weight</li>
    </ul>
  </div>
</div>

## 📚 Related Documentation

<div class="doc-links">
  <a href="packages.html" class="doc-link">
    <span class="doc-icon">📖</span>
    <div>
      <strong>Main Documentation</strong>
      <p>Technical details and architecture</p>
    </div>
  </a>
  <a href="../../CONTRIBUTING.html" class="doc-link">
    <span class="doc-icon">🤝</span>
    <div>
      <strong>Contributing</strong>
      <p>How to contribute improvements</p>
    </div>
  </a>
  <a href="../../" class="doc-link">
    <span class="doc-icon">🏠</span>
    <div>
      <strong>All Extensions</strong>
      <p>View all available apps</p>
    </div>
  </a>
</div>

---

<div class="footer-info">
  <p><strong>Version:</strong> 26.2.0 | <strong>Author:</strong> Sebastian Walter (@walter75)</p>
  <p><strong>Support:</strong> <a href="https://github.com/walter75-Consulting/Business-Central-Apps/issues">GitHub Issues</a> | <a href="https://www.walter75.de">walter75.de</a></p>
  <p style="font-size: 0.9em; color: #666; margin-top: 10px;">Personal open-source project - not a commercial service</p>
</div>

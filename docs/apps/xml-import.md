---
layout: default
title: XML Import
---

<div class="hero-section">
  <h1>📄 walter75 - XML Import</h1>
  <p class="hero-tagline">Flexible XML data import with field mapping and validation</p>
  <div class="badge-container">
    <span class="badge">Integration</span>
    <span class="badge">XML</span>
    <span class="badge">Data Import</span>
  </div>
</div>

---

## 📋 Overview

XML Import provides flexible XML data import capabilities for Business Central. Import data from external systems, EDI partners, or legacy applications using configurable XML mappings.

<div class="feature-grid">
  <div class="feature-card">
    <h3>🔧 Flexible Parsing</h3>
    <p>Handle various XML formats and structures</p>
  </div>
  <div class="feature-card">
    <h3>🗺️ Field Mapping</h3>
    <p>Configure mappings between XML and BC fields</p>
  </div>
  <div class="feature-card">
    <h3>✅ Validation Rules</h3>
    <p>Validate imported data before processing</p>
  </div>
  <div class="feature-card">
    <h3>🚨 Error Handling</h3>
    <p>Detailed error logs and rollback support</p>
  </div>
  <div class="feature-card">
    <h3>📦 Batch Processing</h3>
    <p>Import large XML files efficiently</p>
  </div>
  <div class="feature-card">
    <h3>🔄 Transformation</h3>
    <p>Transform XML data during import</p>
  </div>
</div>

## 🔢 Technical Details

<div class="info-box info-box-primary">
  <p><strong>Object ID Range:</strong> 60500-60799</p>
  <p><strong>Dependencies:</strong> None (standalone extension)</p>
  <p><strong>Integration Points:</strong> All BC tables via field mapping</p>
</div>

## 📦 Installation

<div class="step-container">
  <div class="step">
    <div class="step-number">1</div>
    <div class="step-content">
      <h4>Install Extension</h4>
      <p>Download and install the <code>.app</code> file via Extension Management</p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">2</div>
    <div class="step-content">
      <h4>Create Definition</h4>
      <p>Create <strong>XML Import Definition</strong> for your XML format</p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">3</div>
    <div class="step-content">
      <h4>Map Fields</h4>
      <p>Map XML elements to Business Central tables and fields</p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">4</div>
    <div class="step-content">
      <h4>Set Up Validation</h4>
      <p>Configure validation rules and data transformations</p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">5</div>
    <div class="step-content">
      <h4>Test Import</h4>
      <p>Test with sample XML file and verify results</p>
    </div>
  </div>
</div>

## 🛠️ Configuration

<div class="info-box">
  <p><strong>Quick Setup Guide:</strong></p>
  <ol>
    <li>Obtain sample XML file from your data source</li>
    <li>Create import definition and parse XML structure</li>
    <li>Map XML elements to target BC tables/fields</li>
    <li>Set up validation rules (required fields, data types, ranges)</li>
    <li>Configure error handling and logging options</li>
    <li>Test import with sample data before production use</li>
  </ol>
</div>

<div class="info-box info-box-warning">
  <p><strong>⚠️ Important:</strong> Always test XML imports thoroughly with sample data before using in production. Verify field mappings and validation rules to prevent data corruption.</p>
</div>

## 📚 Documentation

<div class="doc-links">
  <a href="../../" class="doc-link">
    <span class="doc-icon">📖</span>
    <div>
      <strong>Main Documentation</strong>
      <p>Repository overview and all extensions</p>
    </div>
  </a>
  <a href="../../CONTRIBUTING.html" class="doc-link">
    <span class="doc-icon">🤝</span>
    <div>
      <strong>Contributing</strong>
      <p>How to contribute to this project</p>
    </div>
  </a>
</div>

---

<div class="footer-info">
  <p><strong>License:</strong> MIT License - see <a href="../../LICENSE">LICENSE</a> file for details</p>
  <p><strong>Support:</strong> <a href="https://github.com/walter75-Consulting/Business-Central-Apps/issues">GitHub Issues</a> | <a href="https://www.walter75.de">walter75 Consulting</a></p>
</div>

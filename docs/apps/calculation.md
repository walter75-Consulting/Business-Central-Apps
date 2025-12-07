---
layout: default
title: Calculation Extension
---

<div class="hero-section">
  <h1>🧮 walter75 - Calculation</h1>
  <p class="hero-tagline">Advanced product cost calculation and pricing engine with formula support</p>
  <div class="badge-container">
    <span class="badge">Manufacturing</span>
    <span class="badge">Costing</span>
    <span class="badge">Pricing</span>
    <span class="badge">Simulation</span>
  </div>
</div>

---

## 📋 Overview

A comprehensive cost calculation and pricing solution for manufacturing companies. Calculate precise product costs based on Bill of Materials (BOM), Routing, and custom formulas. Support for lot size simulations, production order tracking, post-calculations, and flexible calculation templates with variables.

<div class="feature-grid">
  <div class="feature-card">
    <h3>📐 Formula Engine</h3>
    <p>Powerful formula parser with custom variables and functions</p>
  </div>
  <div class="feature-card">
    <h3>🏭 BOM Integration</h3>
    <p>Automatic material cost calculation from Production BOMs</p>
  </div>
  <div class="feature-card">
    <h3>⚙️ Routing Integration</h3>
    <p>Labor and machine cost calculation from Routings</p>
  </div>
  <div class="feature-card">
    <h3>📊 Lot Size Simulation</h3>
    <p>Compare costs across different production quantities</p>
  </div>
  <div class="feature-card">
    <h3>📝 Templates</h3>
    <p>Reusable calculation templates with line structures</p>
  </div>
  <div class="feature-card">
    <h3>🔄 Post-Calculation</h3>
    <p>Compare planned vs. actual costs after production</p>
  </div>
</div>

## 🔢 Technical Details

<div class="info-box info-box-primary">
  <p><strong>Object ID Range:</strong> 90800-90899</p>
  <p><strong>Dependencies:</strong> None (standalone app)</p>
  <p><strong>Target Platform:</strong> Business Central Cloud 27.0+</p>
</div>

## 📦 Installation

<div class="step-container">
  <div class="step">
    <div class="step-number">1</div>
    <div class="step-content">
      <h4>Download Extension</h4>
      <p>Download the latest <code>.app</code> file from <a href="https://github.com/walter75-Consulting/Business-Central-Apps/releases">Releases</a></p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">2</div>
    <div class="step-content">
      <h4>Install in Business Central</h4>
      <p>Install via <strong>Extension Management</strong> in Business Central</p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">3</div>
    <div class="step-content">
      <h4>Configure Number Series</h4>
      <p>Open <strong>Sales & Receivables Setup</strong> and assign number series for <strong>SEW Calc Nos.</strong></p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">4</div>
    <div class="step-content">
      <h4>Create Variables & Templates</h4>
      <p>Set up calculation variables (e.g., overhead %) and templates</p>
    </div>
  </div>
</div>

## 🏗️ Architecture

### Core Components

<div class="code-section">
  <h4>Tables (Data Model)</h4>
  <ul>
    <li><strong>90800 SEW Calc Template:</strong> Calculation template definitions</li>
    <li><strong>90801 SEW Calc Variable:</strong> Reusable calculation variables</li>
    <li><strong>90802 SEW Calc Template Line:</strong> Template line structure</li>
    <li><strong>90803 SEW Calc Header:</strong> Calculation header (master record)</li>
    <li><strong>90804 SEW Calc Line:</strong> Calculation detail lines with formulas</li>
    <li><strong>90805 SEW Calc Simulation Header:</strong> Lot size simulation headers</li>
    <li><strong>90806 SEW Calc Simulation Line:</strong> Simulation scenario lines</li>
    <li><strong>90807 SEW Calc History Entry:</strong> Calculation change history</li>
  </ul>
</div>

<div class="code-section">
  <h4>Codeunits (Business Logic)</h4>
  <ul>
    <li><strong>90850 SEW Calc Engine:</strong> Main calculation engine with formula evaluation</li>
    <li><strong>90851 SEW Calc Formula Parser:</strong> Formula parsing and variable substitution</li>
    <li><strong>90852 SEW Calc Price Management:</strong> Price source handling (BOM/Routing)</li>
    <li><strong>90853 SEW Calc Template Management:</strong> Template lifecycle (copy, release, archive)</li>
    <li><strong>90854 SEW Calc Simulation Mgt.:</strong> Lot size simulation engine</li>
    <li><strong>90855 SEW Calc Integration Mgt.:</strong> Sales integration event subscribers</li>
    <li><strong>90856 SEW Calc Production Integ:</strong> Production order cost tracking</li>
    <li><strong>90857 SEW Calc Post-Calculation:</strong> Post-calculation creation and comparison</li>
  </ul>
</div>

<div class="code-section">
  <h4>Pages (User Interface)</h4>
  <ul>
    <li><strong>90820-90823:</strong> Template management pages</li>
    <li><strong>90830-90838:</strong> Calculation pages (cards, lists, subforms, history)</li>
  </ul>
</div>

<div class="code-section">
  <h4>Reports</h4>
  <ul>
    <li><strong>90885 SEW Calculation Report:</strong> Print calculation breakdown</li>
  </ul>
</div>

## 🔗 Integrations

### Item Card Extensions

<div class="info-box info-box-success">
  <p><strong>New Fields on Item Card:</strong></p>
  <ul>
    <li><strong>SEW Last Calc No.:</strong> Most recent calculation for this item</li>
    <li><strong>SEW Default Template Code:</strong> Default template for new calculations</li>
  </ul>
  <p><strong>New Actions:</strong></p>
  <ul>
    <li><strong>New Calculation:</strong> Create calculation directly from item</li>
    <li><strong>Calculations:</strong> View all calculations for this item</li>
    <li><strong>Last Calculation:</strong> Open most recent calculation</li>
  </ul>
</div>

### Sales Quote Integration

<div class="info-box info-box-success">
  <p><strong>New Fields on Sales Quote:</strong></p>
  <ul>
    <li><strong>SEW Default Calc Template:</strong> Default template for quote lines</li>
    <li><strong>SEW Auto Calculate:</strong> Auto-create calculations for new lines</li>
  </ul>
  <p><strong>New Fields on Sales Line:</strong></p>
  <ul>
    <li><strong>SEW Calc No.:</strong> Linked calculation</li>
    <li><strong>SEW Calculated Cost:</strong> Cost from calculation</li>
    <li><strong>SEW Calculated Margin %:</strong> Margin percentage</li>
    <li><strong>SEW Target Price:</strong> Suggested selling price</li>
    <li><strong>SEW Material/Labor/Overhead Cost:</strong> Cost breakdown</li>
  </ul>
  <p><strong>FactBox:</strong></p>
  <ul>
    <li><strong>Cost Breakdown FactBox:</strong> Visual cost/margin analysis</li>
  </ul>
</div>

### Production Order Integration

<div class="info-box info-box-success">
  <p><strong>New Fields on Production Order:</strong></p>
  <ul>
    <li><strong>SEW Calc No.:</strong> Linked calculation</li>
    <li><strong>SEW Planned Cost:</strong> Target cost from calculation</li>
    <li><strong>SEW Actual Cost to Date:</strong> Running actual cost</li>
    <li><strong>SEW Cost Variance/Variance %:</strong> Deviation from plan</li>
    <li><strong>SEW Alert Threshold %:</strong> Alert trigger level (default 10%)</li>
    <li><strong>SEW Cost Alert:</strong> Indicator when threshold exceeded</li>
  </ul>
</div>

## 🎯 Key Features

### Formula Engine

<div class="code-section">
  <h4>System Variables</h4>
  <p>Reference calculated values from BOM/Routing:</p>
  <ul>
    <li><code>{MATERIAL}</code> - Total material cost from BOM</li>
    <li><code>{LABOR}</code> - Total labor cost from Routing</li>
    <li><code>{OVERHEAD}</code> - Total overhead cost</li>
    <li><code>{TOTALCOST}</code> - Sum of all costs</li>
  </ul>
</div>

<div class="code-section">
  <h4>Custom Variables</h4>
  <p>Define reusable variables with types:</p>
  <ul>
    <li><strong>Percentage:</strong> Apply as decimal (20% = 0.20)</li>
    <li><strong>Absolute Value:</strong> Fixed amount</li>
    <li><strong>Factor:</strong> Multiplier (1.2 = 20% markup)</li>
  </ul>
  <p><strong>Example:</strong> <code>100 * {OVERHEAD-PCT}</code> where OVERHEAD-PCT = 20 (20%)</p>
</div>

<div class="code-section">
  <h4>Formula Syntax</h4>
  <p>Supports standard math operators with precedence:</p>
  <ul>
    <li><code>+</code> Addition</li>
    <li><code>-</code> Subtraction</li>
    <li><code>*</code> Multiplication</li>
    <li><code>/</code> Division</li>
    <li><code>()</code> Parentheses for grouping</li>
  </ul>
  <p><strong>Example:</strong> <code>({MATERIAL} + {LABOR}) * (1 + {OVERHEAD-PCT})</code></p>
</div>

### Price Source Selection

<div class="info-box info-box-warning">
  <p><strong>Flexible Cost Sources:</strong></p>
  <p>Choose where to get material and capacity costs:</p>
  <ul>
    <li><strong>Item Costs:</strong> Unit Cost, Last Direct Cost, Last Purchase Price, Standard Cost</li>
    <li><strong>Work Center:</strong> Direct Cost, Overhead Rate</li>
    <li><strong>Machine Center:</strong> Direct Cost, Overhead Rate</li>
  </ul>
</div>

### Lot Size Simulation

<div class="feature-grid">
  <div class="feature-card">
    <h3>📊 Multiple Scenarios</h3>
    <p>Compare costs at different production quantities</p>
  </div>
  <div class="feature-card">
    <h3>💰 Unit Cost Analysis</h3>
    <p>See how unit costs decrease with volume</p>
  </div>
  <div class="feature-card">
    <h3>📈 Break-Even Calculation</h3>
    <p>Calculate minimum quantity for profitability</p>
  </div>
  <div class="feature-card">
    <h3>🎯 Recommended Scenario</h3>
    <p>Algorithm suggests optimal lot size</p>
  </div>
</div>

### Post-Calculation

<div class="info-box info-box-primary">
  <p><strong>Compare Planned vs. Actual:</strong></p>
  <p>After production is finished, create a post-calculation to:</p>
  <ul>
    <li>Capture actual material consumption from item ledger</li>
    <li>Capture actual labor time from capacity ledger</li>
    <li>Calculate cost variances (material, labor, overhead)</li>
    <li>Generate variance report for analysis</li>
  </ul>
</div>

### Change History

<div class="info-box">
  <p>Every change to a calculation is tracked:</p>
  <ul>
    <li><strong>Field-level tracking:</strong> What changed, old/new values</li>
    <li><strong>User tracking:</strong> Who made the change</li>
    <li><strong>Timestamp:</strong> When it happened</li>
    <li><strong>Change type:</strong> Created, Modified, Archived, Deleted, Released</li>
  </ul>
</div>

## 🚀 Usage Flow

<div class="step-container">
  <div class="step">
    <div class="step-number">1</div>
    <div class="step-content">
      <h4>Create Template</h4>
      <p>Define calculation structure with formulas and variables</p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">2</div>
    <div class="step-content">
      <h4>Create Calculation</h4>
      <p>Apply template to item, specify lot size and parameters</p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">3</div>
    <div class="step-content">
      <h4>Calculate Costs</h4>
      <p>Engine retrieves BOM/Routing data and evaluates formulas</p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">4</div>
    <div class="step-content">
      <h4>Simulate (Optional)</h4>
      <p>Run lot size simulation to optimize production quantity</p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">5</div>
    <div class="step-content">
      <h4>Release & Transfer</h4>
      <p>Release calculation and transfer costs to Item card</p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">6</div>
    <div class="step-content">
      <h4>Link to Sales/Production</h4>
      <p>Use calculation in sales quotes or production orders</p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">7</div>
    <div class="step-content">
      <h4>Post-Calculation (Optional)</h4>
      <p>After production: compare planned vs. actual costs</p>
    </div>
  </div>
</div>

## 📊 Business Value

<div class="feature-grid">
  <div class="feature-card">
    <h3>💰 Accurate Costing</h3>
    <p>Precise product costs based on actual BOM and Routing data</p>
  </div>
  <div class="feature-card">
    <h3>📈 Better Pricing</h3>
    <p>Calculate target prices based on desired margins</p>
  </div>
  <div class="feature-card">
    <h3>🎯 Optimized Production</h3>
    <p>Find optimal lot sizes through simulation</p>
  </div>
  <div class="feature-card">
    <h3>📉 Cost Control</h3>
    <p>Track actual vs. planned costs during production</p>
  </div>
  <div class="feature-card">
    <h3>⚡ Faster Quoting</h3>
    <p>Quick cost calculations directly from sales quotes</p>
  </div>
  <div class="feature-card">
    <h3>📝 Audit Trail</h3>
    <p>Complete history of all calculation changes</p>
  </div>
</div>

## 🔒 Permissions

<div class="code-section">
  <h4>Permission Sets</h4>
  <ul>
    <li><strong>SEW Calc Full (90899):</strong> Full access (RIMD on all objects)</li>
    <li><strong>SEW Calc Read (90898):</strong> Read-only access</li>
  </ul>
</div>

## 📚 Documentation

<div class="info-box info-box-primary">
  <ul>
    <li><a href="calculation-user-guide.html">📖 User Guide</a> - Complete end-user documentation</li>
    <li><a href="https://github.com/walter75-Consulting/Business-Central-Apps/blob/main/walter75%20-%20Calculation/CHANGELOG.md">📋 Changelog</a> - Version history</li>
    <li><a href="https://github.com/walter75-Consulting/Business-Central-Apps/tree/main/walter75%20-%20Calculation">💻 Source Code</a> - GitHub repository</li>
  </ul>
</div>

---

<div class="footer-info">
  <p><strong>License:</strong> MIT License - see <a href="../../LICENSE">LICENSE</a> file for details</p>
  <p><strong>Author:</strong> Sebastian Walter (@walter75) | <strong>Support:</strong> <a href="https://github.com/walter75-Consulting/Business-Central-Apps/issues">GitHub Issues</a> | <a href="https://www.walter75.de">walter75.de</a></p>
  <p style="font-size: 0.9em; color: #666; margin-top: 10px;">Personal open-source project - not a commercial service</p>
</div>

---

<div style="text-align: center; margin-top: 40px;">
  <a href="index.html" class="btn">← Back to Apps Overview</a>
  <a href="calculation-user-guide.html" class="btn" style="margin-left: 10px;">Read User Guide →</a>
</div>

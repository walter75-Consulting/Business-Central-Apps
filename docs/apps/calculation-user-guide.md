---
layout: default
title: Calculation User Guide
---

<div class="hero-section">
  <h1>🧮 walter75 - Calculation User Guide</h1>
  <p class="hero-tagline">Complete guide to product cost calculation and pricing</p>
  <div class="badge-container">
    <span class="badge">v27.0.0</span>
    <span class="badge">Manufacturing</span>
    <span class="badge">Costing</span>
  </div>
</div>

---

## 📋 Overview

The **walter75 - Calculation** app helps manufacturing companies calculate accurate product costs and determine optimal selling prices. Calculate material costs from BOMs, labor costs from Routings, apply overhead formulas, simulate different production quantities, and track actual vs. planned costs.

<div class="info-box info-box-primary">
  <p><strong>Main Benefits:</strong></p>
  <ul>
    <li>✅ Precise cost calculations based on BOM and Routing</li>
    <li>✅ Flexible formula engine with custom variables</li>
    <li>✅ Lot size simulation for production optimization</li>
    <li>✅ Post-calculation for actual cost tracking</li>
    <li>✅ Integration with Sales Quotes and Production Orders</li>
  </ul>
</div>

## 🛠️ Initial Setup

<div class="step-container">
  <div class="step">
    <div class="step-number">1</div>
    <div class="step-content">
      <h4>Configure Number Series</h4>
      <p>Search for: <strong>Sales & Receivables Setup</strong></p>
      <ul>
        <li>Scroll to <strong>Numbering</strong> section</li>
        <li>Field: <strong>SEW Calc Nos.</strong></li>
        <li>Assign a number series (e.g., "CALC")</li>
        <li>This generates automatic calculation numbers like CALC0001, CALC0002, etc.</li>
      </ul>
      <div class="info-box">
        <p>💡 <strong>Tip:</strong> If the number series doesn't exist, create it via <strong>No. Series</strong> page first</p>
      </div>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">2</div>
    <div class="step-content">
      <h4>Create Calculation Variables</h4>
      <p>Search for: <strong>Calculation Variables</strong></p>
      <p>Create reusable variables for formulas:</p>
      
      <h5>Example: Overhead Percentage</h5>
      <ul>
        <li><strong>Code:</strong> OVERHEAD-PCT</li>
        <li><strong>Description:</strong> Overhead Percentage</li>
        <li><strong>Type:</strong> Percentage</li>
        <li><strong>Value:</strong> 20 (represents 20%)</li>
        <li><strong>Base:</strong> Material (apply to material costs)</li>
        <li><strong>Global:</strong> Yes (available in all calculations)</li>
        <li><strong>Valid From Date:</strong> 01.01.2025</li>
      </ul>
      
      <h5>Example: Setup Cost</h5>
      <ul>
        <li><strong>Code:</strong> SETUP-FIXED</li>
        <li><strong>Description:</strong> Fixed Setup Cost</li>
        <li><strong>Type:</strong> Absolute Value</li>
        <li><strong>Value:</strong> 150.00 (fixed amount in currency)</li>
        <li><strong>Global:</strong> Yes</li>
      </ul>
      
      <div class="info-box info-box-success">
        <p>✅ <strong>Variable Types:</strong></p>
        <ul>
          <li><strong>Percentage:</strong> Value entered as whole number (20 = 20%), used as decimal in formulas (0.20)</li>
          <li><strong>Absolute Value:</strong> Fixed amount added to calculation</li>
          <li><strong>Factor:</strong> Multiplier (1.2 = add 20%, 0.8 = reduce by 20%)</li>
        </ul>
      </div>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">3</div>
    <div class="step-content">
      <h4>Create Calculation Templates</h4>
      <p>Search for: <strong>Calculation Templates</strong></p>
      <p>Templates define the structure of calculations and can be reused across multiple items.</p>
      
      <h5>Template Header</h5>
      <ul>
        <li><strong>Code:</strong> STANDARD</li>
        <li><strong>Description:</strong> Standard Calculation Template</li>
        <li><strong>Price Source Item:</strong> Unit Cost (where to get material costs)</li>
        <li><strong>Price Source Capacity:</strong> Work Center Direct Cost</li>
        <li><strong>Include Material:</strong> Yes</li>
        <li><strong>Include Labor:</strong> Yes</li>
        <li><strong>Include Overhead:</strong> Yes</li>
        <li><strong>Status:</strong> Draft (during creation)</li>
      </ul>
      
      <h5>Template Lines</h5>
      <p>Add calculation structure in the <strong>Lines</strong> subpage:</p>
      
      <table style="width:100%; border-collapse: collapse; margin: 15px 0;">
        <tr style="background: #f0f0f0;">
          <th style="padding:8px; border:1px solid #ddd;">Line No.</th>
          <th style="padding:8px; border:1px solid #ddd;">Type</th>
          <th style="padding:8px; border:1px solid #ddd;">Description</th>
          <th style="padding:8px; border:1px solid #ddd;">Formula</th>
          <th style="padding:8px; border:1px solid #ddd;">Bold</th>
        </tr>
        <tr>
          <td style="padding:8px; border:1px solid #ddd;">10000</td>
          <td style="padding:8px; border:1px solid #ddd;">Header</td>
          <td style="padding:8px; border:1px solid #ddd;">Material Costs</td>
          <td style="padding:8px; border:1px solid #ddd;">-</td>
          <td style="padding:8px; border:1px solid #ddd;">Yes</td>
        </tr>
        <tr>
          <td style="padding:8px; border:1px solid #ddd;">20000</td>
          <td style="padding:8px; border:1px solid #ddd;">Material</td>
          <td style="padding:8px; border:1px solid #ddd;">Raw Materials from BOM</td>
          <td style="padding:8px; border:1px solid #ddd;">{MATERIAL}</td>
          <td style="padding:8px; border:1px solid #ddd;">No</td>
        </tr>
        <tr>
          <td style="padding:8px; border:1px solid #ddd;">30000</td>
          <td style="padding:8px; border:1px solid #ddd;">Formula</td>
          <td style="padding:8px; border:1px solid #ddd;">Material Overhead</td>
          <td style="padding:8px; border:1px solid #ddd;">{MATERIAL} * {OVERHEAD-PCT}</td>
          <td style="padding:8px; border:1px solid #ddd;">No</td>
        </tr>
        <tr>
          <td style="padding:8px; border:1px solid #ddd;">40000</td>
          <td style="padding:8px; border:1px solid #ddd;">Sum Line</td>
          <td style="padding:8px; border:1px solid #ddd;">Total Material</td>
          <td style="padding:8px; border:1px solid #ddd;">-</td>
          <td style="padding:8px; border:1px solid #ddd;">Yes</td>
        </tr>
        <tr>
          <td style="padding:8px; border:1px solid #ddd;">50000</td>
          <td style="padding:8px; border:1px solid #ddd;">Header</td>
          <td style="padding:8px; border:1px solid #ddd;">Labor Costs</td>
          <td style="padding:8px; border:1px solid #ddd;">-</td>
          <td style="padding:8px; border:1px solid #ddd;">Yes</td>
        </tr>
        <tr>
          <td style="padding:8px; border:1px solid #ddd;">60000</td>
          <td style="padding:8px; border:1px solid #ddd;">Labor</td>
          <td style="padding:8px; border:1px solid #ddd;">Work Center Costs from Routing</td>
          <td style="padding:8px; border:1px solid #ddd;">{LABOR}</td>
          <td style="padding:8px; border:1px solid #ddd;">No</td>
        </tr>
        <tr>
          <td style="padding:8px; border:1px solid #ddd;">70000</td>
          <td style="padding:8px; border:1px solid #ddd;">Formula</td>
          <td style="padding:8px; border:1px solid #ddd;">Setup Cost</td>
          <td style="padding:8px; border:1px solid #ddd;">{SETUP-FIXED}</td>
          <td style="padding:8px; border:1px solid #ddd;">No</td>
        </tr>
      </table>
      
      <p><strong>Release Template:</strong> After creating lines, use <strong>Release</strong> action to make template available for calculations</p>
    </div>
  </div>
</div>

---

## 💼 Working with Calculations

### Creating a New Calculation

<div class="step-container">
  <div class="step">
    <div class="step-number">1</div>
    <div class="step-content">
      <h4>Open Calculation List</h4>
      <p>Search for: <strong>Calculations</strong> or <strong>SEW Calc Headers</strong></p>
      <p>Click <strong>New</strong> to create a calculation</p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">2</div>
    <div class="step-content">
      <h4>Fill Header Information</h4>
      <ul>
        <li><strong>No.:</strong> Click AssistEdit (...) to generate from number series</li>
        <li><strong>Template Code:</strong> Select template (e.g., STANDARD)</li>
        <li><strong>Item No.:</strong> Select the item to calculate</li>
        <li><strong>Description:</strong> Auto-fills from item, can edit</li>
        <li><strong>Calculation Date:</strong> Date of calculation (defaults to today)</li>
        <li><strong>Lot Size:</strong> Production quantity (e.g., 100 pieces)</li>
        <li><strong>Status:</strong> Starts as Draft</li>
      </ul>
      
      <div class="info-box">
        <p>💡 <strong>Screenshot Placeholder:</strong> Calculation Card - Header Information</p>
      </div>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">3</div>
    <div class="step-content">
      <h4>Apply Template</h4>
      <p>After saving, use action: <strong>Calculate from Template</strong></p>
      <p>This copies all template lines and evaluates formulas based on:</p>
      <ul>
        <li>Item's Production BOM (material costs)</li>
        <li>Item's Routing (labor costs)</li>
        <li>Defined variables (overhead, setup costs, etc.)</li>
        <li>Specified lot size</li>
      </ul>
      
      <div class="info-box">
        <p>💡 <strong>Screenshot Placeholder:</strong> Template Applied - Lines Populated with Costs</p>
      </div>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">4</div>
    <div class="step-content">
      <h4>Review Calculated Costs</h4>
      <p>Check the <strong>Totals</strong> section:</p>
      <ul>
        <li><strong>Total Material Cost:</strong> Sum of all material costs</li>
        <li><strong>Total Labor Cost:</strong> Sum of all labor costs</li>
        <li><strong>Total Overhead Cost:</strong> Sum of all overhead costs</li>
        <li><strong>Total Cost:</strong> Grand total</li>
      </ul>
      
      <p>Check the <strong>Pricing</strong> section:</p>
      <ul>
        <li><strong>Target Sales Price:</strong> Suggested selling price</li>
        <li><strong>Margin %:</strong> Calculated margin percentage</li>
      </ul>
      
      <div class="info-box">
        <p>💡 <strong>Screenshot Placeholder:</strong> Calculation Totals and Pricing</p>
      </div>
    </div>
  </div>
</div>

### Quick Calculation from Item Card

<div class="info-box info-box-success">
  <p><strong>Faster Workflow:</strong></p>
  <ol>
    <li>Open any <strong>Item Card</strong></li>
    <li>Set <strong>SEW Default Template Code</strong> (one-time setup)</li>
    <li>Click action: <strong>New Calculation</strong></li>
    <li>Calculation is created automatically with item and template pre-filled</li>
  </ol>
  
  <p>💡 <strong>Screenshot Placeholder:</strong> Item Card with Calculation Actions</p>
</div>

---

## 📐 Working with Formulas

### System Variables

<div class="code-section">
  <p>Reference calculated values from BOM/Routing:</p>
  <ul>
    <li><code>{MATERIAL}</code> - Total material cost from Production BOM</li>
    <li><code>{LABOR}</code> - Total labor cost from Routing</li>
    <li><code>{OVERHEAD}</code> - Total overhead cost</li>
    <li><code>{TOTALCOST}</code> - Sum of Material + Labor + Overhead</li>
  </ul>
</div>

### Custom Variables

<div class="code-section">
  <p>Use variables created in <strong>Calculation Variables</strong>:</p>
  <ul>
    <li><code>{OVERHEAD-PCT}</code> - Custom percentage variable</li>
    <li><code>{SETUP-FIXED}</code> - Custom fixed cost variable</li>
    <li><code>{ANY-VARIABLE-CODE}</code> - Any variable you defined</li>
  </ul>
</div>

### Formula Examples

<table style="width:100%; border-collapse: collapse; margin: 15px 0;">
  <tr style="background: #f0f0f0;">
    <th style="padding:8px; border:1px solid #ddd;">Formula</th>
    <th style="padding:8px; border:1px solid #ddd;">Description</th>
  </tr>
  <tr>
    <td style="padding:8px; border:1px solid #ddd;"><code>{MATERIAL} * 1.2</code></td>
    <td style="padding:8px; border:1px solid #ddd;">Add 20% to material cost</td>
  </tr>
  <tr>
    <td style="padding:8px; border:1px solid #ddd;"><code>{LABOR} + {SETUP-FIXED}</code></td>
    <td style="padding:8px; border:1px solid #ddd;">Add fixed setup cost to labor</td>
  </tr>
  <tr>
    <td style="padding:8px; border:1px solid #ddd;"><code>({MATERIAL} + {LABOR}) * {OVERHEAD-PCT}</code></td>
    <td style="padding:8px; border:1px solid #ddd;">Apply overhead % to material + labor</td>
  </tr>
  <tr>
    <td style="padding:8px; border:1px solid #ddd;"><code>{TOTALCOST} * 1.5</code></td>
    <td style="padding:8px; border:1px solid #ddd;">Calculate selling price (50% margin)</td>
  </tr>
  <tr>
    <td style="padding:8px; border:1px solid #ddd;"><code>(10 + 5) * 2</code></td>
    <td style="padding:8px; border:1px solid #ddd;">Simple math (result: 30)</td>
  </tr>
  <tr>
    <td style="padding:8px; border:1px solid #ddd;"><code>100 / 4 + 10</code></td>
    <td style="padding:8px; border:1px solid #ddd;">Operator precedence (result: 35)</td>
  </tr>
</table>

<div class="info-box info-box-warning">
  <p>⚠️ <strong>Important:</strong> Variables must be defined in <strong>Calculation Variables</strong> before use. The formula parser will show an error for undefined variables.</p>
</div>

---

## 📊 Lot Size Simulation

Simulate different production quantities to find the optimal lot size.

<div class="step-container">
  <div class="step">
    <div class="step-number">1</div>
    <div class="step-content">
      <h4>Create Simulation</h4>
      <p>From a <strong>Released</strong> calculation, click: <strong>Simulate Lot Sizes</strong></p>
      <p>A new simulation is created with link to the calculation</p>
      
      <div class="info-box">
        <p>💡 <strong>Screenshot Placeholder:</strong> Simulation Card Opening</p>
      </div>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">2</div>
    <div class="step-content">
      <h4>Set Parameters</h4>
      <ul>
        <li><strong>Target Sales Price:</strong> Desired selling price (optional)</li>
        <li><strong>Target Margin %:</strong> Desired margin percentage (optional)</li>
      </ul>
      <p>Click: <strong>Generate Scenarios</strong></p>
      <p>System creates scenarios for common lot sizes: 10, 50, 100, 500, 1000</p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">3</div>
    <div class="step-content">
      <h4>Review Scenarios</h4>
      <p>The <strong>Simulation Lines</strong> subpage shows:</p>
      <table style="width:100%; border-collapse: collapse; margin: 15px 0;">
        <tr style="background: #f0f0f0;">
          <th style="padding:8px; border:1px solid #ddd;">Column</th>
          <th style="padding:8px; border:1px solid #ddd;">Description</th>
        </tr>
        <tr>
          <td style="padding:8px; border:1px solid #ddd;">Scenario Code</td>
          <td style="padding:8px; border:1px solid #ddd;">SMALL, MEDIUM, LARGE, X-LARGE, XX-LARGE</td>
        </tr>
        <tr>
          <td style="padding:8px; border:1px solid #ddd;">Lot Size</td>
          <td style="padding:8px; border:1px solid #ddd;">Production quantity for this scenario</td>
        </tr>
        <tr>
          <td style="padding:8px; border:1px solid #ddd;">Setup Cost</td>
          <td style="padding:8px; border:1px solid #ddd;">Fixed one-time cost (editable)</td>
        </tr>
        <tr>
          <td style="padding:8px; border:1px solid #ddd;">Material Cost</td>
          <td style="padding:8px; border:1px solid #ddd;">Total material for this quantity</td>
        </tr>
        <tr>
          <td style="padding:8px; border:1px solid #ddd;">Labor Cost</td>
          <td style="padding:8px; border:1px solid #ddd;">Total labor for this quantity</td>
        </tr>
        <tr>
          <td style="padding:8px; border:1px solid #ddd;">Unit Cost</td>
          <td style="padding:8px; border:1px solid #ddd;">Cost per piece (Total Cost / Lot Size)</td>
        </tr>
        <tr>
          <td style="padding:8px; border:1px solid #ddd;">Suggested Sales Price</td>
          <td style="padding:8px; border:1px solid #ddd;">Calculated based on target margin</td>
        </tr>
        <tr>
          <td style="padding:8px; border:1px solid #ddd;">Margin %</td>
          <td style="padding:8px; border:1px solid #ddd;">Profit margin at suggested price</td>
        </tr>
        <tr>
          <td style="padding:8px; border:1px solid #ddd;">Break-Even Qty</td>
          <td style="padding:8px; border:1px solid #ddd;">Minimum quantity to cover setup cost</td>
        </tr>
        <tr>
          <td style="padding:8px; border:1px solid #ddd;">Is Recommended</td>
          <td style="padding:8px; border:1px solid #ddd;">System's recommended scenario ✓</td>
        </tr>
      </table>
      
      <div class="info-box">
        <p>💡 <strong>Screenshot Placeholder:</strong> Simulation Scenarios with Unit Cost Comparison</p>
      </div>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">4</div>
    <div class="step-content">
      <h4>Understand Recommendations</h4>
      <p>The system calculates a <strong>Recommendation Score</strong> based on:</p>
      <ul>
        <li>Proximity to target margin</li>
        <li>Low unit cost</li>
        <li>Reasonable break-even quantity</li>
      </ul>
      <p>The scenario with the highest score is marked <strong>Is Recommended = Yes</strong></p>
    </div>
  </div>
</div>

---

## 🔗 Integration with Sales Quotes

### Automatic Calculation Creation

<div class="step-container">
  <div class="step">
    <div class="step-number">1</div>
    <div class="step-content">
      <h4>Enable Auto-Calculate</h4>
      <p>Open a <strong>Sales Quote</strong></p>
      <p>On the quote header:</p>
      <ul>
        <li><strong>SEW Default Calc Template:</strong> Select template (e.g., STANDARD)</li>
        <li><strong>SEW Auto Calculate:</strong> Enable (Yes)</li>
      </ul>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">2</div>
    <div class="step-content">
      <h4>Add Item Line</h4>
      <p>Add an item to the sales line</p>
      <p>System automatically:</p>
      <ul>
        <li>Creates a calculation using the default template</li>
        <li>Calculates costs based on item's BOM/Routing</li>
        <li>Links calculation to sales line</li>
        <li>Populates cost fields on the line</li>
      </ul>
      
      <div class="info-box">
        <p>💡 <strong>Screenshot Placeholder:</strong> Sales Quote with Auto-Calculated Costs</p>
      </div>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">3</div>
    <div class="step-content">
      <h4>View Cost Breakdown</h4>
      <p>Select a sales line with a calculation</p>
      <p>In the <strong>FactBox</strong> on the right, see:</p>
      <ul>
        <li><strong>Cost Breakdown:</strong> Material, Labor, Overhead costs</li>
        <li><strong>Total Cost:</strong> Sum of all costs</li>
        <li><strong>Margin Status:</strong> Visual indicator (Above/Below Target)</li>
        <li><strong>Margin %:</strong> Current margin at unit price</li>
      </ul>
      
      <div class="info-box">
        <p>💡 <strong>Screenshot Placeholder:</strong> Cost Breakdown FactBox</p>
      </div>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">4</div>
    <div class="step-content">
      <h4>Adjust Pricing</h4>
      <p>On the sales line:</p>
      <ul>
        <li><strong>SEW Calculated Cost:</strong> Shows total cost</li>
        <li><strong>SEW Target Price:</strong> Shows suggested selling price</li>
        <li><strong>Unit Price:</strong> Manually adjust as needed</li>
        <li><strong>SEW Calculated Margin %:</strong> Updates automatically</li>
      </ul>
    </div>
  </div>
</div>

### Manual Calculation Link

<div class="info-box info-box-success">
  <p><strong>Alternative Workflow:</strong></p>
  <p>If auto-calculate is disabled, you can manually link calculations:</p>
  <ol>
    <li>Create calculation separately via <strong>Calculations</strong> list</li>
    <li>On sales line, select the calculation in field: <strong>SEW Calc No.</strong></li>
    <li>Cost fields populate automatically</li>
  </ol>
</div>

---

## 🏭 Integration with Production Orders

### Link Calculation to Production Order

<div class="step-container">
  <div class="step">
    <div class="step-number">1</div>
    <div class="step-content">
      <h4>Create Production Order</h4>
      <p>Create a <strong>Production Order</strong> for an item with a calculation</p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">2</div>
    <div class="step-content">
      <h4>Link Calculation</h4>
      <p>On the production order:</p>
      <ul>
        <li><strong>SEW Calc No.:</strong> Select the calculation</li>
        <li><strong>SEW Planned Cost:</strong> Auto-fills from calculation</li>
        <li><strong>SEW Alert Threshold %:</strong> Set alert level (default 10%)</li>
      </ul>
      
      <div class="info-box">
        <p>💡 <strong>Screenshot Placeholder:</strong> Production Order with Calculation Link</p>
      </div>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">3</div>
    <div class="step-content">
      <h4>Monitor Actual Costs</h4>
      <p>As production progresses:</p>
      <ul>
        <li><strong>SEW Actual Cost to Date:</strong> Updates from capacity/item ledgers</li>
        <li><strong>SEW Cost Variance:</strong> Shows deviation from plan (amount)</li>
        <li><strong>SEW Cost Variance %:</strong> Shows deviation (percentage)</li>
        <li><strong>SEW Cost Alert:</strong> Turns red if variance exceeds threshold</li>
      </ul>
      
      <div class="info-box info-box-warning">
        <p>⚠️ <strong>Cost Alert Example:</strong></p>
        <p>Planned Cost: 1,000 EUR | Actual: 1,150 EUR | Variance: 15% → Alert triggered if threshold is 10%</p>
      </div>
    </div>
  </div>
</div>

### Create Post-Calculation

<div class="step-container">
  <div class="step">
    <div class="step-number">1</div>
    <div class="step-content">
      <h4>Finish Production</h4>
      <p>Complete and <strong>Finish</strong> the production order</p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">2</div>
    <div class="step-content">
      <h4>Create Post-Calculation</h4>
      <p>From the calculation linked to production order:</p>
      <p>Click: <strong>Create Post-Calculation</strong></p>
      <p>System creates a new calculation with actual costs:</p>
      <ul>
        <li>Material cost from actual item consumption</li>
        <li>Labor cost from actual capacity time</li>
        <li>Same overhead formulas applied</li>
      </ul>
      
      <div class="info-box">
        <p>💡 <strong>Screenshot Placeholder:</strong> Post-Calculation with Variances</p>
      </div>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">3</div>
    <div class="step-content">
      <h4>Analyze Variances</h4>
      <p>Compare pre-calculation (CALC0001) vs. post-calculation (CALC0001-POST):</p>
      <ul>
        <li><strong>Material Variance:</strong> Actual - Planned material</li>
        <li><strong>Labor Variance:</strong> Actual - Planned labor</li>
        <li><strong>Total Variance:</strong> Overall cost difference</li>
      </ul>
      <p>Use this data for continuous improvement and future calculations</p>
    </div>
  </div>
</div>

---

## 📄 Printing Reports

<div class="step-container">
  <div class="step">
    <div class="step-number">1</div>
    <div class="step-content">
      <h4>Open Calculation</h4>
      <p>Open the calculation you want to print</p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">2</div>
    <div class="step-content">
      <h4>Start Print</h4>
      <p>Click: <strong>Print Calculation</strong> action</p>
      <p>Report request page opens</p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">3</div>
    <div class="step-content">
      <h4>Configure Report Options</h4>
      <ul>
        <li><strong>Show Variables:</strong> Include variable definitions</li>
        <li><strong>Show Details:</strong> Include formula details</li>
        <li><strong>Show Components:</strong> Include BOM/Routing components</li>
      </ul>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">4</div>
    <div class="step-content">
      <h4>Preview or Print</h4>
      <p>Click <strong>Preview</strong> or <strong>Print</strong></p>
      <p>Report shows:</p>
      <ul>
        <li>Calculation header information</li>
        <li>Cost breakdown by line type</li>
        <li>Formulas and results</li>
        <li>Total costs</li>
        <li>Pricing information</li>
      </ul>
      
      <div class="info-box">
        <p>💡 <strong>Screenshot Placeholder:</strong> Calculation Report Preview</p>
      </div>
    </div>
  </div>
</div>

---

## 📝 Calculation Lifecycle

### Status Workflow

<table style="width:100%; border-collapse: collapse; margin: 15px 0;">
  <tr style="background: #f0f0f0;">
    <th style="padding:8px; border:1px solid #ddd;">Status</th>
    <th style="padding:8px; border:1px solid #ddd;">Description</th>
    <th style="padding:8px; border:1px solid #ddd;">Actions Available</th>
  </tr>
  <tr>
    <td style="padding:8px; border:1px solid #ddd;"><strong>Draft</strong></td>
    <td style="padding:8px; border:1px solid #ddd;">Initial state, fully editable</td>
    <td style="padding:8px; border:1px solid #ddd;">Edit, Calculate, Release</td>
  </tr>
  <tr>
    <td style="padding:8px; border:1px solid #ddd;"><strong>Released</strong></td>
    <td style="padding:8px; border:1px solid #ddd;">Approved, locked for changes</td>
    <td style="padding:8px; border:1px solid #ddd;">Transfer to Item, Simulate, Reopen, Archive</td>
  </tr>
  <tr>
    <td style="padding:8px; border:1px solid #ddd;"><strong>Archived</strong></td>
    <td style="padding:8px; border:1px solid #ddd;">Completed, read-only</td>
    <td style="padding:8px; border:1px solid #ddd;">View only</td>
  </tr>
</table>

### Actions Explained

<div class="feature-grid">
  <div class="feature-card">
    <h3>📝 Release</h3>
    <p>Locks calculation from editing, enables transfer to item and simulation</p>
  </div>
  <div class="feature-card">
    <h3>🔓 Reopen</h3>
    <p>Returns to Draft status for modifications</p>
  </div>
  <div class="feature-card">
    <h3>📦 Archive</h3>
    <p>Permanently archives calculation, read-only</p>
  </div>
  <div class="feature-card">
    <h3>🔄 Transfer to Item</h3>
    <p>Updates item's Unit Cost with calculation total</p>
  </div>
  <div class="feature-card">
    <h3>🔄 Recalculate</h3>
    <p>Re-evaluates all formulas with current data</p>
  </div>
  <div class="feature-card">
    <h3>📊 Export to Excel</h3>
    <p>Export calculation details for external analysis</p>
  </div>
</div>

---

## 📚 Change History

Every change to a calculation is automatically tracked.

<div class="step-container">
  <div class="step">
    <div class="step-number">1</div>
    <div class="step-content">
      <h4>View History</h4>
      <p>From a calculation card, click: <strong>Show History</strong></p>
      <p>Opens the <strong>Calculation History</strong> page</p>
    </div>
  </div>
  
  <div class="step">
    <div class="step-number">2</div>
    <div class="step-content">
      <h4>Review Changes</h4>
      <p>Each history entry shows:</p>
      <ul>
        <li><strong>Change Type:</strong> Created, Modified, Released, Archived</li>
        <li><strong>Change Date/Time:</strong> When the change occurred</li>
        <li><strong>Changed By User:</strong> Who made the change</li>
        <li><strong>Field Name:</strong> What was changed</li>
        <li><strong>Old/New Value:</strong> Before and after values</li>
      </ul>
      
      <div class="info-box">
        <p>💡 <strong>Screenshot Placeholder:</strong> Calculation History List</p>
      </div>
    </div>
  </div>
</div>

---

## 🎯 Best Practices

<div class="info-box info-box-success">
  <h4>✅ Calculation Tips</h4>
  <ul>
    <li><strong>Create Templates:</strong> Define standard calculation structures once, reuse everywhere</li>
    <li><strong>Use Variables:</strong> Centralize overhead rates and factors for easy updates</li>
    <li><strong>Release Before Transfer:</strong> Always release calculations before transferring to items</li>
    <li><strong>Link to Quotes:</strong> Use auto-calculate for faster quote creation</li>
    <li><strong>Simulate First:</strong> Run lot size simulation before committing to production quantities</li>
    <li><strong>Track Production:</strong> Link calculations to production orders for variance tracking</li>
    <li><strong>Post-Calculate:</strong> Create post-calculations to learn from actual costs</li>
  </ul>
</div>

<div class="info-box info-box-warning">
  <h4>⚠️ Common Pitfalls</h4>
  <ul>
    <li><strong>Missing BOM/Routing:</strong> Items must have Production BOM and Routing for cost calculation</li>
    <li><strong>Undefined Variables:</strong> All variables in formulas must exist in Calculation Variables</li>
    <li><strong>Wrong Price Source:</strong> Choose price source that matches your costing method</li>
    <li><strong>Editing Released Calcs:</strong> Reopen first before making changes</li>
    <li><strong>Forgetting Lot Size:</strong> Unit costs vary significantly by production quantity</li>
  </ul>
</div>

---

## 🆘 Troubleshooting

### Formula Errors

<div class="info-box">
  <p><strong>Error: "Invalid formula syntax"</strong></p>
  <p>✅ <strong>Solution:</strong> Check formula for typos, ensure all parentheses match, verify operator placement</p>
  <p><strong>Example:</strong> <code>10 + * 5</code> is invalid → <code>10 + 5 * 2</code> is valid</p>
</div>

<div class="info-box">
  <p><strong>Error: "Variable not found: {VARNAME}"</strong></p>
  <p>✅ <strong>Solution:</strong> Create the variable in <strong>Calculation Variables</strong> first</p>
</div>

### Cost Calculation Issues

<div class="info-box">
  <p><strong>Material Cost is Zero</strong></p>
  <p>✅ <strong>Check:</strong></p>
  <ul>
    <li>Item has Production BOM assigned and certified</li>
    <li>BOM components have costs (Unit Cost, Standard Cost, etc.)</li>
    <li>Price Source is correctly set in template</li>
  </ul>
</div>

<div class="info-box">
  <p><strong>Labor Cost is Zero</strong></p>
  <p>✅ <strong>Check:</strong></p>
  <ul>
    <li>Item has Routing assigned and certified</li>
    <li>Work Centers/Machine Centers have hourly rates</li>
    <li>Routing operations have Setup Time and/or Run Time</li>
  </ul>
</div>

### Transfer to Item Not Working

<div class="info-box">
  <p><strong>Error: "Cannot transfer, calculation not released"</strong></p>
  <p>✅ <strong>Solution:</strong> Release the calculation first (action: <strong>Release</strong>)</p>
</div>

---

---

<div class="footer-info">
  <p><strong>License:</strong> MIT License - see <a href="../../LICENSE">LICENSE</a> file for details</p>
  <p><strong>Author:</strong> Sebastian Walter (@walter75) | <strong>Support:</strong> <a href="https://github.com/walter75-Consulting/Business-Central-Apps/issues">GitHub Issues</a> | <a href="https://www.walter75.de">walter75.de</a></p>
  <p style="font-size: 0.9em; color: #666; margin-top: 10px;">Personal open-source project - not a commercial service</p>
</div>

---

<div style="text-align: center; margin-top: 40px;">
  <a href="calculation.html" class="btn">← Technical Documentation</a>
  <a href="index.html" class="btn" style="margin-left: 10px;">Back to Apps →</a>
</div>

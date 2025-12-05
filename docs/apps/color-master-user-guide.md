# walter75 - Color Master
## User Guide

**Version:** 26.2.0  
**Publisher:** walter75 Consulting  
**Platform:** Microsoft Dynamics 365 Business Central Cloud

---

## Table of Contents

1. [Introduction](#introduction)
2. [Setup](#setup)
3. [Creating Color Formulas](#creating-color-formulas)
4. [Managing Color Inventory](#managing-color-inventory)
5. [Color Matching](#color-matching)
6. [Production with Colors](#production-with-colors)
7. [Troubleshooting](#troubleshooting)

---

## Introduction

The **walter75 - Color Master** extension provides comprehensive color management for manufacturing businesses. Create, manage, and track color formulas with precise component ratios, inventory tracking, and batch production support.

### Key Features

- 🎨 **Formula Management**: Define color recipes with precise ratios
- 📦 **Color Inventory**: Track raw color materials and mixed colors
- 🔄 **Version Control**: Maintain formula history and revisions
- 🎯 **Color Matching**: Find similar colors in database
- 📊 **Batch Tracking**: Track production batches with lot numbers
- ✅ **Quality Control**: Record color measurements and tolerances
- 📈 **Usage Reports**: Analyze color consumption and costs

---

## Setup

### Step 1: Color Master Setup

1. Search for **"Color Master Setup"**
2. Configure general settings:
   - **Color No. Series**: Number series for color codes
   - **Formula No. Series**: Number series for formulas
   - **Batch No. Series**: Automated batch numbers
   - **Default Unit of Measure**: kg, L, or g
   - **Tolerance Percentage**: Acceptable variance in mixing

![Screenshot: Color Master Setup]
*Placeholder for screenshot of Color Master setup page*

### Step 2: Define Base Colors

Set up raw color materials:

1. Search for **"Base Colors"**
2. Click **+ New** for each base color
3. Enter:
   - **Code**: Unique identifier (e.g., "RED-01", "BLUE-05")
   - **Description**: Color name (e.g., "Titanium White", "Cobalt Blue")
   - **Color Type**: Pigment, Binder, Solvent, Additive
   - **Supplier**: Vendor who supplies this color
   - **Unit Cost**: Purchase price per unit
   - **Unit of Measure**: kg, L, etc.

![Screenshot: Base Colors List]
*Placeholder for screenshot of base colors configuration*

### Step 3: Link to Items

1. Each base color should link to an inventory item
2. On **Base Color Card**, specify:
   - **Item No.**: Linked inventory item
   - **Item Variant**: If applicable
3. System tracks inventory through standard BC item ledger

![Screenshot: Base Color Item Link]
*Placeholder for screenshot showing item linkage*

---

## Creating Color Formulas

### Step 1: Create New Color

1. Search for **"Colors"** or **"Color List"**
2. Click **+ New**
3. Enter basic information:
   - **Color Code**: Unique code (e.g., "CUST-2025-001")
   - **Description**: Descriptive name (e.g., "Customer Blue")
   - **Color Family**: Red, Blue, Green, Yellow, etc.
   - **Customer**: If custom color for specific customer
   - **Status**: Development, Approved, Obsolete

![Screenshot: Color Card Header]
*Placeholder for screenshot of color card*

### Step 2: Define Formula Components

1. Navigate to **Formula Lines**
2. Add each component:
   - **Base Color Code**: Select from base colors
   - **Quantity**: Amount per batch
   - **Percentage**: Calculated automatically
   - **Sequence**: Mixing order if important

**Example Formula for "Ocean Blue":**

| Seq | Base Color | Quantity (g) | Percentage | Notes |
|-----|------------|--------------|------------|-------|
| 1 | WHITE-TI | 850 | 85% | Titanium White |
| 2 | BLUE-CO | 120 | 12% | Cobalt Blue |
| 3 | BLACK-01 | 20 | 2% | Carbon Black |
| 4 | BINDER-A | 10 | 1% | Acrylic Binder |
| **Total** | | **1000 g** | **100%** | |

![Screenshot: Formula Lines]
*Placeholder for screenshot of formula component lines*

### Step 3: Set Batch Size

- **Standard Batch Size**: Default production quantity (e.g., 1 kg, 5 L)
- **Minimum Batch**: Smallest mixable amount
- **Maximum Batch**: Largest practical batch
- System scales formula proportionally for different batch sizes

### Step 4: Add Color Specifications

Define quality parameters:

1. Navigate to **Specifications** tab
2. Enter target values:
   - **Color Code (RAL/Pantone)**: Standard color reference
   - **Gloss Level**: Matte, Satin, Semi-Gloss, Gloss
   - **Viscosity**: Target viscosity range
   - **Density**: Expected density
   - **pH Level**: If applicable
   - **Drying Time**: Expected drying time

![Screenshot: Color Specifications]
*Placeholder for screenshot of specification fields*

### Step 5: Upload Color Sample

1. Click **Attach Image** or **Add Picture**
2. Upload photo of physical color sample
3. Image displays on color card for visual reference
4. Helpful for color matching and customer approvals

![Screenshot: Color Sample Image]
*Placeholder for screenshot showing uploaded color sample*

---

## Managing Color Inventory

### Viewing Color Stock

1. Search for **"Color Inventory"**
2. View current stock levels for:
   - Base colors (raw materials)
   - Mixed colors (finished formulas)
3. Columns show:
   - Quantity On Hand
   - Quantity Allocated
   - Quantity Available
   - Reorder Point
   - Preferred Vendor

![Screenshot: Color Inventory List]
*Placeholder for screenshot of inventory view*

### Replenishing Base Colors

1. Monitor base color levels
2. When below reorder point, system can:
   - Create purchase requisition
   - Generate purchase order automatically
   - Send alert to purchasing agent
3. Use standard BC replenishment system

### Mixing Colors (Production)

#### Method 1: Production Order

1. Create **Production Order** for color item
2. Select color formula
3. System generates:
   - Component requirements (base colors needed)
   - Routing (mixing instructions)
4. Post production when complete

![Screenshot: Color Production Order]
*Placeholder for screenshot of color production order*

#### Method 2: Quick Mix (Assembly)

For simple colors, use assembly orders:

1. Search for **"Assembly Orders"**
2. Select color item
3. System shows components from formula
4. Pick components from inventory
5. Post assembly to create finished color

### Lot Number Tracking

Each color batch has unique lot/batch number:

1. When mixing, enter or scan **Batch No.**
2. System records:
   - Production date
   - Expiration date (if applicable)
   - Quantity produced
   - Base color lot numbers used
   - Operator who mixed batch
3. Full traceability from finished color to raw materials

![Screenshot: Batch Number Entry]
*Placeholder for screenshot of batch number tracking*

---

## Color Matching

### Finding Similar Colors

1. Open color you want to match
2. Click **Actions** → **"Find Similar Colors"**
3. System searches by:
   - Color family
   - Formula components
   - Color specifications (RAL/Pantone)
4. Results show similarity percentage

![Screenshot: Color Match Results]
*Placeholder for screenshot of color matching results*

### Creating Color Variant

To create slightly different version:

1. Open source color
2. Click **Actions** → **"Copy to New Color"**
3. New color created with same formula
4. Adjust formula components as needed
5. Link original as "Base Color Reference"

### Customer Color Approval

1. Create sample batch (small quantity)
2. Generate **Color Sample Report** with:
   - Color image
   - Formula details
   - Specifications
3. Send to customer for approval
4. Update **Status** to "Approved" when confirmed

![Screenshot: Color Sample Report]
*Placeholder for screenshot of color approval document*

---

## Production with Colors

### Using Colors in Production BOMs

1. Open **Production BOM** for finished product
2. Add color as component:
   - **Type**: Item
   - **No.**: Color item code
   - **Quantity**: Amount per finished unit
3. System consumes color inventory when producing product

![Screenshot: Color in Production BOM]
*Placeholder for screenshot showing color in BOM*

### Color-Specific Routing

Some colors require special handling:

1. In **Routing**, add color-specific operations:
   - Pre-mix base colors
   - Add tint gradually
   - Stir for specific time
   - Quality check color match
2. Record operation times for costing

### Quality Control During Production

1. At quality control step, verify:
   - Visual color match to sample
   - Measure with colorimeter if available
   - Check viscosity and consistency
   - Confirm batch number recorded
2. **Pass**: Continue to next operation
3. **Fail**: Rework or scrap batch, document issue

![Screenshot: Color QC Checklist]
*Placeholder for screenshot of quality control recording*

---

## Troubleshooting

### Common Issues

#### Issue: "Formula Doesn't Total 100%"

**Cause:** Component quantities don't match intended batch size

**Solution:**
1. Check all formula lines
2. Verify **Quantity** fields
3. System auto-calculates percentages
4. Adjust quantities to reach 100% or intended total
5. Consider minor components like additives

#### Issue: "Color Doesn't Match Sample"

**Possible Causes:**
- Base color batch variation
- Incorrect mixing sequence
- Expired components
- Wrong mixing equipment/conditions

**Solution:**
1. Verify base color lot numbers match approved lots
2. Check mixing sequence followed correctly
3. Confirm component expiration dates
4. Review environmental factors (temperature, humidity)
5. Adjust formula and create new version if needed

#### Issue: "Cannot Find Color in Inventory"

**Cause:** Color not produced or zero inventory

**Solution:**
1. Check **Color Inventory** for current stock
2. Review recent production orders
3. Create new production order if out of stock
4. Check if color status is "Active"
5. Verify item is not blocked

#### Issue: "Base Color Out of Stock"

**Cause:** Inventory depleted, order not placed

**Solution:**
1. Check **Reorder Point** for base color
2. Verify purchase order exists
3. Create emergency purchase order
4. Check with supplier for delivery time
5. Consider alternative base color if available

### Best Practices

✅ **Do:**
- Document all formula changes with version numbers
- Take photos of color samples for reference
- Record batch numbers for traceability
- Set appropriate reorder points for base colors
- Regular quality checks on base color batches
- Train operators on proper mixing procedures
- Clean mixing equipment between different color families

❌ **Don't:**
- Mix colors without following sequence
- Use expired or deteriorated base colors
- Skip batch number recording
- Change approved formulas without creating new version
- Ignore color specification tolerances
- Rush mixing process (affects quality)
- Store mixed colors beyond shelf life

### Maintenance Tasks

**Weekly:**
- Check base color inventory levels
- Review pending color production orders
- Verify no expired base colors in stock

**Monthly:**
- Analyze color usage and costs
- Review slow-moving colors for obsolescence
- Update pricing if base color costs changed
- Clean and calibrate mixing equipment

**Quarterly:**
- Physical inventory count of base colors
- Review all active formulas for optimization
- Audit batch traceability records
- Train new staff on color procedures

---

## Support

For technical support or questions:
- **Issues**: [GitHub Issues](https://github.com/walter75-Consulting/Business-Central-Apps/issues)
- **Documentation**: [Main Documentation](color-master.md)

---

**Last Updated:** December 2025

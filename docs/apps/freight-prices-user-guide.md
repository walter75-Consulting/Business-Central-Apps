# walter75 - Freight Prices
## User Guide

**Version:** 26.2.0  
**Publisher:** walter75 Consulting  
**Platform:** Microsoft Dynamics 365 Business Central Cloud

---

## Table of Contents

1. [Introduction](#introduction)
2. [Setup](#setup)
3. [Managing Freight Zones](#managing-freight-zones)
4. [Configuring Freight Prices](#configuring-freight-prices)
5. [Calculating Freight Costs](#calculating-freight-costs)
6. [Troubleshooting](#troubleshooting)

---

## Introduction

The **walter75 - Freight Prices** extension provides advanced freight pricing management for Microsoft Dynamics 365 Business Central. Calculate accurate shipping costs based on zones, weight, volume, and carrier-specific rules.

### Key Features

- 🗺️ **Zone-Based Pricing**: Define shipping zones by postal code, country, or region
- ⚖️ **Weight/Volume Calculation**: Automatic freight cost based on shipment size
- 🚚 **Multi-Carrier Support**: Different rates for multiple shipping carriers
- 📊 **Price Tiers**: Progressive pricing based on weight brackets
- 🔄 **Automatic Calculation**: Real-time freight cost on sales orders
- 📈 **Price History**: Track freight rate changes over time

---

## Setup

### Prerequisites

Before configuring freight prices:
- Shipping Agents must be set up in Business Central
- Postal codes and countries configured
- Items must have weight and volume dimensions

### Step 1: Enable Freight Pricing

1. Search for **"Freight Price Setup"**
2. Click **+ New** if setup doesn't exist
3. Configure general settings:
   - **Enable Automatic Calculation**: Auto-calculate on sales orders
   - **Default Freight Account**: G/L account for freight charges
   - **Minimum Charge**: Minimum freight cost regardless of weight
   - **Free Freight Threshold**: Order value for free shipping

![Screenshot: Freight Price Setup]
*Placeholder for screenshot of freight price setup page*

---

## Managing Freight Zones

### What are Freight Zones?

Freight zones are geographical areas with specific shipping rates. Zones are typically based on:
- Distance from warehouse
- Postal code ranges
- Countries or regions
- Carrier delivery areas

### Creating Freight Zones

#### Step 1: Open Freight Zones

1. Search for **"Freight Zones"**
2. Click **+ New**

![Screenshot: Freight Zones List]
*Placeholder for screenshot of freight zones list*

#### Step 2: Define Zone Properties

**Basic Information:**
- **Zone Code**: Unique identifier (e.g., "ZONE-1", "EU-CENTRAL")
- **Description**: Descriptive name (e.g., "Germany South", "EU Countries")
- **Priority**: Order of evaluation when multiple zones match (1 = highest)

![Screenshot: Freight Zone Card - Basic]
*Placeholder for screenshot showing zone basic information*

#### Step 3: Assign Postal Code Ranges

Define which postal codes belong to this zone:

1. Navigate to **Lines** → **Postal Code Ranges**
2. Click **+ New Line**
3. Enter:
   - **Country/Region Code**: (e.g., "DE" for Germany)
   - **Postal Code From**: Starting postal code (e.g., "80000")
   - **Postal Code To**: Ending postal code (e.g., "89999")

![Screenshot: Postal Code Ranges]
*Placeholder for screenshot of postal code range configuration*

**Examples:**

| Zone | Description | Country | From | To |
|------|-------------|---------|------|-----|
| ZONE-1 | Bavaria | DE | 80000 | 96999 |
| ZONE-2 | Berlin/Brandenburg | DE | 10000 | 19999 |
| ZONE-3 | Austria | AT | 1000 | 9999 |

#### Step 4: Alternative - Assign by Country

For international zones:

1. Navigate to **Lines** → **Countries/Regions**
2. Select countries that belong to this zone
3. All addresses in these countries will use this zone's rates

![Screenshot: Country Assignment]
*Placeholder for screenshot showing country assignment*

---

## Configuring Freight Prices

### Price Matrix Structure

Freight prices are defined based on:
1. **Freight Zone**: Destination area
2. **Shipping Agent**: Carrier company
3. **Weight/Volume**: Size of shipment
4. **Validity Period**: Date range for pricing

### Creating Freight Prices

#### Step 1: Open Freight Price List

1. Search for **"Freight Prices"**
2. View existing prices or click **+ New**

![Screenshot: Freight Prices List]
*Placeholder for screenshot of freight prices list*

#### Step 2: Define Price Entry

**Header Information:**
- **Freight Zone Code**: Select destination zone
- **Shipping Agent Code**: Select carrier (e.g., DHL, UPS)
- **Starting Date**: When this price becomes valid
- **Ending Date**: When this price expires (blank = no expiration)

![Screenshot: Freight Price Card - Header]
*Placeholder for screenshot showing price header*

#### Step 3: Configure Weight Brackets

Define progressive pricing based on weight:

1. Navigate to **Weight Brackets**
2. Add brackets with increasing weights:

| From Weight (kg) | To Weight (kg) | Price (€) |
|------------------|----------------|-----------|
| 0 | 5 | 8.50 |
| 5.01 | 10 | 12.00 |
| 10.01 | 20 | 18.00 |
| 20.01 | 30 | 25.00 |
| 30.01 | 9999 | 35.00 |

![Screenshot: Weight Brackets]
*Placeholder for screenshot of weight bracket configuration*

**Tips:**
- Use overlapping ranges carefully (system uses "From Weight" priority)
- Last bracket should have high "To Weight" (e.g., 9999) to catch heavy items
- Consider volume-based pricing for bulky items

#### Step 4: Optional - Volume-Based Pricing

For items where volume matters more than weight:

1. Navigate to **Volume Brackets**
2. Define pricing by cubic volume (m³):

| From Volume (m³) | To Volume (m³) | Price (€) |
|------------------|----------------|-----------|
| 0 | 0.1 | 8.50 |
| 0.1 | 0.5 | 15.00 |
| 0.5 | 1.0 | 28.00 |
| 1.0 | 9999 | 45.00 |

![Screenshot: Volume Brackets]
*Placeholder for screenshot of volume bracket configuration*

#### Step 5: Surcharges and Discounts

Add extra charges or discounts:

**Common Surcharges:**
- **Fuel Surcharge**: Percentage added for fuel costs
- **Remote Area Fee**: Fixed fee for difficult-to-reach zones
- **Express Delivery**: Premium for faster service
- **Saturday Delivery**: Weekend delivery fee

**Discounts:**
- **Volume Discount**: Percentage off for high-volume customers
- **Contract Rate**: Special pricing for contracted shippers

![Screenshot: Surcharges Configuration]
*Placeholder for screenshot showing surcharge setup*

---

## Calculating Freight Costs

### Automatic Calculation on Sales Orders

When **Enable Automatic Calculation** is active:

1. Create or open a **Sales Order**
2. Select **Ship-to Address** (determines freight zone)
3. Add items to order lines
4. System automatically:
   - Calculates total weight/volume
   - Determines freight zone from ship-to postal code
   - Finds matching freight price
   - Adds freight charge line to order

![Screenshot: Sales Order with Freight]
*Placeholder for screenshot showing sales order with auto-calculated freight*

### Manual Freight Calculation

If automatic calculation is disabled:

1. Open **Sales Order**
2. Click **Actions** → **Calculate Freight**
3. System prompts for:
   - **Shipping Agent**: Select carrier
   - **Override Zone**: Optionally specify zone
4. Click **OK**
5. Freight line is added to order

![Screenshot: Manual Freight Calculation]
*Placeholder for screenshot of manual freight calculation dialog*

### Reviewing Freight Details

To see how freight was calculated:

1. On the sales order, locate the freight charge line
2. Click **Line** → **Freight Calculation Details**
3. View breakdown:
   - Detected freight zone
   - Total weight/volume
   - Applied price bracket
   - Surcharges applied
   - Final freight amount

![Screenshot: Freight Calculation Details]
*Placeholder for screenshot showing detailed freight calculation*

### Overriding Freight Charges

To manually adjust freight:

1. Locate freight charge line on sales order
2. Edit **Unit Price** field directly
3. System marks line as "Manually Adjusted"
4. Manual adjustments persist on order

⚠️ **Note:** Re-running automatic calculation will overwrite manual changes.

---

## Troubleshooting

### Common Issues

#### Issue: "Freight Not Calculated"

**Possible Causes:**
- Automatic calculation disabled
- No freight zone matches ship-to address
- Shipping agent not configured
- Items missing weight/volume

**Solution:**
1. Verify **Freight Price Setup** → **Enable Automatic Calculation** is checked
2. Check ship-to postal code exists in a freight zone
3. Ensure freight prices exist for the zone and carrier
4. Verify items have weight in item card

#### Issue: "Freight Amount Seems Incorrect"

**Cause:** Wrong freight zone detected or outdated prices

**Solution:**
1. Check **Freight Calculation Details** to see which zone was used
2. Verify postal code is assigned to correct zone
3. Check freight price validity dates
4. Review weight/volume totals on order
5. Look for overlapping price brackets

#### Issue: "Multiple Zones Match Address"

**Cause:** Postal code appears in multiple freight zones

**Solution:**
- System uses zone with highest **Priority** (lowest number)
- Review zone priorities: **Freight Zones** → **Priority** field
- Adjust priorities so most specific zone wins
- Consider removing overlapping postal code ranges

#### Issue: "Surcharges Not Applied"

**Cause:** Surcharge conditions not met or misconfigured

**Solution:**
1. Verify surcharge setup in freight price card
2. Check if conditions are met (e.g., order value, weight threshold)
3. Review surcharge effective dates
4. Test with manual freight calculation

### Best Practices

✅ **Do:**
- Keep freight zones organized by region/distance
- Update freight prices when carriers change rates
- Set expiration dates when negotiating temporary rates
- Use weight brackets that match carrier pricing structure
- Test freight calculation on sample orders after setup

❌ **Don't:**
- Create overlapping zones without clear priorities
- Forget to set item weights (causes calculation failures)
- Use extremely wide weight brackets (makes pricing less accurate)
- Delete freight zones still in use by historical orders
- Ignore freight calculation errors on orders

### Maintaining Freight Prices

**Regular Maintenance Tasks:**

**Monthly:**
- Review freight cost accuracy vs actual carrier invoices
- Update fuel surcharge percentages
- Check for new postal code additions

**Quarterly:**
- Update freight prices based on carrier rate changes
- Review and adjust zone boundaries if needed
- Clean up expired price entries

**Annually:**
- Renegotiate carrier contracts and update rates
- Analyze freight cost trends by zone
- Optimize zone structure based on shipping patterns

---

## Support

For technical support or questions:
- **Issues**: [GitHub Issues](https://github.com/walter75-Consulting/Business-Central-Apps/issues)
- **Documentation**: [Main Documentation](freight-prices.md)

---

**Last Updated:** December 2025

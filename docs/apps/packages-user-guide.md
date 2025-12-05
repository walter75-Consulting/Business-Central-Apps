# walter75 - Packtisch (Packing Station)
## End-User Documentation

### Overview
The **walter75 - Packtisch** app is a comprehensive packing station solution for Microsoft Dynamics 365 Business Central. It streamlines warehouse operations by providing an intuitive barcode scanning interface for packing items from inventory pick orders into parcels for shipment.

This app integrates with:
- **walter75 - PrintNode**: For printing shipping labels
- **walter75 - SendCloud**: For shipping integration

---

## Table of Contents
1. [Getting Started](#getting-started)
2. [Setup](#setup)
3. [Packing Process](#packing-process)
4. [Features](#features)
5. [Troubleshooting](#troubleshooting)

---

## Getting Started

### What is the Packing Station?
The Packing Station is a digital workspace where warehouse staff can:
- Scan inventory pick orders
- Scan items to pack
- Create and manage parcels
- Print shipping labels, packing lists, and delivery notes
- Track which items have been packed

### Key Benefits
- ✅ **Scan-based workflow** - Reduce manual entry errors
- ✅ **Real-time tracking** - See what's packed and what's remaining
- ✅ **Multi-parcel support** - Split orders across multiple packages
- ✅ **Integrated printing** - Direct label and document printing
- ✅ **Package material tracking** - Record box dimensions and weights

---

## Setup

### 1. Package Setup
**Navigation:** Search for "Package Setup"

This is the main configuration page for the packing module. Currently, the setup page is minimal, with the primary setup focused on packing stations.

### 2. Package Materials
**Navigation:** Search for "Package Material List"

Define the packaging materials (boxes, envelopes, etc.) you use in your warehouse.

**Fields to configure:**
- **Code**: Unique identifier for the package material (e.g., "BOX-S", "BOX-M")
- **Description**: Name of the package material (e.g., "Small Box", "Medium Box")
- **Length cm**: Length in centimeters
- **Width cm**: Width in centimeters
- **Height cm**: Height in centimeters
- **Cubage cm³**: Automatically calculated volume
- **Weight kg**: Weight of the empty package material in kilograms

💡 **Tip:** Assign barcodes to your package materials for quick scanning during packing.

### 3. Packing Stations
**Navigation:** Search for "Packing Station List"

Configure physical packing stations in your warehouse.

**Fields to configure:**
- **Station ID**: Unique number for the station
- **Station Name**: Descriptive name (e.g., "Packing Station 1")
- **Label PrinterID**: Associated PrintNode printer for shipping labels
- **Package Material Usage**: Enable to require scanning of package materials
- **Use Scale**: Enable if station has a connected scale
- **Scale ID**: Identifier for the connected scale
- **Delivery Note per Parcel**: Print a delivery note for each parcel

**Status fields** (automatically managed):
- **Full User Name**: Current user at the station
- **Packing is Active**: Whether packing is in progress
- **Current Warehouse Activity**: Currently loaded pick order
- **Last Shipment No.**: Most recent shipment processed
- **Last Invoice No.**: Most recent invoice processed

---

## Packing Process

### Step 1: Start a Packing Session

1. Open the **Packing Station List**
2. Click on the **Station Name** you want to work at
3. The **Packing Card** opens

### Step 2: Scan the Pick Order

When the Packing Card opens, you'll see:
- **Display**: Shows current instruction
- **Input**: Where you scan barcodes
- **Pickorder section**: Shows current pick order details
- **Lines**: List of items to pack

**Action:** Scan the barcode on your inventory pick document

✅ The system will:
- Load all items from that pick order
- Display unpacked quantity and line count
- Prompt you to scan package material (if enabled)

### Step 3: Scan Package Material (Optional)

If your packing station requires package material tracking:

**Action:** Scan the barcode on your box or packaging material

✅ The system will:
- Record the package dimensions
- Record the package weight
- Move to the next step

### Step 4: Create a Parcel

Before packing items, you need to create a parcel:

**Action:** Click the **"New Package"** button in the ribbon

✅ The system will:
- Create a new parcel record
- Assign a parcel number
- Display it as the "Current Shipment Order No."

### Step 5: Scan Items

Now you're ready to pack items!

**Action:** Scan the barcode on an item

✅ The system will:
- Show a dialog asking for quantity
- Confirm the item and description
- Show the quantity to pack

**Enter the quantity** you're placing in the current parcel, then click OK.

✅ The system will:
- Update "SEW Qty. Packed" for that line
- Assign the parcel number to that line
- Update the weight
- Return focus to the scan input field

**Repeat** for each item in the parcel.

### Step 6: Complete the Parcel

When all items for one parcel are scanned:

**Options:**
- **Print Label**: Print shipping label via PrintNode
- **Print Packing List**: Print contents list
- **Print Delivery Note**: Print delivery documentation

### Step 7: Additional Parcels (If Needed)

If not all items fit in one parcel:

1. Click **"New Package"** again
2. Repeat scanning items for the second parcel
3. Continue until all items are packed

### Step 8: Post the Packing

When all items from the pick order are packed:

**Action:** Click **"Post Package"** in the ribbon

✅ The system will:
- Register all packed quantities
- Complete the warehouse activity
- Create shipment documentation

---

## Features

### Scanning Interface

The main **Packing Card** provides a streamlined scanning interface:

**Display Panel:**
- Shows current instructions (e.g., "Scan Document...", "Scan Item...")
- Shows error messages for invalid scans

**Input Field:**
- Always ready for the next scan
- Automatically clears after each scan
- Focus automatically returns here

**Current Status:**
- Current Shipment Order No.
- Current Shipment Order Status
- Current Package Material
- Current Item No.
- Last Scan timestamp

### Line Management

View all items in the pick order with:
- **Item No.** and **Description**
- **Lot No.** (if tracked)
- **SEW Qty. to Pack**: Total quantity to pack
- **SEW Qty. Packed**: Quantity already packed
- **SEW Parcel No.**: Which parcel contains this item
- **SEW Parcel Status**: Status of the associated parcel

**Visual Indicators:**
- Lines change color/style based on packing status

### Manual Operations

If scanning isn't available, you can use manual buttons:

- **Pack Selected Item**: Manually pack the selected line
- **Unpack Selected**: Remove items from a parcel
- **Move Up**: Reorder lines

### Package Management

- **New Package**: Create a new parcel
- **Delete Package**: Remove an empty parcel
- **Clear Package**: Remove all items from a parcel
- **Post Package**: Complete and register the packed order

### Printing Functions

**Navigation menu provides:**
- **Print Label**: Shipping label (requires PrintNode)
- **Print Packing List**: Contents of parcels
- **Print Delivery Note**: Delivery documentation
- **Print Invoice**: Associated invoice
- **Print Commands**: Quick reference guide

### FactBoxes

The right side shows additional information:
- **Parcel List**: All parcels created for this order
- **Details**: Line-specific details

### Quantities Display

At the top, you always see:
- **Unpacked Qty**: Total quantity still to pack
- **Unpacked Lines**: Number of lines still to pack

---

## Advanced Features

### Partial Packing

If a line has 10 items but you only pack 5 in one parcel:

1. Scan the item
2. Enter quantity **5**
3. The system automatically splits the line:
   - First line: 5 packed (assigned to current parcel)
   - Second line: 5 unpacked (available for next parcel)

### Weight Calculation

The system automatically calculates weight:
- Item weight × quantity
- Package material weight (if defined)
- Total parcel weight

### Scale Integration

If your packing station has a scale:
- Enable "use Scale" in Packing Station setup
- Enter the Scale ID
- System can read weight from the scale

---

## Workflow Summary

```
┌─────────────────────────────────────────┐
│ 1. Open Packing Station                │
├─────────────────────────────────────────┤
│ 2. Scan Pick Order Document             │
│    → System loads all lines             │
├─────────────────────────────────────────┤
│ 3. Scan Package Material (optional)     │
│    → System records box info            │
├─────────────────────────────────────────┤
│ 4. Click "New Package"                  │
│    → System creates parcel              │
├─────────────────────────────────────────┤
│ 5. Scan Items                           │
│    → Enter quantity                     │
│    → Repeat for all items in parcel     │
├─────────────────────────────────────────┤
│ 6. Print Label & Documents (optional)   │
├─────────────────────────────────────────┤
│ 7. More items? Create another package   │
│    → Repeat steps 4-6                   │
├─────────────────────────────────────────┤
│ 8. All items packed? Click "Post"       │
│    → Order complete!                    │
└─────────────────────────────────────────┘
```

---

## Troubleshooting

### Issue: "Invalid Scan" Message

**Cause:** The scanned barcode doesn't match expected format

**Solution:**
- Verify you're scanning the correct type of barcode
- Check the display to see what should be scanned next
- Ensure the pick order number series matches system configuration

### Issue: Item Not Found

**Cause:** Scanned item isn't on the current pick order

**Solution:**
- Verify the item is part of the loaded pick order
- Check if the pick order is fully loaded (refresh if needed)
- Ensure you're scanning the item barcode, not a lot number

### Issue: "Wrong Quantity" Error

**Cause:** Trying to pack more than available

**Solution:**
- Check the "SEW Qty. to Pack" field
- If multiple lines exist for the same item, pack other lines first
- Verify the quantity you entered

### Issue: Cannot Post Package

**Cause:** Not all items are packed, or other validation errors

**Solution:**
- Check "unpacked Qty" - must be zero
- Ensure all lines have a parcel assigned
- Verify all parcels are properly configured

### Issue: Printer Not Working

**Cause:** PrintNode integration not configured

**Solution:**
- Check PrintNode setup in the walter75 - PrintNode app
- Verify Packing Station has correct Label PrinterID
- Test the printer directly in PrintNode

---

## Tips & Best Practices

### 🎯 Efficiency Tips

1. **Use barcodes everywhere**: Items, pick orders, and package materials
2. **Pre-select package materials**: Have commonly used boxes pre-barcoded
3. **Complete one parcel at a time**: Don't mix items between parcels during scanning
4. **Use partial packing**: Split large orders into manageable parcels

### 📋 Quality Checks

1. **Verify quantities**: Always double-check the quantity dialog
2. **Check unpacked count**: Ensure it reaches zero before posting
3. **Review parcel list**: Use the FactBox to verify parcel contents
4. **Print packing lists**: Include in parcels for customer verification

### 🔧 Setup Recommendations

1. **Define all package materials**: Even if not scanning, helps with weight calculation
2. **Configure printers correctly**: Test before busy periods
3. **Train all users**: Ensure consistent process across stations
4. **Regular data checks**: Monitor posted shipments for accuracy

---

## Keyboard Shortcuts

- **Tab**: Move between fields (though focus auto-returns to scan input)
- **Enter**: Confirm dialogs
- **Esc**: Cancel dialogs

---

## Support & Contact

For technical support or questions about this app:
- **Website**: https://www.walter75.de
- **Publisher**: walter75 - München

For Business Central support, consult your system administrator or Microsoft partner.

---

## Version Information

- **App Name**: walter75 - Packtisch
- **Version**: 26.2.0.0
- **Platform**: Dynamics 365 Business Central
- **Target**: Cloud

---

## Related Apps

This app works with:
- **walter75 - PrintNode**: Label printing integration
- **walter75 - SendCloud**: Shipping carrier integration

Ensure these apps are installed and configured for full functionality.

---

*Document created: November 6, 2025*
*For: walter75 - Packtisch App*

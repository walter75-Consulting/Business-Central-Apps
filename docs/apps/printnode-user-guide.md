# walter75 - PrintNode
## User Guide

**Version:** 26.2.0  
**Publisher:** walter75 Consulting  
**Platform:** Microsoft Dynamics 365 Business Central Cloud

---

## Table of Contents

1. [Introduction](#introduction)
2. [PrintNode Account Setup](#printnode-account-setup)
3. [Connecting Business Central to PrintNode](#connecting-business-central-to-printnode)
4. [Printer Configuration](#printer-configuration)
5. [Printing Documents](#printing-documents)
6. [Troubleshooting](#troubleshooting)

---

## Introduction

The **walter75 - PrintNode** extension integrates Microsoft Dynamics 365 Business Central with PrintNode cloud printing service, enabling direct printing to thermal printers, label printers, and standard printers from Business Central without local printer drivers.

### Key Features

- 🖨️ **Cloud Printing**: Print from anywhere to any connected printer
- 🏷️ **Label Printers**: Full support for Zebra, Dymo, and other thermal printers
- 📄 **Document Printing**: Reports, invoices, packing lists, delivery notes
- 🌐 **Remote Printing**: Print to printers in different locations
- 🔄 **Auto-Scale**: Automatic printer selection and scaling
- 📊 **Print Queue Management**: Track and manage print jobs
- ⚡ **Fast Setup**: No printer drivers needed on client machines

### Prerequisites

- **PrintNode Account**: Sign up at [www.printnode.com](https://www.printnode.com)
- **PrintNode Client**: Installed on computer(s) connected to printers
- **API Key**: Generated from PrintNode dashboard

---

## PrintNode Account Setup

### Step 1: Create PrintNode Account

1. Visit [www.printnode.com](https://www.printnode.com)
2. Click **"Sign Up"** or **"Start Free Trial"**
3. Complete registration with email and password
4. Verify your email address

![Screenshot: PrintNode Registration]
*Placeholder for screenshot of PrintNode signup page*

### Step 2: Install PrintNode Client Software

**On Windows:**
1. Download PrintNode Client from [www.printnode.com/download](https://www.printnode.com/download)
2. Run installer (PrintNodeSetup.exe)
3. Complete installation wizard
4. Client runs in system tray

**On Mac:**
1. Download Mac version of PrintNode Client
2. Open DMG file and drag to Applications
3. Launch PrintNode from Applications folder

**On Linux:**
1. Download Linux client or use Docker container
2. Follow installation instructions for your distribution

![Screenshot: PrintNode Client System Tray]
*Placeholder for screenshot showing PrintNode client in Windows system tray*

### Step 3: Login to PrintNode Client

1. **Right-click** PrintNode icon in system tray
2. Select **"Sign In"**
3. Enter your PrintNode credentials
4. Client connects to PrintNode cloud
5. Icon turns green when connected

![Screenshot: PrintNode Client Login]
*Placeholder for screenshot of PrintNode client login window*

### Step 4: Verify Printer Detection

1. Right-click PrintNode icon → **"Open Dashboard"**
2. Browser opens to PrintNode web dashboard
3. Navigate to **"Printers"** tab
4. Verify your printers are listed and online

![Screenshot: PrintNode Dashboard Printers]
*Placeholder for screenshot of PrintNode dashboard showing detected printers*

**Printer Status Indicators:**
- 🟢 **Green**: Printer online and ready
- 🔴 **Red**: Printer offline or error
- 🟡 **Yellow**: Printer busy

### Step 5: Generate API Key

1. In PrintNode dashboard, go to **"Account"** → **"API Keys"**
2. Click **"Create API Key"**
3. Enter description: "Business Central Integration"
4. Click **"Create"**
5. **Copy the API Key** (shown only once!)
6. Store securely - you'll need this for Business Central

![Screenshot: PrintNode API Key Generation]
*Placeholder for screenshot showing API key creation in PrintNode dashboard*

⚠️ **Security Note:** Treat API keys like passwords. Never share them publicly.

---

## Connecting Business Central to PrintNode

### Step 1: Open PrintNode Setup

1. In Business Central, search for **"PrintNode Setup"**
2. Click to open setup page

![Screenshot: PrintNode Setup Page]
*Placeholder for screenshot of PrintNode Setup in Business Central*

### Step 2: Enter API Credentials

**Required Fields:**
- **API Key**: Paste the API key from PrintNode dashboard
- **API URL**: Leave default `https://api.printnode.com` (unless using private server)
- **Enable PrintNode**: Check this box to activate integration

![Screenshot: API Key Entry]
*Placeholder for screenshot showing API key field in BC*

### Step 3: Test Connection

1. Click **Actions** → **"Test Connection"**
2. System attempts to connect to PrintNode API
3. Success message confirms connection
4. Failure shows error details

![Screenshot: Test Connection Success]
*Placeholder for screenshot of successful connection test*

**Common Test Failures:**
- **Invalid API Key**: Double-check copied key
- **Network Error**: Check firewall/proxy settings
- **API URL Wrong**: Verify URL is correct

---

## Printer Configuration

### Step 1: Sync Printers from PrintNode

1. In **PrintNode Setup**, click **Actions** → **"Sync Printers"**
2. System retrieves all printers from your PrintNode account
3. Printers are imported into Business Central

![Screenshot: Sync Printers Action]
*Placeholder for screenshot of sync printers button*

### Step 2: View PrintNode Printers

1. Search for **"PrintNode Printers"** in Business Central
2. See list of all synced printers
3. View printer details:
   - **Printer ID**: PrintNode identifier
   - **Printer Name**: Name from Windows/Mac
   - **Computer Name**: Which computer printer is connected to
   - **Status**: Online/Offline
   - **Capabilities**: Supported paper sizes, color, etc.

![Screenshot: PrintNode Printers List]
*Placeholder for screenshot of printer list in Business Central*

### Step 3: Configure Default Printers

Assign printers for specific document types:

1. In **PrintNode Setup**, navigate to **Printer Mappings**
2. Create mappings for each document type:

**Example Mappings:**

| Document Type | Report ID | PrintNode Printer | Paper Size |
|---------------|-----------|-------------------|------------|
| Shipping Label | 50100 | Zebra-ZP450 | 4x6 |
| Packing List | 50101 | HP-LaserJet | A4 |
| Delivery Note | 50102 | HP-LaserJet | A4 |
| Invoice | 1306 | HP-LaserJet | A4 |

![Screenshot: Printer Mappings]
*Placeholder for screenshot of printer mapping configuration*

### Step 4: Configure Printer Options

For each printer, set specific options:

1. Open **PrintNode Printer Card**
2. Configure:
   - **Default Paper Size**: Letter, A4, 4x6, etc.
   - **Default Orientation**: Portrait or Landscape
   - **Color Mode**: Color, Grayscale, Black & White
   - **Duplex**: Single-sided or Double-sided
   - **Copies**: Default number of copies

![Screenshot: Printer Options]
*Placeholder for screenshot showing printer-specific options*

### Step 5: Location-Specific Printers

Assign printers to specific warehouse locations:

1. Search for **"Locations"**
2. Open a location card
3. In **Warehouse** FastTab, find:
   - **Label Printer**: PrintNode printer for shipping labels
   - **Document Printer**: PrintNode printer for documents
   - **Receipt Printer**: PrintNode printer for receipts

![Screenshot: Location Printer Assignment]
*Placeholder for screenshot of location-specific printer fields*

---

## Printing Documents

### Method 1: Automatic Printing

When integrated with other walter75 apps (e.g., Packages):

1. System automatically selects appropriate printer
2. Document is sent to PrintNode
3. Printer receives job and prints
4. No user interaction required

![Screenshot: Automatic Print Process]
*Placeholder for screenshot showing automatic printing indicator*

### Method 2: Manual Report Printing

To print reports manually:

1. Navigate to the report (e.g., Sales Invoice)
2. Click **"Print"** or **"Send To"** → **"PrintNode"**
3. Select document
4. Choose printer from PrintNode printer list
5. Adjust options (copies, paper size)
6. Click **"Print"**

![Screenshot: Print Dialog]
*Placeholder for screenshot of PrintNode print dialog*

### Method 3: Batch Printing

Print multiple documents at once:

1. Open document list (e.g., Posted Sales Invoices)
2. Select multiple documents (Ctrl+Click)
3. Click **Actions** → **"Print via PrintNode"**
4. Choose printer
5. All selected documents print sequentially

![Screenshot: Batch Print Selection]
*Placeholder for screenshot showing multiple document selection*

### Monitoring Print Jobs

Track print job status:

1. Search for **"PrintNode Print Jobs"**
2. View all print jobs with status:
   - 🟡 **Queued**: Waiting to print
   - 🔵 **Processing**: Being sent to printer
   - 🟢 **Printed**: Successfully completed
   - 🔴 **Failed**: Error occurred

![Screenshot: Print Jobs List]
*Placeholder for screenshot of print jobs list*

### Print Job Details

For detailed information:

1. Open a print job entry
2. View:
   - **Document Type**: What was printed
   - **Printer Used**: Which printer
   - **Timestamp**: When job was sent
   - **Status**: Current state
   - **Error Message**: If failed, why
   - **Pages Printed**: Number of pages
   - **File Size**: Size of print job

![Screenshot: Print Job Details]
*Placeholder for screenshot showing detailed print job information*

---

## Troubleshooting

### Common Issues

#### Issue: "Printer Offline"

**Possible Causes:**
- Printer powered off
- PrintNode Client not running
- Computer disconnected from network
- Printer USB cable unplugged

**Solution:**
1. Check printer power and connection
2. Verify PrintNode Client is running (system tray icon)
3. Check printer status in PrintNode dashboard
4. Restart printer if necessary
5. In BC, run **"Sync Printers"** to update status

#### Issue: "Print Job Stuck in Queue"

**Cause:** PrintNode Client or printer driver issue

**Solution:**
1. In PrintNode dashboard, check job status
2. Cancel stuck job from dashboard
3. Restart PrintNode Client:
   - Right-click system tray icon → Exit
   - Restart PrintNode Client
4. Clear printer queue on computer
5. Retry print job from Business Central

#### Issue: "Labels Printing at Wrong Size"

**Cause:** Paper size mismatch or scaling issue

**Solution:**
1. Verify printer paper size setting in **PrintNode Printer Card**
2. Check actual label size loaded in printer
3. Adjust report page size in report designer
4. Enable/disable auto-scaling in printer options
5. Test print from PrintNode dashboard to verify printer setup

#### Issue: "API Connection Failed"

**Cause:** Invalid API key, network issue, or firewall blocking

**Solution:**
1. Verify API key in **PrintNode Setup**
2. Test connection: **Actions** → **"Test Connection"**
3. Check firewall allows HTTPS to api.printnode.com
4. Verify internet connectivity
5. Try generating new API key if old one expired

#### Issue: "Wrong Printer Selected"

**Cause:** Printer mapping not configured or location not set

**Solution:**
1. Check **Printer Mappings** in **PrintNode Setup**
2. Verify correct printer assigned for document type
3. If location-based, ensure document has location code
4. Review printer selection logic in custom code
5. Manually select printer when prompted

### Best Practices

✅ **Do:**
- Keep PrintNode Client running at all times
- Regularly sync printers to update status
- Test printer configurations after changes
- Monitor print job history for failures
- Use descriptive printer names
- Set up location-specific printers for multiple warehouses

❌ **Don't:**
- Share API keys across multiple BC environments without separate PrintNode accounts
- Delete printers from PrintNode while they're in use
- Ignore failed print jobs
- Use generic printer names (hard to identify)
- Forget to restart PrintNode Client after Windows updates

### Maintenance Tasks

**Daily:**
- Check printer status (online/offline)
- Review failed print jobs
- Clear paper jams/refill labels

**Weekly:**
- Review print job history
- Update printer mappings if needed
- Test backup printers

**Monthly:**
- Clean thermal printer heads
- Update PrintNode Client software
- Review API usage (PrintNode dashboard)
- Verify all printers still in use

---

## Support

For technical support or questions:
- **PrintNode Support**: [support.printnode.com](https://support.printnode.com)
- **BC Integration Issues**: [GitHub Issues](https://github.com/walter75-Consulting/Business-Central-Apps/issues)
- **Documentation**: [Main Documentation](printnode.md)

---

**Last Updated:** December 2025

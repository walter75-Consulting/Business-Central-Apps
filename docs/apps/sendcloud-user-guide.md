# walter75 - Sendcloud
## User Guide

**Version:** 26.2.0  
**Publisher:** walter75 Consulting  
**Platform:** Microsoft Dynamics 365 Business Central Cloud

---

## Table of Contents

1. [Introduction](#introduction)
2. [SendCloud Account Setup](#sendcloud-account-setup)
3. [Connecting Business Central](#connecting-business-central)
4. [Shipping Configuration](#shipping-configuration)
5. [Creating Shipments](#creating-shipments)
6. [Printing Labels](#printing-labels)
7. [Tracking Shipments](#tracking-shipments)
8. [Troubleshooting](#troubleshooting)

---

## Introduction

The **walter75 - Sendcloud** extension integrates Microsoft Dynamics 365 Business Central with SendCloud shipping platform, providing access to 80+ carriers for automated label creation, tracking, and returns management.

### Key Features

-  **80+ Carriers**: DHL, UPS, FedEx, DPD, Hermes, GLS, and more
-  **Auto Labels**: Generate shipping labels directly from sales orders
-  **Smart Carrier Selection**: Automatic best carrier based on rules
-  **Real-time Tracking**: Track all shipments from Business Central
-  **Rate Shopping**: Compare carrier rates before shipping
-  **Customs Documents**: Automatic customs forms for international shipping
-  **Returns Portal**: Customer self-service returns

### Prerequisites

- **SendCloud Account**: Sign up at [www.sendcloud.com](https://www.sendcloud.com)
- **Carrier Contracts**: Activated in SendCloud dashboard
- **API Credentials**: Public and Secret keys from SendCloud

---

## SendCloud Account Setup

### Step 1: Create SendCloud Account

1. Visit [www.sendcloud.com](https://www.sendcloud.com)
2. Click **"Sign Up"** or **"Start Free"**
3. Choose your country and business type
4. Complete registration
5. Verify email address
6. Login to SendCloud dashboard

![Screenshot: SendCloud Registration]
*Placeholder for screenshot of SendCloud signup*

### Step 2: Activate Shipping Carriers

1. In SendCloud dashboard, go to **"Settings"**  **"Carriers"**
2. Browse available carriers for your country
3. Click **"Connect"** on carriers you want to use
4. For contract carriers:
   - Enter your carrier account number
   - Provide contract details
5. For SendCloud carriers:
   - Activate directly (no contract needed)
   - May require credit deposit

![Screenshot: SendCloud Carrier Activation]
*Placeholder for screenshot showing carrier connection*

**Popular Carriers:**
- **DHL**: Express and parcel services
- **UPS**: International shipping
- **DPD**: European delivery
- **Hermes**: Budget-friendly parcel
- **PostNL**: Netherlands postal service
- **GLS**: General Logistics Systems

### Step 3: Configure Shipping Products

1. Navigate to **"Settings"**  **"Shipping Products"**
2. Enable products for each carrier:
   - Standard Parcel
   - Express Delivery
   - International Shipping
   - Return Shipping
3. Set default services (signature, insurance, etc.)

![Screenshot: Shipping Products]
*Placeholder for screenshot of shipping product configuration*

### Step 4: Generate API Keys

1. Go to **"Settings"**  **"Integrations"**
2. Click **"API"** section
3. Find **Public Key** and **Secret Key**
4. Click **"Show"** to reveal keys
5. Copy both keys securely

![Screenshot: SendCloud API Keys]
*Placeholder for screenshot of API key location*

 **Security**: Store keys securely - they provide full access to your SendCloud account.

---

## Connecting Business Central

### Step 1: Open SendCloud Setup

1. In Business Central, search for **"SendCloud Setup"**
2. Click to open configuration page

![Screenshot: SendCloud Setup BC]
*Placeholder for screenshot of SendCloud Setup page*

### Step 2: Enter API Credentials

**Required Fields:**
- **Public Key**: Paste from SendCloud dashboard
- **Secret Key**: Paste from SendCloud dashboard
- **Enable SendCloud**: Check to activate integration
- **Default Language**: Select for shipping labels (EN, DE, NL, etc.)

![Screenshot: API Credential Entry]
*Placeholder for screenshot showing credential fields*

### Step 3: Configure General Settings

**Shipment Settings:**
- **Auto-Create Shipments**: Automatically create on order ship
- **Default Parcel Weight (kg)**: Fallback if items have no weight
- **Default Parcel Dimensions**: Length x Width x Height (cm)
- **Sender Address**: Your warehouse return address

![Screenshot: General Settings]
*Placeholder for screenshot of general shipment settings*

### Step 4: Test Connection

1. Click **Actions**  **"Test Connection"**
2. System verifies API credentials
3. Success message confirms SendCloud is reachable
4. System syncs available carriers

![Screenshot: Test Connection Success]
*Placeholder for screenshot of successful connection*

---

## Shipping Configuration

### Step 1: Sync Carriers

1. In **SendCloud Setup**, click **Actions**  **"Sync Carriers"**
2. System retrieves all activated carriers from SendCloud
3. Carriers imported into **SendCloud Carriers** list

![Screenshot: Sync Carriers]
*Placeholder for screenshot of carrier sync process*

### Step 2: View and Configure Carriers

1. Search for **"SendCloud Carriers"**
2. See list of available carriers with:
   - Carrier name and logo
   - Available shipping products
   - Service levels
   - Price estimates

![Screenshot: SendCloud Carriers List]
*Placeholder for screenshot of carriers in BC*

### Step 3: Set Up Shipping Rules

Configure automatic carrier selection:

1. Go to **"SendCloud Shipping Rules"**
2. Create rules based on:
   - **Destination Country**: Different carriers per region
   - **Order Weight**: Light vs heavy parcels
   - **Order Value**: Insurance requirements
   - **Service Level**: Economy, Standard, Express
   - **Customer Preference**: VIP customers get premium shipping

**Example Rules:**

| Priority | Country | Max Weight | Carrier | Product |
|----------|---------|------------|---------|---------|
| 1 | DE | 31.5 kg | DHL | Standard Parcel |
| 2 | AT, CH | 20 kg | DPD | Classic |
| 3 | FR, BE, NL | 30 kg | GLS | Business Parcel |
| 4 | * | 30 kg | DHL | Europlus |

![Screenshot: Shipping Rules]
*Placeholder for screenshot of shipping rule configuration*

### Step 4: Configure Label Printing

**Print Settings:**
- **Label Format**: A4, A6, or thermal 4x6
- **Auto-Print on Create**: Print immediately after shipment creation
- **Printer Selection**: Use PrintNode integration or browser print
- **Print Quantity**: Number of label copies

![Screenshot: Label Print Settings]
*Placeholder for screenshot of label printing configuration*

---

## Creating Shipments

### Method 1: Automatic Creation from Sales Order

When **Auto-Create Shipments** is enabled:

1. Post Sales Order with **Ship** or **Ship and Invoice**
2. System automatically:
   - Creates SendCloud shipment
   - Selects carrier based on rules
   - Generates shipping label
   - Updates order with tracking number

![Screenshot: Auto Shipment Creation]
*Placeholder for screenshot showing automatic shipment indicator*

### Method 2: Manual Shipment Creation

1. Open **Posted Sales Shipment**
2. Click **Actions**  **"Create SendCloud Shipment"**
3. Shipment creation dialog appears:
   - **Carrier**: Auto-selected or choose manually
   - **Shipping Product**: Select service level
   - **Parcel Weight**: Auto-calculated or override
   - **Insurance**: Add if needed
   - **Signature Required**: Check if needed
4. Click **"Create"**

![Screenshot: Manual Shipment Dialog]
*Placeholder for screenshot of manual shipment creation*

### Method 3: Batch Shipment Creation

Process multiple orders at once:

1. Go to **Posted Sales Shipments** list
2. Filter unshipped orders
3. Select multiple shipments (Ctrl+Click)
4. Click **Actions**  **"Bulk Create SendCloud Shipments"**
5. Confirm carrier and service level
6. System processes all selected shipments

![Screenshot: Batch Shipment Creation]
*Placeholder for screenshot showing bulk shipment processing*

---

## Printing Labels

### Single Label Printing

1. Open **Posted Sales Shipment** with SendCloud shipment
2. Click **Actions**  **"Print Shipping Label"**
3. Label downloads or prints automatically
4. Affix label to parcel

![Screenshot: Print Label Action]
*Placeholder for screenshot of print label button*

### Batch Label Printing

1. Go to **SendCloud Shipments** list
2. Filter by **Status**: "Label Created"
3. Select shipments to print
4. Click **Actions**  **"Print Labels (Batch)"**
5. All labels download as single PDF or print sequentially

![Screenshot: Batch Label Printing]
*Placeholder for screenshot of batch label print*

### Label Formats

**A4 Format** (4 labels per sheet):
- Standard office printer
- Multiple shipments per page
- Requires cutting

**A6 Format** (single label):
- Half of A4
- One shipment per page

**Thermal 4x6**:
- Direct thermal printer
- Zebra, Dymo compatibility
- No cutting needed

![Screenshot: Label Format Selection]
*Placeholder for screenshot showing label format options*

---

## Tracking Shipments

### Viewing Tracking Information

1. Open **Posted Sales Shipment**
2. SendCloud FastTab shows:
   - **Tracking Number**: Carrier tracking code
   - **Tracking URL**: Direct link to carrier tracking
   - **Current Status**: In transit, delivered, etc.
   - **Estimated Delivery**: Expected delivery date

![Screenshot: Tracking Info on Shipment]
*Placeholder for screenshot showing tracking information*

### SendCloud Shipments List

1. Search for **"SendCloud Shipments"**
2. View all shipments with status:
   -  **Created**: Shipment created, label not yet generated
   -  **Label Created**: Ready to ship
   -  **In Transit**: Picked up by carrier
   -  **Delivered**: Successfully delivered
   -  **Exception**: Delivery issue

![Screenshot: Shipments Status List]
*Placeholder for screenshot of shipments list with statuses*

### Track & Trace Portal

Share tracking with customers:

1. SendCloud generates Track & Trace URL
2. URL can be:
   - Emailed to customer automatically
   - Added to shipment confirmation
   - Published on customer portal
3. Customers see real-time tracking updates

![Screenshot: Track & Trace Portal]
*Placeholder for screenshot of customer tracking portal*

---

## Troubleshooting

### Common Issues

#### Issue: "Carrier Not Available"

**Cause:** Carrier not activated in SendCloud or not synced

**Solution:**
1. Login to SendCloud dashboard
2. Verify carrier is connected in **Settings**  **Carriers**
3. In BC, run **"Sync Carriers"** action
4. Check shipping rules don't exclude carrier

#### Issue: "Shipment Creation Failed"

**Possible Causes:**
- Missing ship-to address
- Invalid postal code format
- Weight exceeds carrier limit
- API credentials expired

**Solution:**
1. Check error message in **SendCloud Log**
2. Verify ship-to address is complete
3. Confirm postal code format (no spaces for some countries)
4. Check parcel weight is within carrier limits
5. Test API connection in **SendCloud Setup**

#### Issue: "Tracking Number Not Updated"

**Cause:** Sync delay or webhook not configured

**Solution:**
1. Click **Actions**  **"Update Tracking Status"** on shipment
2. Verify webhooks enabled in SendCloud dashboard
3. Check **SendCloud Log** for sync errors
4. Manually run **"Sync All Shipments"** in setup

#### Issue: "Label Won't Print"

**Cause:** Format mismatch or printer issue

**Solution:**
1. Verify label format matches your printer
2. Try different format (A6 instead of thermal)
3. Download label as PDF and print manually
4. Check PrintNode printer status if integrated
5. Clear browser print queue

### Best Practices

 **Do:**
- Keep API credentials secure
- Sync carriers weekly to get new services
- Monitor failed shipments daily
- Use shipping rules for consistency
- Test label printing after setup changes
- Review SendCloud invoices monthly

 **Don't:**
- Create shipments without valid addresses
- Ignore delivery exceptions
- Use outdated carrier accounts
- Forget to weigh parcels accurately
- Delete shipments with active tracking

---

## Support

For technical support:
- **SendCloud Support**: [support.sendcloud.com](https://support.sendcloud.com)
- **BC Integration**: [GitHub Issues](https://github.com/walter75-Consulting/Business-Central-Apps/issues)
- **Documentation**: [Main Documentation](sendcloud.md)

---

**Last Updated:** December 2025

# walter75 - XML Import
## User Guide

**Version:** 26.2.0  
**Publisher:** walter75 Consulting  
**Platform:** Microsoft Dynamics 365 Business Central Cloud

---

## Table of Contents

1. [Introduction](#introduction)
2. [Setup](#setup)
3. [Creating Import Definitions](#creating-import-definitions)
4. [Field Mapping](#field-mapping)
5. [Running Imports](#running-imports)
6. [Validation and Error Handling](#validation-and-error-handling)
7. [Troubleshooting](#troubleshooting)

---

## Introduction

The **walter75 - XML Import** extension provides flexible XML data import functionality for Microsoft Dynamics 365 Business Central. Import data from external systems, legacy databases, and EDI partners using configurable field mapping and validation rules.

### Key Features

- 📄 **XML Parsing**: Import any well-formed XML structure
- 🗺️ **Field Mapping**: Visual drag-and-drop field mapping
- ✅ **Validation Rules**: Pre-import data validation
- 🔄 **Transformation**: Convert data formats during import
- 🚨 **Error Handling**: Detailed error logs with row-level tracking
- 📊 **Batch Processing**: Import large files efficiently
- 🔄 **Scheduled Imports**: Automate recurring imports
- 📝 **Import History**: Audit trail of all imports

### Common Use Cases

- **EDI Data**: Electronic Data Interchange from partners
- **Legacy System Migration**: One-time data import from old systems
- **Third-Party Integration**: Regular data feeds from external systems
- **Product Catalogs**: Import product data from suppliers
- **Price Lists**: Update pricing from external sources
- **Customer Data**: Import contacts and customer information

---

## Setup

### Step 1: XML Import Setup

1. Search for **"XML Import Setup"**
2. Configure general settings:
   - **Default Error Handling**: Skip Row, Stop Import, or Ask User
   - **Batch Size**: Records per batch (affects performance)
   - **Archive Imported Files**: Keep copies of processed files
   - **Archive Path**: Where to store archived XML files
   - **Enable Logging**: Detailed import logging (recommended)

![Screenshot: XML Import Setup]
*Placeholder for screenshot of setup page*

### Step 2: Import File Locations

Configure where to find XML files:

**Option 1: File System**
- **Import Folder**: Local or network path
- System monitors folder for new XML files

**Option 2: FTP/SFTP**
- **Server**: FTP server address
- **Username/Password**: Credentials
- **Remote Path**: Folder on FTP server

**Option 3: Web Service**
- **Endpoint URL**: REST or SOAP service
- **Authentication**: API key or OAuth

![Screenshot: File Location Setup]
*Placeholder for screenshot showing file source configuration*

---

## Creating Import Definitions

### Step 1: New Import Definition

1. Search for **"XML Import Definitions"**
2. Click **+ New**
3. Enter basic information:
   - **Code**: Unique identifier (e.g., "SUPP-PROD", "EDI-ORDER")
   - **Description**: What this import does
   - **Source Type**: File, FTP, Web Service
   - **Target Table**: BC table to import into (e.g., Item, Customer, Sales Order)

![Screenshot: Import Definition Card]
*Placeholder for screenshot of import definition*

### Step 2: Upload Sample XML

1. Click **"Upload Sample XML"**
2. Select sample file representing structure
3. System parses XML and shows:
   - Root element
   - Child elements
   - Attributes
   - Data structure

![Screenshot: XML Structure Viewer]
*Placeholder for screenshot of parsed XML structure*

### Step 3: Define XML Path

Specify where data is in XML:

**Example XML Structure:**
```xml
<Products>
  <Product>
    <ItemNo>1000</ItemNo>
    <Description>Widget A</Description>
    <Price>19.99</Price>
  </Product>
  <Product>
    <ItemNo>1001</ItemNo>
    <Description>Widget B</Description>
    <Price>29.99</Price>
  </Product>
</Products>
```

**Configuration:**
- **Root Element**: `Products`
- **Record Element**: `Product` (each Product = one BC record)
- **XPath**: `/Products/Product` (optional, for complex structures)

![Screenshot: XML Path Configuration]
*Placeholder for screenshot showing XPath setup*

---

## Field Mapping

### Step 1: Open Field Mapper

1. From **Import Definition**, click **"Field Mapping"**
2. Left panel shows:
   - **Source**: XML elements/attributes
3. Right panel shows:
   - **Target**: BC table fields

![Screenshot: Field Mapper Interface]
*Placeholder for screenshot of mapping interface*

### Step 2: Map Fields

Create mappings between XML and BC:

**Method 1: Drag and Drop**
1. Drag XML element from left
2. Drop on BC field on right
3. Mapping line created automatically

**Method 2: Manual Entry**
1. Click **+ New Mapping Line**
2. **Source Field**: Select or enter XML element name
3. **Target Field**: Select BC table field
4. **Required**: Check if field must have value

![Screenshot: Field Mapping Lines]
*Placeholder for screenshot of mapping lines table*

### Step 3: Configure Transformations

Apply data transformations during import:

**Common Transformations:**

| Transformation | Purpose | Example |
|----------------|---------|---------|
| **Trim** | Remove spaces | " ABC " → "ABC" |
| **Uppercase** | Convert to capitals | "abc" → "ABC" |
| **Lowercase** | Convert to lowercase | "ABC" → "abc" |
| **Date Format** | Convert date format | "01/15/2025" → "2025-01-15" |
| **Number Format** | Handle decimal separators | "1.234,56" → "1234.56" |
| **Prefix/Suffix** | Add text | "123" → "CUST-123" |
| **Lookup** | Replace values | "Y" → TRUE |
| **Calculate** | Math operations | Quantity * Price |

**Example Mapping with Transformation:**

| XML Element | Transformation | BC Field | Notes |
|-------------|----------------|----------|-------|
| ItemNo | Trim, Uppercase | No. | Remove spaces, capitalize |
| Description | Trim | Description | |
| Price | Number Format (EU) | Unit Price | Convert comma to decimal |
| Active | Lookup (Y=TRUE, N=FALSE) | Blocked | Convert Y/N to boolean |

![Screenshot: Transformation Rules]
*Placeholder for screenshot of transformation configuration*

### Step 4: Default Values

Set defaults for missing data:

1. For each mapping line, specify **Default Value**
2. If XML element is empty/missing, use default
3. Examples:
   - **Gen. Prod. Posting Group**: "RETAIL"
   - **VAT Prod. Posting Group**: "STANDARD"
   - **Inventory Posting Group**: "RESALE"

![Screenshot: Default Values]
*Placeholder for screenshot showing default value setup*

### Step 5: Conditional Mapping

Apply different rules based on data:

**Example:**
- **IF** `<Type>` = "PRODUCT" **THEN** import to **Item** table
- **IF** `<Type>` = "SERVICE" **THEN** import to **Resource** table

1. Click **"Add Condition"**
2. Define:
   - **Source Field**: Field to evaluate
   - **Operator**: Equals, Contains, Greater Than, etc.
   - **Value**: Comparison value
   - **Action**: Use Different Mapping, Skip Row, or Set Value

![Screenshot: Conditional Mapping]
*Placeholder for screenshot of conditional mapping rules*

---

## Running Imports

### Method 1: Manual Import

1. Go to **XML Import Definitions**
2. Select import definition
3. Click **Actions** → **"Run Import"**
4. Select XML file to import
5. Click **"Start Import"**

![Screenshot: Manual Import Dialog]
*Placeholder for screenshot of import start dialog*

### Method 2: Batch Import (Folder Monitor)

Set up automatic imports:

1. Configure **Import Folder** in setup
2. Enable **Auto-Import** on import definition
3. System monitors folder every X minutes
4. New XML files are processed automatically
5. Files moved to archive or deleted after import

![Screenshot: Folder Monitor Settings]
*Placeholder for screenshot of folder monitoring setup*

### Method 3: Scheduled Import

Use job queue for recurring imports:

1. Search for **"Job Queue Entries"**
2. Create new entry:
   - **Object Type**: Codeunit
   - **Object ID**: XML Import Codeunit
   - **Parameter**: Import Definition Code
   - **Recurring**: Enable
   - **Frequency**: Daily, Hourly, etc.
3. System runs import on schedule

![Screenshot: Job Queue Entry]
*Placeholder for screenshot of scheduled job configuration*

### Import Progress

During import, monitor:

1. **Progress Bar**: Percentage complete
2. **Records Processed**: Count of rows imported
3. **Errors**: Number of failed rows
4. **Time Elapsed**: Import duration
5. **Estimated Time Remaining**

![Screenshot: Import Progress]
*Placeholder for screenshot of import progress indicator*

---

## Validation and Error Handling

### Pre-Import Validation

Before importing, system validates:

1. **XML Structure**: Well-formed XML
2. **Required Fields**: All mandatory fields present
3. **Data Types**: Text, numbers, dates in correct format
4. **Field Length**: Values don't exceed field size
5. **Custom Rules**: Business logic validation

![Screenshot: Validation Results]
*Placeholder for screenshot of pre-import validation*

### Error Handling Options

When error occurs:

**Skip Row (Default):**
- Logs error
- Continues with next row
- Summary shows errors at end

**Stop Import:**
- Halts immediately on first error
- No data committed to database
- Review and fix XML, retry

**Ask User:**
- Prompts for decision per error
- Skip, Retry, or Stop
- Useful for one-time imports

![Screenshot: Error Handling Dialog]
*Placeholder for screenshot of error handling options*

### Import Log

Review import results:

1. Search for **"XML Import Log"**
2. Filter by:
   - Import definition
   - Date range
   - Status (Success, Partial, Failed)
3. View:
   - Total records
   - Successful imports
   - Failed records
   - Error messages

![Screenshot: Import Log List]
*Placeholder for screenshot of import log*

### Error Details

For failed imports:

1. Open **Import Log Entry**
2. Navigate to **Error Lines**
3. See each failed row with:
   - **Row Number**: Position in XML
   - **Field**: Which field caused error
   - **Value**: What was in XML
   - **Error Message**: Why it failed
   - **XML Snippet**: Context of error

![Screenshot: Error Details]
*Placeholder for screenshot of detailed error view*

### Fixing and Re-importing

After fixing errors:

1. Correct XML file
2. Use **"Re-import Failed Records"** action
3. System retries only failed rows
4. New errors logged separately

---

## Troubleshooting

### Common Issues

#### Issue: "XML File Not Found"

**Cause:** File path incorrect or permission issue

**Solution:**
1. Verify file path in import definition
2. Check file exists at specified location
3. Ensure BC service account has read permissions
4. For network paths, verify UNC path is accessible
5. Check firewall rules for FTP/web service

#### Issue: "Invalid XML Structure"

**Cause:** Malformed XML or encoding issues

**Solution:**
1. Open XML in text editor to verify structure
2. Check for:
   - Missing closing tags
   - Unescaped special characters (`<`, `>`, `&`)
   - Encoding declaration (UTF-8 recommended)
3. Validate XML using online validator
4. Compare to sample XML used in mapping

#### Issue: "Field Mapping Error"

**Cause:** Source field name changed or doesn't exist

**Solution:**
1. Re-upload sample XML to refresh structure
2. Verify XML element names match mapping
3. Check for case sensitivity (XML is case-sensitive)
4. Review XPath expression if used
5. Test mapping with small sample file

#### Issue: "Data Validation Failed"

**Cause:** Data doesn't meet BC table requirements

**Solution:**
1. Check error log for specific validation message
2. Common issues:
   - Required field missing (e.g., Gen. Prod. Posting Group)
   - Value too long for field
   - Invalid data type (text in number field)
   - Duplicate key (item already exists)
3. Add transformation or default value
4. Adjust validation rules if too strict

#### Issue: "Import Performance Slow"

**Cause:** Large file or complex transformations

**Solution:**
1. Increase **Batch Size** in setup (e.g., 100 → 500)
2. Disable detailed logging temporarily
3. Run import during off-hours
4. Split large XML into smaller files
5. Optimize conditional mapping (fewer conditions)
6. Use database indexes on lookup fields

### Best Practices

✅ **Do:**
- Test imports with small sample files first
- Document field mappings for team reference
- Archive imported XML files for audit trail
- Monitor import logs regularly
- Use transformations instead of pre-processing XML
- Set appropriate error handling per import type
- Schedule imports during low-usage times

❌ **Don't:**
- Import into production without testing
- Delete import definitions in use
- Ignore validation errors
- Use overly complex XPath expressions
- Skip error log reviews
- Import duplicate data without key checks
- Modify XML structure without updating mappings

### Maintenance Tasks

**Daily:**
- Review failed imports
- Monitor auto-import folders
- Check error logs for new issues

**Weekly:**
- Archive old import log entries
- Update mappings if source system changes
- Test import definitions still work

**Monthly:**
- Clean up archived XML files
- Review import performance metrics
- Optimize slow-running imports
- Update documentation for mapping changes

---

## Advanced Features

### Multi-Level XML Structures

For complex XML with nested data:

**Example: Order with Line Items**
```xml
<Order>
  <OrderNo>SO-001</OrderNo>
  <Customer>CUST-100</Customer>
  <Lines>
    <Line>
      <ItemNo>1000</ItemNo>
      <Quantity>5</Quantity>
    </Line>
    <Line>
      <ItemNo>1001</ItemNo>
      <Quantity>10</Quantity>
    </Line>
  </Lines>
</Order>
```

Configure:
1. **Primary Import**: Order header to Sales Header table
2. **Related Import**: Order lines to Sales Line table
3. Link via **Parent Import** relationship

![Screenshot: Multi-Level Import]
*Placeholder for screenshot of hierarchical import configuration*

### Custom Validation Codeunits

For complex business rules:

1. Create AL codeunit with validation logic
2. Subscribe to validation events
3. Return TRUE (pass) or FALSE (fail) with error message
4. Assign codeunit to import definition

---

## Support

For technical support or questions:
- **Issues**: [GitHub Issues](https://github.com/walter75-Consulting/Business-Central-Apps/issues)
- **Documentation**: [Main Documentation](xml-import.md)

---

**Last Updated:** December 2025

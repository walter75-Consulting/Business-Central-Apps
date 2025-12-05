# walter75 - BDE Terminal
## User Guide

**Version:** 26.2.0  
**Publisher:** walter75 Consulting  
**Platform:** Microsoft Dynamics 365 Business Central Cloud

---

## Table of Contents

1. [Introduction](#introduction)
2. [Terminal Setup](#terminal-setup)
3. [Using the BDE Terminal](#using-the-bde-terminal)
4. [Recording Time](#recording-time)
5. [Reporting Production](#reporting-production)
6. [Troubleshooting](#troubleshooting)

---

## Introduction

The **walter75 - BDE Terminal** (Betriebsdatenerfassung/Manufacturing Data Entry) extension provides touch-optimized terminals for manufacturing floor workers to record production data, working time, and machine status directly in Business Central.

### Key Features

- 🏭 **Shop Floor Interface**: Large buttons optimized for touch screens
- ⏱️ **Time Tracking**: Record start/stop times for production orders
- 📊 **Production Reporting**: Report output quantities and scrap
- 🔧 **Machine Status**: Track machine downtime and maintenance
- 👤 **Employee Login**: Secure access with employee identification
- 📱 **Mobile Friendly**: Responsive design for tablets and terminals

---

## Terminal Setup

### Step 1: Configure BDE Terminals

1. Search for **"BDE Terminal List"** in Business Central
2. Click **+ New** to create a new terminal

![Screenshot: BDE Terminal List]
*Placeholder for screenshot of BDE Terminal list*

### Step 2: Basic Terminal Settings

**Terminal Information:**
- **Terminal No.**: Unique identifier (e.g., "TERM-001")
- **Description**: Descriptive name (e.g., "Assembly Line 1 Terminal")
- **Location Code**: Warehouse location where terminal is physically located
- **Work Center Code**: Associated work center or machine group

![Screenshot: BDE Terminal Card - Basic Settings]
*Placeholder for screenshot showing basic terminal configuration*

### Step 3: Terminal Type Configuration

**Terminal Type**: Select the primary function:
- **Time Recording**: For tracking employee working hours
- **Production Recording**: For reporting production quantities
- **Combined**: Both time and production recording

**Display Options:**
- **Show Employee Photo**: Display employee picture on login
- **Large Button Mode**: Extra-large buttons for touch screens
- **Auto Logout Time (minutes)**: Automatically log out after inactivity

![Screenshot: Terminal Type Selection]
*Placeholder for screenshot showing terminal type options*

### Step 4: Button Configuration

Configure custom action buttons for quick access:

1. Navigate to **Actions** → **Configure Buttons**
2. Add buttons for common tasks:
   - Start Production Order
   - Report Output
   - Report Scrap
   - Take Break
   - End Shift

![Screenshot: Button Configuration]
*Placeholder for screenshot of button configuration page*

**Button Properties:**
- **Caption**: Text displayed on button
- **Action Code**: System action to execute
- **Color**: Button background color
- **Position**: Button placement on screen (1-12)

---

## Using the BDE Terminal

### Accessing the Terminal

**Option 1: Direct Access**
1. Search for **"BDE Terminal"** in Business Central
2. Select your terminal from the list
3. Click **Open Terminal**

**Option 2: Web URL**
- Bookmark the terminal's web URL for quick access on tablets
- URL format: `https://your-bc-instance.com/terminal?id=TERM-001`

![Screenshot: Terminal Login Screen]
*Placeholder for screenshot of terminal login screen*

### Employee Login

**Login Methods:**

**Method 1: Scan Employee Badge**
1. Scan employee barcode badge
2. Terminal automatically logs in employee
3. Personal dashboard displays

**Method 2: Manual Entry**
1. Click **Manual Login**
2. Enter Employee No.
3. Enter PIN (if configured)
4. Click **Login**

![Screenshot: Employee Login]
*Placeholder for screenshot showing login methods*

### Terminal Dashboard

After login, employees see:
- **Current Status**: Clocked in/out, current operation
- **Active Production Order**: Currently assigned work
- **Quick Actions**: Configured buttons for common tasks
- **Today's Summary**: Hours worked, quantities produced

![Screenshot: Terminal Dashboard]
*Placeholder for screenshot of employee dashboard*

---

## Recording Time

### Clock In

1. **Login** to the terminal with your employee ID
2. Click the **"Clock In"** button
3. System records start time
4. Status changes to "Working"

![Screenshot: Clock In]
*Placeholder for screenshot of clock in screen*

### Start Work on Production Order

1. From the dashboard, click **"Start Production"**
2. Scan or enter the **Production Order No.**
3. Select the **Operation** you're working on
4. Click **"Start"**
5. Timer begins tracking time for this operation

![Screenshot: Start Production]
*Placeholder for screenshot showing starting production on an order*

### Take Break

1. Click **"Take Break"** button
2. Select break type:
   - Regular Break
   - Lunch Break
   - Unplanned Break
3. Timer pauses
4. Status shows "On Break"

![Screenshot: Break Types]
*Placeholder for screenshot of break type selection*

### Resume Work

1. Click **"Resume Work"** button
2. Timer continues
3. Status returns to "Working"

### Clock Out

1. Ensure all production is reported
2. Click **"Clock Out"** button
3. Review time summary
4. Confirm clock out
5. Automatic logout

![Screenshot: Clock Out Summary]
*Placeholder for screenshot of clock out summary*

---

## Reporting Production

### Report Output Quantity

1. Click **"Report Output"** from terminal dashboard
2. Enter or confirm:
   - **Production Order No.**
   - **Operation No.**
   - **Quantity Produced**: Number of finished items
   - **Timestamp**: Defaults to current time
3. Click **"Post"** to record output

![Screenshot: Report Output]
*Placeholder for screenshot of output reporting screen*

### Report Scrap/Defects

1. Click **"Report Scrap"** button
2. Enter:
   - **Production Order No.**
   - **Operation No.**
   - **Scrap Quantity**: Number of defective items
   - **Scrap Reason Code**: Select from predefined reasons
     - Material Defect
     - Machine Error
     - Human Error
     - Quality Failure
3. Optional: Add notes explaining the issue
4. Click **"Post"** to record scrap

![Screenshot: Report Scrap]
*Placeholder for screenshot of scrap reporting with reason codes*

### Complete Operation

1. Click **"Complete Operation"** button
2. System shows operation summary:
   - Total time spent
   - Total quantity produced
   - Total scrap reported
3. Verify data is correct
4. Click **"Confirm Completion"**
5. Operation status updates to "Finished"

![Screenshot: Operation Completion]
*Placeholder for screenshot of operation completion summary*

### Report Machine Downtime

1. Click **"Machine Downtime"** button
2. Enter:
   - **Work Center**: Affected machine
   - **Downtime Type**:
     - Maintenance
     - Breakdown
     - Setup/Changeover
     - No Material
   - **Start Time**: When downtime began
   - **Expected Duration**: Estimated time to resolve
3. Add description of issue
4. Click **"Register"**

![Screenshot: Machine Downtime]
*Placeholder for screenshot of downtime registration*

### Resolve Machine Downtime

1. Click **"Resolve Downtime"** button
2. Select the downtime entry
3. Enter **Resolution Notes**
4. Confirm **Actual Duration**
5. Click **"Resolve"**
6. Machine status returns to "Available"

![Screenshot: Resolve Downtime]
*Placeholder for screenshot of downtime resolution*

---

## Troubleshooting

### Common Issues

#### Issue: "Cannot Clock In"

**Possible Causes:**
- Employee already clocked in
- Employee not set up in the system
- Terminal not properly configured

**Solution:**
1. Check if employee is already clocked in at another terminal
2. Verify employee exists in Employee list
3. Ensure employee has proper permissions
4. Check terminal configuration

#### Issue: "Production Order Not Found"

**Cause:** Scanned barcode doesn't match any active production order

**Solution:**
1. Verify production order status (must be "Released")
2. Check for typos in manual entry
3. Ensure barcode scanner is configured correctly
4. Confirm production order is assigned to the correct location

#### Issue: "Operation Already Started"

**Cause:** Another employee is already working on this operation

**Solution:**
1. Check with supervisor about operation assignment
2. Verify the operation routing
3. If error, supervisor can reset operation status

#### Issue: "Touch Screen Not Responsive"

**Cause:** Display calibration or browser compatibility issue

**Solution:**
1. Refresh the browser (F5)
2. Clear browser cache
3. Recalibrate touch screen in device settings
4. Use recommended browser (Edge or Chrome)
5. Check for Windows updates

### Best Practices

✅ **Do:**
- Clock in immediately when arriving at workstation
- Report scrap as soon as defects are identified
- Complete operations promptly when finished
- Report machine issues immediately
- Clock out at end of shift

❌ **Don't:**
- Share employee credentials
- Report quantities without verification
- Leave terminal logged in unattended
- Forget to report breaks (affects time accuracy)
- Ignore system warnings or errors

### Getting Help

**Supervisor Functions:**
- Reset stuck operations
- Correct time entries
- Review production reports
- Manage employee access

**IT Support Contact:**
- Terminal connectivity issues
- Hardware problems
- Software updates

---

## Support

For technical support or questions:
- **Issues**: [GitHub Issues](https://github.com/walter75-Consulting/Business-Central-Apps/issues)
- **Documentation**: [Main Documentation](bde-terminal.md)

---

**Last Updated:** December 2025

# Architecture: Core App

**Date**: 2025-12-25  
**Complexity**: MEDIUM  
**Author**: al-architect  
**Status**: Approved

## Executive Summary

The Core App serves as the foundational infrastructure layer for all walter75 Business Central extensions. Phase 1 provides three essential capabilities: **Error Logging** (centralized error tracking with BC retention policy), **Activity Log Integration** (leveraging BC's standard Table 710), and **Feature Management** (feature registration and validation). This foundation is always-on with no configuration required—dependent apps can immediately use error logging, activity tracking, and feature validation. Prepared for future licensing integration in Phase 3.

## Business Context

### Problem Statement

**Current State**: Extensions operate independently without:
- Centralized error tracking across the application stack
- Unified activity logging for integrations and workflows
- Ability to enable/disable features dynamically (e.g., "Explode BOM")
- Foundation for future licensing and feature access control

**Desired State**: A platform infrastructure layer that:
- Captures and stores errors from all SEW apps
- Integrates with BC's standard Activity Log for process tracking
- Provides feature toggle mechanism for admins to enable/disable functionality
- Creates foundation for licensing-based feature control (Phase 3)

### Success Criteria

- ✅ All walter75 apps can log errors to centralized Error Log table
- ✅ Activity Log Helper simplifies logging to BC's standard Activity Log (Table 710)
- ✅ Feature Management allows toggling features (e.g., Base App's "Explode BOM")
- ✅ Admin page provides simple UI to enable/disable features
- ✅ Public APIs available for dependent apps to check feature status
- ✅ Error log retention automatically deletes entries after 30 days
- ✅ Phase 1 deliverable within 2-3 weeks

## Architectural Design

### Object ID Range

**Allocated Range**: `71000-71999` (1000 objects)

**Range Distribution**:
```
71000-71099: Install & Core Infrastructure (100 objects)
71100-71199: Error Logging (100 objects)
71200-71299: Activity Log Integration (100 objects)
71300-71399: Feature Management (100 objects)
71400-71499: Telemetry (reserved for Phase 2)
71500-71599: Licensing (reserved for Phase 3)
71600-71699: Consent Management (reserved for Phase 3)
71700-71799: Admin UI (Dashboard, Wizards) (reserved for Phase 3+)
71800-71899: Integration Events & Public APIs
71900-71999: Reserved for future expansion
```

### Data Model

#### Tables (Phase 1)

**Table 71100 "SEW Error Log""
- Purpose: Centralized error logging for all SEW apps
- Key fields:
  - Entry No. (Integer, AutoIncrement) - Primary Key
  - Timestamp (DateTime) - When error occurred
  - Severity (Enum: Info/Warning/Error/Critical)
  - Error Message (Text[2048]) - Main error text
  - Context Info (Text[2048]) - Additional context
  - User ID (Code[50]) - Who triggered the error
  - Session ID (Integer) - BC session identifier
  - Company Name (Text[30]) - Which company
  - Object Type (Enum "Object Type") - Table/Page/Codeunit/etc
  - Object ID (Integer) - Which object
  - Stack Trace (Blob) - Full call stack (if available)
- Keys:
  - PK: Entry No. (Clustered)
  - TimestampIdx: Timestamp (for retention policy and date filtering)
  - SeverityIdx: Severity, Timestamp (for filtered queries)
- Retention Policy: 30 days on Timestamp field
- DataClassification: Mixed (SystemMetadata for technical, CustomerContent for messages, EndUserIdentifiableInformation for User ID)

**Table 71300 "SEW Feature"**
- Purpose: Feature toggle configuration for all SEW apps
- Key fields:
  - Code (Code[50]) - Primary Key (e.g., "BASE-EXPLODE-BOM", "MANUFACTURING-SCHEDULING")
  - App Name (Text[100]) - Which app owns this feature (e.g., "Base App")
  - Feature Name (Text[100]) - Display name (e.g., "Explode BOM")
  - Description (Text[250]) - What the feature does
  - Enabled (Boolean) - On/Off toggle
  - Requires License (Boolean) - Future: Check license before enabling
  - License Feature Code (Code[50]) - Future: Maps to license table
  - Default State (Boolean) - Default value on first install
  - Activation Date (DateTime) - When feature was enabled
  - Activation User (Code[50]) - Who enabled it
  - Last Modified Date/User
- Keys:
  - PK: Code
  - AppIdx: App Name, Code (for filtering by app)
  - EnabledIdx: Enabled (for quick enabled-only queries)
- DataClassification: SystemMetadata

### Business Logic (Codeunits)

#### Codeunit 71100 "SEW Error Logger"
**Purpose**: Centralized error logging API for all SEW apps

**Permissions**: RIMD on "SEW Error Log"

**Key Procedures**:
```al
procedure LogError(ErrorMessage: Text; ContextInfo: Text)
// Logs an error with automatic severity = Error

procedure LogWarning(WarningMessage: Text; ContextInfo: Text)
// Logs a warning with severity = Warning

procedure LogInfo(InfoMessage: Text; ContextInfo: Text)
// Logs informational message with severity = Info

procedure LogCritical(CriticalMessage: Text; ContextInfo: Text)
// Logs critical error with severity = Critical

procedure LogException(ErrorInfo: ErrorInfo)
// Converts BC ErrorInfo to log entry with full details

procedure LogErrorWithObject(ErrorMessage: Text; ContextInfo: Text; ObjectType: Enum "Object Type"; ObjectID: Integer)
// Logs error with specific object identification

procedure SetStackTrace(var ErrorLog: Record "SEW Error Log"; StackTraceText: Text)
// Stores stack trace in Blob field
```

**Event Publishers**:
```al
[IntegrationEvent(false, false)]
local procedure OnAfterErrorLogged(ErrorLog: Record "SEW Error Log")
// Fired after error logged, allows extensions to react
```

**Business Logic**:
- Automatically capture Session ID, User ID, Company Name from system
- Store large stack traces in Blob field to avoid Text field limits
- Set timestamp automatically to current DateTime
- Always enabled - no configuration needed

---

#### Codeunit 71200 "SEW Activity Log Helper"
**Purpose**: Simplified API for BC's standard Activity Log (Table 710)

**Permissions**: RIMD on "Activity Log"

**Key Procedures**:
```al
procedure LogSuccess(RelatedRecordID: RecordId; Description: Text; DetailedInfo: Text)
// Logs successful activity to standard BC Activity Log

procedure LogFailure(RelatedRecordID: RecordId; Description: Text; DetailedInfo: Text)
// Logs failed activity to BC Activity Log AND SEW Error Log

procedure LogIntegrationCall(Source: Text; Endpoint: Text; Success: Boolean; ResponseDetails: Text)
// Specialized logging for API/integration calls

procedure LogWorkflowStep(WorkflowCode: Code[20]; StepDescription: Text; Success: Boolean; Details: Text)
// Logs workflow process steps

procedure LogBatchJob(JobName: Text; RecordsProcessed: Integer; Success: Boolean; Summary: Text)
// Logs batch processing activities
```

**Integration Pattern**:
- Uses BC's standard `Codeunit "Activity Log"` internally
- Context = 'SEW' for all entries (easy filtering)
- On failure, automatically logs to SEW Error Log as well (dual logging)

---

#### Codeunit 71300 "SEW Feature Management"
**Purpose**: Feature toggle validation and management

**SingleInstance**: true (for feature cache with 10-minute auto-refresh)

**Permissions**: RIMD on "SEW Feature"

**Key Procedures**:
```al
procedure IsFeatureEnabled(FeatureCode: Code[50]): Boolean
// Main API: Check if feature is enabled (with automatic 10-minute cache refresh)
// Cache automatically refreshes when 10-minute boundary crossed

procedure EnableFeature(FeatureCode: Code[50])
// Enable a feature (admin action)
// Updates database and cache immediately

procedure DisableFeature(FeatureCode: Code[50])
// Disable a feature (admin action)
// Updates database and cache immediately

procedure RegisterFeature(FeatureCode: Code[50]; AppName: Text[100]; FeatureName: Text[100]; Description: Text[250]; DefaultEnabled: Boolean)
// Called by Install codeunits to register features
// Adds feature to cache immediately

procedure ValidateFeatureAccess(FeatureCode: Code[50])
// Throws error if feature is disabled (use in business logic)

procedure GetFeaturesByApp(AppName: Text[100]): Record "SEW Feature"
// Returns all features for a specific app

procedure RefreshCache()
// Force cache refresh (called automatically every 10 minutes, or manually by admin)
```

**Event Publishers**:
```al
[IntegrationEvent(false, false)]
local procedure OnBeforeFeatureValidation(FeatureCode: Code[50]; var IsEnabled: Boolean; var IsHandled: Boolean)
// Allows extensions to override feature state (e.g., license check in Phase 3)

[IntegrationEvent(false, false)]
local procedure OnAfterFeatureStateChanged(FeatureCode: Code[50]; NewState: Boolean)
// Fired when feature enabled/disabled
```

**Business Logic**:
- **Caching**: Store feature states in Dictionary<Code[50], Boolean> for performance
- **Auto-Refresh**: Cache automatically refreshes every 10 minutes (when IsFeatureEnabled called after 10-minute boundary)
- **Immediate Updates**: EnableFeature/DisableFeature update cache immediately for current session
- **Multi-Session Propagation**: Changes propagate to other sessions within 10 minutes (automatic)
- **Future Hook**: OnBeforeFeatureValidation event allows Phase 3 licensing to override
- **Default Behavior**: If feature not found, return false (fail-safe)
- **Registration**: Install codeunits register features automatically and add to cache

**Cache Refresh Logic**:
```al
var
    FeatureCache: Dictionary of [Code[50], Boolean];
    LastRefreshMinute: Integer;
    CacheInitialized: Boolean;

procedure IsFeatureEnabled(FeatureCode: Code[50]): Boolean
begin
    // Initialize on first call
    if not CacheInitialized then
        RefreshCache();
    
    // Auto-refresh every 10 minutes
    if (Time2Minute(Time) div 10) <> LastRefreshMinute then
        RefreshCache();
    
    // Return cached value
    if FeatureCache.ContainsKey(FeatureCode) then
        exit(FeatureCache.Get(FeatureCode))
    else
        exit(false);
end;

procedure RefreshCache()
var
    Feature: Record "SEW Feature";
begin
    Clear(FeatureCache);
    
    if Feature.FindSet() then
        repeat
            FeatureCache.Add(Feature.Code, Feature.Enabled);
        until Feature.Next() = 0;
    
    LastRefreshMinute := Time2Minute(Time) div 10;
    CacheInitialized := true;
end;

local procedure UpdateCacheEntry(FeatureCode: Code[50]; NewState: Boolean)
begin
    if FeatureCache.ContainsKey(FeatureCode) then
        FeatureCache.Set(FeatureCode, NewState)
    else
        FeatureCache.Add(FeatureCode, NewState);
end;
```

---

#### Codeunit 71000 "SEW Core Install"
**Purpose**: Installation and upgrade handling

**Subtype**: Install

**Permissions**: RIMD on all Core tables

**Key Procedures**:
```al
local procedure OnInstallAppPerDatabase()
// Initialize setup, create default Core Setup record, set retention policy

local procedure OnInstallAppPerCompany()
// Company-specific initialization (currently empty)
```

**Business Logic**:
```al
procedure OnInstallAppPerDatabase()
var
    RetenPolAllowedTables: Codeunit "Reten. Pol. Allowed Tables";
begin
    // Register Error Log table for retention policy
    // Allows admins to configure retention via standard BC Retention Policy UI
    RetenPolAllowedTables.AddAllowedTable(Database::"SEW Error Log");
end;
```

**Retention Policy Notes**:
- Uses BC's standard Retention Policy feature (introduced in BC 19.0)
- Admin configures retention period via **Retention Policies** page (search in BC)
- No custom retention code needed - BC handles cleanup automatically
- Table is registered as "allowed" for retention policy
- Default recommendation: 30 days, but admin can adjust as needed

---

#### Codeunit 71001 "SEW Core Upgrade"
**Purpose**: Version upgrade logic

**Subtype**: Upgrade

**Key Procedures**:
```al
local procedure OnUpgradePerDatabase()
// Schema upgrades (future versions)

local procedure OnUpgradePerCompany()
// Data migrations (future versions)
```

**Business Logic**: Currently empty, prepared for future upgrades

---

### Enumerations

#### Enum 71100 "SEW Error Severity"
```al
enum 71100 "SEW Error Severity"
{
    Extensible = false;
    
    value(0; Info) { Caption = 'Info'; }
    value(1; Warning) { Caption = 'Warning'; }
    value(2; Error) { Caption = 'Error'; }
    value(3; Critical) { Caption = 'Critical'; }
}
```

### User Interface (Pages)

#### Page 71100 "SEW Error Log List"
**Type**: List  
**SourceTable**: "SEW Error Log"  
**Purpose**: View and filter error logs

**Layout**:
- Repeater with fields: Entry No., Timestamp, Severity, Error Message, Context Info, User ID, Object Type, Object ID
- Filters: Severity (dropdown), Date Range (from/to)

**Actions**:
- **Show Details** → Drills down to Error Log Card
- **Export to Excel** → Standard BC export
- **Delete Old Entries** → Manual trigger of retention cleanup
- **Refresh** → Reload data

**Promoted Actions**: Show Details, Export to Excel

---

#### Page 71101 "SEW Error Log Card"
**Type**: Card  
**SourceTable**: "SEW Error Log"  
**Purpose**: Detailed error view with full stack trace

**Layout**:
- General FastTab: Entry No., Timestamp, Severity, Error Message, Context Info
- Details FastTab: User ID, Session ID, Company Name, Object Type, Object ID
- Stack Trace FastTab: Blob field displayed as multiline text

**Actions**:
- **Copy to Clipboard** → Copy error details
- **View Related** → Navigate to related record (if RecordID available)

---

#### Page 71300 "SEW Feature Management"
**Type**: List  
**SourceTable**: "SEW Feature"  
**Purpose**: Admin page to enable/disable features

**Layout**:
- Repeater with fields: Code, App Name, Feature Name, Description, Enabled (editable), Requires License, Activation Date, Activation User

**Filters**: 
- App Name filter (quick filter by app)
- Enabled filter (show only enabled/disabled)

**Actions**:
- **Enable Feature** → Sets Enabled = true, records activation user/date, updates cache immediately
- **Disable Feature** → Sets Enabled = false, updates cache immediately
- **Enable All** → Bulk enable all features for selected app
- **Disable All** → Bulk disable all features for selected app
- **Reset to Default** → Reset feature to Default State value
- **Refresh Cache** → Manual cache refresh (normally auto-refreshes every 10 minutes)

**Promoted Actions**: Enable Feature, Disable Feature, Refresh Cache

**Auto-Refresh Behavior**:
- Cache automatically refreshes every 10 minutes when IsFeatureEnabled() is called
- Admin's session updates immediately when enabling/disabling via actions
- Other user sessions see changes within 10 minutes (next auto-refresh)
- Manual "Refresh Cache" action available for immediate refresh if needed

**Validation**:
- OnValidate(Enabled): Record Activation Date and User when enabling
- OnValidate(Enabled): Fire OnAfterFeatureStateChanged event
- OnValidate(Enabled): Clear feature cache

---

#### Page 71301 "SEW Feature Card"
**Type**: Card  
**SourceTable**: "SEW Feature"  
**Purpose**: Detailed feature configuration

**Layout**:
- General FastTab: Code, App Name, Feature Name, Description, Enabled
- Licensing FastTab: Requires License, License Feature Code (future)
- Tracking FastTab: Default State, Activation Date, Activation User, Last Modified Date, Last Modified User

**Actions**:
- **Toggle State** → Quick enable/disable
- **Test Feature** → Calls IsFeatureEnabled() and shows result

---



### Integration Points

#### Event Publishers (Extensibility)

**Codeunit 71100 "SEW Error Logger"**
```al
[IntegrationEvent(false, false)]
local procedure OnAfterErrorLogged(ErrorLog: Record "SEW Error Log")
// Allows extensions to react to errors (e.g., send email notification on Critical)
```

**Codeunit 71300 "SEW Feature Management"**
```al
[IntegrationEvent(false, false)]
local procedure OnBeforeFeatureValidation(FeatureCode: Code[50]; var IsEnabled: Boolean; var IsHandled: Boolean)
// Allows Phase 3 licensing to override feature state

[IntegrationEvent(false, false)]
local procedure OnAfterFeatureStateChanged(FeatureCode: Code[50]; NewState: Boolean)
// Fired when feature enabled/disabled, allows cache refresh in other apps
```

#### Public API for Dependent Apps

**Error Logging Usage** (from any SEW app):
```al
codeunit 74100 "Base Explode BOM"
{
    var
        ErrorLogger: Codeunit "SEW Error Logger";
        FeatureMgmt: Codeunit "SEW Feature Management";
    
    procedure ExplodeBOM(SalesLine: Record "Sales Line")
    begin
        // Feature check
        FeatureMgmt.ValidateFeatureAccess('BASE-EXPLODE-BOM');
        
        // Business logic
        if not ValidateBOM(SalesLine) then begin
            ErrorLogger.LogError(
                StrSubstNo('Cannot explode BOM for item %1', SalesLine."No."),
                StrSubstNo('Sales Order: %1, Line: %2', SalesLine."Document No.", SalesLine."Line No.")
            );
            Error('BOM validation failed. See error log for details.');
        end;
        
        // Process BOM...
        
        // Log success to Activity Log
        ActivityLogHelper.LogSuccess(
            SalesLine.RecordId,
            'BOM Exploded Successfully',
            StrSubstNo('Item: %1, Quantity: %2', SalesLine."No.", SalesLine.Quantity)
        );
    end;
}
```

**Feature Registration** (in Base App Install codeunit):
```al
codeunit 74000 "Base App Install"
{
    Subtype = Install;
    
    trigger OnInstallAppPerDatabase()
    var
        FeatureMgmt: Codeunit "SEW Feature Management";
    begin
        // Register features
        FeatureMgmt.RegisterFeature(
            'BASE-EXPLODE-BOM',
            'Base App',
            'Explode BOM',
            'Automatically explode BOM components into sales lines',
            true  // enabled by default
        );
        
        FeatureMgmt.RegisterFeature(
            'BASE-ADVANCED-PRICING',
            'Base App',
            'Advanced Pricing',
            'Enable advanced pricing calculations with tiered discounts',
            false  // disabled by default (future feature)
        );
    end;
}
```

**Feature Check Pattern**:
```al
// Pattern 1: Validate (throws error if disabled)
FeatureMgmt.ValidateFeatureAccess('BASE-EXPLODE-BOM');

// Pattern 2: Check and branch
if FeatureMgmt.IsFeatureEnabled('BASE-EXPLODE-BOM') then
    ExplodeBOM(SalesLine)
else
    Message('Explode BOM feature is disabled. Contact your administrator.');

// Pattern 3: UI visibility
trigger OnOpenPage()
begin
    ExplodeBOMAction.Visible := FeatureMgmt.IsFeatureEnabled('BASE-EXPLODE-BOM');
end;
```

#### Activity Log Integration Pattern

**Dual Logging on Failure**:
```al
codeunit 71200 "SEW Activity Log Helper"
{
    procedure LogFailure(RelatedRecordID: RecordId; Description: Text; DetailedInfo: Text)
    var
        ActivityLog: Record "Activity Log";
        ErrorLogger: Codeunit "SEW Error Logger";
    begin
        // Standard BC Activity Log
        ActivityLog.LogActivity(
            RelatedRecordID,
            Enum::"Activity Log Status"::Failed,
            'SEW',
            Description,
            DetailedInfo
        );
        
        // Also log to SEW Error Log for analysis
        ErrorLogger.LogError(Description, DetailedInfo);
    end;
}
```

### Security Model

#### Permission Sets

**PermissionSet 71000 "SEW-CORE-READ"**
- **Target Users**: All users (basic visibility)
- **Permissions**:
  - Read: Error Log, Feature
  - Execute: Error Logger (read-only methods), Feature Management (IsFeatureEnabled only)
- **Purpose**: View errors and check feature status

**PermissionSet 71001 "SEW-CORE-USER"**
- **Target Users**: General users logging errors
- **Permissions**:
  - Inherits: SEW-CORE-READ
  - Insert: Error Log (via codeunit only)
  - Execute: Error Logger (all methods), Activity Log Helper (all methods)
- **Purpose**: Log errors and activities

**PermissionSet 71002 "SEW-CORE-ADMIN"**
- **Target Users**: System administrators
- **Permissions**:
  - Inherits: SEW-CORE-USER
  - RIMD: All Core tables (Error Log, Feature)
  - Execute: All Core codeunits
  - Pages: All Core pages including Feature Management and Error Logs
  - Note: Retention Policy configuration requires SUPER or Retention Policy Admin permissions (BC standard)
- **Purpose**: Full administrative control

**Hierarchical Structure**:
```
SEW-CORE-ADMIN (Super)
    ├── SEW-CORE-USER (Standard)
    │   └── SEW-CORE-READ (Basic)
```

### Performance Considerations

**Error Log Table**:
- **Index on Timestamp**: Fast filtering by date range, used by retention policy for cleanup
- **Index on Severity + Timestamp**: Efficient critical error queries
- **AutoIncrement Entry No.**: Avoid key conflicts in multi-user environments
- **Blob for Stack Trace**: Avoid TEXT[max] performance issues, store large traces separately
- **Retention Policy**: Uses BC standard Retention Policy framework
  - Table registered in OnInstallAppPerDatabase
  - Admin configures via **Retention Policies** page in BC
  - Filter by **Timestamp** field (records older than X days deleted)
  - Recommended: 30 days, configurable per company
  - Runs automatically via BC job queue

**Feature Caching**:
- **SingleInstance Codeunit**: Feature states cached per session
- **Dictionary Cache**: Code[50] → Boolean mapping, O(1) lookups
- **Auto-Refresh Interval**: Every 10 minutes (automatic background refresh)
- **Immediate Updates**: Enable/Disable actions update cache instantly in admin's session
- **Multi-Session Propagation**: Other sessions see changes within max 10 minutes
- **Expected Hit Ratio**: >99% (features rarely change, cache refresh only every 10 min)
- **Performance Impact**: 1 DB query per 10 minutes per active session (negligible overhead)

**Activity Log Integration**:
- Uses BC's native Activity Log table (already optimized)
- No additional indexing required
- Dual logging only on failures (minimize overhead)

### Testing Strategy

#### Unit Tests (Test Codeunit)

**Codeunit 71950 "SEW Error Logger Test"**
```al
[Test]
procedure TestLogError()
// Verify error logged with correct severity and fields

[Test]
procedure TestLogWarning()
// Verify warning logged

[Test]
procedure TestRetentionPolicy()
// Create old entries, run retention job, verify deletion

[Test]
procedure TestStackTraceBlob()
// Verify large stack traces stored correctly in Blob field
```

**Codeunit 71951 "SEW Feature Mgmt Test"**
```al
[Test]
procedure TestRegisterFeature()
// Register feature, verify record created

[Test]
procedure TestIsFeatureEnabled()
// Enable feature, verify IsFeatureEnabled returns true

[Test]
procedure TestFeatureCache()
// Test caching: verify DB hit only on first call

[Test]
procedure TestValidateFeatureAccess()
// Disable feature, verify ValidateFeatureAccess throws error

[Test]
procedure TestEnableDisableEvents()
// Verify OnAfterFeatureStateChanged event fires
```

**Codeunit 71952 "SEW Activity Log Test"**
```al
[Test]
procedure TestLogSuccess()
// Verify Activity Log entry created with Success status

[Test]
procedure TestLogFailure()
// Verify dual logging: Activity Log + Error Log

[Test]
procedure TestLogIntegrationCall()
// Verify integration logging format
```

#### Integration Tests

**Install Codeunit Test**:
- Run OnInstallAppPerDatabase successfully
- Verify Error Log table registered in allowed retention policy tables
- Verify table available in BC's Retention Policies page

**Feature Registration Flow**:
- Simulate Base App install registering features
- Verify features appear in Feature Management page
- Enable/disable via UI, verify cache cleared

**Cross-App Error Logging**:
- From test app, call SEW Error Logger
- Verify error appears in Error Log List
- Verify permissions enforced (non-admin cannot delete)

#### UI Tests

**Feature Management Page**:
- Enable feature via toggle, verify Enabled = true
- Disable feature, verify cache refreshed
- Test bulk enable/disable actions

**Error Log List Page**:
- Filter by severity, verify correct records shown
- Export to Excel, verify all fields included
- Delete old entries action, verify confirmation dialog

#### Performance Tests

**Error Logging Performance**:
- Insert 10,000 error log entries
- Measure insert time (should be <10ms per entry)
- Query by severity filter (should be <500ms for 10k records)

**Feature Cache Performance**:
- Call IsFeatureEnabled 1,000 times for same feature
- Measure time: First call ~20ms, subsequent calls <1ms
- Verify only 1 DB query executed (cache hit)

**Retention Policy Test**:
- Insert 50,000 old error entries (31 days ago)
- Run retention job
- Measure cleanup time (should be <30 seconds)
- Verify all old entries deleted

### Test Data

**Library Codeunit 71990 "SEW Test Data - Core"**
```al
procedure CreateErrorLog(Severity: Enum "SEW Error Severity"): Record "SEW Error Log"
// Create test error log entry

procedure CreateOldErrorLog(DaysOld: Integer): Record "SEW Error Log"
// Create old entry for retention testing

procedure CreateFeature(FeatureCode: Code[50]; Enabled: Boolean): Record "SEW Feature"
// Create test feature

procedure EnableAllFeatures()
// Bulk enable all test features

procedure CleanupTestData()
// Delete all test records
```

## Implementation Phases

### Phase 1: Foundation - Error Logging, Activity Log, Feature Management (Week 1-3) 🎯

**Week 1: App Structure & Error Logging**

Deliverables:
- [x] Create app folder structure: `Core App/src/`
  - `ErrorLogging/` - Error Log table, enum, codeunit, pages
  - `ActivityLog/` - Activity Log Helper codeunit
  - `FeatureManagement/` - Feature table, codeunit, pages
  - `Install/` - Install and Upgrade codeunits
  - `Permissions/` - Permission set objects

- [x] Create `app.json`:
  ```json
  {
    "id": "71000000-0000-0000-0000-000000000001",
    "name": "Core App",
    "publisher": "SEW",
    "version": "1.0.0.0",
    "brief": "Foundation layer for all SEW extensions",
    "description": "Provides error logging, activity tracking, and feature management",
    "privacyStatement": "",
    "EULA": "",
    "help": "",
    "url": "",
    "logo": "",
    "dependencies": [],
    "platform": "27.0.0.0",
    "application": "27.0.0.0",
    "idRanges": [
      {
        "from": 71000,
        "to": 71999
      }
    ],
    "features": [
      "NoImplicitWith"
    ]
  }
  ```

- [x] Implement Error Logging:
  - Enum 71100 "SEW Error Severity"
  - Table 71100 "SEW Error Log"
  - Codeunit 71100 "SEW Error Logger"
  - Page 71100 "SEW Error Log List"
  - Page 71101 "SEW Error Log Card"

- [x] Implement Activity Log Integration:
  - Codeunit 71200 "SEW Activity Log Helper"

**Validation**: 
- Error Logger.LogError() creates entry in table
- Error Log List page displays entries with filtering
- Activity Log Helper creates entries in standard BC Activity Log (Table 710)
- Dual logging on failure works correctly

---

**Week 2: Feature Management**

Deliverables:
- [x] Implement Feature Management:
  - Table 71300 "SEW Feature"
  - Codeunit 71300 "SEW Feature Management"
  - Page 71300 "SEW Feature Management"
  - Page 71301 "SEW Feature Card"

- [x] Add feature caching with Dictionary
- [x] Implement event publishers (OnBeforeFeatureValidation, OnAfterFeatureStateChanged)
- [x] Test feature registration flow
- [x] Test enable/disable with cache invalidation

**Validation**:
- RegisterFeature() creates feature record
- IsFeatureEnabled() returns correct state
- Cache works: Second call doesn't hit database
- EnableFeature/DisableFeature fire events correctly

---

**Week 3: Install, Permissions, Documentation**

Deliverables:
- [x] Implement Install/Upgrade:
  - Codeunit 71000 "SEW Core Install"
  - Codeunit 71001 "SEW Core Upgrade"
  - Register Error Log table for retention policy

- [x] Create Permission Sets:
  - PermissionSet 71000 "SEW-CORE-READ"
  - PermissionSet 71001 "SEW-CORE-USER"
  - PermissionSet 71002 "SEW-CORE-ADMIN"

- [x] Documentation:
  - README.md (public APIs, usage examples)
  - CHANGELOG.md
  - Update repository `docs/App ID Ranges.md`

**Validation**:
- Install codeunit runs successfully
- Error Log table appears in BC's Retention Policies page as allowed table
- Admin can configure retention policy via standard BC UI
- Permissions enforce access control correctly
- Documentation complete and accurate

---

**Phase 1 Completion Checklist**:
- ✅ All objects compile without errors
- ✅ Unit tests pass (Error Logger, Feature Mgmt, Activity Log)
- ✅ Integration tests pass (Install, cross-app calls)
- ✅ UI tests pass (pages functional)
- ✅ Performance tests pass (10k errors, cache hit ratio)
- ✅ Documentation published
- ✅ Base App can depend on Core App
- ✅ Example feature registered and tested ("BASE-EXPLODE-BOM")

---

### Phase 2: Telemetry (Week 4-5) 🔜 FUTURE

**Deferred to Phase 2**:
- ISV telemetry collection to SEW Application Insights
- Codeunit 71400 "SEW Telemetry Manager"
- Integration with BC Feature Telemetry
- Event telemetry for feature usage tracking
- Application Insights connection string in app.json

**Rationale**: Phase 1 provides immediate value with error logging and feature management. Telemetry adds observability but isn't blocking for dependent apps.

---

### Phase 3: Licensing & Consent (Week 6-10) ⏭️ FUTURE

**Deferred to Phase 3**:
- Table 71500 "SEW License" (trial/full licensing)
- Codeunit 71500 "SEW License Manager"
- License-based feature control (hook into OnBeforeFeatureValidation event)
- Table 71600 "SEW Consent" (GDPR consent management)
- Setup Wizard (multi-step configuration)
- Core Dashboard (Role Center)

**Integration with Feature Management**:
```al
// Phase 3: License Manager subscribes to feature validation event
[EventSubscriber(ObjectType::Codeunit, Codeunit::"SEW Feature Management", 'OnBeforeFeatureValidation', '', false, false)]
local procedure CheckLicenseBeforeFeature(FeatureCode: Code[50]; var IsEnabled: Boolean; var IsHandled: Boolean)
var
    Feature: Record "SEW Feature";
begin
    if not Feature.Get(FeatureCode) then
        exit;
    
    if not Feature."Requires License" then
        exit;
    
    // Check if license allows this feature
    if not LicenseManager.IsFeatureLicensed(Feature."License Feature Code") then begin
        IsEnabled := false;
        IsHandled := true;
    end;
end;
```

**Rationale**: Licensing and consent are important for AppSource but not required for internal PTE deployment. Phase 1-2 deliver core functionality first.

---

## Technical Decisions

### Decision 1: Error Log vs Activity Log - Use Both (Two-Tier Strategy)

**Options Considered**:
- **Option A**: Only custom Error Log table
  - Pros: Full control, optimized for error analysis
  - Cons: Doesn't leverage BC standard tooling
  
- **Option B**: Only BC standard Activity Log
  - Pros: Native BC UI, established patterns
  - Cons: Not optimized for error tracking, no retention policy control
  
- **Option C**: Both (two-tier logging)
  - Pros: Error Log for errors (with retention), Activity Log for process tracking
  - Cons: Slight complexity of two systems

**Decision**: **Option C** - Use both systems with clear separation

**Rationale**:
- **Error Log**: Application errors with retention policy (30 days), severity levels, stack traces
- **Activity Log**: Business process tracking (integrations, workflows, batch jobs), long-term audit trail
- **Integration**: Activity Log Helper automatically logs to Error Log on failure (dual logging)
- **Compatibility**: Customers familiar with Activity Log page can continue using it
- **Specialization**: Each system optimized for its purpose

---

### Decision 2: Feature Management in Phase 1 vs Phase 3

**Options Considered**:
- **Option A**: Include in Phase 1 (with Error Logging)
  - Pros: Enables feature toggles immediately, prepares for licensing
  - Cons: Slightly increases Phase 1 scope
  
- **Option B**: Defer to Phase 3 (with Licensing)
  - Pros: Smaller Phase 1, faster delivery
  - Cons: Dependent apps can't use feature toggles until Phase 3

**Decision**: **Option A** - Include Feature Management in Phase 1

**Rationale**:
- User requirement: "Explode BOM" needs to be toggleable now
- Feature Management is foundational (like error logging), not a "nice-to-have"
- Phase 3 licensing will hook into existing feature system (via events), no refactoring needed
- Minimal complexity: Table + Codeunit + 2 Pages (~200 lines of code)
- High value: Enables/disables features without code changes

---

### Decision 3: Feature Caching Strategy with 10-Minute Auto-Refresh

**Options Considered**:
- **Option A**: No caching (query database every time)
  - Pros: Always fresh data
  - Cons: Performance overhead (feature checks in tight loops)
  
- **Option B**: Session-scoped cache with manual invalidation
  - Pros: Fast lookups, explicit control
  - Cons: Admin must remember to refresh, stale data risk
  
- **Option C**: Session-scoped cache with time-based auto-refresh
  - Pros: Fast lookups + automatic freshness, no manual intervention
  - Cons: Max N-minute delay for cross-session updates

**Decision**: **Option C** - Session-scoped cache with 10-minute auto-refresh

**Rationale**:
- **Performance**: Dictionary provides O(1) lookups (<1ms), 1000x faster than DB queries
- **Freshness**: 10-minute max staleness acceptable for feature toggles (not real-time critical)
- **Simplicity**: No manual cache management needed, automatic background refresh
- **Admin Control**: Enable/Disable actions update cache immediately for admin's session
- **Multi-Session**: Other users see changes within 10 minutes without intervention
- **Standard Pattern**: Similar to BC's No. Series caching and Configuration Package caching
- **Overhead**: Only 1 DB query per 10 minutes per active session (negligible)

**Implementation Detail**:
```al
// Check every call: Has 10-minute boundary been crossed?
if (Time2Minute(Time) div 10) <> LastRefreshMinute then
    RefreshCache(); // Automatic refresh
```

**Why 10 Minutes**:
- Fast enough: Admin enables feature → users see it within 10 min (acceptable for feature toggles)
- Efficient: 6 refreshes/hour vs 60 refreshes/hour (1-minute) or 1 refresh/hour (60-minute)
- Predictable: Refreshes at :00, :10, :20, :30, :40, :50 (easy to understand for support)

---

### Decision 4: ID Range Allocation

**Decision**: Use **71000-71999** (1000 objects)

**Rationale**:
- Aligns with repository architecture (Foundation & Base Apps layer)
- 1000 objects sufficient for Core App (currently using ~20)
- Allows growth for Phase 2 (Telemetry) and Phase 3 (Licensing/Consent)
- Clear range boundaries for each subsystem (100 objects per feature area)

**Current Allocation**:
```
71000-71099: Install & Core Infrastructure (2 used, 98 free)
71100-71199: Error Logging (5 used, 95 free)
71200-71299: Activity Log (1 used, 99 free)
71300-71399: Feature Management (4 used, 96 free)
71400-71499: Telemetry (Phase 2) (0 used, 100 free)
71500-71599: Licensing (Phase 3) (0 used, 100 free)
71600-71699: Consent (Phase 3) (0 used, 100 free)
71700-71799: Admin UI (Phase 3+) (0 used, 100 free)
71800-71999: Integration & Reserved (200 free)
```

---

### Decision 5: SingleInstance Codeunits for State Management

**Decision**: Use SingleInstance = true for Feature Management codeunit

**Rationale**:
- Feature cache needs to persist across multiple calls in same session
- Dictionary variable maintains state within session
- Standard BC pattern for caching (No. Series, Setup records)
- No risk of cross-session data leakage (each session has own instance)

---

### Decision 6: Event-Driven Extensibility for Licensing

**Decision**: Publish OnBeforeFeatureValidation event in Phase 1

**Rationale**:
- Prepares architecture for Phase 3 licensing without refactoring
- Phase 3 License Manager subscribes to event, no Feature Management changes needed
- Extensible: Other extensions can also override feature state
- Decoupling: Feature Management doesn't need to know about licensing

**Phase 3 Integration Pattern**:
```
Phase 1: Feature Management publishes event → No subscribers yet
Phase 3: License Manager subscribes → Overrides feature state if unlicensed
```

---

## Dependencies

### Base Objects (Business Central Standard)
- **Table 710 "Activity Log"** - Used by Activity Log Helper
- **Enum "Activity Log Status"** - Success, Failed, etc.
- **Enum "Object Type"** - Table, Page, Codeunit, etc. (for error logging)
- **Codeunit "Activity Log"** - Standard BC logging API (wrapper)

### Extensions
- None (Core App is the foundation layer)

### External Systems
- None in Phase 1
- Phase 2: Azure Application Insights (telemetry)
- Phase 3: License Validation API (optional)

### AL-Go Structure
- Separate app folder: `Core App/`
- Test app: `Core App.Test/` (optional, can be added in Phase 1 Week 3)
- Standard AL-Go workflows (CICD, PublishToEnvironment)

## Risks & Mitigations

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| **Retention policy not working** | Error log grows unbounded | Medium | Test retention job in sandbox, monitor table size, add manual cleanup action |
| **Feature cache not invalidated** | Stale feature states | Medium | Test cache invalidation thoroughly, add manual "Refresh Cache" action on page |
| **Dependent apps call wrong API** | Inconsistent logging | Low | Document public APIs clearly, provide code examples in README |
| **Performance degradation** | Slow error logging | Low | Index on Timestamp + Severity, use Blob for large data, test with 10k records |
| **Permission issues** | Users can't log errors | Medium | Include SEW-CORE-USER in Base App permissions by default |
| **Feature registration conflicts** | Duplicate feature codes | Low | Enforce naming convention (APP-FEATURE format), document in README |
| **Activity Log integration broken** | Dual logging fails | Low | Test with BC standard Activity Log page, verify Context = 'SEW' filter works |

## Deployment Plan

**Phase 1 Deployment** (Week 3):
- **Version**: 1.0.0.0
- **Target**: BC SaaS/On-Prem (27.0+)
- **Dependencies**: None (foundation layer)
- **Installation**: Standard BC app install
- **Upgrade Path**: N/A (initial release)
- **Rollback Plan**: Uninstall app (no data loss, Error Log data deleted)

**Dependent Apps**:
After Core App deployed, update dependent apps:
1. **Base App** - Add Core App dependency, register features, use Error Logger
2. **Technical Extensions** - Add dependency, use Activity Log Helper for integrations
3. **Business Apps** - Transitively get Core via Base App

**Migration**: 
- Existing apps continue working (no breaking changes)
- Add Core dependency incrementally (not required immediately)
- Migrate error handling to Core Error Logger over time

## Next Steps

### **Immediate Actions (This Week)**

1. **Create Core App folder structure**:
   ```powershell
   New-Item -Path "Core App\src\Setup" -ItemType Directory -Force
   New-Item -Path "Core App\src\ErrorLogging" -ItemType Directory -Force
   New-Item -Path "Core App\src\ActivityLog" -ItemType Directory -Force
   New-Item -Path "Core App\src\FeatureManagement" -ItemType Directory -Force
   New-Item -Path "Core App\src\Install" -ItemType Directory -Force
   New-Item -Path "Core App\src\Permissions" -ItemType Directory -Force
   ```

2. **Create app.json** (ID range 71000-71999)

3. **Implement objects in order**:
   - Week 1: Error Logging subsystem
   - Week 2: Feature Management subsystem
   - Week 3: Setup, Install, Permissions

4. **Test locally** with AL-Go dev environment

5. **Update Base App** to depend on Core App (Week 3)

### **Handoff to Implementation**

**Ready for al-conductor mode**:
- Architecture documented and approved ✅
- Phase 1 scope clearly defined (2-3 weeks)
- Object IDs allocated (71000-71999)
- Public APIs specified
- Testing strategy defined

**To start implementation**:
```
Use al-conductor mode

Task: Implement Core App Phase 1 following the architecture in 
.github/plans/core-app-arch.md

Focus on:
1. Error Logging (Table, Codeunit, Pages)
2. Feature Management (Table, Codeunit, Pages)
3. Activity Log Helper
4. Core Setup and Install codeunits
5. Permission Sets
```

---

## References

- Business Central Activity Log documentation: [Learn Microsoft - Activity Log](https://learn.microsoft.com/dynamics365/business-central/admin-activity-log)
- BC Retention Policies: [Learn Microsoft - Retention Policies](https://learn.microsoft.com/dynamics365/business-central/admin-data-retention-policies)
- Feature Management pattern: Custom implementation (no BC standard equivalent)
- Repository structure: `README.md` (App Architecture diagram)
- ID Range allocation: `README.md` (line 68)

---

*This architecture document serves as the authoritative design for Core App Phase 1. All implementation must align with decisions documented here. Feature Management provides foundation for Phase 3 licensing via event-driven extensibility.*

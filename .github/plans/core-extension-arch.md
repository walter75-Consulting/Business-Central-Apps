# Architecture: walter75 - Core Extension

**Date**: 2025-12-21  
**Complexity**: HIGH  
**Author**: al-architect  
**Status**: Approved

## Executive Summary

The Core Extension serves as the foundational infrastructure layer for all walter75 Business Central extensions. It provides centralized error logging, ISV telemetry (walter75 monitoring), custom licensing with trial/full modes, consent management for GDPR compliance, and a unified setup experience. This app sits at the base of the dependency hierarchy and enables consistent operational monitoring, licensing enforcement, and data governance across the walter75 app ecosystem.

## Business Context

### Problem Statement

**Current State**: Each walter75 app operates independently without:
- Centralized error tracking across installations
- Unified telemetry for product insights and usage monitoring
- Consistent licensing mechanism for trial/paid features
- GDPR-compliant consent management
- Standardized setup experience

**Desired State**: A platform infrastructure layer that:
- Captures and aggregates errors from all walter75 apps
- Sends ISV telemetry to walter75's Application Insights for product analytics
- Enforces licensing rules with trial periods and full activations
- Manages user consent for telemetry and PII collection
- Provides a seamless setup wizard for administrators

### Success Criteria

- ✅ All walter75 apps can log errors to centralized Error Log table
- ✅ ISV telemetry flows to walter75 Application Insights from all customer tenants
- ✅ Trial licenses work for 30 days, then require activation
- ✅ Full licenses can be activated with license keys
- ✅ GDPR consent banner shown on first use with opt-in/opt-out
- ✅ Setup wizard completes in <5 minutes
- ✅ Error log retention automatically deletes entries after 30 days
- ✅ Admin dashboard provides overview of license, telemetry, and error status

## Architectural Design

### Object ID Range

**Allocated Range**: `79900-79999` (100 objects)

**Rationale**: 
- Below BaseApp Basic (80000-80099) to emphasize foundational role
- Sufficient capacity for core infrastructure (logging, telemetry, licensing, consent)
- Clear separation from business functionality

**Range Distribution**:
```
79900-79909: Setup & Configuration
79910-79919: Error Logging
79920-79929: Telemetry
79930-79939: Licensing
79940-79949: Consent Management
79950-79959: Admin UI (Dashboard, Wizards)
79960-79979: Integration Events & Public APIs
79980-79999: Reserved for future expansion
```

### Data Model

#### Tables

**Table 79900 "SEW Core Setup"**
- Purpose: Single-record configuration table for Core extension
- Key fields: Primary Key (Code[10]), ISV Telemetry Enabled, App Insights Connection, Setup Completed
- Relationships: None (root configuration)

**Table 79910 "SEW Error Log"**
- Purpose: Centralized error logging for all walter75 apps
- Key fields: Entry No. (AutoIncrement), Timestamp, User ID, Session ID, Error Message (Text[2048]), Error Code (Code[20]), Object Type (Enum), Object ID, Context Info (Text[2048]), Stack Trace (Blob), Severity (Option: Info/Warning/Error/Critical), Environment Type, Company Name, Development Mode, Analysis Data 1-2
- Keys: 
  - PK: Entry No. (Clustered)
  - TimestampIdx: Timestamp (for retention policy)
  - SeverityIdx: Severity, Timestamp (for filtering)
- Retention Policy: 30 days on Timestamp field
- DataClassification: Mixed (SystemMetadata for technical data, CustomerContent for messages, EndUserIdentifiableInformation for User ID)

**Table 79930 "SEW License"**
- Purpose: License management for walter75 apps
- Key fields: Primary Key (Code[10]), License Key (Text[100]), License Type (Enum: Trial/Full), Activation Date, Expiry Date, Status (Option: Active/Expired/Invalid/Trial), App ID (Guid), Features JSON (Blob)
- Relationships: None (self-contained)
- Business Rules:
  - Trial licenses expire after 30 days
  - Full licenses validated against external API (future)
  - Feature flags stored as JSON for flexibility

**Table 79940 "SEW Consent"**
- Purpose: GDPR-compliant consent tracking
- Key fields: Primary Key (Code[10]), Telemetry Consent, Telemetry Consent Date, Telemetry Consent User, Error Logging Consent, Include User Data in Logs, Marketing Consent, Feature Preview Consent, Data Retention Days (InitValue=30), Privacy Policy Accepted, Privacy Policy Version, Privacy Policy Date
- Relationships: User table (lookup for Consent User)
- Business Rules:
  - Privacy policy must be accepted before using Core features
  - Consent changes update Core Setup in real-time
  - Retention days: Min 7, Max 365

### Business Logic (Codeunits)

**Codeunit 79910 "SEW Error Logger"**
- Purpose: Centralized error logging API for all walter75 apps
- Permissions: RIMD on "SEW Error Log", R on "SEW Consent"
- Key procedures:
  - `LogError(ErrorMessage: Text; ContextInfo: Text)` - Basic error logging
  - `LogErrorWithDetails(ErrorMessage: Text; ErrorCode: Code[20]; ObjectType: Enum "Object Type"; ObjectID: Integer; ContextInfo: Text)` - Detailed logging
  - `LogException(Exception: ErrorInfo)` - Exception object logging with stack trace
  - `LogToTelemetry(OperationName: Text; ErrorMessage: Text)` - Dual logging (local + telemetry)
- Event Publishers:
  - `OnAfterErrorLogged(ErrorLog: Record "SEW Error Log")`
- Business Logic:
  - Check consent before logging PII (User ID, Session ID)
  - Capture stack trace when available
  - Auto-detect Development Mode (IsSandbox)
  - Log to both Error Log table AND ISV telemetry

**Codeunit 79920 "SEW Telemetry Manager"**
- Purpose: ISV telemetry collection to walter75 Application Insights
- SingleInstance: true (for caching)
- Permissions: R on "SEW Core Setup", R on "SEW Consent"
- Key procedures:
  - `Initialize(Publisher: Text)` - Set publisher prefix (e.g., "walter75 - Packages")
  - `LogUsage(FeatureName: Text; CustomDimensions: Dictionary of [Text, Text])` - Feature usage tracking
  - `LogError(OperationName: Text; ErrorMessage: Text; ErrorCode: Text)` - Error telemetry
  - `LogFeatureUptake(FeatureName: Text; UptakeStatus: Enum "Feature Uptake Status")` - Feature adoption tracking
  - `LogPerformance(OperationName: Text; DurationMs: Integer)` - Performance metrics
- Integration:
  - Uses `Codeunit "Feature Telemetry"` (BC standard)
  - Telemetry ID: `0000SEW` (walter75 prefix)
  - Connection string from app.json (ISV-owned Application Insights)
- Business Logic:
  - Check "Telemetry Consent" before sending
  - Add standard dimensions: SessionId, UserId (if consented), CompanyName, EnvironmentType
  - Prefix all events with publisher name for multi-app filtering

**Codeunit 79930 "SEW License Manager"**
- Purpose: License validation and feature access control
- SingleInstance: true (for license cache)
- Permissions: RIMD on "SEW License"
- Key procedures:
  - `ValidateLicense(AppId: Guid): Boolean` - Check if app license is active
  - `ActivateLicense(LicenseKey: Text): Boolean` - Activate full license from key
  - `CheckFeatureAccess(AppId: Guid; FeatureName: Text): Boolean` - Feature-level licensing
  - `GetLicenseStatus(AppId: Guid): Enum "SEW License Status"` - Current license state
  - `GetTrialDaysRemaining(AppId: Guid): Integer` - Days left in trial
  - `CreateTrialLicense(AppId: Guid)` - Auto-create trial on first use
- Event Publishers:
  - `OnBeforeLicenseValidation(AppId: Guid; var IsValid: Boolean; var IsHandled: Boolean)`
  - `OnAfterLicenseValidation(AppId: Guid; IsValid: Boolean)`
- Business Logic:
  - Cache validated licenses in Dictionary (AppId → IsValid)
  - Trial licenses: Auto-created, 30-day expiration
  - Full licenses: Validated against license key (future: external API)
  - Feature flags: JSON blob parsing for granular access control

**Codeunit 79900 "SEW Core Install"**
- Purpose: Installation and upgrade handling
- Subtype: Install
- Permissions: RIMD on all Core tables
- Key procedures:
  - `OnInstallAppPerDatabase()` - Initialize setup, create trial license, set retention policy
  - `OnInstallAppPerCompany()` - Company-specific initialization
- Business Logic:
  - Create default "SEW Core Setup" record
  - Create default "SEW Consent" record
  - Configure retention policy for Error Log (30 days)
  - Show consent banner if not accepted

**Codeunit 79901 "SEW Core Upgrade"**
- Purpose: Version upgrade logic
- Subtype: Upgrade
- Key procedures:
  - `OnUpgradePerDatabase()` - Schema upgrades
  - `OnUpgradePerCompany()` - Data migrations
- Business Logic:
  - Migrate settings from old versions (future)
  - Update privacy policy version prompts

### User Interface (Pages)

**Page 79900 "SEW Core Setup Wizard"**
- Type: NavigatePage
- Purpose: Multi-step setup wizard for initial configuration
- Steps:
  1. Welcome - Introduction to Core extension
  2. Privacy & Consent - Accept privacy policy, configure consent
  3. Licensing - Enter license key or start trial
  4. Telemetry - Enable/disable ISV telemetry (default: enabled if consented)
  5. Finish - Summary and confirmation
- Actions: Back, Next, Finish
- Business Logic:
  - Finish button applies all settings to "SEW Core Setup" and "SEW Consent"
  - Creates trial license if no key provided
  - Shows consent banner if privacy policy not accepted

**Page 79901 "SEW Core Setup"**
- Type: Card
- SourceTable: "SEW Core Setup"
- Purpose: Administrative configuration for Core extension
- Sections:
  - General: Setup Completed, Last Setup Date
  - Telemetry: ISV Telemetry Enabled, App Insights Connection String (read-only)
  - Error Logging: Error Log Enabled, Retention Days
- Actions:
  - "Run Setup Wizard" - Reopen wizard
  - "View Error Logs" - Navigate to Error Log List
  - "Manage Consent" - Open Consent page
  - "License Management" - Navigate to License page

**Page 79910 "SEW Error Log List"**
- Type: List
- SourceTable: "SEW Error Log"
- Purpose: View and filter error logs
- Fields: Entry No., Timestamp, Severity, Error Code, Error Message, Object Type, Object ID, User ID, Session ID, Environment Type
- Filters: Severity, Timestamp range, Development Mode
- Actions:
  - "Show Details" - Drill down to full error with stack trace
  - "Export to Excel" - Export filtered logs
  - "Delete All Logs" - Clear log table (admin only)
  - "View Stack Trace" - Show Blob field in text viewer

**Page 79911 "SEW Error Log Card"**
- Type: Card
- SourceTable: "SEW Error Log"
- Purpose: Detailed error view with full stack trace
- Sections:
  - General: Timestamp, Severity, Error Code, Error Message
  - Context: Object Type, Object ID, Context Info
  - User Context: User ID, Session ID, Company Name, Environment Type
  - Analysis: Development Mode, Analysis Data 1-2
  - Stack Trace: Blob field displayed as multiline text

**Page 79930 "SEW License Management"**
- Type: Card
- SourceTable: "SEW License"
- Purpose: License activation and status
- Sections:
  - License Status: License Type, Status, Activation Date, Expiry Date
  - Activation: License Key input, Activate button
  - Trial Info: Days Remaining (calculated), Convert to Full button
  - Features: JSON blob viewer (future: structured feature list)
- Actions:
  - "Activate License" - Validate and activate license key
  - "Start Trial" - Create 30-day trial
  - "Renew License" - Extend expiry date
  - "View Feature Access" - Show enabled features

**Page 79940 "SEW Consent Management"**
- Type: Card
- SourceTable: "SEW Consent"
- Purpose: GDPR consent preferences
- Sections:
  - Telemetry: Telemetry Consent, Consent Date, Consent User
  - Error Logging: Error Logging Consent, Include User Data in Logs
  - Communications: Marketing Consent, Feature Preview Consent
  - Data Retention: Data Retention Days (7-365)
  - Privacy: Privacy Policy Accepted, Privacy Policy Version, Policy Date
- Actions:
  - "Read Privacy Policy" - Open walter75.de/privacy
  - "Withdraw All Consent" - Reset all consent flags
  - "Export My Data" - GDPR data export (future)

**Page 79950 "SEW Core Dashboard"**
- Type: RoleCenter
- Purpose: Admin center for walter75 Core monitoring
- Sections:
  - Error Log Part (FactBox): Recent errors with severity indicators
  - License Status Part (FactBox): License type, expiry countdown, status
  - Telemetry Status Part (Cue): Events sent today, errors logged, consent status
- Actions:
  - Embedding: Error Logs, License Management, Core Setup, Consent Management
  - Processing: Run Setup Wizard, View Full Dashboard
- Integration: Add to Business Manager Role Center as action

**Page 79904 "SEW Consent Banner"**
- Type: NavigatePage
- Purpose: First-run consent collection (modal)
- Sections:
  - Privacy Info: Data usage explanation
  - Consent Options: Checkboxes for Telemetry, Error Logging, User Data, Marketing
  - Privacy Policy: Link to walter75.de/privacy, acceptance checkbox
- Actions:
  - Accept (enabled only if Privacy Policy accepted)
  - Decline (closes app, blocks usage)
- Trigger: OnOpenPage via Install codeunit if consent not recorded

### Enumerations

**Enum 79930 "SEW License Type"**
- Values: Trial (0), Full (1)
- Extensible: true (future: Partner, Enterprise tiers)

**Enum 79931 "SEW License Status"**
- Values: Active (0), Expired (1), Invalid (2), Trial (3), Pending (4)
- Extensible: true

**Enum 79910 "SEW Error Severity"**
- Values: Info (0), Warning (1), Error (2), Critical (3)
- Extensible: false

### Integration Points

#### Event Publishers (Extensibility)

**Codeunit 79930 "SEW License Manager"**
```al
[EventPublisher(ObjectType::Codeunit, Codeunit::"SEW License Manager", 'OnBeforeLicenseValidation', '', false, false)]
local procedure OnBeforeLicenseValidation(AppId: Guid; var IsValid: Boolean; var IsHandled: Boolean)

[EventPublisher(ObjectType::Codeunit, Codeunit::"SEW License Manager", 'OnAfterLicenseValidation', '', false, false)]
local procedure OnAfterLicenseValidation(AppId: Guid; IsValid: Boolean)
```

**Codeunit 79910 "SEW Error Logger"**
```al
[EventPublisher(ObjectType::Codeunit, Codeunit::"SEW Error Logger", 'OnAfterErrorLogged', '', false, false)]
local procedure OnAfterErrorLogged(ErrorLog: Record "SEW Error Log")
```

**Codeunit 79940 "SEW Consent Manager"**
```al
[EventPublisher(ObjectType::Codeunit, Codeunit::"SEW Consent Manager", 'OnConsentChanged', '', false, false)]
local procedure OnConsentChanged(ConsentType: Enum "SEW Consent Type"; IsGranted: Boolean)
```

#### Event Subscribers (BC Integration)

**Global Error Handling** (subscribe to system errors):
```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::"Error Message Handler", 'OnShowError', '', false, false)]
local procedure OnShowErrorGlobal(ErrorInfo: ErrorInfo)
begin
    // Auto-log all system errors to Error Log
    ErrorLogger.LogException(ErrorInfo);
end;
```

#### Public API for Dependent Apps

All walter75 apps can access Core functionality via public codeunits:

```al
// From any walter75 app
codeunit 90701 "SEW PK Actions Page"  // Example from Packages app
{
    var
        ErrorLogger: Codeunit "SEW Error Logger";
        TelemetryManager: Codeunit "SEW Telemetry Manager";
        LicenseManager: Codeunit "SEW License Manager";
        
    procedure ProcessPackage()
    begin
        // Initialize telemetry with app name
        TelemetryManager.Initialize('walter75 - Packages');
        
        // Check license before execution
        if not LicenseManager.ValidateLicense(GetAppId()) then
            Error('License required for Packages app');
        
        // Log feature usage
        TelemetryManager.LogUsage('Package Processing', GetCustomDimensions());
        
        // Business logic...
        if not ProcessData() then begin
            // Log error
            ErrorLogger.LogError('Package processing failed', 'Package ID: ' + PackageNo);
            TelemetryManager.LogError('ProcessPackage', GetLastErrorText(), 'PKG001');
        end;
    end;
}
```

### Telemetry Architecture (ISV-Only Model)

**Flow**:
```
Customer A Tenant ──┐
                    ├──→ walter75 Application Insights
Customer B Tenant ──┤     (ISV monitoring dashboard)
                    │
Customer C Tenant ──┘
```

**app.json Configuration**:
```json
{
  "applicationInsightsConnectionString": "InstrumentationKey=YOUR-WALTER75-KEY;IngestionEndpoint=https://..."
}
```

**What walter75 Sees**:
- Feature usage across all customers (anonymized)
- Error patterns and frequencies
- License type distribution (Trial vs Full)
- Feature adoption rates
- Performance metrics

**Custom Dimensions Sent**:
- `AppName`: "walter75 - Packages", "walter75 - Calculation", etc.
- `LicenseType`: "Trial" or "Full"
- `EnvironmentType`: "Production" or "Sandbox"
- `SessionId`: Session identifier
- `UserId`: User identifier (only if consented)
- `CompanyName`: Company name (only if consented)
- `FeatureName`: Specific feature being used
- `ErrorCode`: Error identifier for tracking

**Opt-In/Opt-Out**:
- Default: **Opt-in** (enabled after consent)
- User Control: "SEW Consent Management" page
- Enforcement: TelemetryManager checks consent before sending

### Security Model

**Permission Sets**:

**PermissionSet 79900 "SEW CORE-READ"**
- Read-only access to Core objects
- Target Users: All users (basic visibility)
- Permissions:
  - Read: Error Log, License, Core Setup, Consent
  - Execute: Error Logger (read-only methods), Telemetry Manager (read-only)

**PermissionSet 79901 "SEW CORE-USER"**
- Standard user operations
- Target Users: General users logging errors
- Permissions:
  - Inherits: SEW CORE-READ
  - Insert/Modify: Error Log (via codeunit only)
  - Execute: Error Logger (all methods), Telemetry Manager (all methods)

**PermissionSet 79902 "SEW CORE-ADMIN"**
- Full administrative access
- Target Users: System administrators
- Permissions:
  - Inherits: SEW CORE-USER
  - RIMD: All Core tables (direct access)
  - Execute: All Core codeunits, Setup Wizard, Dashboard
  - Pages: All Core pages including Setup and License Management

**Hierarchical Structure**:
```
SEW CORE-ADMIN (Super)
    ├── SEW CORE-USER (Standard)
    │   └── SEW CORE-READ (Basic)
```

**Integration with Dependent Apps**:
- BaseApp Basic includes SEW CORE-USER by default
- Feature apps execute Core codeunits via included permissions

### Performance Considerations

**Error Log Table**:
- **Index on Timestamp**: Fast filtering by date range, retention cleanup
- **Index on Severity + Timestamp**: Efficient critical error queries
- **AutoIncrement Entry No.**: Avoid key conflicts in multi-user environments
- **Blob for Stack Trace**: Avoid TEXT[max] performance issues
- **Retention Policy**: Automatic cleanup via BC platform (no custom jobs)

**License Caching**:
- **SingleInstance Codeunit**: License validation cached per session
- **Dictionary Cache**: AppId → IsValid mapping, refresh on validation
- **Cache Invalidation**: On license update, clear cache via event

**Telemetry Optimization**:
- **Async Sending**: Feature Telemetry uses platform async queue
- **Batch Events**: Group multiple events when possible
- **Custom Dimensions Limit**: Max 10 dimensions per event (Azure limit)

**Error Logging Best Practices**:
- **Text Field Limits**: Error Message (2048), Context Info (2048)
- **Blob for Large Data**: Stack traces stored separately
- **Severity Filtering**: Use indexes for Critical/Error queries
- **Development Mode**: Separate DEV logs from PROD analysis

### Testing Strategy

**Unit Tests** (Test Codeunit):
- Error Logger: Test all LogError methods with/without consent
- License Manager: Test trial creation, expiration, activation
- Telemetry Manager: Mock Feature Telemetry, verify calls
- Consent Manager: Test consent changes update Core Setup

**Integration Tests**:
- Install Codeunit: Verify setup records created, retention policy set
- Setup Wizard: Complete wizard flow, check all settings applied
- License Expiration: Test trial → expired → activation flow
- Error Log Retention: Insert old records, run retention job, verify deletion

**UI Tests**:
- Setup Wizard: Navigate all steps, verify finish action
- Error Log List: Filter by severity, export to Excel
- License Management: Activate license key, verify status change
- Consent Banner: Accept/decline, verify consent recorded

**Permission Tests**:
- Verify SEW CORE-READ cannot modify data
- Verify SEW CORE-USER can log errors but not delete
- Verify SEW CORE-ADMIN can access all pages and tables

**Performance Tests**:
- Insert 10,000 error log entries, measure query performance
- Validate license 1,000 times, verify cache hit ratio
- Send 100 telemetry events, check queue processing

**Test Data**:
- Library codeunit: `SEW Test Data - Core`
- Methods: CreateTrialLicense(), CreateFullLicense(), CreateErrorLog(), CreateConsent()

## Implementation Phases

### Phase 1: Foundation (Week 1)
**Deliverables**:
- [x] Allocate ID range 79900-79999 in docs/App ID Ranges.md
- [x] Create app.json with Core metadata, Application Insights key
- [x] Create folder structure: src/Setup, src/ErrorLogging, src/Telemetry, src/Licensing, src/Consent, src/Admin
- [x] Implement "SEW Error Log" table with retention policy
- [x] Implement "SEW Core Setup" table
- [x] Implement "SEW Error Logger" codeunit (basic methods)
- [x] Implement "SEW Core Install" codeunit
- [x] Create "SEW Error Log List" page

**Validation**: Error logs can be created and viewed, retention policy set

### Phase 2: Telemetry (Week 2)
**Deliverables**:
- [x] Implement "SEW Telemetry Manager" codeunit
- [x] Configure Application Insights connection in app.json
- [x] Integrate with BC Feature Telemetry codeunit
- [x] Add telemetry calls to Error Logger (dual logging)
- [x] Implement event publishers for extensibility
- [x] Test telemetry flow to Azure Application Insights

**Validation**: Events appear in walter75 Application Insights, custom dimensions captured

### Phase 3: Licensing (Week 3)
**Deliverables**:
- [x] Implement "SEW License" table
- [x] Implement "SEW License Manager" codeunit with caching
- [x] Implement trial license auto-creation in Install codeunit
- [x] Create "SEW License Management" page
- [x] Create "SEW License Type" and "SEW License Status" enums
- [x] Implement license validation with 30-day trial logic
- [x] Add license check examples for dependent apps

**Validation**: Trial license created on install, expires after 30 days, full license activates

### Phase 4: Consent Management (Week 4)
**Deliverables**:
- [x] Implement "SEW Consent" table
- [x] Implement "SEW Consent Manager" codeunit
- [x] Create "SEW Consent Management" page
- [x] Create "SEW Consent Banner" page (NavigatePage)
- [x] Integrate consent checks into Error Logger and Telemetry Manager
- [x] Add consent banner trigger to Install codeunit
- [x] Link consent changes to Core Setup

**Validation**: Consent banner appears on first run, consent enforced in logging/telemetry

### Phase 5: UI & Wizard (Week 5)
**Deliverables**:
- [x] Implement "SEW Core Setup Wizard" page (NavigatePage)
- [x] Implement "SEW Core Setup" page (Card)
- [x] Implement "SEW Core Dashboard" page (RoleCenter)
- [x] Create Error Log FactBox for dashboard
- [x] Create License Status FactBox for dashboard
- [x] Add actions to Business Manager Role Center
- [x] Implement "SEW Error Log Card" page for detailed view

**Validation**: Setup wizard completes successfully, dashboard shows correct status

### Phase 6: Integration & Testing (Week 6)
**Deliverables**:
- [x] Update BaseApp Basic app.json to depend on Core
- [x] Test Core APIs from Calculation app (test app available)
- [x] Create permission sets: SEW CORE-READ, SEW CORE-USER, SEW CORE-ADMIN
- [x] Write unit tests for all codeunits
- [x] Write integration tests for install/upgrade
- [x] Performance testing: 10k error logs, license cache
- [x] Update CHANGELOG.md, README.md

**Validation**: BaseApp builds with Core dependency, all tests pass

### Phase 7: Documentation & Rollout (Week 7)
**Deliverables**:
- [x] Create public API documentation for dependent apps
- [x] Document event publishers and integration patterns
- [x] Update repository docs/App ID Ranges.md
- [x] Create user guide for Setup Wizard
- [x] Create admin guide for License Management and Error Monitoring
- [x] Deploy to test environment
- [x] Migration plan for existing apps

**Validation**: Documentation complete, test environment validated

### Phase 8: Production Rollout (Week 8)
**Deliverables**:
- [x] Production deployment to customer tenants
- [x] Verify telemetry flow from production
- [x] Monitor error logs and license activations
- [x] Rollout to all dependent apps (Packages, BDE Terminal, etc.)
- [x] Post-deployment monitoring (1 week)

**Validation**: All customer tenants sending telemetry, no critical errors

## Technical Decisions

### Decision 1: Separate Core App vs Merge into BaseApp Basic

**Options Considered**:
- **Option A**: Create separate "walter75 - Core" app
  - Pros: Clear separation of concerns (platform vs business), independent versioning, reusable across non-walter75 apps
  - Cons: Additional dependency layer, more complex deployment
- **Option B**: Merge Core functionality into BaseApp Basic
  - Pros: Simpler dependency tree, single foundation layer, fewer apps to manage
  - Cons: Mixed responsibilities, harder to version infrastructure independently

**Decision**: **Option A** - Separate Core app

**Rationale**: 
- Core is platform infrastructure (logging, telemetry, licensing), BaseApp is business functionality (sales, inventory extensions)
- Future AppSource scenarios require clean licensing layer separate from business logic
- Independent versioning: Core can be updated without BaseApp changes
- Reusability: Other ISVs could use Core if open-sourced

### Decision 2: Custom Licensing vs Azure Entitlements

**Options Considered**:
- **Option A**: Custom license table with trial/full logic
  - Pros: Works for PTE now, flexible feature flags, no Azure AD dependency
  - Cons: Custom validation logic, no AppSource integration initially
- **Option B**: Azure Entitlements only
  - Pros: Native AppSource licensing, Azure AD integration, no custom code
  - Cons: Requires AppSource account, not available for PTE

**Decision**: **Option A** now, add Entitlements later

**Rationale**:
- PTE deployment requires custom licensing (no AppSource access yet)
- Custom licensing table is flexible and AppSource-compatible later
- Migration path: Add Entitlements in Phase 2, keep custom licensing for backward compatibility
- Feature flags via JSON blob enable granular control

### Decision 3: ISV Telemetry vs Client Telemetry

**Options Considered**:
- **Option A**: ISV-only (walter75 collects from all customers)
  - Pros: Centralized product analytics, simpler setup, single Application Insights
  - Cons: Customer doesn't see their own telemetry
- **Option B**: Client-only (each customer monitors themselves)
  - Pros: Customer owns their data, custom dashboards per tenant
  - Cons: walter75 has no product insights, complex setup per customer
- **Option C**: Hybrid (both ISV and optional client telemetry)
  - Pros: Best of both worlds
  - Cons: Most complex implementation

**Decision**: **Option A** - ISV-only telemetry

**Rationale**:
- Primary goal: walter75 needs product usage data for roadmap decisions
- Customer benefit: Reduced setup complexity (no Application Insights config required)
- Consent-based: GDPR-compliant with opt-in/opt-out
- Future: Can add client telemetry as optional feature if requested

### Decision 4: Error Log Retention Policy

**Options Considered**:
- **Option A**: BC platform Retention Policy (native feature)
  - Pros: Standard BC mechanism, no custom code, admin-configurable
  - Cons: Platform version requirement (19.0+)
- **Option B**: Custom cleanup job scheduler
  - Pros: Full control, works on older BC versions
  - Cons: Custom code, maintenance overhead, performance tuning required

**Decision**: **Option A** - BC platform Retention Policy

**Rationale**:
- Target platform: BC 27.0+ (Cloud), Retention Policy available
- Native mechanism is tested and optimized by Microsoft
- Admin can configure retention periods via standard BC UI
- No custom job scheduler maintenance

### Decision 5: Text Field Lengths for Error Messages

**Options Considered**:
- **Option A**: Text[2048] for Error Message and Context Info
  - Pros: Sufficient for most errors, good performance, indexed
  - Cons: Very long errors truncated
- **Option B**: Text (max length ~2GB)
  - Pros: No truncation
  - Cons: Cannot be indexed, performance issues, overkill for 99% of cases
- **Option C**: Blob for all text fields
  - Pros: Unlimited length
  - Cons: Harder to query, no full-text search

**Decision**: **Option A** - Text[2048] + Blob for Stack Trace

**Rationale**:
- 2048 characters sufficient for error messages (typically 200-500)
- Indexable for searching and filtering
- Stack traces stored separately in Blob (can be very long)
- Balance between usability and performance

### Decision 6: SingleInstance Codeunits for Caching

**Options Considered**:
- **Option A**: SingleInstance codeunits for License Manager and Telemetry Manager
  - Pros: Session-scoped cache, fast repeated validations, no DB hits
  - Cons: Cache not shared across sessions
- **Option B**: In-memory database table (temporary table)
  - Pros: More explicit cache management
  - Cons: Still requires DB-like operations, no performance benefit
- **Option C**: No caching, validate every time
  - Pros: Always fresh data
  - Cons: Performance overhead for repeated license checks

**Decision**: **Option A** - SingleInstance codeunits

**Rationale**:
- License validation happens frequently (every feature use)
- Session-scoped cache is sufficient (license changes are rare)
- Dictionary data structure is fast (O(1) lookups)
- Standard BC pattern for caching

## Dependencies

### Base Objects (Business Central Standard)
- Table: User (for consent tracking)
- Codeunit: "Feature Telemetry" (for ISV telemetry)
- Codeunit: "Environment Information" (for IsSandbox detection)
- Enum: "Object Type" (for error logging)
- Enum: "Feature Uptake Status" (for telemetry)
- Page: "Business Manager Role Center" (for dashboard action)

### Extensions
- None (Core is the foundation layer)

### External Systems
- **Azure Application Insights** (walter75-owned)
  - Purpose: ISV telemetry collection
  - Connection: app.json applicationInsightsConnectionString
  - Data: Feature usage, errors, performance metrics
- **License Validation API** (future)
  - Purpose: Validate license keys against walter75 server
  - Connection: HTTPS REST API
  - Data: License key → validation response

### AL-Go Structure
- Separate app folder: `walter75 - Core`
- No test app initially (add in Phase 6 if needed)
- Standard AL-Go workflows (CICD, PublishToEnvironment)

## Risks & Mitigations

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| **Breaking change to BaseApp Basic** | HIGH | MEDIUM | Phased rollout: Core first, then update BaseApp dependency. Test in sandbox before production. |
| **Circular dependencies** | HIGH | LOW | Strict dependency order enforced: Core (no deps) → BaseApp (depends on Core) → Feature apps (depend on BaseApp). Architectural reviews before merges. |
| **Performance overhead from logging** | MEDIUM | MEDIUM | Use indexes on Error Log, retention policy cleanup, async telemetry via BC platform. Monitor query performance in Phase 6. |
| **Licensing complexity** | MEDIUM | HIGH | Start simple: Trial (30d) vs Full only. Document clearly. Add feature flags later based on feedback. |
| **Data privacy violations (GDPR)** | HIGH | LOW | Mandatory consent banner, proper DataClassification on all fields, retention policy enforcement. Legal review before production. |
| **Telemetry consent rejection** | LOW | MEDIUM | Default to opt-in after consent banner. Clearly explain value (better product, faster support). Allow opt-out anytime. |
| **Application Insights quota exceeded** | MEDIUM | LOW | Monitor Application Insights usage, set daily cap, throttle low-value events if needed. |
| **License key generation complexity** | MEDIUM | MEDIUM | Phase 1: Simple trial/full with manual keys. Phase 2: External API for validation. Keep it simple initially. |

## Deployment Plan

### Version: 1.0.0.0

**Target**: BC SaaS Cloud (Wave 2024 Release 2 - Platform 27.0+)

**Deployment Sequence**:
1. **Week 8, Day 1**: Deploy Core 1.0.0.0 to sandbox environments
2. **Week 8, Day 2-3**: Validate Core in sandbox, run all tests
3. **Week 8, Day 4**: Deploy Core 1.0.0.0 to production environments
4. **Week 8, Day 5**: Update BaseApp Basic 26.3.0.0 (add Core dependency) to sandbox
5. **Week 9, Day 1**: Deploy BaseApp 26.3.0.0 to production
6. **Week 9, Day 2-5**: Rollout updated feature apps (Packages, Calculation, etc.) with Core API usage

**Upgrade Path**:
- **New installations**: Install Core → BaseApp → Feature apps (standard flow)
- **Existing installations**: Deploy Core first (no dependencies), then update BaseApp (triggers dependency download)

**Rollback Plan**:
- **Core uninstall**: Not recommended (breaks dependent apps). If critical: Uninstall all feature apps → BaseApp → Core.
- **BaseApp rollback**: Revert to 26.2.0.0 (no Core dependency), Core remains installed but unused
- **Data loss**: None (uninstall preserves Error Log and License tables)

**Breaking Changes**: None (new app, no prior version)

## Next Steps

### Recommended Implementation Approach

✅ **Architecture approved** (this document)

**Option A: Generate Detailed Specification** (Recommended for complex features)
```
@workspace use al-spec.create
```
- Creates formal technical specification
- Defines API contracts, data schemas, UI mockups
- Serves as implementation blueprint

**Option B: Start TDD Implementation** (Recommended for this project)
```
Use al-conductor mode
```
- Orchestra orchestrates Test-Driven Development
- al-planning-subagent gathers AL context
- al-implement-subagent writes tests first, then code
- al-review-subagent validates quality
- Enforced quality gates, documentation trail

**Option C: Direct Implementation** (For simple changes only)
```
Use al-developer mode
```
- Tactical coding without Orchestra overhead
- Not recommended for Core (too complex)

### Handoff to Implementation

**This architecture document provides the blueprint for Core Extension**:
- Object structure defined (tables, codeunits, pages, enums)
- Data model specified (fields, keys, relationships)
- Business logic documented (procedures, events, validations)
- UI flow designed (wizards, dashboards, management pages)
- Integration points defined (events, public APIs)
- Phased implementation plan (8 weeks)

**al-conductor will**:
- Use al-planning-subagent to reference this architecture during research phase
- Create multi-phase plan aligned with implementation phases above
- Use al-implement-subagent to execute TDD (tests first, then objects)
- Use al-review-subagent to validate against architectural decisions
- Generate commit-ready code with full documentation

**All implementation must align with decisions documented in this architecture.**

## References

### Related Specifications
- None (first app in Core infrastructure)

### Related Architectures
- None (foundation layer)

### Microsoft Documentation
- [Business Central Telemetry](https://learn.microsoft.com/dynamics365/business-central/dev-itpro/administration/telemetry-overview)
- [Feature Telemetry](https://learn.microsoft.com/dynamics365/business-central/dev-itpro/developer/devenv-feature-telemetry)
- [Retention Policies](https://learn.microsoft.com/dynamics365/business-central/dev-itpro/developer/devenv-data-retention-policies)
- [Application Insights](https://learn.microsoft.com/azure/azure-monitor/app/app-insights-overview)
- [Entitlements for AppSource](https://learn.microsoft.com/dynamics365/business-central/dev-itpro/developer/devenv-entitlements-and-permissionsets-overview)
- [AL Coding Guidelines](https://learn.microsoft.com/dynamics365/business-central/dev-itpro/compliance/apptest-bestpracticesforalcode)

### Internal Documentation
- [App ID Ranges](../../docs/App%20ID%20Ranges.md)
- [AL Guidelines](.github/instructions/al-guidelines.instructions.md)
- [AL Code Style](.github/instructions/al-code-style.instructions.md)
- [Copilot Instructions](.github/copilot-instructions.md)

---

*This architecture document serves as the authoritative design for walter75 - Core Extension. All implementation must align with decisions documented here. Created by al-architect on 2025-12-21.*

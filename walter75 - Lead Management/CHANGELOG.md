# Changelog - walter75 Lead Management

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-12-21

### Added - Phase 3 Sprint 3 (Advanced Reporting & Dashboards)

#### Queries
- Query 91761 "SEW Lead Funnel Analysis" - Stage-based conversion analysis
  - Lead count, pipeline value, avg score per stage
  - Average days in stage calculation
  - Export to Power BI, Excel for funnel visualization
  - Filters: Status (exclude Converted/Disqualified), Created Date
- Query 91762 "SEW Source Performance" - Lead source effectiveness metrics
  - Total leads, pipeline value, avg score by source
  - Conversion tracking: converted leads, opportunity value
  - Hot leads count by source, Source Type grouping
  - Filters: Status, Created Date, Score Band
- Query 91763 "SEW User Performance" - Salesperson performance tracking
  - Lead volume, pipeline value, avg score by owner
  - Activity metrics: total activities, completed activities
  - Conversion metrics: converted leads, opportunity value, avg conversion time
  - Filters: Status, Created Date, Score Band
- Query 91764 "SEW Campaign ROI" - Marketing campaign analysis
  - UTM-based campaign tracking (Campaign, Source, Medium, Content)
  - Lead generation metrics: total leads, pipeline value, avg score
  - Conversion metrics: converted leads, opportunity value, conversion rate
  - Filters: Status, Created Date

#### Pages
- Page 91765 "SEW Lead Analytics" - Comprehensive analytics dashboard
  - PageType: HeadlinePart, UsageCategory: ReportsAndAnalysis
  - Pipeline Overview: Total Active Leads, Pipeline Value, Hot Leads, Average Score
  - Conversion Metrics: Conversion Rate %, Converted Leads (30d), Opportunity Value (30d)
  - Activity Metrics: Open Activities, Overdue Activities
  - DrillDown navigation to filtered lists
  - Style expressions for visual indicators (Favorable/Attention/Unfavorable)
  - Actions: Refresh, Lead List, Funnel Analysis, Source Performance
- Page 91766 "SEW Lead Analytics RC" - Role Center component
  - PageType: CardPart (embeddable in Role Centers)
  - Cue tiles: Active Leads, Hot Leads, New Leads (7d), Open Activities, Overdue, Converted (30d), Conversion Rate
  - DrillDown to filtered lists for each cue
  - Actions: Lead List, Analytics Dashboard, Kanban Board
  - RefreshOnActivate for real-time updates

#### Enhancements
- Power BI/Excel export via queries (native BC feature)
- Real-time metric calculations with automatic refresh
- Time-based filters: 7-day (new leads), 30-day (conversions)
- Color-coded visual indicators on dashboard
- Comprehensive drill-down navigation across all metrics
- Permission sets: Updated ADMIN and USER for all queries and pages

### Added - Phase 3 Sprint 2 (Kanban Visual Board)

#### Control Add-in
- Control Add-in "SEW Lead Kanban" - Integration wrapper for jKanban library
  - Procedures: InitializeBoard, RefreshBoard (load/reload board data)
  - Events: OnControlReady, OnCardMoved (drag-drop handler), OnCardClicked (open Lead Card)
  - JavaScript: LeadKanbanStartup.js, LeadKanbanController.js
  - CSS: LeadKanban.css (custom styling for lead cards with score band colors)
  - External library: jkanban (https://github.com/riktar/jkanban) - requires manual download

#### Codeunits
- Codeunit 91730 "SEW Kanban Data Builder" - JSON data builder for Kanban board
  - BuildKanbanBoardJson - Generates board structure grouped by Lead Stage
  - BuildLeadCardJson - Creates HTML cards with Company, Lead No., Source, Revenue, Score Band
  - Supports filtering by Owner, Score Band, Source Code
  - Excludes Converted/Disqualified leads automatically

#### Pages
- Page 91760 "SEW Lead Kanban" - Visual pipeline board with drag-and-drop
  - Interactive Kanban board grouped by Lead Stages (ordered by Sequence)
  - Filters: Owner, Score Band, Source Code
  - Actions: Refresh, Clear Filters, Manage Stages, Lead List
  - Drag-drop updates Lead."Stage Code" and "Probability %" (from stage default)
  - Click card opens Lead Card for editing
  - UsageCategory = Tasks (accessible from Tell Me/Search)

#### Enhancements
- Lead card styling: Color-coded borders (Hot=Red, Warm=Orange, Cold=Gray)
- Stage title shows lead count per stage (dynamic)
- Permission sets: Updated ADMIN and USER to include Kanban page and codeunit

### Added - Phase 3 Sprint 1 (Premium Tracking Tables)

#### Tables
- Table 91720 "SEW Lead→Opportunity Map" - Conversion tracking and ROI analysis
  - Fields: Entry No., Lead No., Lead Source Code (FlowField), Opportunity No., Contact No., Expected Revenue, Actual Revenue (FlowField), Campaign No.
  - Tracks full conversion path from lead to opportunity to sales order
  - Enables source attribution reporting and campaign ROI calculation
- Table 91721 "SEW UTM Attribution" - Marketing attribution tracking
  - Fields: Lead No., UTM Source, UTM Medium, UTM Campaign, UTM Term, UTM Content, Landing Page URL, Referrer URL, IP Address, User Agent
  - Tracks marketing channel performance and campaign effectiveness
- Table 91722 "SEW Lead Attachment Link" - Document management integration
  - Fields: Entry No., Lead No., Document Attachment Entry No., Description, File Name, File Extension, Attached By Name (FlowField)
  - Links leads to BC Document Attachment system for file management
- Table 91723 "SEW API Inbound Log" - API troubleshooting and audit trail
  - Fields: Entry No., Source, Request Method, Request Path, Payload (Blob), Processed, Result, Error Message, Lead No., Response Time (ms)
  - Logs all API requests with full payload for debugging and compliance
  - Helper procedures: GetPayloadText, SetPayloadText for JSON handling

#### Pages
- Page 91724 "SEW Lead Conversion Log" - Read-only conversion audit trail with navigation to Lead/Opportunity/Contact
- Page 91725 "SEW UTM Attribution Card" - CardPart for Lead Card FactBox displaying UTM parameters
- Page 91726 "SEW API Inbound Log" - API request troubleshooting page with payload viewer

#### Enhancements
- Lead Card: Added UTM Attribution FactBox for marketing source visibility
- Conversion Manager: CreateLeadOpportunityMap procedure creates audit trail on conversion
- Permission sets: Updated ADMIN and USER to include all Phase 3 objects

### Added - Phase 2 Sprint 6 (Scoring Engine)

#### Tables
- Table 91714 "SEW Lead Scoring Model" - Scoring configuration header
  - Fields: Model Code, Name, Active (enforces single active model), Decay Per Day, Band Hot/Warm Thresholds
  - OnDelete cascade removes associated rules
- Table 91715 "SEW Lead Scoring Rule" - Individual scoring criteria per model
  - Fields: Rule Code, Model Code, Attribute (enum), Operator (enum), Value, Score Delta, Is Fit Score
  - Supports Fit (company attributes) and Intent (engagement) score separation

#### Enums
- Enum 91707 "SEW Scoring Attribute" - Source/Industry/EmployeeCount/Country/EmailOpen/WebsiteVisit/ActivityOutcome
- Enum 91708 "SEW Scoring Operator" - Equals/Contains/Greater/Less/Between

#### Codeunits
- Codeunit 91726 "SEW Scoring Engine" - Calculate Fit + Intent scores with decay
  - CalculateLeadScore - Main entry point, orchestrates scoring calculation
  - CalculateFitScore - Evaluate company attribute rules (static score)
  - CalculateIntentScore - Evaluate engagement rules (decays over time)
  - EvaluateRule - Rule condition matching per attribute
  - ApplyDecay - Reduces Intent score based on inactivity (Decay Per Day setting)
  - UpdateScoreBand - Sets Hot/Warm/Cold based on Total Score and thresholds
  - Supports configurable scoring rules per attribute with point deltas

#### Pages
- Page 91722 "SEW Lead Scoring Models" - Configure scoring models with RecalculateAllScores action
- Page 91723 "SEW Lead Scoring Rules" - Define scoring rules per model

#### Enhancements
- Lead table: Added Field 52 "Score (Fit)", Field 53 "Score (Intent)" (both Integer, read-only)
- LeadManagement codeunit: UpdateScoreBand now calls Scoring Engine instead of hardcoded logic
- Permission sets: Updated to include all scoring objects (tables, codeunits, pages)

### Added - Phase 2 Sprint 5 (Routing Engine)

#### Tables
- Table 91712 "SEW Lead Routing Rule" - Auto-assignment rule configuration
  - Fields: Rule Code, Name, Rule Type, Active, Priority, Min/Max Score, Source Code, Territory Code, Salesperson Code, Assign to User ID, Team Code, Last Assigned User ID
  - OnDelete validation prevents deletion of rules with assignment history
- Table 91713 "SEW Lead Assignment Log" - Assignment audit trail
  - Fields: Entry No., Lead No., Rule Code, From/To User ID with FlowField names, Reason, SystemCreatedAt
  - Tracks both automatic and manual assignments

#### Enums
- Enum 91706 "SEW Routing Rule Type" - RoundRobin/Territory/ScoreThreshold/SourceBased

#### Codeunits
- Codeunit 91725 "SEW Routing Engine" - Auto-assignment orchestration
  - AssignLead - Evaluates all active rules by priority, applies first match
  - RuleMatchesLead - Condition evaluation for each rule type
  - ExecuteRule - Delegates to type-specific handlers (RoundRobin, Territory, ScoreThreshold, SourceBased)
  - LogAssignment - Creates audit trail entry
  - ManualAssign - Manual assignment with logging

#### Pages
- Page 91720 "SEW Lead Routing Rules" - Setup page for routing rules with test action
- Page 91721 "SEW Lead Assignment Log" - Read-only audit trail viewer

#### Enhancements
- Lead List page: Added Auto-Assign action using routing engine
- Lead Setup table: Default Owner User ID serves as fallback when no rules match
- Permission sets: Updated to include all routing objects

### Added - Phase 2 Sprint 4 (Lead Activities & Stages)

#### Tables
- Table 91710 "SEW Lead Stage" - Pipeline stages for Kanban view
  - Fields: Stage Code, Description, Sequence, Is Closed, Is Won, Default Probability %, SLA (Hours)
  - OnDelete validation prevents deletion of stages assigned to leads
- Table 91711 "SEW Lead Activity" - Interaction history tracking
  - Fields: Entry No., Lead No., Contact No., Type, Subject, Notes, Due Date, Start/End DateTime, Duration, Completed, Outcome, User ID, External Item ID
  - Auto-updates Lead's Last Activity Date on insert
  - FlowField for User Name display

#### Enums
- Enum 91703 "SEW Activity Type" - Call/Email/Meeting/Task/Note
- Enum 91704 "SEW Activity Outcome" - Connected/NoAnswer/LeftVM/Positive/Negative/Rescheduled

#### Pages
- Page 91716 "SEW Lead Stages" - Setup page for pipeline stages
- Page 91717 "SEW Lead Activity List" - Full list view with MarkCompleted action, due date styling
- Page 91718 "SEW Lead Activity Card" - Detailed activity editor
- Page 91719 "SEW Lead Activity ListPart" - FactBox for Lead Card showing activities

#### Enhancements
- Lead table: Added Field 34 "Stage Code" with auto-update of Probability % from stage defaults
- Lead Setup table: Added Field 51 "Default Stage Code" for new leads
- Lead Card page: Added Activities ListPart in FactBox area
- Permission sets: Updated to include all new Stage and Activity objects

### Added - RichText Fields for Lead Details

#### Table Enhancements
- Field 95 "Lead Description" (BLOB) - RichText field for capturing detailed lead information (e.g., call agency notes)
- Field 96 "Lead Summary" (BLOB) - RichText field for AI-generated lead analysis and summary
- Helper procedures: SetLeadDescription, GetLeadDescription, SetLeadSummary, GetLeadSummary

#### Page Enhancements
- Lead Card: Added dedicated groups for Lead Description and Lead Summary with RichText editors
- Both fields use ExtendedDatatype = RichContent for rich formatting capabilities

### Added - Phase 1 Sprint 3 (UI & Conversion)

#### Pages
- Page 91710 "SEW Lead List" - List page with filters, views (Active, Hot, My Leads), and actions
- Page 91711 "SEW Lead Card" - Card page with Quick Capture toggle, system info, and navigation
- Page 91712 "SEW Lead Setup" - Setup page for numbering and defaults
- Page 91713 "SEW Lead Sources" - List of lead sources
- Page 91714 "SEW Lost Reasons" - List of lost/disqualification reasons
- Page 91715 "SEW Lead Status History" - Audit trail viewer

#### Codeunits
- Codeunit 91722 "SEW Conversion Manager" - Lead to Opportunity conversion
  - ConvertLeadToOpportunity - Creates BC Opportunity from Qualified Lead
  - CanConvertLead - Validation helper
  - Full integration: creates Opportunity, Opportunity Entry, updates Lead
- Codeunit 91724 "SEW Validation Rules" - Centralized validation
  - ValidateLeadBeforeInsert, ValidateLeadBeforeModify
  - ValidateContactLink, ValidateEmail
  - ValidateRequiredFieldsForStatus

#### Permission Sets
- PermissionSet 91701 "SEW LEAD-USER" - Standard user permissions (RIM on Leads)
- PermissionSet 91702 "SEW LEAD-API" - API integration permissions

#### Enhancements
- Lead table: Added LookupPageId and DrillDownPageId
- Lead Source table: Added page references
- Lost Reason table: Added page references
- Lead Status History table: Added "Changed By User Name" FlowField, page references
- All permission sets: Added Locked = true to Caption properties

### Added - Phase 1 Sprint 2 (Contact Integration)

#### Codeunits
- Codeunit 91720 "SEW Lead Management" - Core CRUD operations and status management
  - CreateLead, UpdateLeadStatus, CreateStatusHistory, UpdateScoreBand, EnforceRequiredFields
  - Status transition validation (Qualified/Converted require Contact, Converted requires Expected Revenue)
- Codeunit 91721 "SEW Lead-Contact Sync" - Hybrid Contact pattern implementation
  - CreateOrLinkContact orchestrator
  - FindExistingContact deduplication (by email primary, company+phone secondary)
  - CreateContactFromLead mapping
  - ClearQuickFields post-link cleanup
  - SyncContactToLead for Salesperson Code synchronization
- Codeunit 91723 "SEW Deduplication" - Duplicate lead detection
  - CheckDuplicateLead (exact match by email or Contact No.)
  - WarnIfDuplicate confirmation dialog
  - GetDuplicateLeads list retrieval

#### Integrations
- Lead table Contact No. field trigger calls SyncContactToLead
- Lead table Status field trigger auto-creates Contact on Working status
- Permission set updated with codeunit permissions

### Added - Phase 1 Sprint 1 (Foundation)

#### Tables
- Table 91700 "SEW Lead" - Core lead entity with hybrid Contact pattern
- Table 91701 "SEW Lead Setup" - Central configuration
- Table 91702 "SEW Lead Source" - Lead origin tracking
- Table 91703 "SEW Lost Reason" - Disqualification reasons
- Table 91704 "SEW Lead Status History" - Audit trail for status transitions

#### Enums
- Enum 91700 "SEW Lead Status" - New/Working/Nurturing/Qualified/Disqualified/Converted
- Enum 91701 "SEW Lead Source Channel" - Web/Event/Referral/Social/InboundCall/Outbound
- Enum 91702 "SEW Disqualification Reason" - NoBudget/NoAuthority/NoNeed/NoTimeline/Duplicate/Invalid/Other
- Enum 91705 "SEW Score Band" - Hot/Warm/Cold

#### Features
- Quick capture fields (Company Name, Email, Phone) for fast lead entry
- Auto-create Contact when Status changes to Working
- BC system audit integration (SystemCreatedBy/At, SystemModifiedBy/At)
- FlowFields for username display (System Created By Name, System Modified By Name)
- No. Series management for Lead numbering
- Status workflow validation (Qualified requires Contact)
- GDPR consent tracking (Marketing Consent, timestamp, source, IP address)
- Multiple indexes for performance (Email dedup, Status+Owner, Source+Date, ScoreBand+NextActivity)

#### Architecture
- Hybrid Contact Pattern: Optional Contact reference, mandatory for Qualified+
- Object ID Range: 91700-91799
- Target: BC Cloud Platform 27.0, Runtime 16.0
- Dependency: walter75 - BaseApp NEW (26.2.0.0)

### Technical Notes
- All tables have Caption and ToolTip properties per LinterCop requirements
- DataClassification properly set on all fields
- Extensible enums for customization
- LookupPageId and DrillDownPageId configured for user experience

## [Unreleased]

### Planned - Phase 1 Sprint 2 (Contact Integration)
- Codeunit 91721 "SEW Lead-Contact Sync" - CreateOrLinkContact logic
- Codeunit 91723 "SEW Deduplication" - Exact match deduplication
- Lead Card page with Quick capture visibility toggle
- Contact relationship UI

### Planned - Phase 1 Sprint 3 (Conversion & UI)
- Codeunit 91720 "SEW Lead Management" - Core CRUD operations
- Codeunit 91722 "SEW Conversion Manager" - Lead to Opportunity conversion
- Codeunit 91724 "SEW Validation Rules" - Business rule validation
- Page 91710 "SEW Lead List"
- Page 91711 "SEW Lead Card"
- Page 91712 "SEW Lead Setup"
- Page 91713 "SEW Lead Sources"
- Page 91714 "SEW Lost Reasons"
- Permission Sets (LEAD-ADMIN, LEAD-USER, LEAD-API)
- Translation files (EN, DE)

### Planned - Phase 2 (Advanced Features)
- Lead Activities (calls, emails, meetings, tasks)
- Lead Stages for Kanban boards
- Lead Scoring (rule-based Fit + Intent)
- Routing Engine (Round-Robin, Territory, Score threshold)
- API v2.0 Pages
- CSV Import
- Dashboards

### Planned - Phase 3 (Premium Features)
- UTM Attribution
- AI Scoring (optional)
- ROI Reporting
- AppSource Certification

# Architecture: walter75 - Learning Management & Skills

**Date**: 2025-12-25  
**Complexity**: HIGH  
**Author**: al-architect  
**Status**: Proposed

## Executive Summary

The Learning Management & Skills extension provides a comprehensive system for tracking employee professional development, specifically focused on Microsoft Learn Business Central training. It synchronizes the complete Microsoft Learn catalog (modules, learning paths) daily via API, enables managers to assign training to employees, tracks completion status, manages version updates, and generates competency-based skill matrices. The system implements a role-based skill framework with proficiency levels, career progression tracking, and automated user task notifications for assignments and content updates.

## Business Context

### Problem Statement

**Current State**: Organizations using Business Central lack:
- Centralized tracking of employee Business Central skills and training
- Visibility into who has completed which Microsoft Learn modules
- Systematic assignment of training based on roles
- Detection when training content is updated (requiring re-certification)
- Competency framework for career progression
- Integration between Microsoft Learn and BC employee records

**Desired State**: A platform that:
- Automatically syncs Microsoft Learn catalog daily
- Allows managers to assign learning paths/modules to employees
- Tracks completion with timestamps (honor system initially)
- Creates User Tasks for new assignments
- Notifies employees when assigned content is updated
- Generates role-based skill matrices showing proficiency levels
- Supports career progression with competency frameworks

### Success Criteria

- ✅ Daily sync of Microsoft Learn catalog (modules + learning paths) from API
- ✅ Store rich metadata: levels, roles, subjects, summary, duration, icon_url, social_image_url
- ✅ Assign complete learning paths OR individual modules to employees
- ✅ User Task creation for new assignments with due dates
- ✅ Honor-system completion tracking with completion date
- ✅ Change detection: notify employees when assigned content is updated (via User Task)
- ✅ Competency framework: map skills to roles, track proficiency (Beginner/Intermediate/Advanced)
- ✅ Skill matrix reports: employee skills, team gaps, compliance status
- ✅ Integration with Employee (5200) and User Task (1170) tables

## Architectural Design

### Object ID Range

**Allocated Range**: `91800-91899` (100 objects)

**Rationale**:
- Follows Lead Management (91700-91799) in ID sequence
- Employee skill-related functionality logically grouped
- Sufficient capacity for learning + competency framework

**Range Distribution**:
```
91800-91809: Setup & Configuration
91810-91829: Microsoft Learn Catalog (Modules, Paths, Relationships)
91830-91839: Employee Assignments & Tracking
91840-91849: Competency Framework (Skills, Roles, Levels)
91850-91859: User Interface (List/Card Pages, Dashboards)
91860-91879: Business Logic (Sync, Assignment, Notifications)
91880-91889: Integration Events & Public APIs
91890-91899: Reserved for future expansion
```

### Data Model

#### Tables (Microsoft Learn Catalog Layer)

**Table 91810 "SEW Learning Module"**
- Purpose: Microsoft Learn modules catalog (sync from API)
- Key fields:
  - UID (Code[100]) - Microsoft Learn UID (PK, e.g., "learn-dynamics.migrate-data-dynamics-365-business-central")
  - Title (Text[250]) - Module title
  - Summary (Text[2048]) - Module description
  - Duration in Minutes (Integer)
  - Icon URL (Text[250]) - https://learn.microsoft.com/...
  - Social Image URL (Text[250]) - Social sharing image
  - URL (Text[250]) - Link to module
  - First Unit URL (Text[250]) - Direct link to first unit
  - Last Modified (DateTime) - Microsoft Learn last update date
  - Number of Children (Integer) - Number of units in module
  - Rating Count (Integer), Rating Average (Decimal) - Microsoft Learn ratings
  - Popularity (Decimal) - Microsoft popularity score
  - Locale (Code[10]) - de-DE, en-US
  - Catalog Hash (Code[50]) - MD5 hash for change detection
  - Type (Code[20]) - "module" (fixed value)
- Secondary Keys:
  - Last Modified (for change detection)
  - Title (for searching)
- DataClassification: PublicWebContent (from Microsoft Learn)

**Table 91811 "SEW Learning Path"**
- Purpose: Microsoft Learn learning paths catalog
- Key fields:
  - UID (Code[100]) - Microsoft Learn UID (PK)
  - Title (Text[250])
  - Summary (Text[2048])
  - Duration in Minutes (Integer) - Sum of all modules
  - Icon URL (Text[250])
  - Social Image URL (Text[250])
  - URL (Text[250])
  - First Module URL (Text[250])
  - Last Modified (DateTime)
  - Number of Children (Integer) - Number of modules in path
  - Rating Count (Integer), Rating Average (Decimal)
  - Popularity (Decimal)
  - Locale (Code[10])
  - Catalog Hash (Code[50])
  - Type (Code[20]) - "learningPath"
- Secondary Keys:
  - Last Modified
  - Title
- DataClassification: PublicWebContent

**Table 91812 "SEW Learning Path Module"**
- Purpose: Many-to-many relationship between Learning Paths and Modules
- Key fields:
  - Learning Path UID (Code[100]) - FK to Learning Path
  - Module UID (Code[100]) - FK to Learning Module
  - Sequence (Integer) - Order within path
- Primary Key: Learning Path UID, Sequence
- Relationships:
  - TableRelation: "SEW Learning Path".UID
  - TableRelation: "SEW Learning Module".UID
- DataClassification: PublicWebContent

**Table 91813 "SEW Module Level"** (Enum alternative as table for 1:n relationship)
- Purpose: Module difficulty levels (beginner, intermediate, advanced)
- Key fields:
  - Module UID (Code[100])
  - Level (Code[20]) - "beginner", "intermediate", "advanced"
- Primary Key: Module UID, Level
- DataClassification: PublicWebContent

**Table 91814 "SEW Module Role"**
- Purpose: Target roles for modules (functional-consultant, developer, business-user, etc.)
- Key fields:
  - Module UID (Code[100])
  - Role (Code[50]) - "functional-consultant", "developer", "business-user", "business-analyst", "maker", "student"
- Primary Key: Module UID, Role
- DataClassification: PublicWebContent

**Table 91815 "SEW Module Subject"**
- Purpose: Subject areas (finance-accounting, supply-chain-management, etc.)
- Key fields:
  - Module UID (Code[100])
  - Subject (Code[50]) - "finance-accounting", "supply-chain-management", "business-applications", "data-management", etc.
- Primary Key: Module UID, Subject
- DataClassification: PublicWebContent

**Table 91816 "SEW Learning Path Level"**
- Purpose: Learning path difficulty levels
- Key fields: Learning Path UID, Level
- DataClassification: PublicWebContent

**Table 91817 "SEW Learning Path Role"**
- Purpose: Target roles for learning paths
- Key fields: Learning Path UID, Role
- DataClassification: PublicWebContent

**Table 91818 "SEW Learning Path Subject"**
- Purpose: Subject areas for learning paths
- Key fields: Learning Path UID, Subject
- DataClassification: PublicWebContent

#### Tables (Employee Assignment & Tracking Layer)

**Table 91830 "SEW Employee Learning Assignment"**
- Purpose: Assign learning paths/modules to employees, track completion
- Key fields:
  - Entry No. (Integer, AutoIncrement) - PK
  - Employee No. (Code[20]) - FK to Employee (5200)
  - Assignment Type (Enum: Module, Learning Path)
  - Module UID (Code[100]) - FK to Learning Module (if type = Module)
  - Learning Path UID (Code[100]) - FK to Learning Path (if type = Learning Path)
  - Assigned By User ID (Code[50]) - Manager who assigned
  - Assigned Date (Date)
  - Due Date (Date)
  - Status (Enum: Not Started → In Progress → Completed → Outdated)
  - Started Date (Date) - When employee marked as started
  - Completed Date (Date) - When employee marked as completed
  - Completion Notes (Text[250]) - Optional notes from employee
  - User Task No. (Integer) - FK to User Task (1170)
  - Content Version (Code[50]) - Hash of module/path at assignment time
  - Current Content Version (Code[50]) - Latest hash from catalog (FlowField)
  - Version Outdated (Boolean) - Calculated: Content Version ≠ Current Content Version
- Keys:
  - PK: Entry No.
  - Employee No., Status (for filtering)
  - Due Date (for overdue notifications)
  - Module UID, Employee No. (unique constraint - prevent duplicate assignments)
  - Learning Path UID, Employee No. (unique constraint)
- DataClassification: CustomerContent

**Table 91831 "SEW Assignment Module Progress"**
- Purpose: Track completion of individual modules within assigned learning paths
- Key fields:
  - Assignment Entry No. (Integer) - FK to Employee Learning Assignment (PK1)
  - Module UID (Code[100]) - FK to Learning Module (PK2)
  - Status (Enum: Not Started → In Progress → Completed)
  - Started Date (Date)
  - Completed Date (Date)
- Primary Key: Assignment Entry No., Module UID
- DataClassification: CustomerContent

#### Tables (Competency Framework Layer)

**Table 91840 "SEW Skill"**
- Purpose: Skill definitions (e.g., "BC Financial Management", "AL Development")
- Key fields:
  - Code (Code[20]) - PK, e.g., "FIN-GL", "DEV-AL"
  - Description (Text[100]) - "General Ledger Setup & Management"
  - Skill Category (Code[20]) - "Functional", "Technical", "Business Process"
  - Required for Roles (Text[250]) - Comma-separated role codes
- DataClassification: CustomerContent

**Table 91841 "SEW Skill Learning Mapping"**
- Purpose: Map modules/paths to skills they teach
- Key fields:
  - Skill Code (Code[20]) - FK to Skill
  - Content Type (Enum: Module, Learning Path)
  - Content UID (Code[100]) - FK to Module or Learning Path
  - Proficiency Level Gained (Enum: Beginner, Intermediate, Advanced) - What level does completing this content grant?
- Primary Key: Skill Code, Content Type, Content UID
- DataClassification: CustomerContent

**Table 91842 "SEW Employee Skill"**
- Purpose: Employee skill matrix (aggregated view + manual overrides)
- Key fields:
  - Employee No. (Code[20]) - PK1
  - Skill Code (Code[20]) - PK2
  - Proficiency Level (Enum: None, Beginner, Intermediate, Advanced, Expert)
  - Source (Enum: Training Completion, Manager Assessment, Self-Assessment, Certification)
  - Acquired Date (Date)
  - Last Assessed Date (Date)
  - Notes (Text[250])
- Primary Key: Employee No., Skill Code
- DataClassification: CustomerContent

**Table 91843 "SEW Role Skill Requirement"**
- Purpose: Define required skills for each role (e.g., "Functional Consultant" needs X skills)
- Key fields:
  - Role Code (Code[20]) - PK1 (e.g., "FUNC-CONSULTANT", "DEVELOPER")
  - Skill Code (Code[20]) - PK2
  - Minimum Proficiency (Enum: Beginner, Intermediate, Advanced)
  - Mandatory (Boolean) - Required vs. recommended
- Primary Key: Role Code, Skill Code
- DataClassification: CustomerContent

**Table 91844 "SEW Employee Role"**
- Purpose: Assign employees to roles (many-to-many)
- Key fields:
  - Employee No. (Code[20]) - PK1
  - Role Code (Code[20]) - PK2
  - Primary Role (Boolean) - Is this the employee's main role?
  - Effective Date (Date)
- Primary Key: Employee No., Role Code
- DataClassification: CustomerContent

#### Tables (Configuration)

**Table 91800 "SEW Learning Mgmt Setup"**
- Purpose: Single-record configuration table
- Key fields:
  - Primary Key (Code[10]) - Single record with PK ''
  - API URL (Text[250]) - "https://learn.microsoft.com/api/catalog/"
  - API Locale (Code[10]) - "de-de" (default)
  - API Product Filter (Code[50]) - "dynamics-business-central"
  - Last Sync Date Time (DateTime)
  - Sync Frequency (Option: Daily, Weekly, Manual)
  - Default Assignment Due Days (Integer, InitValue=30)
  - Auto Create User Tasks (Boolean, InitValue=true)
  - Notify on Content Update (Boolean, InitValue=true)
  - Sync Job Queue Entry ID (Guid) - FK to Job Queue Entry
- DataClassification: CustomerContent

### Enumerations

**Enum 91830 "SEW Assignment Type"**
- Values: Module (0), Learning Path (1)

**Enum 91831 "SEW Assignment Status"**
- Values: Not Started (0), In Progress (1), Completed (2), Outdated (3)
- Outdated: Content was updated since completion, may need re-training

**Enum 91840 "SEW Proficiency Level"**
- Values: None (0), Beginner (1), Intermediate (2), Advanced (3), Expert (4)

**Enum 91841 "SEW Skill Source"**
- Values: Training Completion (0), Manager Assessment (1), Self-Assessment (2), Certification (3)

**Enum 91842 "SEW Skill Category"**
- Values: Functional (0), Technical (1), Business Process (2), Leadership (3)

### Business Logic (Codeunits)

**Codeunit 91860 "SEW Learn Catalog Sync"**
- Purpose: Sync Microsoft Learn catalog from API
- SingleInstance: false
- Permissions: RIMD on all SEW Learning tables, R on SEW Learning Mgmt Setup
- Key procedures:
  - `SyncFullCatalog()` - Main entry point, calls API and updates all tables
  - `FetchFromAPI(var JsonResponse: Text): Boolean` - HTTP GET from Microsoft Learn API
  - `ParseModules(JsonResponse: Text)` - Parse modules array from JSON
  - `ParseLearningPaths(JsonResponse: Text)` - Parse learningPaths array from JSON
  - `UpsertModule(ModuleJson: JsonObject)` - Insert or update module record
  - `UpsertLearningPath(PathJson: JsonObject)` - Insert or update learning path record
  - `UpdateModuleLevels(ModuleUID: Code; LevelsJson: JsonArray)` - Update 1:n relationships
  - `UpdateModuleRoles(ModuleUID: Code; RolesJson: JsonArray)`
  - `UpdateModuleSubjects(ModuleUID: Code; SubjectsJson: JsonArray)`
  - `LinkPathToModules(PathUID: Code; ModulesJson: JsonArray)` - Populate Learning Path Module table
  - `CalculateContentHash(JsonObject: JsonObject): Code` - MD5 hash for change detection
  - `DetectContentChanges()` - Compare hashes, mark assignments as Outdated if content changed
- Event Publishers:
  - `OnAfterSyncComplete(ModulesAdded: Integer; PathsAdded: Integer; ModulesUpdated: Integer; PathsUpdated: Integer)`
  - `OnBeforeUpsertModule(var ModuleJson: JsonObject; var IsHandled: Boolean)`
- Business Logic:
  - Rate limiting: Wait 1 second between API calls if needed
  - Error handling: Log to Core Error Logger if API fails
  - Incremental sync: Only update records with newer Last Modified dates
  - Telemetry: Log sync duration and record counts to Core Telemetry Manager

**Codeunit 91861 "SEW Assignment Manager"**
- Purpose: Create and manage employee learning assignments
- SingleInstance: false
- Permissions: RIMD on SEW Employee Learning Assignment, SEW Assignment Module Progress, User Task
- Key procedures:
  - `AssignModuleToEmployee(EmployeeNo: Code; ModuleUID: Code; DueDate: Date): Integer` - Returns Assignment Entry No.
  - `AssignLearningPathToEmployee(EmployeeNo: Code; PathUID: Code; DueDate: Date): Integer`
  - `CreateUserTask(AssignmentEntryNo: Integer): Integer` - Create User Task record, return Task No.
  - `MarkModuleStarted(AssignmentEntryNo: Integer)`
  - `MarkModuleCompleted(AssignmentEntryNo: Integer; CompletionNotes: Text)`
  - `MarkPathModuleCompleted(AssignmentEntryNo: Integer; ModuleUID: Code)` - Update progress within learning path
  - `CheckPathCompletion(AssignmentEntryNo: Integer): Boolean` - Auto-complete path when all modules done
  - `NotifyContentUpdate(AssignmentEntryNo: Integer)` - Create User Task when content changes
  - `GetAssignmentProgress(AssignmentEntryNo: Integer): Decimal` - % complete for learning paths
- Event Publishers:
  - `OnAfterAssignmentCreated(AssignmentRec: Record "SEW Employee Learning Assignment")`
  - `OnAfterModuleCompleted(AssignmentRec: Record "SEW Employee Learning Assignment")`
  - `OnAfterPathCompleted(AssignmentRec: Record "SEW Employee Learning Assignment")`
- Business Logic:
  - Prevent duplicate assignments: Check existing assignments before creating
  - Auto-create progress records for learning path modules
  - Close User Task when assignment completed
  - Store content version hash at assignment time
  - Calculate due dates based on setup default days

**Codeunit 91862 "SEW Skill Matrix Manager"**
- Purpose: Update employee skill matrix based on completed training
- SingleInstance: false
- Permissions: RIMD on SEW Employee Skill, R on SEW Skill Learning Mapping, R on SEW Employee Learning Assignment
- Key procedures:
  - `UpdateEmployeeSkills(EmployeeNo: Code)` - Recalculate all skills for employee
  - `ProcessCompletedAssignment(AssignmentEntryNo: Integer)` - Update skills when assignment completed
  - `GetSkillsFromContent(ContentType: Enum; ContentUID: Code): List of [Code]` - Get skills taught by module/path
  - `CalculateProficiencyLevel(EmployeeNo: Code; SkillCode: Code): Enum` - Determine proficiency from completed training
  - `GetRoleSkillGaps(EmployeeNo: Code; RoleCode: Code): List of [Code]` - Which skills are missing for a role?
  - `GetTeamSkillMatrix(ManagerNo: Code): Record` - Aggregate skills for manager's team
- Event Publishers:
  - `OnAfterSkillUpdated(EmployeeNo: Code; SkillCode: Code; NewLevel: Enum)`
- Business Logic:
  - Proficiency calculation: Max level from all completed training
  - Source tracking: Training Completion when auto-updated
  - Manager override: Don't overwrite Manager Assessment or Certification sources
  - FlowFields: Skill count per employee, employee count per skill

**Codeunit 91863 "SEW Content Change Detector"**
- Purpose: Detect when Microsoft Learn content is updated, notify employees
- SingleInstance: false
- Permissions: R on SEW Learning Module, SEW Learning Path, R on SEW Employee Learning Assignment, I on User Task
- Key procedures:
  - `DetectChanges()` - Main entry point, called after sync
  - `CheckModuleChanges()` - Compare current hash vs. assignment content version
  - `CheckLearningPathChanges()`
  - `NotifyEmployees(AssignmentList: List of [Integer])` - Create User Tasks for outdated assignments
  - `MarkAssignmentsOutdated(AssignmentList: List of [Integer])` - Update status to Outdated
- Event Publishers:
  - `OnContentUpdateDetected(AssignmentEntryNo: Integer; OldHash: Code; NewHash: Code)`
- Business Logic:
  - Only notify for Completed assignments (not In Progress)
  - Create User Task: "Module X has been updated. Please review and re-certify."
  - Option to auto-reset status to Not Started (configurable in setup)

**Codeunit 91800 "SEW Learning Mgmt Install"**
- Purpose: Installation and setup
- Subtype: Install
- Key procedures:
  - `OnInstallAppPerCompany()` - Create default setup record, install job queue entry
  - `CreateDefaultSkills()` - Seed skill definitions (BC Functional, BC Technical, AL Development, etc.)
  - `CreateDefaultRoles()` - Seed roles (Functional Consultant, Developer, etc.)
- Business Logic:
  - Create Job Queue Entry for daily sync (3:00 AM)
  - Link to Codeunit 91860 "SEW Learn Catalog Sync"
  - Create default skills based on Microsoft Learn subjects

**Codeunit 91801 "SEW Learning Mgmt Upgrade"**
- Purpose: Version upgrades
- Subtype: Upgrade
- Key procedures:
  - `OnUpgradePerCompany()` - Data migrations

### User Interface (Pages)

**Page 91850 "SEW Learning Module List"**
- Type: List
- SourceTable: "SEW Learning Module"
- Purpose: Browse Microsoft Learn modules catalog
- Fields: UID, Title, Summary (truncated), Duration in Minutes, Last Modified, Popularity, Rating Average
- Filters: Levels (via FlowFilter), Roles (via FlowFilter), Subjects (via FlowFilter)
- Actions:
  - "View on Microsoft Learn" - Open URL in browser
  - "Assign to Employee" - Open assignment wizard
  - "View Levels" - Navigate to Module Level records
  - "View Roles" - Navigate to Module Role records
  - "View Subjects" - Navigate to Module Subject records
  - "Sync Catalog" - Manual sync trigger
- FactBox: Module Details (icon, social image, number of units)

**Page 91851 "SEW Learning Module Card"**
- Type: Card
- SourceTable: "SEW Learning Module"
- Purpose: Detailed module view
- Sections:
  - General: UID, Title, URL, Icon URL (displayed as image)
  - Details: Summary (multiline), Duration, Last Modified, Rating Count, Rating Average, Popularity
  - Metadata: Levels (subpage), Roles (subpage), Subjects (subpage)
  - Assignments: Employees assigned to this module (subpage)
- Actions:
  - "Open in Browser" - Launch URL
  - "Assign to Employee" - Assignment wizard

**Page 91852 "SEW Learning Path List"**
- Type: List
- SourceTable: "SEW Learning Path"
- Purpose: Browse learning paths
- Fields: UID, Title, Summary, Duration in Minutes, Number of Modules, Last Modified
- Filters: Levels, Roles, Subjects
- Actions:
  - "View Modules" - Navigate to modules in this path
  - "Assign to Employee" - Assignment wizard
  - "View on Microsoft Learn"

**Page 91853 "SEW Learning Path Card"**
- Type: Card
- SourceTable: "SEW Learning Path"
- Purpose: Detailed learning path view
- Sections:
  - General: UID, Title, URL, Icon
  - Details: Summary, Duration, Number of Modules
  - Metadata: Levels, Roles, Subjects
  - Modules: Subpage showing all modules in path (ordered by Sequence)
  - Assignments: Employees assigned to this path
- Actions:
  - "Open in Browser"
  - "Assign to Employee"

**Page 91830 "SEW Employee Learning Assignments"**
- Type: List
- SourceTable: "SEW Employee Learning Assignment"
- Purpose: View all assignments (admin view)
- Fields: Entry No., Employee No., Employee Name (FlowField), Assignment Type, Module/Path Title (FlowField), Assigned Date, Due Date, Status, Completed Date
- Filters: Employee No., Status, Due Date, Assignment Type
- Actions:
  - "Create User Task" - Manually create task if auto-creation failed
  - "Mark Completed" - Admin override
  - "Notify Content Update" - Manual re-notification
  - "View Progress" - Show module progress for learning paths

**Page 91831 "SEW My Learning Assignments"**
- Type: List
- SourceTable: "SEW Employee Learning Assignment"
- Purpose: Employee self-service view (filtered by current user)
- Source Table View: WHERE(Employee No. = FILTER(UserEmployeeNo))
- Fields: Assignment Type, Title, Assigned Date, Due Date, Status, Progress %, Completed Date
- Actions:
  - "Mark Started" - Update status to In Progress
  - "Mark Completed" - Open completion wizard (enter notes, set date)
  - "View Content" - Open module/path card
  - "Open on Microsoft Learn" - Launch URL
- FactBox: Assignment Progress (for learning paths)

**Page 91832 "SEW Assignment Wizard"**
- Type: NavigatePage
- Purpose: Multi-step wizard to assign training to employees
- Steps:
  1. Select Content: Choose module OR learning path (search by title, filter by level/role/subject)
  2. Select Employees: Multi-select from Employee list (filter by department, role)
  3. Set Due Date: Calculate from duration (e.g., 30 days + duration), or manual override
  4. Confirmation: Review assignments, click Finish
- Actions: Back, Next, Finish, Cancel
- Business Logic:
  - Finish button calls Assignment Manager.AssignModuleToEmployee() or AssignLearningPathToEmployee()
  - Auto-create User Tasks if setup enabled
  - Show success message: "X assignments created"

**Page 91840 "SEW Employee Skill Matrix"**
- Type: List
- SourceTable: "SEW Employee Skill"
- Purpose: View employee skill matrix
- Fields: Employee No., Employee Name, Skill Code, Skill Description (FlowField), Proficiency Level, Source, Acquired Date, Last Assessed Date
- Filters: Employee No., Proficiency Level, Source, Skill Category
- Actions:
  - "Update from Training" - Recalculate skills based on completed assignments
  - "Manager Assessment" - Override proficiency level (manual entry)
  - "Skill Gap Analysis" - Compare to role requirements
  - "Export to Excel"

**Page 91841 "SEW Team Skill Matrix"**
- Type: List
- Purpose: Manager view of team skills (matrix view)
- SourceTable: Employee (5200) filtered by Manager No. = CurrentUserEmployeeNo
- Matrix: Columns = Skills, Rows = Employees, Cell Values = Proficiency Level (color-coded)
- Actions:
  - "Identify Gaps" - Show missing skills for role
  - "Assign Training" - Bulk assignment wizard
  - "Export Report"

**Page 91842 "SEW Skill Gap Analysis"**
- Type: Card (Calculation page)
- Purpose: Show skill gaps for an employee vs. a target role
- Input: Employee No., Target Role Code
- Output:
  - Current Skills (subpage): Employee Skill records
  - Required Skills (subpage): Role Skill Requirement records
  - Gap Analysis (calculated): Required skills where employee proficiency < minimum
- Actions:
  - "Recommend Training" - Show modules/paths that teach missing skills
  - "Create Learning Plan" - Auto-assign recommended content

**Page 91843 "SEW Learning Dashboard"**
- Type: RoleCenter (or Headline + Cues)
- Purpose: Overview dashboard for administrators
- Sections:
  - KPIs (Cues):
    - Total Assignments
    - Completed This Month
    - Overdue Assignments
    - Content Updates (Outdated assignments)
  - Charts:
    - Completion Rate by Department
    - Most Popular Modules
    - Skill Coverage %
  - Quick Links:
    - Assign Training
    - Sync Catalog
    - View Assignments
    - Skill Matrix

**Page 91800 "SEW Learning Mgmt Setup"**
- Type: Card
- SourceTable: "SEW Learning Mgmt Setup"
- Purpose: Configuration page
- Sections:
  - API Settings: API URL, Locale, Product Filter
  - Sync Settings: Last Sync Date, Frequency, Sync Job Queue Entry
  - Assignment Settings: Default Due Days, Auto Create User Tasks, Notify on Content Update
- Actions:
  - "Run Sync Now" - Manual catalog sync
  - "View Sync Log" - Show Core Error Log entries
  - "Test API Connection" - Verify connectivity

### Integration Points

#### Event Publishers (Extensibility)

**Codeunit 91860 "SEW Learn Catalog Sync"**
```al
[EventPublisher(ObjectType::Codeunit, Codeunit::"SEW Learn Catalog Sync", 'OnAfterSyncComplete', '', false, false)]
local procedure OnAfterSyncComplete(ModulesAdded: Integer; PathsAdded: Integer; ModulesUpdated: Integer; PathsUpdated: Integer)

[EventPublisher(ObjectType::Codeunit, Codeunit::"SEW Learn Catalog Sync", 'OnBeforeUpsertModule', '', false, false)]
local procedure OnBeforeUpsertModule(var ModuleJson: JsonObject; var IsHandled: Boolean)
```

**Codeunit 91861 "SEW Assignment Manager"**
```al
[EventPublisher(ObjectType::Codeunit, Codeunit::"SEW Assignment Manager", 'OnAfterAssignmentCreated', '', false, false)]
local procedure OnAfterAssignmentCreated(AssignmentRec: Record "SEW Employee Learning Assignment")

[EventPublisher(ObjectType::Codeunit, Codeunit::"SEW Assignment Manager", 'OnAfterModuleCompleted', '', false, false)]
local procedure OnAfterModuleCompleted(AssignmentRec: Record "SEW Employee Learning Assignment")
```

**Codeunit 91862 "SEW Skill Matrix Manager"**
```al
[EventPublisher(ObjectType::Codeunit, Codeunit::"SEW Skill Matrix Manager", 'OnAfterSkillUpdated', '', false, false)]
local procedure OnAfterSkillUpdated(EmployeeNo: Code; SkillCode: Code; NewLevel: Enum "SEW Proficiency Level")
```

#### Event Subscribers (BC Integration)

**Job Queue Entry (Automatic Sync)**:
```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Queue Entry", 'OnBeforeRun', '', false, false)]
local procedure OnBeforeRunJobQueue(var JobQueueEntry: Record "Job Queue Entry")
begin
    if JobQueueEntry."Object Type to Run" = JobQueueEntry."Object Type to Run"::Codeunit then
        if JobQueueEntry."Object ID to Run" = Codeunit::"SEW Learn Catalog Sync" then
            // Daily sync logic
end;
```

**User Task Integration**:
```al
[EventSubscriber(ObjectType::Table, Database::"User Task", 'OnAfterInsertEvent', '', false, false)]
local procedure OnAfterUserTaskInsert(var Rec: Record "User Task")
begin
    // Link User Task to Assignment via User Task No. field
end;
```

**Employee Table Extension** (Optional):
```al
tableextension 91800 "SEW Employee Ext" extends Employee
{
    fields
    {
        field(91800; "SEW Learning Role Code"; Code[20])
        {
            Caption = 'Learning Role';
            TableRelation = "SEW Role Skill Requirement".Role Code;
            DataClassification = CustomerContent;
        }
        field(91801; "SEW Skill Count"; Integer)
        {
            Caption = 'Skills Acquired';
            FieldClass = FlowField;
            CalcFormula = Count("SEW Employee Skill" WHERE("Employee No." = FIELD("No."), Proficiency Level = FILTER(>None)));
            Editable = false;
        }
    }
}
```

#### Public API for Other Apps

All walter75 apps can access Learning Management functionality:

```al
// From any walter75 app
codeunit 90701 "Example Codeunit"
{
    var
        AssignmentMgr: Codeunit "SEW Assignment Manager";
        SkillMatrixMgr: Codeunit "SEW Skill Matrix Manager";
        
    procedure AssignTrainingToEmployee(EmployeeNo: Code[20])
    var
        ModuleUID: Code[100];
        DueDate: Date;
        AssignmentNo: Integer;
    begin
        ModuleUID := 'learn-dynamics.create-items'; // Example module
        DueDate := CalcDate('<30D>', Today);
        
        AssignmentNo := AssignmentMgr.AssignModuleToEmployee(EmployeeNo, ModuleUID, DueDate);
        
        if AssignmentNo <> 0 then
            Message('Training assigned successfully. Assignment No: %1', AssignmentNo);
    end;
    
    procedure CheckEmployeeSkills(EmployeeNo: Code[20])
    var
        SkillGaps: List of [Code[20]];
    begin
        SkillGaps := SkillMatrixMgr.GetRoleSkillGaps(EmployeeNo, 'FUNC-CONSULTANT');
        
        if SkillGaps.Count > 0 then
            Message('Employee has %1 skill gaps', SkillGaps.Count);
    end;
}
```

### Microsoft Learn API Integration

**API Endpoint**: `https://learn.microsoft.com/api/catalog/?locale=de-de&product=dynamics-business-central`

**Response Structure** (JSON):
```json
{
  "modules": [
    {
      "summary": "Module description",
      "levels": ["intermediate"],
      "roles": ["functional-consultant", "business-user"],
      "products": ["dynamics-365", "dynamics-business-central"],
      "subjects": ["finance-accounting"],
      "uid": "learn-dynamics.module-name",
      "type": "module",
      "title": "Module Title",
      "duration_in_minutes": 79,
      "rating": {"count": 727, "average": 4.69},
      "popularity": 0.5062,
      "icon_url": "https://...",
      "social_image_url": "https://...",
      "locale": "en-us",
      "last_modified": "2024-08-27T23:01:00+00:00",
      "url": "https://...",
      "firstUnitUrl": "https://...",
      "units": ["unit1", "unit2"],
      "number_of_children": 7
    }
  ],
  "learningPaths": [
    {
      "summary": "Path description",
      "levels": ["intermediate"],
      "roles": ["functional-consultant"],
      "products": ["dynamics-365", "dynamics-business-central"],
      "subjects": ["finance-accounting"],
      "uid": "learn-dynamics.path-name",
      "type": "learningPath",
      "title": "Path Title",
      "duration_in_minutes": 206,
      "rating": {"count": 0},
      "popularity": 0.4155,
      "icon_url": "https://...",
      "social_image_url": "https://...",
      "locale": "en-us",
      "last_modified": "2025-03-24T22:55:00+00:00",
      "url": "https://...",
      "firstModuleUrl": "https://...",
      "modules": ["module1", "module2"],
      "number_of_children": 5
    }
  ]
}
```

**Sync Strategy**:
1. Daily Job Queue Entry triggers at 3:00 AM
2. Fetch full catalog (GET request)
3. Parse JSON using AL JsonObject/JsonArray
4. Upsert modules: Check if UID exists, compare Last Modified date
5. Upsert learning paths: Same logic
6. Update 1:n relationships (levels, roles, subjects)
7. Link learning paths to modules via Learning Path Module table
8. Calculate MD5 hash of JSON for each module/path → store in Catalog Hash field
9. Run Content Change Detector to mark outdated assignments
10. Log sync results to Core Error Logger + Telemetry Manager

**Error Handling**:
- HTTP timeout: Retry 3 times with exponential backoff
- Invalid JSON: Log error, skip record, continue sync
- Missing fields: Use default values (e.g., Duration = 0)
- API rate limiting: Respect HTTP 429 response, wait and retry

### Security Model

**Permission Sets**:

**PermissionSet 91900 "SEW LEARN-READ"**
- Read-only access to all Learning Management objects
- Target Users: All employees (view their own assignments)
- Permissions:
  - Read: All SEW Learning tables
  - Execute: Assignment Manager (read-only methods), Skill Matrix Manager (read-only)

**PermissionSet 91901 "SEW LEARN-USER"**
- Standard user operations (mark assignments started/completed)
- Target Users: All employees
- Permissions:
  - Inherits: SEW LEARN-READ
  - Modify: SEW Employee Learning Assignment (own records only - via security filter)
  - Execute: Assignment Manager (completion methods)

**PermissionSet 91902 "SEW LEARN-MANAGER"**
- Manager operations (assign training to team)
- Target Users: Managers, department heads
- Permissions:
  - Inherits: SEW LEARN-USER
  - Insert/Modify: SEW Employee Learning Assignment (team members only)
  - Execute: Assignment Manager (all methods), Skill Matrix Manager
  - Pages: Assignment Wizard, Team Skill Matrix

**PermissionSet 91903 "SEW LEARN-ADMIN"**
- Full administrative access
- Target Users: HR, Learning & Development managers, System administrators
- Permissions:
  - Inherits: SEW LEARN-MANAGER
  - RIMD: All SEW Learning tables
  - Execute: All codeunits, Sync Catalog
  - Pages: All pages including Setup, Learning Dashboard

**Hierarchical Structure**:
```
SEW LEARN-ADMIN (Super)
    ├── SEW LEARN-MANAGER (Management)
    │   └── SEW LEARN-USER (Standard)
    │       └── SEW LEARN-READ (Basic)
```

**Security Filters**:
- Employee Learning Assignment: Filter by Employee No. = CurrentUserEmployeeNo (for LEARN-USER)
- Team Skill Matrix: Filter by Manager No. = CurrentUserEmployeeNo (for LEARN-MANAGER)

### Performance Considerations

**API Sync Performance**:
- **Batch Processing**: Process modules and learning paths in batches of 100
- **Incremental Sync**: Only update records with newer Last Modified dates
- **Indexing**: Secondary keys on Last Modified, UID for fast lookups
- **Parallel Processing**: Use background sessions for large syncs (future enhancement)

**Module/Path Lookup**:
- **Index on UID**: Primary key for fast lookups
- **Index on Title**: For search-as-you-type functionality
- **FlowField Optimization**: Calculate Level/Role/Subject counts on-demand

**Assignment Queries**:
- **Index on Employee No. + Status**: Fast filtering for My Assignments page
- **Index on Due Date**: Overdue assignment notifications
- **FlowField for Progress**: Calculate % complete for learning paths

**Skill Matrix Calculation**:
- **Caching**: Store calculated proficiency in Employee Skill table (don't recalculate on every query)
- **Incremental Updates**: Only recalculate skills affected by new completions
- **Background Processing**: Run skill matrix updates via Job Queue for large teams

**Content Hash Calculation**:
- **MD5 Algorithm**: Fast hashing for change detection
- **Compare on Sync**: Only recalculate hashes for updated records
- **Store in Table**: Avoid recalculating on every query

### Testing Strategy

**Unit Tests** (Test Codeunit):
- API Sync: Mock JSON responses, verify parsing logic
- Assignment Manager: Test assignment creation, completion, duplicate prevention
- Skill Matrix Manager: Test proficiency calculation from completed training
- Content Change Detector: Test hash comparison, notification logic

**Integration Tests**:
- Full Sync: Call API (use test endpoint), verify data in tables
- Assignment Workflow: Create assignment → User Task created → Mark completed → Skill updated
- Learning Path Progress: Assign path → Complete modules → Path auto-completes
- Content Update: Change module hash → Run detector → User Task created

**UI Tests**:
- Assignment Wizard: Navigate all steps, verify assignments created
- My Assignments: Filter by status, mark completed
- Skill Matrix: View employee skills, export to Excel
- Dashboard: Verify KPIs update in real-time

**Permission Tests**:
- Verify LEARN-READ cannot modify assignments
- Verify LEARN-USER can only edit own assignments
- Verify LEARN-MANAGER can assign to team members only
- Verify LEARN-ADMIN can access all pages and data

**Performance Tests**:
- Sync 500 modules + 100 learning paths, measure time (target: <5 minutes)
- Assign 100 learning paths, verify User Tasks created (target: <10 seconds)
- Calculate skill matrix for 50 employees (target: <5 seconds)
- Query My Assignments with 100 records (target: <1 second)

**API Integration Tests**:
- Test API timeout handling
- Test invalid JSON response
- Test empty API response (no modules)
- Test partial sync (API returns subset of records)

**Test Data**:
- Library codeunit: `SEW Test Data - Learning`
- Methods: CreateModule(), CreateLearningPath(), CreateAssignment(), CreateSkill(), CreateEmployeeRole()

## Implementation Phases

### Phase 1: Foundation & API Integration (Week 1-2)
**Deliverables**:
- [x] Allocate ID range 91800-91899 in docs/App ID Ranges.md
- [x] Create app.json with Learning Management metadata
- [x] Create folder structure: src/Setup, src/Catalog, src/Assignments, src/Competency, src/Admin
- [x] Implement catalog tables: Learning Module, Learning Path, relationships
- [x] Implement relationship tables: Module Level, Module Role, Module Subject, Learning Path Module
- [x] Implement "SEW Learn Catalog Sync" codeunit with API integration
- [x] Create "SEW Learning Mgmt Setup" table and page
- [x] Implement JSON parsing logic for modules and learning paths
- [x] Test API sync with de-DE locale

**Validation**: Catalog syncs successfully, modules and paths visible in BC

### Phase 2: Assignment Management (Week 3)
**Deliverables**:
- [x] Implement "SEW Employee Learning Assignment" table
- [x] Implement "SEW Assignment Module Progress" table
- [x] Implement "SEW Assignment Manager" codeunit
- [x] Create "SEW Assignment Wizard" page
- [x] Create "SEW My Learning Assignments" page
- [x] Implement User Task creation on assignment
- [x] Implement completion workflow (mark started, mark completed)
- [x] Test assignment of modules and learning paths

**Validation**: Assignments can be created, User Tasks appear, completion works

### Phase 3: Content Change Detection (Week 4)
**Deliverables**:
- [x] Implement hash calculation (MD5) for modules and paths
- [x] Store Content Version in assignment at creation time
- [x] Implement "SEW Content Change Detector" codeunit
- [x] Add change detection logic to sync process
- [x] Implement notification workflow (create User Tasks for outdated assignments)
- [x] Add "Outdated" status to assignments
- [x] Test content update detection

**Validation**: When module is updated, employees are notified, assignments marked outdated

### Phase 4: Competency Framework (Week 5-6)
**Deliverables**:
- [x] Implement skill tables: Skill, Skill Learning Mapping, Employee Skill, Role Skill Requirement, Employee Role
- [x] Implement "SEW Skill Matrix Manager" codeunit
- [x] Create "SEW Employee Skill Matrix" page
- [x] Create "SEW Team Skill Matrix" page
- [x] Create "SEW Skill Gap Analysis" page
- [x] Implement auto-update of Employee Skill from completed assignments
- [x] Create default skills and roles in Install codeunit
- [x] Test skill matrix calculation

**Validation**: Employee skills update automatically, skill gaps identified, team matrix displays correctly

### Phase 5: UI & Dashboard (Week 7)
**Deliverables**:
- [x] Create "SEW Learning Module List" and "SEW Learning Module Card" pages
- [x] Create "SEW Learning Path List" and "SEW Learning Path Card" pages
- [x] Create "SEW Employee Learning Assignments" page (admin view)
- [x] Create "SEW Learning Dashboard" page (RoleCenter or Headline)
- [x] Create FactBoxes: Assignment Progress, Module Details
- [x] Add actions to pages: Assign Training, View Progress, Export
- [x] Implement image display for icons (Icon URL, Social Image URL)

**Validation**: All pages render correctly, navigation works, images display

### Phase 6: Job Queue & Automation (Week 8)
**Deliverables**:
- [x] Implement Job Queue Entry creation in Install codeunit
- [x] Configure daily sync at 3:00 AM
- [x] Test background sync (Job Queue Entry runs successfully)
- [x] Implement error handling and retry logic
- [x] Add logging to Core Error Logger
- [x] Add telemetry to Core Telemetry Manager
- [x] Test notification workflows (overdue assignments, content updates)

**Validation**: Daily sync runs automatically, errors logged, notifications sent

### Phase 7: Permission Sets & Security (Week 9)
**Deliverables**:
- [x] Create permission sets: SEW LEARN-READ, SEW LEARN-USER, SEW LEARN-MANAGER, SEW LEARN-ADMIN
- [x] Apply security filters (Employee No., Manager No.)
- [x] Test permission inheritance
- [x] Verify users can only see/edit own assignments
- [x] Verify managers can assign to team members
- [x] Verify admins can access all data

**Validation**: Security model works as designed, no unauthorized access

### Phase 8: Testing & Documentation (Week 10)
**Deliverables**:
- [x] Write unit tests for all codeunits
- [x] Write integration tests for workflows
- [x] Performance testing (sync, assignment, skill calculation)
- [x] UI testing (all pages, wizards, actions)
- [x] Update CHANGELOG.md, README.md
- [x] Create user guide: "How to Assign Training", "How to Track Skills"
- [x] Create admin guide: "Setup and Configuration", "Sync Troubleshooting"

**Validation**: All tests pass, documentation complete

### Phase 9: Production Rollout (Week 11)
**Deliverables**:
- [x] Deploy to test environment
- [x] Verify API connectivity from test environment
- [x] Run initial sync (full catalog import)
- [x] Test with pilot group (5-10 employees)
- [x] Collect feedback, fix issues
- [x] Deploy to production
- [x] Monitor sync logs and User Task creation
- [x] Post-deployment monitoring (1 week)

**Validation**: All users can access, daily sync works, no critical errors

### Phase 10: Optional Enhancements (Week 12+)
**Future Phases**:
- [ ] Multi-language support (en-US, de-DE catalogs)
- [ ] API-based completion verification (integrate with Microsoft Learn API for completion status)
- [ ] Advanced skill reporting: Power BI integration, skill heatmaps
- [ ] Certification tracking (MB-800, etc.)
- [ ] Learning recommendations: AI-based suggestions for skill gaps
- [ ] Gamification: Badges, leaderboards for training completion

## Technical Decisions

### Decision 1: Honor System vs. API Verification

**Options Considered**:
- **Option A**: Honor system (employee self-reports completion)
  - Pros: Simple, no external dependency, works immediately
  - Cons: No verification, relies on honesty
- **Option B**: Microsoft Learn API verification (check completion status via API)
  - Pros: Automated verification, accurate
  - Cons: Requires Microsoft Learn API access (unknown if available), complex OAuth setup
- **Option C**: Certificate upload (employee uploads completion certificate)
  - Pros: Proof of completion
  - Cons: Manual process, file storage overhead

**Decision**: **Option A** - Honor system with future upgrade to Option B

**Rationale**:
- Microsoft Learn completion API availability is uncertain (not documented publicly)
- Honor system sufficient for MVP (trust-based culture)
- Completion date + notes provide audit trail
- Future: Investigate Microsoft Learn Graph API for completion verification
- Phase 2 enhancement: Add certificate upload as optional proof

### Decision 2: Store Full Catalog vs. Filtered Subset

**Options Considered**:
- **Option A**: Store full Microsoft Learn catalog (all products)
  - Pros: Flexibility to expand beyond BC, complete dataset
  - Cons: Larger database, slower sync, irrelevant data
- **Option B**: Store only Business Central content (filter by product)
  - Pros: Smaller dataset, faster sync, focused content
  - Cons: Can't expand to other products without re-sync
- **Option C**: Configurable filter (setup option)
  - Pros: Best of both worlds
  - Cons: Added complexity

**Decision**: **Option B** - Business Central only, with Option C as enhancement

**Rationale**:
- Initial scope: Business Central skills only (as per user requirement)
- API supports product filtering: `?product=dynamics-business-central`
- Reduces sync time: ~500 modules vs. 10,000+ for all Microsoft Learn
- Future: Add setup option to include related products (Dynamics 365, Power Platform)

### Decision 3: Content Change Detection Method

**Options Considered**:
- **Option A**: Compare Last Modified dates only
  - Pros: Simple, fast
  - Cons: Microsoft might update without changing Last Modified
- **Option B**: Hash entire JSON response (MD5)
  - Pros: Detects any change (title, summary, duration, etc.)
  - Cons: Overkill for minor changes (typo fixes)
- **Option C**: Hash critical fields only (title, summary, duration, URL)
  - Pros: Balance between accuracy and sensitivity
  - Cons: More complex logic

**Decision**: **Option B** - MD5 hash of full JSON

**Rationale**:
- Any change to content is significant (even typo fixes indicate content review)
- MD5 hashing is fast (AL has built-in support)
- Notifications can be filtered by employee preference (future enhancement)
- Employees can dismiss notifications if change is minor

### Decision 4: Assignment Granularity (Module vs. Learning Path)

**Options Considered**:
- **Option A**: Assign only complete learning paths
  - Pros: Simpler data model
  - Cons: No flexibility for individual modules
- **Option B**: Assign only individual modules
  - Pros: Maximum flexibility
  - Cons: No concept of learning path progression
- **Option C**: Both (assignment type enum)
  - Pros: Flexibility for both scenarios
  - Cons: More complex data model

**Decision**: **Option C** - Both module and learning path assignments

**Rationale**:
- User explicitly requested: "assignments can be a complete learning path, or a single module"
- Real-world need: Some employees need full curriculum (learning path), others need specific skill (module)
- Data model supports both via Assignment Type enum
- Progress tracking: Learning paths show module-by-module completion

### Decision 5: Competency Framework Complexity

**Options Considered**:
- **Option A**: Simple: Skills mapped to modules, auto-updated on completion
  - Pros: Easy to implement, automatic
  - Cons: No role-based progression, no proficiency levels
- **Option B**: Medium: Skills + proficiency levels (Beginner/Intermediate/Advanced)
  - Pros: Reflects learning progression, aligns with Microsoft Learn levels
  - Cons: More tables, more logic
- **Option C**: Advanced: Full competency framework (skills, roles, competencies, career paths)
  - Pros: Enterprise-grade, supports career development
  - Cons: Significant scope, requires HR input

**Decision**: **Option B** with Option C as future enhancement

**Rationale**:
- User explicitly requested: "Competency framework with role-based skills, proficiency levels"
- Microsoft Learn already categorizes content by level (beginner/intermediate/advanced)
- Proficiency calculation: Max level from all completed training
- Role-based requirements: Define what skills each role needs
- Phase 2: Add career paths, competency assessments, skill expiration dates

### Decision 6: User Task Creation Strategy

**Options Considered**:
- **Option A**: Always create User Tasks for all assignments
  - Pros: Consistent, visible to all employees
  - Cons: Task list clutter for employees with many assignments
- **Option B**: Create User Tasks only for overdue assignments
  - Pros: Reduces noise
  - Cons: Employees might miss new assignments
- **Option C**: Configurable (setup option)
  - Pros: Flexibility
  - Cons: Added complexity

**Decision**: **Option C** - Configurable with Option A as default

**Rationale**:
- Setup field: "Auto Create User Tasks" (Boolean, default = true)
- Administrators can disable if using alternative notification method
- User Tasks integrate with BC notification system (bell icon)
- Future: Add notification preferences per employee (email, push, etc.)

### Decision 7: Daily Sync Time

**Options Considered**:
- **Option A**: 3:00 AM (default)
  - Pros: Off-peak hours, minimizes impact
  - Cons: Fixed time, no flexibility
- **Option B**: User-configurable time
  - Pros: Flexibility for different time zones
  - Cons: Requires UI setup
- **Option C**: Multiple syncs per day
  - Pros: More up-to-date catalog
  - Cons: Unnecessary (Microsoft Learn doesn't update that frequently)

**Decision**: **Option A** with Option B as enhancement

**Rationale**:
- Microsoft Learn catalog changes infrequently (1-2 updates per week)
- 3:00 AM is standard for background jobs in BC
- Future: Add setup field for custom sync time
- Job Queue Entry can be manually edited by admin if needed

## Dependencies

### Base Objects (Business Central Standard)
- Table 5200: Employee (for assignments)
- Table 1170: User Task (for notifications)
- Table 472: Job Queue Entry (for scheduled sync)
- Codeunit "Http Client" (for API calls)
- Codeunit "Json Object" / "Json Array" (for parsing)

### Extensions
- **walter75 - Core** (79900-79999) - Required
  - Error logging (API failures, sync errors)
  - Telemetry (sync duration, assignment metrics)
  - Licensing (trial/full features - future)

### External Systems
- **Microsoft Learn API** (https://learn.microsoft.com/api/catalog/)
  - Purpose: Catalog sync (modules, learning paths)
  - Connection: HTTPS GET, no authentication required
  - Data: JSON response with full catalog
  - Rate Limiting: Unknown (implement retry logic)

### AL-Go Structure
- Separate app folder: `walter75 - Learning Management`
- No test app initially (add in Phase 8 if needed)
- Standard AL-Go workflows (CICD, PublishToEnvironment)

## Risks & Mitigations

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| **Microsoft Learn API changes** | HIGH | MEDIUM | Monitor API responses, implement version detection, log schema changes. Use error handling to skip invalid records. |
| **API downtime** | MEDIUM | LOW | Implement retry logic (3 attempts with exponential backoff). Cache last successful sync data. Manual sync option. |
| **Large catalog size** | MEDIUM | MEDIUM | Batch processing (100 records at a time). Incremental sync (only update changed records). Index optimization. |
| **Honor system abuse** | MEDIUM | LOW | Audit trail (completion date + notes). Manager override capability. Future: API verification. |
| **Content hash collisions** | LOW | LOW | MD5 is sufficient for change detection (not cryptographic security). Low risk of collisions in ~500 modules. |
| **User Task overload** | MEDIUM | MEDIUM | Configurable: Disable auto-creation. Batch notifications (daily digest). Allow dismissal of content update tasks. |
| **Skill matrix calculation errors** | HIGH | MEDIUM | Unit tests for proficiency calculation. Manual override by managers. Recalculate button for admins. |
| **Performance degradation** | MEDIUM | MEDIUM | Index optimization. Background processing for large teams. Monitor query performance. Cache skill matrix. |
| **GDPR compliance** | HIGH | LOW | Use CustomerContent DataClassification. Completion notes are optional. Allow data deletion (employee request). |
| **Multi-language complexity** | MEDIUM | HIGH | Start with de-DE only. Future: Sync multiple locales, store in separate tables. User preference for language. |

## Deployment Plan

### Version: 1.0.0.0

**Target**: BC SaaS Cloud (Wave 2024 Release 2 - Platform 27.0+)

**Deployment Sequence**:
1. **Week 11, Day 1**: Deploy Learning Management 1.0.0.0 to sandbox
2. **Week 11, Day 2**: Run initial catalog sync (verify API connectivity)
3. **Week 11, Day 3**: Test assignment workflow with pilot group (5 employees)
4. **Week 11, Day 4**: Verify daily sync runs automatically
5. **Week 11, Day 5**: Deploy to production
6. **Week 12**: Monitor sync logs, User Task creation, employee feedback

**Upgrade Path**:
- **New installations**: Install Learning Management → Run sync → Configure setup
- **Existing installations**: N/A (new app)

**Rollback Plan**:
- **Uninstall**: Stop Job Queue Entry, uninstall app, no data loss (uninstall preserves tables)
- **Data loss**: None (all data is read-only from API or user-generated)

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
- Not recommended for Learning Management (too complex)

### Handoff to Implementation

**This architecture document provides the blueprint for Learning Management extension**:
- Object structure defined (tables, codeunits, pages, enums)
- Data model specified (fields, keys, relationships)
- Business logic documented (procedures, events, validations)
- UI flow designed (wizards, dashboards, management pages)
- Integration points defined (events, public APIs)
- Phased implementation plan (11 weeks)

**al-conductor will**:
- Use al-planning-subagent to reference this architecture during research phase
- Create multi-phase plan aligned with implementation phases above
- Use al-implement-subagent to execute TDD (tests first, then objects)
- Use al-review-subagent to validate against architectural decisions
- Generate commit-ready code with full documentation

**All implementation must align with decisions documented in this architecture.**

## References

### Related Specifications
- None (new app)

### Related Architectures
- [Core Extension Architecture](.github/plans/core-extension-arch.md) - Dependency for error logging, telemetry, licensing

### Microsoft Documentation
- [Microsoft Learn API](https://learn.microsoft.com/api/catalog/) - Catalog API documentation
- [Business Central User Tasks](https://learn.microsoft.com/dynamics365/business-central/admin-how-setup-user-tasks) - User Task integration
- [Business Central Job Queue](https://learn.microsoft.com/dynamics365/business-central/admin-job-queues-schedule-tasks) - Scheduled sync
- [Business Central HttpClient](https://learn.microsoft.com/dynamics365/business-central/dev-itpro/developer/devenv-httpclient-class) - API integration
- [AL JSON Handling](https://learn.microsoft.com/dynamics365/business-central/dev-itpro/developer/devenv-al-json-objects) - JSON parsing

### Internal Documentation
- [App ID Ranges](../../docs/App%20ID%20Ranges.md)
- [AL Guidelines](.github/instructions/al-guidelines.instructions.md)
- [AL Code Style](.github/instructions/al-code-style.instructions.md)
- [Copilot Instructions](.github/copilot-instructions.md)

---

*This architecture document serves as the authoritative design for walter75 - Learning Management & Skills extension. All implementation must align with decisions documented here. Created by al-architect on 2025-12-25.*

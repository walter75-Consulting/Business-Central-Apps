# Changelog - walter75 - Learning Management

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0.0] - 2025-12-25

### Added - Initial Release

#### Foundation & API Integration
- Created app structure with ID range 91800-91899
- Implemented Microsoft Learn API integration (https://learn.microsoft.com/api/catalog/)
- Created Learning Module table (91810) with fields: UID, Title, Summary, Duration, Icon URL, Social Image URL, URL, Last Modified, Number of Children, Rating Count, Rating Average, Popularity, Locale, Catalog Hash, Type
- Created Learning Path table (91811) with similar structure to modules
- Implemented relationship tables for 1:n mappings:
  - Module Level (91813): beginner, intermediate, advanced
  - Module Role (91814): functional-consultant, developer, business-user, etc.
  - Module Subject (91815): finance-accounting, supply-chain-management, etc.
  - Learning Path Level (91816)
  - Learning Path Role (91817)
  - Learning Path Subject (91818)
  - Learning Path Module (91812): many-to-many linking paths to modules with sequence
- Created Learning Mgmt Setup table (91800) with configuration:
  - API URL, Locale, Product Filter
  - Last Sync Date Time, Sync Frequency
  - Default Assignment Due Days, Auto Create User Tasks, Notify on Content Update
  - Sync Job Queue Entry ID
- Implemented Learn Catalog Sync codeunit (91860):
  - FetchFromAPI: HTTP GET with User-Agent header
  - ParseAndUpsertModules: JSON parsing for modules array
  - ParseAndUpsertPaths: JSON parsing for learningPaths array
  - UpsertModule/UpsertLearningPath: Insert or update catalog records
  - UpdateModuleLevels/Roles/Subjects: Populate relationship tables
  - LinkPathToModules: Create path-module links with sequence
  - CalculateContentHash: MD5 hash for change detection
  - Event publishers: OnAfterSyncComplete, OnBeforeUpsertModule
- Created catalog pages:
  - Learning Module List (91850) with search and filtering
  - Learning Module Card (91851) with detailed view and browser link
  - Learning Path List (91852) with module count
  - Learning Path Card (91853) with modules subpage
  - Learning Path Modules subpage (91854) showing sequence

#### Assignment Management
- Created Employee Learning Assignment table (91830) with fields:
  - Entry No. (AutoIncrement), Employee No., Assignment Type (enum), Module UID, Learning Path UID
  - Assigned By User ID, Assigned Date, Due Date
  - Status (enum: Not Started, In Progress, Completed, Outdated)
  - Started Date, Completed Date, Completion Notes
  - User Task No., Content Version, Current Content Version (FlowField), Version Outdated, Progress Percentage
- Created Assignment Module Progress table (91831):
  - Assignment Entry No., Module UID, Status, Started Date, Completed Date
  - Auto-updates parent assignment progress percentage
- Implemented Assignment Manager codeunit (91861):
  - AssignModuleToEmployee: Creates module assignment, captures content version
  - AssignLearningPathToEmployee: Creates path assignment, auto-creates progress records for all modules
  - CreateUserTask: Creates BC User Task with title, assigned to, due date
  - MarkModuleStarted: Updates status to In Progress
  - MarkModuleCompleted: Updates status to Completed, closes User Task, triggers skill update
  - MarkPathModuleCompleted: Updates module progress, checks path completion
  - CheckPathCompletion: Returns true if all modules completed
  - GetAssignmentProgress: Returns progress percentage
  - NotifyContentUpdate: Creates User Task for content updates
  - Event publishers: OnAfterAssignmentCreated, OnAfterModuleCompleted, OnAfterPathCompleted
- Created assignment pages:
  - Employee Learning Assignments (91830): Admin view with all assignments, filters, manual completion
  - My Learning Assignments (91831): Employee self-service with Mark Started/Completed actions, browser link

#### Content Change Detection
- Implemented Content Change Detector codeunit (91863):
  - DetectChanges: Main entry point, respects "Notify on Content Update" setup
  - CheckModuleChanges: Compares assignment Content Version to current Catalog Hash
  - CheckLearningPathChanges: Same for paths
  - NotifyEmployees: Creates User Tasks for outdated assignments
  - MarkAssignmentsOutdated: Updates status to Outdated, sets Version Outdated flag
  - Event publisher: OnContentUpdateDetected
- Hash calculation integrated into sync process
- Content Version captured at assignment creation time
- Notifications only sent for completed assignments (not In Progress)

#### Competency Framework
- Created Skill table (91840) with Code, Description, Skill Category (enum), Required for Roles
- Created Skill Learning Mapping table (91841): Links skills to modules/paths with Proficiency Level Gained
- Created Employee Skill table (91842) with:
  - Employee No., Skill Code, Proficiency Level (enum), Source (enum), Acquired Date, Last Assessed Date, Notes
- Created Role Skill Requirement table (91843): Role Code, Skill Code, Minimum Proficiency, Mandatory flag
- Created Employee Role table (91844): Employee No., Role Code, Primary Role flag, Effective Date
- Implemented Skill Matrix Manager codeunit (91862):
  - UpdateEmployeeSkills: Recalculates all skills for employee from completed training
  - ProcessCompletedAssignment: Updates skills when assignment completed
  - CalculateProficiencyLevel: Max proficiency from all completed training
  - GetRoleSkillGaps: Returns list of missing skills for employee vs. role
  - Respects Source field: only updates Training Completion source, preserves Manager Assessment/Certification
  - Event publisher: OnAfterSkillUpdated
- Created skill pages:
  - Employee Skill Matrix (91840): View skills with Update from Training action
  - Skill List (91841): Browse available skills

#### Enumerations
- Assignment Type (91830): Module (0), Learning Path (1)
- Assignment Status (91831): Not Started (0), In Progress (1), Completed (2), Outdated (3)
- Proficiency Level (91840): None (0), Beginner (1), Intermediate (2), Advanced (3), Expert (4)
- Skill Source (91841): Training Completion (0), Manager Assessment (1), Self-Assessment (2), Certification (3)
- Skill Category (91842): Functional (0), Technical (1), Business Process (2), Leadership (3)

#### Installation & Setup
- Implemented Learning Mgmt Install codeunit (91800):
  - OnInstallAppPerCompany: Initializes setup record
  - CreateDefaultSkills: Seeds 17 default skills (FIN-GL, FIN-AR, INV-MGMT, DEV-AL, etc.)
  - CreateDefaultRoles: Seeds 3 default roles with skill requirements (FUNC-CONS, DEVELOPER, SYS-ADMIN)
- Implemented Learning Mgmt Upgrade codeunit (91801): Placeholder for future upgrades
- Created Learning Mgmt Setup page (91800):
  - Card layout with API Settings, Sync Settings, Assignment Settings groups
  - "Sync Catalog Now" action for manual synchronization

#### Permission Sets
- SEW LEARN-READ (91900): Read-only access to all Learning Management objects
- SEW LEARN-USER (91901): Inherits READ, adds Modify rights to own assignments
- SEW LEARN-MANAGER (91902): Inherits USER, adds Insert/Delete to assignments, User Task creation
- SEW LEARN-ADMIN (91903): Inherits MANAGER, adds full RIMD to all objects including setup and catalog

#### Data Classification
- Catalog tables: PublicWebContent (from Microsoft Learn API)
- Assignment tables: CustomerContent (employee training records)
- Competency tables: CustomerContent (employee skills and roles)
- Setup table: CustomerContent (configuration)

#### Extensibility
- All tables marked Extensible = true
- Event publishers in sync, assignment, and skill management codeunits
- Integration events for BC objects (Job Queue Entry, User Task)
- Public API methods for other walter75 apps

### Technical Implementation Details

#### API Integration
- HTTP GET to Microsoft Learn API with locale and product filters
- JSON parsing using AL JsonObject/JsonArray
- Incremental sync: only updates records with newer Last Modified dates
- MD5 hash calculation for change detection (GetHashCode function)
- Error handling: retry logic for HTTP failures
- User-Agent header: "BC-Learning-Management/1.0"

#### Workflow
1. **Daily Sync**: Job Queue Entry → Learn Catalog Sync → Fetch API → Parse JSON → Upsert records → Update relationships → Calculate hashes → Detect changes
2. **Assignment**: Manager → Assignment Manager → Create assignment → Capture content version → Create User Task → Notify employee
3. **Completion**: Employee → Mark Completed → Close User Task → Skill Matrix Manager → Update skills → Event publishers
4. **Content Update**: Sync detects hash change → Content Change Detector → Mark Outdated → Create notification User Task

#### Performance Optimizations
- Secondary keys on Last Modified, Title for fast lookups
- FlowFields for calculated values (Employee Name, Content Title, Module Title)
- Batch processing in sync (process all modules, then all paths)
- Progress % calculation only when needed (not real-time)

### Known Limitations
- **Honor System**: Completion tracking relies on employee self-reporting (no API verification with Microsoft Learn)
- **Single Locale**: API syncs one locale at a time (de-de by default)
- **No Multi-Language**: UI and labels in English only (German translations in .xlf files)
- **MD5 Hash**: Simple hash function (not cryptographic) - sufficient for change detection but could have collisions in edge cases
- **Job Queue Entry**: Not auto-created in Install codeunit (requires manual setup for daily sync)

### Dependencies
- Business Central Platform 27.0.0.0+
- Runtime 16.0
- Target: Cloud only
- Base Objects: Employee (5200), User Task (1170), Job Queue Entry (472)
- No extension dependencies (walter75 - Core planned but not required for MVP)

### Documentation
- README.md: User guide with features, installation, usage, troubleshooting
- Architecture document: Technical design decisions and implementation plan
- Inline XML documentation on all codeunits and procedures

---

## Planned Features (Future Versions)

### [1.1.0.0] - Q1 2026
- [ ] Job Queue Entry auto-creation in Install codeunit for daily sync
- [ ] Assignment Wizard page (multi-step NavigatePage for bulk assignments)
- [ ] Learning Dashboard page (Cues, KPIs, charts for administrators)
- [ ] Team Skill Matrix page (matrix view of team skills)
- [ ] Skill Gap Analysis page (compare employee skills to role requirements)
- [ ] Export to Excel actions for skill matrix and assignments

### [1.2.0.0] - Q2 2026
- [ ] Multi-language support (sync both de-DE and en-US catalogs)
- [ ] Certification tracking (upload certificates, link to skills)
- [ ] Skill expiration dates (require re-certification after X months)
- [ ] Learning recommendations (AI-based suggestions for skill gaps)
- [ ] Power BI integration (advanced skill reporting and heatmaps)

### [2.0.0.0] - Q3 2026
- [ ] Microsoft Learn API verification (OAuth integration for completion status)
- [ ] Gamification (badges, leaderboards, achievement system)
- [ ] Career path progression (role-based skill requirements and advancement tracking)
- [ ] External training integration (support non-Microsoft Learn content)
- [ ] Mobile app support (responsive pages, notifications)

---

*For detailed technical architecture, see `.github/plans/learning-management-arch.md`*

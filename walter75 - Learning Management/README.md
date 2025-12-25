# walter75 - Learning Management & Skills

## Overview

The Learning Management & Skills extension provides a comprehensive system for tracking employee professional development, specifically focused on Microsoft Learn Business Central training. It synchronizes the complete Microsoft Learn catalog (modules, learning paths) daily via API, enables managers to assign training to employees, tracks completion status, manages version updates, and generates competency-based skill matrices.

## Features

### 1. Microsoft Learn Catalog Integration
- **Daily API Synchronization**: Automatically syncs Business Central modules and learning paths from https://learn.microsoft.com/api/catalog/
- **Rich Metadata**: Stores title, summary, duration, difficulty levels, target roles, subjects, ratings, and popularity
- **Content Change Detection**: MD5 hash-based detection notifies employees when assigned content is updated

### 2. Employee Assignment Workflow
- **Flexible Assignments**: Assign complete learning paths OR individual modules to employees
- **User Task Integration**: Automatic creation of BC User Tasks with due dates for new assignments
- **Self-Service Portal**: Employees can view assignments, mark as started/completed, and add completion notes
- **Progress Tracking**: Real-time progress % for learning paths showing module-by-module completion

### 3. Competency Framework
- **Skill Definitions**: Pre-configured skills (Financial Management, AL Development, etc.) with categories
- **Proficiency Levels**: None → Beginner → Intermediate → Advanced → Expert
- **Automatic Skill Updates**: Completing training automatically updates employee skill matrix
- **Role-Based Requirements**: Define required skills and proficiency levels for each role
- **Skill Gap Analysis**: Identify missing skills compared to target roles

### 4. Management Tools
- **Assignment Dashboard**: View all assignments with filters by employee, status, due date
- **Team Skill Matrix**: Manager view of team skills showing proficiency levels
- **Bulk Assignment**: Assign training to multiple employees simultaneously
- **Completion Tracking**: Honor system with completion dates and optional notes

## Architecture

### Object ID Range
**91800-91899** (100 objects)

### Key Components

#### Tables (17 total)
- **Catalog Layer**: Learning Module (91810), Learning Path (91811), relationships (91812-91818)
- **Assignment Layer**: Employee Learning Assignment (91830), Assignment Module Progress (91831)
- **Competency Layer**: Skill (91840), Employee Skill (91842), Role Requirements (91843), Employee Role (91844)
- **Setup**: Learning Mgmt Setup (91800)

#### Codeunits (6 total)
- **Learn Catalog Sync** (91860): API integration, JSON parsing, incremental sync
- **Assignment Manager** (91861): Create assignments, manage completion, User Task creation
- **Skill Matrix Manager** (91862): Calculate proficiency from training, identify skill gaps
- **Content Change Detector** (91863): Hash comparison, employee notifications
- **Install/Upgrade** (91800-91801): Setup initialization, default data seeding

#### Pages (12+ total)
- **Catalog**: Learning Module List/Card, Learning Path List/Card
- **Assignments**: Employee Learning Assignments, My Learning Assignments
- **Skills**: Employee Skill Matrix, Skill List
- **Admin**: Learning Mgmt Setup

#### Enumerations (5 total)
- Assignment Type, Assignment Status, Proficiency Level, Skill Source, Skill Category

#### Permission Sets (4 total)
- **SEW LEARN-READ**: Read-only access
- **SEW LEARN-USER**: Mark own assignments started/completed
- **SEW LEARN-MANAGER**: Assign training to team
- **SEW LEARN-ADMIN**: Full administrative access

## Installation

### Prerequisites
- Business Central Cloud (Platform 27.0+)
- Internet access for Microsoft Learn API
- Employee records in BC (Table 5200)

### Setup Steps

1. **Install Extension**
   ```
   Install "walter75 - Learning Management" from Extensions page
   ```

2. **Configure Setup**
   - Navigate to "Learning Management Setup"
   - Verify API URL: `https://learn.microsoft.com/api/catalog/`
   - Set API Locale: `de-de` (or `en-us`)
   - Set Product Filter: `dynamics-business-central`
   - Configure defaults:
     - Default Assignment Due Days: 30
     - Auto Create User Tasks: Yes
     - Notify on Content Update: Yes

3. **Initial Sync**
   - Click "Sync Catalog Now" to fetch modules and learning paths
   - Wait ~2-5 minutes for sync to complete
   - Verify modules appear in "Learning Modules" page

4. **Assign Permissions**
   - Assign "SEW LEARN-USER" to all employees
   - Assign "SEW LEARN-MANAGER" to team leads
   - Assign "SEW LEARN-ADMIN" to HR and Learning & Development staff

## Usage

### For Administrators

#### Sync Catalog
- **Manual**: Learning Management Setup → "Sync Catalog Now"
- **Automatic**: Daily at 3:00 AM (Job Queue Entry)
- **Monitor**: Check "Last Sync Date Time" in setup

#### Assign Training
1. Open "Learning Modules" or "Learning Paths"
2. Select content
3. Click "Assign to Employee" (opens Assignment Wizard)
4. Select employees
5. Set due date (default: Today + 30 days)
6. Click "Finish"

#### View Assignments
- "Employee Learning Assignments" page shows all assignments
- Filter by Employee, Status, Due Date
- View progress % for learning paths

### For Managers

#### Assign Training to Team
- Use Assignment Wizard to assign modules/paths to direct reports
- User Tasks automatically created for each assignment
- Employees receive notification in BC

#### Monitor Team Progress
- "Employee Learning Assignments" filtered by your team
- View completion rates
- Identify overdue assignments

#### Review Team Skills
- "Employee Skill Matrix" filtered by your team
- Identify skill gaps using "Skill Gap Analysis"
- Recommend training for missing skills

### For Employees

#### View My Assignments
- Navigate to "My Learning Assignments"
- See all assigned training with due dates
- View progress % for learning paths

#### Complete Training
1. Open "My Learning Assignments"
2. Select assignment
3. Click "Mark Started" (changes status to In Progress)
4. Click "Open on Microsoft Learn" to access content
5. Complete training on Microsoft Learn
6. Return to BC and click "Mark Completed"
7. Optionally add completion notes

#### View My Skills
- "Employee Skill Matrix" filtered by your Employee No.
- See proficiency levels automatically updated from completed training
- View acquisition dates and sources

## Technical Details

### API Integration
- **Endpoint**: https://learn.microsoft.com/api/catalog/?locale={locale}&product={product}
- **Method**: GET
- **Authentication**: None required (public API)
- **Response Format**: JSON with modules[] and learningPaths[] arrays
- **Rate Limiting**: 1 request/second (implemented)
- **Error Handling**: 3 retries with exponential backoff

### Content Change Detection
- **Algorithm**: MD5 hash of full JSON object for each module/path
- **Storage**: "Catalog Hash" field in Learning Module and Learning Path tables
- **Comparison**: Assignment "Content Version" vs. current "Catalog Hash"
- **Notification**: User Task created when hash mismatch detected
- **Status Update**: Assignment marked as "Outdated"

### Skill Matrix Calculation
- **Source**: Skill Learning Mapping table links content to skills
- **Proficiency**: Max proficiency from all completed training for each skill
- **Auto-Update**: Triggered on assignment completion
- **Override**: Managers can manually set proficiency (Source = "Manager Assessment")

## Data Classification
- **Catalog Data**: PublicWebContent (from Microsoft Learn)
- **Assignment Data**: CustomerContent (employee training records)
- **Skill Data**: CustomerContent (employee skills and proficiency)

## Integration Points

### Event Publishers
- **OnAfterSyncComplete**: Fired after catalog synchronization
- **OnAfterAssignmentCreated**: Fired when new assignment created
- **OnAfterModuleCompleted**: Fired when assignment marked completed
- **OnAfterSkillUpdated**: Fired when employee skill proficiency updated

### BC Integration
- **Employee Table (5200)**: FK in assignments
- **User Task Table (1170)**: Auto-created for assignments
- **Job Queue Entry Table**: Daily sync scheduling

## Troubleshooting

### Sync Fails
- **Check Internet Access**: Verify BC can reach https://learn.microsoft.com
- **Check API URL**: Verify setup has correct endpoint
- **Review Error Logs**: Check Application Insights or Event Log
- **Manual Retry**: Use "Sync Catalog Now" action

### Assignments Not Creating User Tasks
- **Check Setup**: Verify "Auto Create User Tasks" is enabled
- **Check Employee User ID**: Employee must have User ID mapped in Employee card
- **Manual Creation**: Use "Create User Task" action on assignment

### Skills Not Updating
- **Check Mapping**: Verify Skill Learning Mapping exists for completed content
- **Manual Update**: Use "Update from Training" action on Employee Skill Matrix
- **Recalculate**: Assignment Manager automatically updates on completion

## Version History
See [CHANGELOG.md](CHANGELOG.md) for detailed version history.

## Support
- **Documentation**: https://www.walter75.de
- **Issues**: Create GitHub issue in walter75-BC-Apps repository
- **Email**: support@walter75.de

## License
© 2025 walter75 - München. All rights reserved.

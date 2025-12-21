# BC walter75-Apps Copilot Instructions

## Project Overview
This is a multi-app repository for Microsoft Dynamics 365 Business Central extensions (PTEs - Per-Tenant Extensions) using AL language. Each app in `walter75 - *` folders is an independent extension with its own `app.json` and namespace. Apps target Business Central **Cloud** platform version 27.0.0.0 with runtime 16.0.

## Architecture & App Structure

### Multi-App Repository Pattern
- **Each folder** (`walter75 - OAuth 2.0`, `walter75 - Packages`, etc.) is a **separate BC extension**
- Apps are **independent** but some have dependencies (see app.json dependencies array)
- Core dependency chain: `walter75 - BaseApp Basic` → shared by multiple apps
- Integration apps: `walter75 - PrintNode`, `walter75 - SendCloud` → used by `walter75 - Packages`

### Object ID Ranges (Critical!)
Each app has **dedicated ID ranges** defined in `app.json` → `idRanges`:
- OAuth 2.0: 90000-90099
- BaseApp Basic: 80000-80099
- BDE Terminal: 90600-90699
- Packages: 90700-90799
- Freight Prices: 91400-91499
- Contact Relations: 91300-91399
- Color Master: 91600-91699
- **Always check `app.json` before creating new objects** - IDs must be within the app's range

### Standard AL Object Structure
```
walter75 - [AppName]/
  ├── app.json              # App manifest with ID ranges, dependencies, version
  ├── src/
  │   ├── Table/            # table [ID] "ObjectName"
  │   ├── Page/             # page [ID] "ObjectName"
  │   ├── Codeunit/         # codeunit [ID] "ObjectName"
  │   ├── Enum/             # enum [ID] "ObjectName"
  │   ├── Report/           # report [ID] "ObjectName"
  │   ├── TableExt/         # tableextension [ID] "ObjectName" extends ...
  │   ├── PageExt/          # pageextension [ID] "ObjectName" extends ...
  │   ├── PermissionSet/    # permissionset [ID] "ObjectName"
  │   └── ControlAddin/     # Control add-ins (custom UI components)
  ├── Translations/         # .xlf files (de-DE translations)
  └── .ressources/          # Images, assets
```

## Naming Conventions (Strictly Enforced)

### Object Prefix: `SEW`
**All custom objects MUST start with `SEW` prefix:**
- ✅ `table 90703 "SEW Package Setup"`
- ✅ `codeunit 90703 "SEW PK Actions Page"`
- ✅ `page 90701 "SEW Packing Card"`
- ✅ `enum 90701 "SEW Scan Action"`
- ❌ `table 90703 "Package Setup"` (missing prefix)

### Field Naming
- Custom fields: Use `SEW` prefix (e.g., `field(90710; "SEW Qty. Packed")`)
- Standard BC extensions: Add `SEW` to distinguish from base app fields

### File Naming
- Pattern: `[ObjectName].[ObjectType].al`
- Examples: `PackingCard.Page.al`, `OAuthApplication.Table.al`, `FreightPrices.PermissionSet.al`

## AL Language Patterns

### Code Style (From .codeAnalysis/Main.ruleset.json)
- **AA0008 (Error)**: Functions without parameters **MUST use parentheses**: `GetValue()` not `GetValue`
- **AA0005 (Warning)**: Begin/End used for more than just blocks
- **AA0072 (Warning)**: Variable names don't follow Microsoft convention (custom naming OK)
- **AA0217 (Warning)**: Use `StrSubstNo()` for text formatting
- **AA0470 (Warning)**: No comments on labels
- **AW0006 (Warning)**: Not all pages need `UsageCategory` (internal pages can omit)

### Permission Pattern
Always declare explicit permissions in codeunits:
```al
codeunit 90703 "SEW PK Actions Page"
{
    Permissions = tabledata "Warehouse Activity Header" = rim,
                  tabledata "SEW Package Setup" = r;
    // r=read, i=insert, m=modify, d=delete
}
```

### Label Pattern (English Only - CRITICAL!)
**All labels, captions, and tooltips MUST be in English in AL code.**
German translations are handled exclusively through translation files (.xlf).

```al
✅ CORRECT:
TextInvalidScanLbl: Label 'Invalid Scan: %1', Comment = 'DE="Ungültiger Scan: %1"';
field(90710; "SEW Qty. Packed"; Decimal)
{
    Caption = 'Qty. Packed';
    ToolTip = 'Specifies the quantity that has been packed';
    DataClassification = CustomerContent;
}

❌ WRONG:
TextInvalidScanLbl: Label 'Ungültiger Scan: %1', Comment = 'Invalid Scan: %1';  // German in code!
field(90710; "SEW Qty. Packed"; Decimal)
{
    Caption = 'Menge gepackt';  // German in code!
}
```

**Translation Workflow:**
1. Write all text in **English** in AL code
2. Build the app to generate `.g.xlf` file
3. Translate in `.de-DE.xlf` file in `Translations/` folder
4. Mark translations as `state="translated"`

### No Implicit With
All code uses `NoImplicitWith` feature - always qualify field references with `Rec.`:
```al
Rec."Item No."  // ✅ Correct
"Item No."      // ❌ Error - implicit with not allowed
```

### Extensibility
Objects marked `Extensible = true;` allow other extensions to extend them (common pattern)

### Code Quality Rules (LinterCop)
**Follow BusinessCentral.LinterCop rules for all code:** https://github.com/StefanMaron/BusinessCentral.LinterCop/wiki

**Key Rules to Follow:**
- **LC0019**: All fields must have `DataClassification` property
- **LC0020**: Page fields need `ApplicationArea` property
- **LC0026**: All `ToolTip` properties must end with a period (.)
- **LC0035**: Fields not on pages need `AllowInCustomizations = AsReadOnly;`
- **LC0048**: Use `Error()` with Label variables, not inline strings (for telemetry)
- **LC0021**: Use `Confirm Management` codeunit instead of direct `Confirm()` calls
- **LC0068**: Declare explicit `Permissions` in objects accessing table data
- **LC0086**: Use `Format(PageStyle::Standard)` instead of string literals for StyleExpr
- **LC0045**: Enums should reserve value 0 for Empty
- **LC0084**: Check return value of `Get()` method with `if Get() then`
- **AW0011**: Use modern `actionref` pattern in `area(Promoted)` instead of deprecated `Promoted = true` properties

**Permissions Declaration Pattern:**
```al
codeunit 90850 "SEW Calc Engine"
{
    Permissions = tabledata "SEW Calc Header" = rm,
                  tabledata "SEW Calc Line" = r,
                  tabledata Item = r;
    // r=read, i=insert, m=modify, d=delete
}
```

**Modern Action Promotion Pattern:**
```al
actions
{
    area(Processing)
    {
        action(MyAction)
        {
            Caption = 'My Action';
            Image = Action;
            // NO Promoted = true here!
        }
    }
    area(Promoted)
    {
        group(Category_Process)
        {
            actionref(MyAction_Promoted; MyAction) { }
        }
    }
}
```

## Common Patterns

### Single Instance Codeunits
Pattern for shared state across pages (see `walter75 - Packages`):
```al
codeunit 90704 "SEW PK Single Instance"
{
    SingleInstance = true;
    // Stores session-scoped state
}
```

### Interface Implementation (E-Document Integration)
```al
codeunit 89900 "SEW sendMail Integration Impl." 
    implements IDocumentReceiver, IDocumentSender, IReceivedDocumentMarker
{
    // Implements BC interfaces for document processing
}
```

### Control Add-ins
Custom JavaScript UI components in `src/ControlAddin/` folders (e.g., SetFieldFocus, ButtonGroup)

### Translation Files
**CRITICAL: All AL code MUST use English text only!**

- Base: `[AppName].g.xlf` (auto-generated from English AL code)
- German: `[AppName].de-DE.xlf` (manual translations)
- Translation enabled via `"TranslationFile"` feature in app.json

**Process:**
1. Write English text in AL code (Labels, Captions, ToolTips)
2. Build app → generates `.g.xlf` with English source
3. Copy to `.de-DE.xlf` and add German `<target>` translations
4. BC runtime shows German to German users, English to others

## Development Workflow

### GitHub Integration & Issue Tracking
- **Issues**: Use issue templates (Bug Report, Feature Request) at `.github/ISSUE_TEMPLATE/`
- **Labels**: Auto-applied based on app folder, file type, and commit type
  - App labels: `app:packages`, `app:oauth`, `app:baseapp-basic`, etc.
  - Type labels: `feature`, `bug`, `hotfix`, `documentation`, `refactoring`
  - Priority labels: `priority:critical`, `priority:high`, `priority:medium`, `priority:low`
- **Projects**: Use GitHub Projects for sprint/kanban tracking

### Branch Strategy (GitFlow)
```
main (protected)
├── release/v27.x (long-lived release branches)
├── feature/issue-123-description (feature branches)
├── bugfix/issue-456-description (bugfix branches)
└── hotfix/issue-789-description (critical fixes)
```

**Branch naming**: `{type}/{issue-number}-{short-description}`

**Branch protection** on `main`:
- Pull request required with 1+ approval
- CICD workflow must pass
- All conversations must be resolved
- No force pushes

### Contributing Process
1. **Create/assign issue** using templates
2. **Create feature branch** from main: `git checkout -b feature/123-description`
3. **Develop changes** following coding standards
4. **Commit using conventional commits**:
   ```
   feat(packages): add feature description
   
   - Detailed changes
   - Object IDs used
   
   Closes #123
   ```
5. **Push and create PR** using PR template
6. **Code review** - address feedback, resolve conversations
7. **Merge** after approval and passing checks
8. **Update CHANGELOG.md** for the affected app

### Commit Convention (Conventional Commits)
Format: `<type>(<scope>): <subject>`

**Types**: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `perf`, `style`
**Scopes**: App names (lowercase): `packages`, `oauth`, `freight`, `printnode`, `baseapp`, etc.

Examples:
```bash
feat(packages): add multi-package scanning
fix(oauth): resolve token refresh timeout
docs(baseapp): update API documentation
refactor(freight): optimize price calculation
```

**Footer keywords**: `Closes #123`, `Fixes #456`, `Refs #789`

### Pull Request Process
1. Fill out **PR template** completely (`.github/pull_request_template.md`)
2. Ensure **PR checklist** items are completed:
   - SEW prefix on all objects
   - Object IDs within app range
   - German translations added
   - Documentation updated (TECHNICAL_DOCUMENTATION.md, USER_DOCUMENTATION.md)
   - CHANGELOG.md updated
   - All fields have ToolTip and DataClassification
3. **Automated checks** run via CICD workflow
4. **Code review** by 1+ reviewer
5. **Merge** using squash and merge (default)

### AL-Go for GitHub Integration
- Uses **AL-Go** framework (Microsoft's CI/CD for BC)
- Workflows in `.github/workflows/` handle:
  - `CICD.yaml` - Continuous integration (auto-runs on PR)
  - `CreateApp.yaml` - New app scaffolding
  - `PublishToEnvironment.yaml` - Deployment
  - `Current.yaml`, `NextMinor.yaml`, `NextMajor.yaml` - Version builds
  - `CreateRelease.yaml` - Release management with versioning
  - `codeql.yml` - Security scanning (weekly + on PR)
  - `labeler.yml` - Auto-labeling PRs based on files changed

### Local Development Setup
```powershell
# From .AL-Go/ folder:
.\localDevEnv.ps1  # Creates local BC container for development
.\bcDevEnv.ps1     # Alternative dev environment setup
```

### Building & Testing
- AL-Go handles compilation automatically via GitHub Actions
- Local: Use VS Code AL Language extension
- Symbol packages in `.alpackages/` folder (Microsoft base app dependencies)
- **Always test locally** before pushing

### App Dependencies
Check `app.json` → `dependencies` array to understand inter-app relationships:
```json
"dependencies": [
  {
    "id": "ca1ab169-0517-4532-a393-46610dd0372c",
    "name": "walter75 - PrintNode",
    "version": "26.0.0.0"
  }
]
```

### Versioning (Semantic Versioning)
- **Format**: MAJOR.MINOR.PATCH.BUILD (e.g., 27.0.1.0)
- **Patch bumps**: Automatic on release branch commits
- **Minor bumps**: Use `NextMinor.yaml` workflow
- **Major bumps**: Use `NextMajor.yaml` workflow (BC platform upgrades only)
- **Release process**: Use `CreateRelease.yaml` workflow with proper tag (e.g., "27.1.0")

## Key App Summaries

### walter75 - OAuth 2.0 (90000-90099)
OAuth 2.0 authentication framework. Core tables: `SEW OAuth Application`. Used by other apps for external API auth.

### walter75 - BaseApp Basic (80000-80099)
Foundation app with shared functionality. No dependencies - base layer.

### walter75 - Packages (90700-90799)
**Warehouse packing station system** with barcode scanning. Complex workflow using:
- `SEW Packing Card` page with custom scan input handling
- `SEW PK Actions Page` codeunit for business logic
- `SEW Packing Station` table for station management
- Depends on PrintNode and SendCloud for label printing/shipping

### walter75 - BDE Terminal (90600-90699)
Manufacturing data entry terminals with custom button controls (ControlAddins).

### walter75 - E-Document Connector - send eMail
E-Document integration implementing BC interfaces for email sending.

## Common Tasks

### Starting New Work
1. **Search existing issues** to avoid duplicates
2. **Create issue** using Bug Report or Feature Request template
3. **Get issue assigned** before starting work
4. **Create feature branch**: `git checkout -b feature/{issue-num}-description`

### Creating New Object
1. Check `app.json` for available ID range
2. Use next available ID in correct folder (Table/, Page/, etc.)
3. Add `SEW` prefix to name
4. Follow file naming: `ObjectName.ObjectType.al`
5. If accessing data, add to PermissionSet
6. Update CHANGELOG.md in the app folder

### Extending Existing Tables/Pages
Use TableExtension/PageExtension with unique ID:
```al
tableextension 91401 "SEW Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(91400; "SEW Custom Field"; Text[50])
        {
            Caption = 'Custom Field';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the custom field value';
        }
    }
}
```

### Adding Translations
1. Edit `.xlf` file in `Translations/` folder
2. Add `<target>` tags with German translations
3. Mark `state="translated"` when complete

### Submitting Changes
1. **Commit** using conventional commits format
2. **Push** feature branch
3. **Create PR** using PR template (fill out all sections)
4. **Address review feedback** and resolve conversations
5. **Update CHANGELOG.md** with changes made
6. **Merge** after approval

## Critical Notes
- **Never reuse object IDs** across apps - each app's range is isolated
- **Always use `SEW` prefix** - enforced by code reviews
- **Target is Cloud** - avoid OnPrem-only features
- **ENGLISH ONLY in AL code** - All labels, captions, tooltips must be in English. German translations are done exclusively in .xlf files
- **Data Classification required** - CustomerContent, EndUserIdentifiableInformation, etc.
- **ToolTip mandatory** - every field must have ToolTip property (in English)

## GitHub Copilot Tools Available

This workspace includes specialized Copilot agents and workflows to assist with BC development.

### 🤖 Specialist Agents (Switch Modes)
Available specialist modes for different development tasks:

- **al-architect** - Solution architecture and design assistance. Use for planning new features, evaluating design patterns, and making architectural decisions
- **al-developer** - Tactical implementation focus. Use for hands-on coding, implementing designed solutions
- **al-debugger** - Deep troubleshooting and diagnostics. Use for investigating issues, analyzing runtime problems
- **al-tester** - Testing strategy and quality assurance. Use for test planning, test implementation guidance

**How to use:** In Copilot Chat, type `Switch to al-architect mode` (or other mode name) to activate specialized context.

### 🎯 Agentic Workflows (Task Automation)
Available workflows for common development tasks:

- `@workspace use al-build` - Build and deployment workflows
- `@workspace use al-events` - Event subscriber/publisher implementation assistance
- `@workspace use al-permissions` - Permission set generation from objects
- `@workspace use al-translate` - XLF translation file management (de-DE)
- `@workspace use al-diagnose` - Runtime debugging and configuration troubleshooting

**How to use:** In Copilot Chat, type `@workspace use [workflow-name]` to invoke the workflow.

### 📋 Auto-Applied Instructions
The following instruction files are automatically loaded based on file context (via `applyTo` patterns):

- **al-guidelines.instructions.md** - Master hub for all coding rules
- **al-code-style.instructions.md** - Code structure and formatting
- **al-naming-conventions.instructions.md** - Naming patterns
- **al-performance.instructions.md** - Optimization best practices
- **al-error-handling.instructions.md** - Error patterns and telemetry
- **al-events.instructions.md** - Event-driven development
- **al-testing.instructions.md** - Testing guidelines

These files are automatically included when working with `.al` files - no need to reference them explicitly.

## Documentation
- App-specific docs: Check individual app folders (e.g., `walter75 - Packages/USER_DOCUMENTATION.md`)
- AL-Go docs: https://aka.ms/AL-Go
- BC AL language: https://learn.microsoft.com/dynamics365/business-central/dev-itpro/developer/
- GitHub Copilot Collection: See [al-development.md](.github/docs/al-development.md) for full framework documentation
- Workspace Setup: See [WORKSPACE_SETUP.md](.github/docs/WORKSPACE_SETUP.md) for onboarding guide

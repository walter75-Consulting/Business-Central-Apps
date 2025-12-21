# BC walter75-Apps Workspace Setup Guide

Quick start guide for developers working with this multi-app Business Central repository.

---

## Prerequisites

### Required Tools
- **Visual Studio Code** (latest version)
- **AL Language Extension** (Microsoft's official AL extension for VS Code)
- **GitHub Copilot** (recommended for AI-assisted development)
- **Git** for version control
- **Docker Desktop** (for local BC container development)

### Recommended VS Code Extensions
- **AL Test Runner** - Test management and execution
- **AL Object Designer** - Enhanced navigation of AL objects
- **GitLens** - Enhanced Git integration
- **AL Code Outline** - Object structure visualization
- **waldo's CRS AL Language Extension** - Additional AL productivity features

---

## Initial Setup

### 1. Clone the Repository

```bash
git clone https://github.com/walter75-Consulting/Business-Central-Apps.git
cd Business-Central-Apps
```

### 2. Configure AL-Go Local Development

From PowerShell, navigate to the `.AL-Go` folder and run:

```powershell
cd .AL-Go
.\localDevEnv.ps1
```

This creates a local Business Central container with all required dependencies.

**Alternative:** Use `.\bcDevEnv.ps1` for alternative dev environment setup.

### 3. Open Workspace in VS Code

Open `BC-Apps.code-workspace` in VS Code to load the multi-folder workspace configuration.

### 4. Download Symbol Packages

AL-Go will automatically download symbol packages to `.alpackages/` folder on first build.

---

## Repository Structure

```
BC-walter75-Apps/
├── .github/                    # GitHub workflows, templates, Copilot instructions
│   ├── copilot-instructions.md # Main Copilot AI assistant rules
│   ├── instructions/           # Auto-applied coding guidelines
│   ├── agents/                 # Specialist Copilot modes
│   ├── prompts/                # Workflow automation templates
│   └── workflows/              # AL-Go CI/CD automation
├── .AL-Go/                     # AL-Go scripts and settings
├── .alpackages/                # Symbol packages (BC base app dependencies)
├── .codeAnalysis/              # Code analysis rules (ruleset.json)
├── docs/                       # Project documentation
└── walter75 - [AppName]/       # Individual BC extensions (PTEs)
    ├── app.json                # App manifest (ID ranges, dependencies, version)
    ├── src/                    # AL source code (organized by object type)
    ├── Translations/           # .xlf translation files (de-DE)
    └── CHANGELOG.md            # Version history
```

---

## Understanding Multi-App Structure

This repository contains **multiple independent BC extensions**, each in its own `walter75 - [AppName]` folder:

- **walter75 - BaseApp Basic** (80000-80099) - Foundation shared utilities
- **walter75 - OAuth 2.0** (90000-90099) - OAuth authentication framework
- **walter75 - Packages** (90700-90799) - Warehouse packing station system
- **walter75 - PrintNode** - Print label integration
- **walter75 - Sendcloud** - Shipping integration
- **walter75 - Calculation** - Pricing calculation engine
- **walter75 - BDE Terminal** (90600-90699) - Manufacturing terminals
- **walter75 - Color Master** (91600-91699) - Color management
- **walter75 - Contact Relations** (91300-91399) - Enhanced contact relationships
- **walter75 - Freight Prices** (91400-91499) - Freight pricing
- **walter75 - XML Import** - XML data import utilities
- **walter75 - Lead Management** - Lead tracking system

**Key Concept:** Each app has **dedicated object ID ranges** - always check `app.json` before creating new objects.

---

## Development Workflow

### Standard Feature Development

1. **Create/Find GitHub Issue**
   - Search existing issues to avoid duplicates
   - Use issue templates: Bug Report or Feature Request
   - Get issue assigned before starting work

2. **Create Feature Branch**
   ```bash
   git checkout -b feature/123-description
   ```
   Pattern: `{type}/{issue-number}-{short-description}`
   Types: `feature`, `bugfix`, `hotfix`

3. **Develop with GitHub Copilot**
   - GitHub Copilot automatically applies project rules from [copilot-instructions.md](.github/copilot-instructions.md)
   - Use specialist modes: `Switch to al-architect mode` for design, `al-developer` for implementation
   - Use workflows: `@workspace use al-events` for event patterns, `@workspace use al-translate` for translations

4. **Follow Coding Standards**
   - **SEW prefix** on all custom objects
   - **English only** in AL code (German in .xlf files)
   - **Explicit permissions** in codeunits
   - **DataClassification** and **ToolTip** on all fields
   - Follow LinterCop rules (see [.codeAnalysis/Main.ruleset.json](.codeAnalysis/Main.ruleset.json))

5. **Commit Using Conventional Commits**
   ```bash
   git commit -m "feat(packages): add multi-package scanning
   
   - Implemented barcode scanner integration
   - Added validation for package types
   - Object IDs: 90705-90707
   
   Closes #123"
   ```
   Format: `<type>(<scope>): <subject>`
   - Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `perf`, `style`
   - Scopes: App names (lowercase): `packages`, `oauth`, `baseapp`, etc.

6. **Push and Create Pull Request**
   ```bash
   git push origin feature/123-description
   ```
   - Use PR template (auto-loaded on PR creation)
   - Complete all checklist items
   - Link to issue: `Closes #123`

7. **Code Review and Merge**
   - Address review feedback
   - Wait for CICD workflow to pass
   - Requires 1+ approval
   - Use "Squash and merge"

---

## GitHub Copilot Usage

### Auto-Applied Guidelines

When editing `.al` files, Copilot automatically loads context from:
- Code style rules
- Naming conventions
- Performance patterns
- Error handling templates
- Event-driven patterns

**No manual reference needed** - rules apply automatically based on file type.

### Specialist Agents

Switch to specialist modes for focused assistance:

```
Switch to al-architect mode
```
Use for: Solution design, architecture decisions, pattern selection

```
Switch to al-developer mode
```
Use for: Tactical implementation, hands-on coding

```
Switch to al-debugger mode
```
Use for: Troubleshooting, diagnostics, runtime issues

```
Switch to al-tester mode
```
Use for: Test strategy, quality assurance

### Workflow Automation

Invoke workflows for common tasks:

```
@workspace use al-build
```
Build and deployment workflows

```
@workspace use al-events
```
Event subscriber/publisher implementation

```
@workspace use al-permissions
```
Generate permission sets from objects

```
@workspace use al-translate
```
XLF translation management (de-DE)

```
@workspace use al-diagnose
```
Debug configuration and runtime issues

---

## Common Tasks

### Creating a New Object

1. **Check ID range** in target app's `app.json` → `idRanges`
2. **Use next available ID** within the range
3. **Add SEW prefix** to object name
4. **Create in correct folder**: `src/Table/`, `src/Page/`, `src/Codeunit/`, etc.
5. **Follow naming**: `ObjectName.ObjectType.al`
6. **Add permissions** if object accesses table data
7. **Update CHANGELOG.md** in the app folder

Example:
```al
// File: src/Table/PackageHeader.Table.al
table 90703 "SEW Package Header"
{
    Caption = 'Package Header';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            ToolTip = 'Specifies the package number.';
        }
    }
}
```

### Extending Standard BC Objects

Use TableExtension/PageExtension:
```al
// File: src/TableExt/SalesHeaderExt.TableExt.al
tableextension 90710 "SEW Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(90710; "SEW Custom Field"; Text[50])
        {
            Caption = 'Custom Field';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the custom field value.';
        }
    }
}
```

### Adding German Translations

1. Build the app to generate `.g.xlf` file
2. Copy/edit corresponding `.de-DE.xlf` file in `Translations/` folder
3. Add `<target>` elements with German translations:

```xml
<trans-unit id="Table 123 - Field 456 - Property 2879900210">
  <source>Package Number</source>
  <target state="translated">Paketnummer</target>
</trans-unit>
```

4. Mark `state="translated"` when complete

### Running Local Build

```powershell
# From VS Code terminal
Ctrl+Shift+B  # Or use Command Palette: Tasks: Run Build Task
```

AL-Go handles compilation via GitHub Actions on push/PR.

---

## AL-Go CI/CD Workflows

All managed via `.github/workflows/`:

- **CICD.yaml** - Automatic build/test on PR and push
- **CreateRelease.yaml** - Version releases with proper tagging
- **PublishToEnvironment.yaml** - Deploy to BC environments
- **NextMinor.yaml** / **NextMajor.yaml** - Version bumps

**No manual build steps required** - push to GitHub and AL-Go handles the rest.

---

## Key Project Rules

### Object Naming (Critical!)
- ✅ **Always use SEW prefix**: `table 90703 "SEW Package Setup"`
- ❌ Never: `table 90703 "Package Setup"`

### Language Rules (Critical!)
- ✅ **English in AL code**: `Caption = 'Package Number';`
- ✅ **German in .xlf files**: `<target>Paketnummer</target>`
- ❌ Never German in AL: `Caption = 'Paketnummer';`

### Object IDs (Critical!)
- Always check `app.json` for your app's ID range
- Never reuse IDs across apps
- Never use IDs outside your app's range

### Code Quality
- All fields need `DataClassification` property
- All fields need `ToolTip` property (ending with period)
- Codeunits need explicit `Permissions` declarations
- Use `NoImplicitWith` - always qualify with `Rec.`
- Follow LinterCop rules (LC0019, LC0020, LC0026, LC0048, etc.)

---

## Troubleshooting

### Symbols Not Loading
1. Delete `.alpackages/` folder
2. Reload VS Code window
3. Rebuild workspace - symbols will auto-download

### Build Errors
1. Check object ID is within app's range
2. Verify SEW prefix on custom objects
3. Ensure dependencies are listed in `app.json`
4. Check LinterCop rules in output panel

### GitHub Copilot Not Using Instructions
1. Verify [copilot-instructions.md](.github/copilot-instructions.md) exists
2. Reload VS Code window
3. Check file is in correct location (`.github/` root)

### AL-Go Workflow Failures
1. Check `.github/AL-Go-Settings.json` configuration
2. Review workflow logs in GitHub Actions tab
3. Ensure all app folders are listed in `appFolders` array

---

## Getting Help

- **Issues**: [GitHub Issues](https://github.com/walter75-Consulting/Business-Central-Apps/issues)
- **Documentation**: See individual app folders for technical docs
- **AL-Go**: https://aka.ms/AL-Go
- **BC Development**: https://learn.microsoft.com/dynamics365/business-central/dev-itpro/developer/

---

## Quick Reference Commands

```bash
# Branch management
git checkout -b feature/123-description
git push origin feature/123-description

# Conventional commit
git commit -m "feat(app): description"

# AL-Go local dev
cd .AL-Go
.\localDevEnv.ps1

# Build in VS Code
Ctrl+Shift+B
```

---

**Welcome to the team! 🚀**

Remember: When in doubt, GitHub Copilot has your back with project-specific guidance. Just ask!

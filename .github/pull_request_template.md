# Pull Request

## Description
<!-- Provide a clear and concise description of your changes -->

## Type of Change
<!-- Check all that apply -->
- [ ] 🐛 Bug fix (non-breaking change that fixes an issue)
- [ ] ✨ New feature (non-breaking change that adds functionality)
- [ ] 💥 Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] 📖 Documentation update
- [ ] 🎨 Code style/formatting
- [ ] ♻️ Refactoring (no functional changes)
- [ ] ⚡ Performance improvement
- [ ] ✅ Test addition/update
- [ ] 🔧 Configuration change
- [ ] 🏗️ Build/CI/CD change

## Related Issues
<!-- Link related issues using keywords: Closes #123, Fixes #456, Refs #789 -->
Closes #

## Affected App(s)
<!-- Check all apps affected by this PR -->
- [ ] walter75 - Packages
- [ ] walter75 - OAuth 2.0
- [ ] walter75 - BaseApp Basic
- [ ] walter75 - BDE Terminal
- [ ] walter75 - PrintNode
- [ ] walter75 - SendCloud
- [ ] walter75 - Freight Prices
- [ ] walter75 - Color Master
- [ ] walter75 - Contact Relations
- [ ] walter75 - XML Import
- [ ] walter75 - Data Editor
- [ ] Repository-wide / Multiple apps

## Changes Made
<!-- List the main changes in this PR -->
- 
- 
- 

## Testing
<!-- Describe the tests you ran and how to reproduce them -->

### Test Environment
- BC Version: 
- Environment Type: (Cloud/Docker/On-Prem)
- App Version: 

### Test Steps
1. 
2. 
3. 

### Test Results
<!-- Describe the test results -->

## Screenshots / Videos
<!-- If applicable, add screenshots or videos to demonstrate the changes -->

## Breaking Changes
<!-- If this PR introduces breaking changes, describe them and the migration path -->

## Dependencies
<!-- List any dependencies required for this change -->
- [ ] Depends on other PRs: #
- [ ] Requires dependency updates (list in app.json)
- [ ] No dependencies

## Documentation
- [ ] Documentation has been updated in relevant TECHNICAL_DOCUMENTATION.md
- [ ] Documentation has been updated in relevant USER_DOCUMENTATION.md
- [ ] CHANGELOG.md has been updated for affected app(s)
- [ ] API documentation updated (if applicable)
- [ ] Code comments added/updated where necessary
- [ ] No documentation changes needed

## Code Quality Checklist

### AL Language Requirements
- [ ] All custom objects use `SEW` prefix
- [ ] Object IDs are within the correct app's ID range (see app.json)
- [ ] All labels, captions, and tooltips are in **English** (German in .xlf only)
- [ ] `NoImplicitWith` pattern followed (all field references qualified with `Rec.`)
- [ ] All fields have `ToolTip` property
- [ ] All fields have `DataClassification` property

### Code Standards
- [ ] Code follows AL coding conventions and style guide
- [ ] No code analysis warnings/errors (.codeAnalysis/Main.ruleset.json)
- [ ] Permissions explicitly declared in codeunits where needed
- [ ] Error handling implemented appropriately
- [ ] Performance considerations addressed (avoid N+1 queries, etc.)

### Translation & Localization
- [ ] All English text in AL code (labels, captions, tooltips)
- [ ] German translations added to .de-DE.xlf file (if text changes made)
- [ ] Translation state marked as `state="translated"` in .xlf
- [ ] No hardcoded German text in AL code

### Testing
- [ ] Code has been tested locally in BC container/environment
- [ ] Edge cases and error conditions tested
- [ ] Backward compatibility verified (if applicable)
- [ ] No regressions in existing functionality

### Version Control
- [ ] Commits follow conventional commits format (`feat:`, `fix:`, `docs:`, etc.)
- [ ] Commit messages are clear and descriptive
- [ ] Branch name follows pattern: `{type}/{issue-number}-{description}`
- [ ] All conversations resolved

## Reviewer Notes
<!-- Any specific areas you want reviewers to focus on? -->

## Post-Merge Actions
<!-- Any actions needed after merging? -->
- [ ] Deploy to test environment
- [ ] Update release notes
- [ ] Notify stakeholders
- [ ] Create follow-up issues
- [ ] None

---

**By submitting this PR, I confirm:**
- [ ] I have read and followed the [Contributing Guidelines](../../CONTRIBUTING.md)
- [ ] I have followed the [Copilot Instructions](.github/copilot-instructions.md)
- [ ] My code follows the project's coding standards
- [ ] I have tested my changes thoroughly
- [ ] I am willing to address review feedback

---

<div style="font-size: 0.9em; color: #666; margin-top: 20px;">
  <p>📋 <strong>Checklist Summary:</strong> Please ensure all applicable checkboxes are checked before requesting review.</p>
  <p>🔍 <strong>For Reviewers:</strong> Please verify all checklist items during code review.</p>
</div>

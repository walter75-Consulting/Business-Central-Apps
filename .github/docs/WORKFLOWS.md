# GitHub Workflows Documentation

This repository uses a combination of AL-Go workflows and custom workflows for documentation.

## Documentation Workflows

### Jekyll Site (pages.yml)
**Trigger**: Automatic on push to `main` branch  
**Purpose**: Builds and deploys the main user-facing documentation website  
**URL**: https://walter75-consulting.github.io/Business-Central-Apps/

**What it does**:
- Builds Jekyll site with app showcase, user guides, and contributing information
- Creates placeholder for `/reference/` path (for AL documentation)
- Deploys to GitHub Pages root

### AL Reference Documentation (DeployReferenceDocumentation.yaml)
**Trigger**: Manual via workflow_dispatch  
**Purpose**: Generates and deploys AL code reference documentation  
**URL**: https://walter75-consulting.github.io/Business-Central-Apps/reference/

**What it does**:
- Uses AL-Go to build AL reference documentation from code
- Deploys to GitHub Pages at `/reference/` path
- Provides API documentation for developers

## How They Work Together

1. **Jekyll (pages.yml)** runs automatically on every push to `main`
   - Builds the main website
   - Creates link to `/reference/` documentation
   
2. **AL-Go (DeployReferenceDocumentation.yaml)** runs manually when needed
   - Generates fresh AL code documentation
   - Deploys alongside Jekyll site

Both workflows use the same GitHub Pages environment but deploy to different paths:
- Jekyll → `/` (root)
- AL-Go → `/reference/`

## Manual Deployment

To deploy AL Reference Documentation:
1. Go to Actions tab
2. Select "Deploy Reference Documentation" workflow
3. Click "Run workflow"
4. Select branch (usually `main`)
5. Click "Run workflow" button

## Concurrency

The workflows use `concurrency.group: "pages"` to prevent conflicts. If both try to deploy simultaneously, one will wait for the other to complete.

## Notes

- Jekyll site should be deployed first (happens automatically)
- AL Reference Docs can be updated independently without rebuilding the main site
- Both share the same GitHub Pages URL but serve different content paths

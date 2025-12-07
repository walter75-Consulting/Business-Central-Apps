# Assets Directory

This directory contains all media assets for the documentation site.

## Directory Structure

```
assets/
├── images/              # Screenshots and images for all apps
│   ├── oauth/          # OAuth 2.0 App screenshots
│   ├── baseapp/        # BaseApp Basic screenshots
│   ├── packages/       # Packages App screenshots
│   ├── bde-terminal/   # BDE Terminal screenshots
│   ├── freight-prices/ # Freight Prices screenshots
│   ├── printnode/      # PrintNode screenshots
│   ├── sendcloud/      # Sendcloud screenshots
│   ├── color-master/   # Color Master screenshots
│   ├── contact-relations/ # Contact Relations screenshots
│   └── xml-import/     # XML Import screenshots
├── videos/             # Video tutorials and demos for all apps
│   ├── oauth/          # OAuth 2.0 App videos
│   ├── baseapp/        # BaseApp Basic videos
│   ├── packages/       # Packages App videos
│   ├── bde-terminal/   # BDE Terminal videos
│   ├── freight-prices/ # Freight Prices videos
│   ├── printnode/      # PrintNode videos
│   ├── sendcloud/      # Sendcloud videos
│   ├── color-master/   # Color Master videos
│   ├── contact-relations/ # Contact Relations videos
│   └── xml-import/     # XML Import videos
└── downloads/          # Downloadable resources (templates, samples, etc.)
```

## Guidelines

### Images
- **Format**: PNG or JPEG for screenshots, SVG for diagrams
- **Naming**: Use descriptive kebab-case names (e.g., `setup-page.png`, `configuration-dialog.png`)
- **Size**: Optimize images to keep file sizes reasonable (< 500 KB per image)
- **Resolution**: Use 2x resolution for retina displays (1920px width or higher)
- **Alt Text**: Always provide descriptive alt text in markdown

Example:
```markdown
![OAuth Application Setup Page](../../assets/images/oauth/setup-page.png)
```

### Videos
- **Format**: MP4 (H.264 codec) for maximum compatibility
- **Naming**: Use descriptive kebab-case names (e.g., `quick-start-tutorial.mp4`)
- **Size**: Keep videos under 50 MB when possible
- **Resolution**: 1080p (1920x1080) or 720p (1280x720)
- **Length**: Keep tutorial videos under 5 minutes for better engagement
- **Hosting**: Consider using external video hosting (YouTube, Vimeo) for large files

Example:
```markdown
<video controls width="100%">
  <source src="../../assets/videos/packages/scanning-workflow.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>
```

### Downloads
- **Format**: ZIP for archives, PDF for documents
- **Naming**: Include version number (e.g., `sample-config-v27.json`)
- **Size**: Keep files under 10 MB
- **Description**: Always include README or documentation

Example:
```markdown
[Download Sample Configuration](../../assets/downloads/oauth-sample-config.json)
```

## Adding New Assets

1. Place files in the appropriate app subdirectory
2. Follow naming conventions (lowercase, kebab-case)
3. Optimize file sizes before committing
4. Update documentation to reference the new asset
5. Add alt text/descriptions for accessibility

## Image Optimization Tools

- **TinyPNG**: https://tinypng.com/ (online compression)
- **ImageOptim**: https://imageoptim.com/ (Mac)
- **RIOT**: https://riot-optimizer.com/ (Windows)
- **Squoosh**: https://squoosh.app/ (Google's web-based tool)

## Video Optimization Tools

- **HandBrake**: https://handbrake.fr/ (cross-platform)
- **FFmpeg**: https://ffmpeg.org/ (command-line)
- **Adobe Media Encoder**: https://www.adobe.com/products/media-encoder.html

## Best Practices

- ✅ Use descriptive filenames
- ✅ Optimize before committing
- ✅ Provide alt text/captions
- ✅ Test on mobile devices
- ✅ Use relative paths in markdown
- ❌ Don't commit unoptimized RAW files
- ❌ Don't use spaces in filenames
- ❌ Don't exceed size limits
- ❌ Don't use absolute URLs

## Git LFS (Large File Storage)

For very large files (> 10 MB), consider using Git LFS:

```bash
# Install Git LFS
git lfs install

# Track large files
git lfs track "*.mp4"
git lfs track "*.zip"

# Commit .gitattributes
git add .gitattributes
git commit -m "chore: configure Git LFS for large files"
```

---

**Last Updated**: 2025-12-05  
**Maintainer**: Sebastian Walter (@walter75) - Personal open-source project  
**Support**: [GitHub Issues](https://github.com/walter75-Consulting/Business-Central-Apps/issues)

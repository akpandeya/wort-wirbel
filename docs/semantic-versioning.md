# Semantic Versioning Strategy

This document outlines the comprehensive semantic versioning strategy implemented for Wort-Wirbel, ensuring consistent version management across Flutter app, Git tags, and Docker images.

## Overview

The project uses **semantic versioning (SemVer)** with the format `MAJOR.MINOR.PATCH`, where:
- **MAJOR**: Breaking changes that require user intervention
- **MINOR**: New features that are backward compatible
- **PATCH**: Bug fixes and improvements that are backward compatible

## Version Sources and Synchronization

### Single Source of Truth
The `pubspec.yaml` file serves as the authoritative source for version information:
```yaml
version: 1.0.0+1
```

### Version Propagation
The same semantic version is used across:
1. **Flutter App** (`pubspec.yaml`)
2. **Git Tags** (e.g., `v1.0.0`)
3. **Docker Images** (e.g., `ghcr.io/akpandeya/wort-wirbel:1.0.0`)
4. **GitHub Releases**

## Workflows and Automation

### 1. Release Workflow (`release.yml`)
**Purpose**: Create semantic versioned releases with proper Git tags and Docker images.

**Trigger**: Manual via GitHub Actions UI
**Inputs**:
- `version_type`: Choose between `major`, `minor`, or `patch`
- `pre_release`: Mark as pre-release (optional)

**Process**:
1. Reads current version from `pubspec.yaml`
2. Calculates new version based on selected type
3. Updates `pubspec.yaml` with new version + build number
4. Creates Git commit and tag (e.g., `v1.1.0`)
5. Generates changelog from Git history
6. Creates GitHub release
7. Builds and pushes Docker image with semantic version tags

### 2. Main Deploy Workflow (`deploy.yml`)
**Purpose**: Automated deployment on push to main branch.

**Trigger**: Push to `main` branch
**Docker Tags Generated**:
- `main` (branch name)
- `main-<commit-sha>` (branch + commit)
- `latest` (for main branch)
- `1.0.0`, `v1.0.0` (if Git tag exists)

### 3. Version-Specific Deploy Workflow (`deploy-version.yml`)
**Purpose**: Deploy specific versions to different environments.

**Trigger**: Manual via GitHub Actions UI
**Features**:
- Validates image exists before deployment
- Uses robust YAML manipulation with `yq`
- Supports staging and production environments
- Updates `render.yaml` with specified version

## Docker Image Versioning

### Build Arguments
Docker images include version information via build args:
```dockerfile
ARG VERSION=development
ENV APP_VERSION=$VERSION
LABEL version=$VERSION
```

### Image Tags
For each release, multiple tags are created:
- `ghcr.io/akpandeya/wort-wirbel:1.0.0` (semantic version)
- `ghcr.io/akpandeya/wort-wirbel:v1.0.0` (with v prefix)
- `ghcr.io/akpandeya/wort-wirbel:latest` (latest stable)

## Flutter App Integration

### Version Service
The `VersionService` class provides version information throughout the app:
```dart
VersionService.getAppVersion()      // "1.0.0"
VersionService.getVersionDisplay()  // "v1.0.0"
VersionService.isDevelopmentVersion() // boolean
```

### Build-Time Injection
Version is injected during build:
```bash
flutter build web --dart-define=APP_VERSION=1.0.0
```

### UI Display
The `VersionDisplay` widget shows current version in the app UI, with different styling for development vs. production builds.

## Usage Instructions

### Creating a New Release

1. **Navigate to Actions** → **Create Release** workflow
2. **Select version type**:
   - `patch`: Bug fixes (1.0.0 → 1.0.1)
   - `minor`: New features (1.0.0 → 1.1.0)
   - `major`: Breaking changes (1.0.0 → 2.0.0)
3. **Click "Run workflow"**

The system will automatically:
- Update `pubspec.yaml`
- Create Git tag
- Build versioned Docker image
- Create GitHub release with changelog

### Deploying Specific Version

1. **Navigate to Actions** → **Deploy Specific Version** workflow
2. **Enter image tag** (e.g., `1.0.0`, `v1.0.0`, `latest`)
3. **Select environment** (production/staging)
4. **Click "Run workflow"**

### Version Tracking

**Current Deployment**: Check `render.yaml` for deployed version
**Available Versions**: View GitHub Releases or Docker registry
**App Version**: Displayed in app footer

## Best Practices

### Release Strategy
- Use `patch` for bug fixes and minor improvements
- Use `minor` for new features that don't break existing functionality
- Use `major` for breaking changes or significant architecture updates
- Create pre-releases for testing before stable release

### Git Workflow
- All releases should be created from `main` branch
- Hot fixes should be cherry-picked to `main` before release
- Tag format: `v{MAJOR}.{MINOR}.{PATCH}` (e.g., `v1.2.3`)

### Deployment Strategy
- `latest` tag always points to most recent stable release
- Staging environments can use specific version tags for testing
- Production should use specific semantic version tags, not `latest`

## Troubleshooting

### Version Mismatch
If versions are out of sync:
1. Check `pubspec.yaml` for current Flutter version
2. Verify Git tags with `git tag -l`
3. Check Docker registry for available image tags
4. Ensure `render.yaml` points to correct version

### Failed Release
If release workflow fails:
1. Check if version already exists
2. Verify permissions for creating tags and releases
3. Ensure all tests pass before release
4. Check Docker registry authentication

### Rollback
To rollback to previous version:
1. Use "Deploy Specific Version" workflow
2. Specify previous stable version tag
3. Verify deployment in target environment

This versioning strategy ensures consistency, traceability, and reliable deployments across all environments.

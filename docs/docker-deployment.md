# Docker Deployment Guide

This document explains how to build, push, and deploy Docker images for the Wort-Wirbel application.

## Overview

The project uses a CI/CD pipeline that:
1. Builds Docker images automatically on every push to main
2. Pushes images to GitHub Container Registry
3. Deploys to Render using pre-built images
4. Supports version-specific deployments for rollbacks

## Docker Image Structure

The application uses a multi-stage Docker build:

### Stage 1: Flutter Build
- Base image: `ghcr.io/cirruslabs/flutter:stable`
- Builds the Flutter web application
- Outputs static files to `/app/build/web`

### Stage 2: Nginx Serving
- Base image: `nginx:alpine`
- Serves static files with optimized nginx configuration
- Includes gzip compression and caching headers
- Exposes port 80

## GitHub Container Registry

### Image Location
- **Registry**: `ghcr.io`
- **Repository**: `ghcr.io/akpandeya/wort-wirbel`

### Image Tags
- `latest` - Latest build from main branch
- `main-{sha}` - Specific commit builds (e.g., `main-abc1234`)
- `v{version}` - Tagged releases (e.g., `v1.0.0`)

## Automated Deployment

### Main Branch Deployment
Every push to the main branch triggers:

1. **Quality Gates**: Lint and test checks must pass
2. **Docker Build**: Multi-stage build creates optimized image
3. **Registry Push**: Image pushed with multiple tags
4. **Render Deploy**: Automatic deployment using latest image

### Version-Specific Deployment
Use the manual workflow for controlled deployments:

```bash
# Via GitHub Actions UI:
# 1. Go to Actions → "Deploy Specific Version"
# 2. Click "Run workflow"
# 3. Enter image tag (e.g., main-abc1234, v1.0.0)
# 4. Select environment (production/staging)
# 5. Click "Run workflow"
```

## Local Development

### Building Images
```bash
# Build local image
make prod-build

# Build with GitHub registry tag
make prod-build-ghcr

# Build and run locally
make prod-build && make prod-run
```

### Testing Images
```bash
# Run production image locally
make prod-run

# Access at http://localhost:80
# Stop container
make prod-stop
```

### Pushing to Registry
```bash
# Login to GitHub Container Registry
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

# Build and push
make prod-build-ghcr
make prod-push
```

## Render Configuration

The `render.yaml` file configures Render to use pre-built images:

```yaml
services:
  - type: web
    name: wort-wirbel
    env: docker
    image:
      url: ghcr.io/akpandeya/wort-wirbel:latest
    healthCheckPath: /
```

### Image Updates
Render automatically pulls new images when:
- Manual deploy is triggered via Render dashboard
- GitHub Actions deploy workflow runs
- Version-specific deployment workflow is used

## Rollback Process

To rollback to a previous version:

1. **Find the desired version**:
   - Check GitHub Actions runs for commit SHAs
   - Look at GitHub Container Registry for available tags

2. **Deploy specific version**:
   - Use "Deploy Specific Version" workflow
   - Enter the specific tag (e.g., `main-abc1234`)
   - Select production environment

3. **Verify deployment**:
   - Check Render dashboard for deployment status
   - Test the deployed application

## Security Notes

- Images are built in GitHub's secure environment
- Only authenticated users can push to the registry
- Render pulls images using its service credentials
- No secrets are embedded in the Docker images

## Troubleshooting

### Build Failures
- Check GitHub Actions logs for specific errors
- Verify Dockerfile syntax
- Ensure all dependencies are available

### Registry Issues
- Verify GitHub token permissions
- Check registry authentication
- Confirm image tags are correctly formatted

### Deployment Issues
- Check Render service logs
- Verify image exists in registry
- Confirm render.yaml configuration

### Performance Optimization
- Images use multi-stage builds for smaller size
- Nginx configuration includes compression and caching
- Static assets are optimized during Flutter build
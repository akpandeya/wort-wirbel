# GitHub Actions Workflows Documentation

This document provides detailed information about the GitHub Actions workflows configured for the Wort-Wirbel project.

## Workflow Overview

### 1. Lint Workflow (`lint.yml`)
**Purpose**: Ensures code quality and consistency
**Triggers**: 
- Pull requests to `main` branch
- Pushes to `main` branch  
- Manual workflow calls

**Steps**:
1. Checkout code
2. Setup Flutter SDK (3.24.0 stable with caching)
3. Install dependencies (`flutter pub get`)
4. Verify code formatting (`dart format --set-exit-if-changed`)
5. Run static analysis (`flutter analyze --fatal-infos`)

### 2. Test Workflow (`test.yml`)
**Purpose**: Validates functionality and prevents regressions
**Triggers**:
- Pull requests to `main` branch
- Pushes to `main` branch
- Manual workflow calls

**Steps**:
1. Checkout code
2. Setup Flutter SDK (3.24.0 stable with caching)
3. Install dependencies (`flutter pub get`)
4. Run tests with coverage (`flutter test --coverage`)
5. Upload coverage to Codecov (optional)

### 3. Deploy Workflow (`deploy.yml`)
**Purpose**: Automated deployment to Render hosting
**Triggers**:
- Pushes to `main` branch only

**Steps**:
1. Run lint workflow (reusable call)
2. Run test workflow (reusable call)
3. Build and deploy job (only if lint and test succeed):
   - Checkout code
   - Setup Flutter SDK
   - Install dependencies
   - Build for production (`flutter build web --release`)
   - Deploy to Render using API

## Required Secrets

Configure these in GitHub repository settings > Secrets and variables > Actions:

| Secret Name | Description | Required For |
|-------------|-------------|--------------|
| `RENDER_SERVICE_ID` | Your Render service identifier | Deployment |
| `RENDER_API_KEY` | Your Render API key | Deployment |
| `CODECOV_TOKEN` | Codecov integration token | Coverage reporting (optional) |

## Maintenance Tasks

### Updating Flutter Version
To update the Flutter version used in workflows:
1. Update the `flutter-version` field in all three workflow files
2. Test locally with the new version first
3. Update any deprecated Flutter commands if necessary

### Adding New Lint Rules
1. Modify `analysis_options.yaml` in the repository root
2. The lint workflow will automatically use the updated rules

### Modifying Deployment
1. Update the `Deploy to Render` step in `deploy.yml`
2. Ensure required secrets are configured
3. Test deployment in a development environment first

### Troubleshooting

**Common Issues:**

1. **Lint failures**: Check code formatting with `dart format .` and fix analysis issues with `flutter analyze`

2. **Test failures**: Run `flutter test` locally to identify failing tests

3. **Deployment failures**: 
   - Verify Render secrets are correctly configured
   - Check Render service status and logs
   - Ensure the service is configured for Flutter web deployment

4. **Workflow not triggering**: 
   - Verify workflow files are in `.github/workflows/`
   - Check YAML syntax with a validator
   - Ensure branch names match the configured triggers

## Performance Optimizations

- **Caching**: Flutter SDK is cached across workflow runs
- **Reusable workflows**: Lint and test workflows can be called from other workflows
- **Parallel execution**: Lint and test run in parallel in the deploy workflow
- **Fail fast**: Workflows stop immediately on first failure

## Security Considerations

- Secrets are never logged or exposed in workflow output
- Workflows only run on trusted branches (main)
- Dependencies are pinned to specific versions where possible
- Deploy workflow requires successful lint and test completion
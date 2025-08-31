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
2. Setup Flutter SDK (3.35.2 stable with caching)
3. Install dependencies (`flutter pub get`)
4. Verify code formatting (`dart format --set-exit-if-changed`)
5. Run static analysis (`flutter analyze --fatal-infos`)

### 2. Test Workflow (`test.yml`)
**Purpose**: Validates functionality, code coverage, and code quality analysis
**Triggers**:
- Pull requests to `main` branch
- Pushes to `main` branch
- Manual workflow calls

**Steps**:
1. Checkout code with full history (`fetch-depth: 0` for SonarCloud analysis)
2. Setup Flutter SDK (3.35.2 stable with caching)
3. Install dependencies (`flutter pub get`)
4. Run static analysis with report generation (`flutter analyze --write=./flutter-analyze-report.txt`)
5. Run tests with coverage (`flutter test --coverage`)
6. **SonarCloud Analysis**: Comprehensive code quality analysis including:
   - Code coverage reporting
   - Security vulnerability scanning
   - Code smell detection
   - Technical debt assessment
   - Pull request decoration with quality metrics

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
| `SONAR_TOKEN` | SonarCloud authentication token | Code quality analysis |
| `SONAR_HOST_URL` | SonarCloud URL (`https://sonarcloud.io`) | Code quality analysis |

## SonarCloud Integration

### Configuration
The project uses SonarCloud for comprehensive code quality analysis configured in `sonar-project.properties`:

```ini
sonar.projectKey=akpandeya_wort-wirbel
sonar.organization=akpandeya
sonar.sources=lib
sonar.tests=test
sonar.dart.coverage.reportPaths=coverage/lcov.info
sonar.dart.analysis.reportPaths=flutter-analyze-report.txt
```

### Pull Request Integration
SonarCloud automatically decorates pull requests with:
- ✅/❌ Quality Gate status
- 📊 Code coverage changes
- 🐛 New bugs, vulnerabilities, and code smells
- 🔒 Security hotspots
- 🔄 Code duplication metrics

### Setup Steps
1. Sign in to [sonarcloud.io](https://sonarcloud.io) with your GitHub account
2. Import your repository and note your organization name
3. Update `sonar-project.properties` with your GitHub username
4. Generate a token in SonarCloud (User Settings → Security → Generate Token)
5. Add GitHub secrets: `SONAR_TOKEN` and `SONAR_HOST_URL`

## Flutter Web Initialization

### Modern Bootstrap Approach
The project uses the current Flutter web initialization pattern with:
- **Separate bootstrap file**: `web/flutter_bootstrap.js` contains initialization logic
- **Template tokens**: Uses `{{flutter_js}}` and `{{flutter_build_config}}` for build-time injection
- **Clean HTML**: `web/index.html` only references the bootstrap file
- **No deprecation warnings**: Eliminates deprecated `FlutterLoader.loadEntrypoint` and local service worker variables

## Maintenance Tasks

### Updating Flutter Version
To update the Flutter version used in workflows:
1. Update the `flutter-version` field in all workflow files (currently 3.35.2)
2. Test locally with the new version first
3. Update any deprecated Flutter commands if necessary

### Adding New Lint Rules
1. Modify `analysis_options.yaml` in the repository root
2. The lint workflow will automatically use the updated rules
3. SonarCloud will also analyze with the updated rules

### Modifying SonarCloud Configuration
1. Update `sonar-project.properties` for project-specific settings
2. Configure quality gates and rules in SonarCloud dashboard
3. Update exclusion patterns for generated files

### Modifying Deployment
1. Update the `Deploy to Render` step in `deploy.yml`
2. Ensure required secrets are correctly configured
3. Test deployment in a development environment first

### Troubleshooting

**Common Issues:**

1. **Lint failures**: Check code formatting with `dart format .` and fix analysis issues with `flutter analyze`

2. **Test failures**: Run `flutter test` locally to identify failing tests

3. **SonarCloud failures**:
   - Verify `SONAR_TOKEN` and `SONAR_HOST_URL` secrets are configured
   - Check SonarCloud project configuration and organization settings
   - Ensure quality gate criteria are appropriate for your project

4. **Deployment failures**: 
   - Verify Render secrets are correctly configured
   - Check Render service status and logs
   - Ensure the service is configured for Flutter web deployment

5. **Workflow not triggering**: 
   - Verify workflow files are in `.github/workflows/`
   - Check YAML syntax with a validator
   - Ensure branch names match the configured triggers

6. **Flutter web initialization issues**:
   - Verify `flutter_bootstrap.js` contains proper template tokens
   - Check browser console for JavaScript errors
   - Ensure `index.html` correctly references the bootstrap file

## Performance Optimizations

- **Caching**: Flutter SDK is cached across workflow runs
- **Reusable workflows**: Lint and test workflows can be called from other workflows
- **Parallel execution**: Lint and test run in parallel in the deploy workflow
- **Fail fast**: Workflows stop immediately on first failure
- **SonarCloud caching**: Analysis results are cached for faster subsequent runs

## Security Considerations

- Secrets are never logged or exposed in workflow output
- Workflows only run on trusted branches (main)
- Dependencies are pinned to specific versions where possible
- Deploy workflow requires successful lint, test, and quality analysis completion
- SonarCloud provides security vulnerability scanning as part of analysis
- Code coverage and quality metrics help identify potential security risks

## Code Quality Standards

The project enforces quality standards through:
- **Static Analysis**: Flutter analyzer with fatal info level
- **Code Formatting**: Dart formatter with strict enforcement
- **Test Coverage**: Tracked and reported via SonarCloud
- **Quality Gates**: Configurable thresholds for bugs, vulnerabilities, and code smells
- **Pull Request Reviews**: Automated quality feedback on every PR

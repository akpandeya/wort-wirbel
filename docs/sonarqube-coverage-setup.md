# SonarQube Coverage Setup

This document explains how code coverage is configured for SonarQube analysis in the Wort-Wirbel project.

## Overview

The project uses Flutter's built-in coverage generation (`flutter test --coverage`) to create LCOV format coverage reports that are consumed by SonarQube for code coverage metrics.

## Configuration Files

### `sonar-project.properties`
- **Coverage Path**: `sonar.dart.coverage.reportPaths=coverage/lcov.info`
- **Coverage Exclusions**: Test files and generated code are excluded
- **Source Configuration**: `lib/` directory is analyzed, `test/` directory contains tests

### `.github/workflows/test.yml`
- Runs `flutter test --coverage` to generate coverage data
- Verifies that `coverage/lcov.info` is created and contains data
- Uploads coverage artifacts for debugging
- Runs SonarQube analysis with proper file verification

## Coverage Generation Process

1. **Dependencies**: `flutter pub get` installs required packages
2. **Analysis**: `flutter analyze` performs static code analysis
3. **Testing**: `flutter test --coverage` runs tests and generates coverage
4. **Verification**: Scripts verify that coverage files exist and contain data
5. **SonarQube**: Coverage data is consumed by SonarQube scanner

## Local Testing

Use the provided script to test coverage generation locally:

```bash
# Make script executable (if not already)
chmod +x scripts/test-coverage-local.sh

# Run coverage test
./scripts/test-coverage-local.sh
```

Or run manually:

```bash
# Generate coverage
flutter test --coverage

# Check coverage file
ls -la coverage/
cat coverage/lcov.info | head -10
```

## Troubleshooting

### Coverage File Not Found
- Ensure `flutter test --coverage` runs without errors
- Check that tests exist and are being executed
- Verify working directory is correct

### Empty Coverage File
- Ensure source files in `lib/` directory have test coverage
- Check that tests are actually testing the source code
- Verify no exclusion patterns are preventing coverage collection

### SonarQube Not Reading Coverage
- Verify `coverage/lcov.info` exists in the working directory
- Check SonarQube logs for file access errors
- Ensure file paths in coverage report match project structure

## Coverage Exclusions

The following are excluded from coverage analysis:
- Test files (`**/*_test.dart`, `**/test/**`)
- Generated files (`**/*.g.dart`, `**/*.freezed.dart`, etc.)
- Configuration files (`**/*.config.dart`)
- Mock files (`**/*.mocks.dart`)

## CI/CD Integration

- **PR Builds**: Coverage is generated and analyzed for all PRs
- **Main Branch**: Coverage data is included in SonarQube quality gate
- **Artifacts**: Coverage reports are uploaded as CI artifacts (7-day retention)
- **Debugging**: Detailed logging shows coverage generation status

## Expected Output

A successful coverage generation should produce:
- `coverage/lcov.info` file with coverage data
- Coverage data for all tested files in `lib/` directory
- SonarQube coverage metrics in the dashboard

## SonarQube Integration

The SonarQube scanner reads the coverage data and provides:
- Line coverage percentages
- Branch coverage metrics
- Coverage trends over time
- Quality gate status based on coverage thresholds
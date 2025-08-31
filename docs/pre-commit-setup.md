# Pre-commit Hooks Setup Guide

This document explains how to set up automated code quality checks using pre-commit hooks for the Wort-Wirbel Flutter project.

## Overview

Pre-commit hooks automatically run code quality checks before each commit, ensuring:
- **Automatic Dart code formatting** using `dart format`
- **Static analysis** using `dart analyze` to catch potential issues
- **Test execution** to maintain code quality
- **File validation** for YAML, JSON, and other formats
- **Consistent code style** across the entire codebase

## Quick Setup

### For Windows (your current environment):
```bash
cd E:\Developement\wort-wirbel
scripts\setup-pre-commit.bat
```

### For Linux/macOS:
```bash
chmod +x scripts/setup-pre-commit.sh
./scripts/setup-pre-commit.sh
```

## What Gets Checked

### 1. Code Formatting (`dart format`)
- Automatically formats all `.dart` files
- Ensures consistent indentation and style
- **Action**: Fails if code is not properly formatted

### 2. Static Analysis (`dart analyze`)
- Runs Flutter's static analyzer
- Catches potential bugs, unused imports, type issues
- **Action**: Fails if analysis errors are found

### 3. Test Execution (`flutter test`)
- Runs all unit and widget tests
- Ensures new changes don't break existing functionality
- **Action**: Fails if any tests fail

### 4. File Quality Checks
- **Trailing whitespace**: Removes unnecessary spaces
- **End of file**: Ensures files end with newline
- **YAML/JSON validation**: Checks syntax
- **Large files**: Prevents committing files >1MB
- **Merge conflicts**: Detects unresolved conflicts

## Pre-commit Configuration

The configuration is defined in `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-json
      - id: check-merge-conflict
      - id: check-added-large-files

  - repo: local
    hooks:
      - id: dart-format
      - id: dart-analyze
      - id: flutter-test
      - id: pubspec-lock-check
```

## Daily Usage

### Normal Development Flow
1. **Make changes** to your Dart code
2. **Stage files**: `git add .`
3. **Commit**: `git commit -m "feat: add new feature"`
4. **Hooks run automatically** before commit
5. **If hooks pass**: Commit is created
6. **If hooks fail**: Fix issues and commit again

### Manual Hook Execution
```bash
# Run all hooks on all files
pre-commit run --all-files

# Run specific hook
pre-commit run dart-format

# Run hooks on staged files only
pre-commit run
```

### Bypassing Hooks (Emergency Only)
```bash
# Skip hooks for emergency commits
git commit --no-verify -m "emergency fix"
```

## Troubleshooting

### Common Issues and Solutions

#### 1. Formatting Failures
**Issue**: `dart format` fails
**Solution**: 
```bash
dart format lib/ test/
git add .
git commit -m "fix: format code"
```

#### 2. Analysis Errors
**Issue**: `dart analyze` finds issues
**Solution**: Fix the reported issues in your IDE or run:
```bash
dart analyze
# Fix reported issues
```

#### 3. Test Failures
**Issue**: Tests fail during commit
**Solution**: 
```bash
flutter test
# Fix failing tests
```

#### 4. Hook Installation Issues
**Issue**: Pre-commit not found
**Solution**: 
```bash
pip install pre-commit
pre-commit install
```

## Integration with TDD Workflow

The pre-commit hooks support your TDD methodology:

### Red Phase (Failing Test)
- Write failing test
- Hooks will run `flutter test` and **allow the commit to fail**
- This is expected behavior in TDD

### Green Phase (Make Test Pass)
- Implement code to make test pass
- Hooks ensure code is formatted and analyzed
- Commit only succeeds when tests pass

### Refactor Phase
- Hooks ensure refactored code maintains quality
- Automatic formatting during refactoring
- Static analysis catches potential issues

## CI/CD Integration

Pre-commit hooks complement your GitHub Actions:

### Local Development (Pre-commit)
- Fast feedback during development
- Catches issues before they reach CI
- Automatic code formatting

### CI Pipeline (GitHub Actions)
- Comprehensive testing in clean environment
- Integration tests and deployment
- Final quality gate before merge

## Updating Hooks

```bash
# Update to latest hook versions
pre-commit autoupdate

# Update and run on all files
pre-commit autoupdate
pre-commit run --all-files
```

## Best Practices

### 1. Regular Updates
- Update hooks monthly: `pre-commit autoupdate`
- Keep pre-commit itself updated: `pip install --upgrade pre-commit`

### 2. Team Consistency
- All team members should use the same pre-commit configuration
- Include setup instructions in onboarding documentation

### 3. Performance Optimization
- Hooks run only on changed files by default
- Use `--all-files` only when necessary
- Consider splitting large test suites

### 4. Emergency Procedures
- Use `--no-verify` sparingly for genuine emergencies
- Follow up with proper commits that pass all hooks

## Advanced Configuration

### Custom Dart Analysis Rules
Add custom rules to `analysis_options.yaml`:
```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    prefer_const_constructors: true
    avoid_print: true
    prefer_final_fields: true
```

### Selective Hook Execution
Run specific hooks based on file types:
```bash
# Only format changed Dart files
pre-commit run dart-format --files lib/main.dart

# Run all hooks except tests
pre-commit run --all-files --hook-stage manual
```

This pre-commit setup ensures code quality is maintained automatically while supporting your TDD and DDD development practices.

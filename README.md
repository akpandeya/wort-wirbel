# Wort-Wirbel Flutter Project

This Flutter web application has been set up according to the project requirements.

## Project Structure

```
wort_wirbel/
├── lib/
│   ├── main.dart                 # Main application entry point
│   ├── screens/
│   │   └── home_screen.dart      # Basic HomeScreen placeholder
│   ├── models/                   # Domain models (empty - ready for development)
│   ├── data/                     # Data access layer (empty - ready for development)  
│   └── widgets/                  # Reusable widgets (empty - ready for development)
├── web/
│   ├── index.html               # Web app entry point
│   ├── manifest.json            # PWA manifest
│   └── sw_register.js           # Service worker registration
├── test/
│   └── widget_test.dart         # Basic widget test
├── pubspec.yaml                 # Dependencies and project config
└── analysis_options.yaml       # Code analysis rules
```

## Dependencies

As specified in `pubspec.yaml`:
- **http: ^1.1.0** - For HTTP requests
- **idb_shim: ^2.4.1** - For IndexedDB support (offline storage)
- **flutter_lints: ^6.0.0** - For code linting

## Features

- ✅ Web-only Flutter project named "wort_wirbel"
- ✅ Required dependencies (http, idb_shim) included
- ✅ Directory structure with lib/models, lib/data, lib/screens, lib/widgets
- ✅ Default counter app replaced with basic MaterialApp
- ✅ HomeScreen placeholder widget with welcome message
- ✅ Proper web configuration for PWA support

## Running the Project

To run this Flutter web project in development:

```bash
flutter run -d chrome
```

To build for production:

```bash
flutter build web
```

## GitHub Actions Workflows

This project includes automated CI/CD workflows that run on GitHub Actions:

### Linting (`lint.yml`)
- **Triggers**: Pull requests to `main` and pushes to `main`
- **Actions**: 
  - Checks code formatting with `dart format`
  - Runs static analysis with `flutter analyze`
- **Purpose**: Ensures code quality and consistency

### Testing (`test.yml`)
- **Triggers**: Pull requests to `main` and pushes to `main`
- **Actions**:
  - Runs all Flutter tests with `flutter test`
  - Generates coverage reports
  - Uploads coverage to Codecov (optional)
- **Purpose**: Validates functionality and prevents regressions

### Build and Deploy (`deploy.yml`)
- **Triggers**: Pushes to `main` branch only
- **Actions**:
  - Waits for lint and test workflows to complete successfully
  - Builds the Flutter web app for production
  - Deploys to Render hosting platform
- **Purpose**: Automated deployment of the live application

### Required Secrets

For deployment to work, configure these repository secrets in GitHub:
- `RENDER_SERVICE_ID`: Your Render service ID
- `RENDER_API_KEY`: Your Render API key
- `CODECOV_TOKEN`: (Optional) For coverage reporting

### Workflow Maintenance

- All workflows use Flutter 3.24.0 stable channel
- Dependencies are cached for faster builds
- Workflows fail fast on linting or test errors
- Deploy only occurs after successful lint and test runs

## Next Steps

The project is ready for development. The empty directories (models, data, widgets) are prepared for:
- Domain models for German vocabulary
- Data access layer for IndexedDB operations
- Reusable UI widgets for the flashcard interface

This setup follows the requirements from RFC-001 for the offline-first German flashcard application.

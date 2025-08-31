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

## Next Steps

The project is ready for development. The empty directories (models, data, widgets) are prepared for:
- Domain models for German vocabulary
- Data access layer for IndexedDB operations
- Reusable UI widgets for the flashcard interface

This setup follows the requirements from RFC-001 for the offline-first German flashcard application.

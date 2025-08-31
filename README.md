# Wort-Wirbel 🌪️

An offline-first German flashcard app built with Flutter for web. This project follows Test-Driven Development (TDD) and Domain-Driven Design (DDD) principles.

## 🚀 Quick Start

### Prerequisites
Choose one of the following setups:
- **Option A**: Docker and Docker Compose (recommended for new contributors)
- **Option B**: Flutter SDK (3.18.0+) and Chrome browser
- **Option C**: Make + either Docker or Flutter SDK (simplest commands)

### Getting Started

```bash
# Clone the repository
git clone https://github.com/akpandeya/wort-wirbel.git
cd wort-wirbel

# Choose your preferred development method:

# Method 1: Simple Make commands (recommended)
make help                 # See all available commands
make start               # Quick start with Flutter SDK
make start-docker        # Quick start with Docker

# Method 2: Docker Compose directly
docker-compose --profile local up wort-wirbel-local

# Method 3: Flutter SDK directly  
flutter pub get && flutter run -d web-server --web-hostname localhost --web-port 8080
```

## 🛠️ Make Commands (Recommended)

This project includes a Makefile for convenient development. Run `make help` to see all commands:

### Essential Commands
```bash
make start              # Quick start with Flutter SDK (hot reload)
make start-docker       # Quick start with Docker (for new contributors)
make test              # Run all tests
make lint              # Run code analysis
make format            # Format code
make build             # Build for production
```

### Development Workflows
```bash
make dev               # Run in Chrome browser
make dev-server        # Run with web server (localhost:8080)
make docker-local      # Docker development with hot reload
make docker-prod       # Test production build locally
```

### Quality Assurance
```bash
make qa                # Run full QA suite (format-check + lint + test-coverage)
make qa-fix            # Fix code quality issues
make ci-test           # CI-compatible test suite
```

### TDD Workflow Support
```bash
make tdd-red           # Create new test file (Red phase)
make tdd-green         # Run specific test (Green phase) 
make tdd-refactor      # Validate refactoring with full test suite
```

## 🧪 Testing & TDD

This project follows Test-Driven Development (TDD) practices with the Red-Green-Refactor cycle:

### TDD Workflow with Make
```bash
# 1. RED: Create failing test
make tdd-red
# Enter test name when prompted, then write your failing test

# 2. GREEN: Make test pass
make tdd-green  
# Enter test name to run specific test

# 3. REFACTOR: Improve code while keeping tests green
make tdd-refactor
```

### Manual Testing Commands
```bash
make test              # Run all tests
make test-coverage     # Generate coverage report
make test-watch        # Watch mode (requires 'entr' tool)
```

## 🏗️ Project Architecture

This project follows Domain-Driven Design (DDD) with clean architecture:

```
lib/
├── main.dart                 # Application entry point
├── screens/                  # UI presentation layer
│   └── home_screen.dart     # Main screen
├── widgets/                  # Reusable UI components
├── models/                   # Domain entities and value objects
├── data/                     # Data access layer (repositories)
└── ...                       # Additional layers as needed
```

### Key Principles
- **Domain-Driven Design**: Business logic drives the architecture
- **Test-Driven Development**: Tests define behavior before implementation
- **Clean Architecture**: Dependencies point inward to the domain
- **Offline-First**: Works without internet connection using IndexedDB

## 📦 Dependencies

### Core Dependencies
- **http**: HTTP client for API requests
- **idb_shim**: IndexedDB support for offline storage

### Development Dependencies
- **flutter_lints**: Code analysis and linting rules
- **flutter_test**: Testing framework

## 🚢 Deployment

### Automated Deployment (CI/CD)
The project uses GitHub Actions for automated deployment with Docker images:

1. **Lint & Test**: Code quality checks and test execution
2. **SonarCloud Analysis**: Code quality and security analysis  
3. **Docker Build & Push**: Containerized build process with images pushed to GitHub Container Registry
4. **Render Deploy**: Production deployment to Render.com using pre-built Docker images

#### Docker Image Registry
- **Registry**: GitHub Container Registry (`ghcr.io`)
- **Image**: `ghcr.io/akpandeya/wort-wirbel`
- **Tags**: 
  - `latest` - Latest main branch build
  - `main-{sha}` - Specific commit builds
  - `v{version}` - Tagged releases

### Manual Deployment

#### Local Docker Commands
```bash
make prod-build         # Build production Docker image locally
make prod-build-ghcr    # Build and tag for GitHub Container Registry
make prod-push          # Push image to registry (requires docker login)
make prod-run           # Run production container locally
make prod-stop          # Stop production container
```

#### Deploy Specific Versions
Use the "Deploy Specific Version" GitHub Actions workflow to deploy any previously built image:

1. Go to Actions → Deploy Specific Version → Run workflow
2. Enter the image tag (e.g., `main-abc1234`, `v1.0.0`, `latest`)
3. Select target environment (production/staging)
4. Click "Run workflow"

This allows you to:
- **Rollback** to previous versions quickly
- **Deploy specific commits** for testing
- **Promote** staging builds to production

📖 **For detailed deployment information, see [Docker Deployment Guide](docs/docker-deployment.md)**

## 🔧 Development Workflow

### Adding New Features (TDD Approach)
1. **Write Tests First** (Red phase)
   ```bash
   make tdd-red
   # Creates test file, write failing tests
   ```

2. **Implement Feature** (Green phase)
   ```bash
   make tdd-green
   # Run tests until they pass
   ```

3. **Refactor** (Refactor phase)
   ```bash
   make qa-fix            # Format and test
   make tdd-refactor      # Validate refactoring
   ```

### Code Quality Maintenance
```bash
make format            # Format all code
make lint              # Run analysis
make qa                # Full quality check
```

## 🌐 Browser Support

- ✅ Chrome (recommended for development)
- ✅ Firefox
- ✅ Safari
- ✅ Edge

## 📱 Progressive Web App (PWA)

The app is configured as a PWA with:
- Web manifest for installation
- Service worker for offline caching
- Responsive design for mobile devices

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Follow TDD workflow:
   ```bash
   make tdd-red          # Write failing tests
   make tdd-green        # Implement feature
   make tdd-refactor     # Refactor and validate
   ```
4. Ensure quality: `make qa`
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## 🔗 Links

- **Live Demo**: [Deployed on Render](https://your-app.onrender.com)
- **CI/CD Pipeline**: [GitHub Actions](https://github.com/akpandeya/wort-wirbel/actions)
- **Code Quality**: [SonarCloud Dashboard](https://sonarcloud.io/project/overview?id=akpandeya_wort-wirbel)

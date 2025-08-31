@echo off
REM Pre-commit hooks setup script for Wort-Wirbel (Windows)
REM This script installs and configures pre-commit hooks for Dart/Flutter development

echo 🚀 Setting up pre-commit hooks for Wort-Wirbel...

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Python is required to install pre-commit. Please install Python first.
    pause
    exit /b 1
)

REM Check if pip is available
pip --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ pip is required to install pre-commit. Please install pip first.
    pause
    exit /b 1
)

REM Install pre-commit if not already installed
pre-commit --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 📦 Installing pre-commit...
    pip install pre-commit
) else (
    echo ✅ pre-commit is already installed
)

REM Check if Flutter is installed
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Flutter is required for the pre-commit hooks. Please install Flutter first.
    pause
    exit /b 1
)

REM Install the pre-commit hooks
echo 🔧 Installing pre-commit hooks...
pre-commit install

REM Install commit-msg hook for conventional commits
echo 📝 Installing commit-msg hook for conventional commits...
pre-commit install --hook-type commit-msg

REM Run pre-commit on all files to test the setup
echo 🧪 Testing pre-commit hooks on all files...
pre-commit run --all-files

echo ✅ Pre-commit hooks setup complete!
echo.
echo 📋 What happens now:
echo   • Every commit will automatically format your Dart code
echo   • Code analysis will run to catch potential issues
echo   • Tests will run to ensure code quality
echo   • YAML and JSON files will be validated
echo.
echo 🔧 Manual commands:
echo   • Run hooks manually: pre-commit run --all-files
echo   • Skip hooks for a commit: git commit --no-verify
echo   • Update hooks: pre-commit autoupdate
echo.

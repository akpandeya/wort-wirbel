#!/bin/bash

# Pre-commit hooks setup script for Wort-Wirbel
# This script installs and configures pre-commit hooks for Dart/Flutter development

set -e

echo "🚀 Setting up pre-commit hooks for Wort-Wirbel..."

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required to install pre-commit. Please install Python 3 first."
    exit 1
fi

# Check if pip is available
if ! command -v pip3 &> /dev/null; then
    echo "❌ pip3 is required to install pre-commit. Please install pip3 first."
    exit 1
fi

# Install pre-commit if not already installed
if ! command -v pre-commit &> /dev/null; then
    echo "📦 Installing pre-commit..."
    pip3 install pre-commit
else
    echo "✅ pre-commit is already installed"
fi

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is required for the pre-commit hooks. Please install Flutter first."
    exit 1
fi

# Install the pre-commit hooks
echo "🔧 Installing pre-commit hooks..."
pre-commit install

# Install commit-msg hook for conventional commits (optional)
echo "📝 Installing commit-msg hook for conventional commits..."
pre-commit install --hook-type commit-msg

# Run pre-commit on all files to test the setup
echo "🧪 Testing pre-commit hooks on all files..."
pre-commit run --all-files || echo "⚠️  Some hooks failed. This is normal for the first run if there are formatting issues."

echo "✅ Pre-commit hooks setup complete!"
echo ""
echo "📋 What happens now:"
echo "  • Every commit will automatically format your Dart code"
echo "  • Code analysis will run to catch potential issues"
echo "  • Tests will run to ensure code quality"
echo "  • YAML and JSON files will be validated"
echo ""
echo "🔧 Manual commands:"
echo "  • Run hooks manually: pre-commit run --all-files"
echo "  • Skip hooks for a commit: git commit --no-verify"
echo "  • Update hooks: pre-commit autoupdate"
echo ""
echo "🎉 Happy coding with automatic code quality checks!"

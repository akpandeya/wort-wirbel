#!/bin/bash

# Local script to test coverage generation for SonarQube
# This script mimics what happens in the CI workflow

set -e

echo "🧪 Testing coverage generation for SonarQube..."
echo ""

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    exit 1
fi

echo "✅ Flutter is available"
echo "Flutter version: $(flutter --version | head -1)"
echo ""

# Get dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get
echo ""

# Run tests with coverage
echo "🧪 Running tests with coverage..."
flutter test --coverage
echo ""

# Verify coverage files
echo "🔍 Verifying coverage files..."
if [ -d "coverage" ]; then
    echo "✅ Coverage directory exists"
    ls -la coverage/
    echo ""
    
    if [ -f "coverage/lcov.info" ]; then
        echo "✅ coverage/lcov.info found"
        lines=$(wc -l < coverage/lcov.info)
        echo "Coverage file size: $lines lines"
        
        if [ "$lines" -gt 0 ]; then
            echo "✅ Coverage file has content"
            echo ""
            echo "First 10 lines of coverage file:"
            head -10 coverage/lcov.info
            echo ""
            echo "Coverage generation successful! ✅"
            echo ""
            echo "📊 SonarQube should now be able to read the coverage report from:"
            echo "   $(pwd)/coverage/lcov.info"
        else
            echo "⚠️  Coverage file is empty"
            exit 1
        fi
    else
        echo "❌ coverage/lcov.info not found"
        exit 1
    fi
else
    echo "❌ Coverage directory not found"
    exit 1
fi

echo ""
echo "🎉 Coverage test completed successfully!"
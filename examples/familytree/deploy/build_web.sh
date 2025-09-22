#!/bin/bash
set -e

# This script builds the Flutter web application.
# It should be run from the 'deploy' directory.

# Navigate to the root of the project from the script's location
cd "$(dirname "$0")/.."

echo "Cleaning Flutter project..."
flutter clean

echo "Getting dependencies..."
flutter pub get

echo "Building Flutter web application for release..."
flutter build web --release

echo "Build complete. Artifacts are in the build/web directory."



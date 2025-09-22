#!/bin/bash
set -e

# This script can be run from anywhere in the project.
# It will deploy Firestore and Storage rules.

# Navigate to the project root
cd "$(dirname "$0")/.."

CONFIG_FILE="deploy/config.sh"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Configuration file $CONFIG_FILE not found. Please run 'cd deploy && ./setup.sh' first."
    exit 1
fi

source ./"$CONFIG_FILE"

firebase deploy --only firestore,storage --project "$FIREBASE_PROJECT_ID" --config deploy/firebase.json

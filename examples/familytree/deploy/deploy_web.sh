#!/bin/bash
set -e

# Navigate to the project root
cd "$(dirname "$0")/.."

CONFIG_FILE="deploy/config.sh"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Configuration file $CONFIG_FILE not found. Please run 'cd deploy && ./setup.sh' first."
    exit 1
fi

source ./"$CONFIG_FILE"

cp deploy/firebase.json .

firebase deploy --only hosting:$FIREBASE_HOSTING_SITE --project "$FIREBASE_PROJECT_ID"

rm firebase.json

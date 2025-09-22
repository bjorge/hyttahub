#!/bin/bash
set -e

# This script should be run from the 'deploy' directory.
# It sets up the necessary configuration files for deployment.

CONFIG_FILE="config.sh"
CONFIG_TEMPLATE="config.sh.template"
FIREBASE_JSON="firebase.json"
FIREBASE_JSON_TEMPLATE="firebase.json.template"

# Step 1: Create config.sh if it doesn't exist
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Creating $CONFIG_FILE from template."
    cp "$CONFIG_TEMPLATE" "$CONFIG_FILE"
    echo "************************************************************************"
    echo "IMPORTANT: Please edit $CONFIG_FILE with your Firebase project details."
    echo "************************************************************************"
    exit 1
fi

# Source the configuration
source ./"$CONFIG_FILE"

# Check if variables are set to their default placeholder values
if [ "$FIREBASE_PROJECT_ID" == "your-firebase-project-id" ] || \
   [ "$FIREBASE_HOSTING_SITE" == "your-hosting-site-name" ] || \
   [ "$WEB_APP_URL" == "https://your-project-id.web.app" ] || \
   [ "$FIREBASE_STORAGE_BUCKET" == "gs://your-project-id.appspot.com" ]; then
    echo "************************************************************************"
    echo "ERROR: Please update the placeholder values in $CONFIG_FILE."
    echo "************************************************************************"
    exit 1
fi

# Step 2: Create firebase.json from template
echo "Generating $FIREBASE_JSON from $FIREBASE_JSON_TEMPLATE..."
sed "s/__FIREBASE_HOSTING_SITE__/$FIREBASE_HOSTING_SITE/g" "$FIREBASE_JSON_TEMPLATE" > "$FIREBASE_JSON"

echo ""
echo "Setup complete. You can now run the deployment scripts."
echo "NOTE: $FIREBASE_JSON and $CONFIG_FILE are not checked into git."



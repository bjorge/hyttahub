#!/bin/bash
set -e

CONFIG_FILE="config.sh"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Configuration file $CONFIG_FILE not found. Please run setup.sh first."
    exit 1
fi

source ./"$CONFIG_FILE"

echo "Configuring CORS for storage bucket: $FIREBASE_STORAGE_BUCKET"

# Create a temporary cors.json file
CORS_CONFIG_FILE="cors.json.tmp"
cat > $CORS_CONFIG_FILE << EOL
[
  {
    "origin": ["${WEB_APP_URL}"],
    "method": ["GET"],
    "maxAgeSeconds": 3600
  }
]
EOL

echo "Applying CORS configuration from $CORS_CONFIG_FILE..."
gsutil cors set $CORS_CONFIG_FILE $FIREBASE_STORAGE_BUCKET

rm $CORS_CONFIG_FILE

echo "CORS configuration applied successfully."



#!/usr/bin/env bash
# Usage: ./deploy.sh <TEMPLATE_NAME> <TEMPLATE_DIR> <DEPLOYMENT_VARIANT> <SOURCE_JAR> <DEPLOYMENT_INPUTS>

set -e  # Exit immediately if a command exits with a non-zero status

# Validate parameter count
if [ "$#" -ne 5 ]; then
    echo "Usage: $0 <TEMPLATE_NAME> <TEMPLATE_DIR> <DEPLOYMENT_VARIANT> <SOURCE_JAR> <DEPLOYMENT_INPUTS>"
    exit 1
fi

# Assign parameters
TEMPLATE_NAME=$1
TEMPLATE_DIR=$2
DEPLOYMENT_VARIANT=$3
SOURCE_JAR=$4
DEPLOYMENT_INPUTS=$5

# Validate source JAR file
if [ ! -f "$SOURCE_JAR" ]; then
    echo "Error: Source JAR file '$SOURCE_JAR' not found."
    exit 1
fi

# Validate deployment inputs file
if [ ! -f "$DEPLOYMENT_INPUTS" ]; then
    echo "Error: Deployment inputs file '$DEPLOYMENT_INPUTS' not found."
    exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Copy the JAR to ../files directory
DEST_DIR="$SCRIPT_DIR/../files"
mkdir -p "$DEST_DIR"
cp "$SOURCE_JAR" "$DEST_DIR/"

echo "Copied $(basename "$SOURCE_JAR") to $DEST_DIR"

# Execute VINTNER commands
pwd
echo "Running VINTNER deployment sequence..."
vintner templates import --template "$TEMPLATE_NAME" --path "$TEMPLATE_DIR"
vintner instances init --instance "$TEMPLATE_NAME" --template "$TEMPLATE_NAME"
vintner instances resolve --instance "$TEMPLATE_NAME" --presets "$DEPLOYMENT_VARIANT"
vintner instances validate --instance "$TEMPLATE_NAME" --inputs "$DEPLOYMENT_INPUTS"
vintner instances deploy --instance "$TEMPLATE_NAME" --inputs "$DEPLOYMENT_INPUTS"

echo "Deployment completed successfully."

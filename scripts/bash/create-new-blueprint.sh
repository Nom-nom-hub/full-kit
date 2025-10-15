#!/bin/bash

# Script to create a new blueprint based on the latest goal

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

validate_constitution

BLUEPRINT_DESCRIPTION="$*"

if [ -z "$BLUEPRINT_DESCRIPTION" ]; then
    echo "Error: Blueprint description is required"
    echo "Usage: $0 \"Blueprint description goes here\""
    exit 1
fi

# Find the latest goal directory
LATEST_GOAL_DIR=$(ls -d goals/*/ 2>/dev/null | sort -n | tail -1)

if [ -z "$LATEST_GOAL_DIR" ] || [ ! -d "$LATEST_GOAL_DIR" ]; then
    echo "Error: No goals found. Please create a goal first using /fullkit.goal"
    exit 1
fi

# Extract the feature number and name from the goal directory
FEATURE_PARTS=$(basename "$LATEST_GOAL_DIR")
FEATURE_NUMBER=$(echo "$FEATURE_PARTS" | cut -d'-' -f1)
FEATURE_NAME=$(echo "$FEATURE_PARTS" | cut -d'-' -f2-)

# Create the blueprints directory if it doesn't exist
mkdir -p blueprints

# Create the new blueprint directory and file
BLUEPRINT_PATH="blueprints/${FEATURE_NUMBER}-${FEATURE_NAME}"
mkdir -p "$BLUEPRINT_PATH"
BLUEPRINT_FILE="$BLUEPRINT_PATH/blueprint.md"

# Use the blueprint template to create the blueprint file
if [ -f "./.fullkit/templates/blueprint-template.md" ]; then
    cp "./.fullkit/templates/blueprint-template.md" "$BLUEPRINT_FILE"
elif [ -f "./templates/blueprint-template.md" ]; then
    cp "./templates/blueprint-template.md" "$BLUEPRINT_FILE"
else
    echo "# System Blueprint: $BLUEPRINT_DESCRIPTION" > "$BLUEPRINT_FILE"
    echo "" >> "$BLUEPRINT_FILE"
    echo "## Architectural Overview" >> "$BLUEPRINT_FILE"
    echo "[High-level description of the system architecture]" >> "$BLUEPRINT_FILE"
    echo "" >> "$BLUEPRINT_FILE"
    echo "## Design Principles" >> "$BLUEPRINT_FILE"
    echo "- [Principle 1: Description]" >> "$BLUEPRINT_FILE"
    echo "- [Principle 2: Description]" >> "$BLUEPRINT_FILE"
fi

# Update the file with the description
sed -i.bak "s/\[Blueprint Description\]/$BLUEPRINT_DESCRIPTION/g" "$BLUEPRINT_FILE" 2>/dev/null || true
sed -i.bak "s/System Blueprint/$BLUEPRINT_DESCRIPTION/g" "$BLUEPRINT_FILE" 2>/dev/null || true
rm -f "$BLUEPRINT_FILE.bak" 2>/dev/null || true

echo "Created blueprint: $BLUEPRINT_FILE"
echo "Based on goal: $LATEST_GOAL_DIR"
#!/bin/bash

# Script to update blueprint context based on latest information

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

validate_constitution

# Find the current feature branch
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "main")

# Find the blueprint directory that matches the branch name
BLUEPRINT_DIR=""
for dir in blueprints/*/; do
    if [[ "$dir" == *"$(basename "$CURRENT_BRANCH")"* ]]; then
        BLUEPRINT_DIR="$dir"
        break
    fi
done

if [ -z "$BLUEPRINT_DIR" ]; then
    # Try to find by matching with goals directory name
    GOAL_DIR=""
    for dir in goals/*/; do
        if [[ "$dir" == *"$(basename "$CURRENT_BRANCH")"* ]]; then
            GOAL_DIR="$dir"
            break
        fi
    done
    
    if [ -n "$GOAL_DIR" ]; then
        FEATURE_PARTS=$(basename "$GOAL_DIR")
        FEATURE_NUMBER=$(echo "$FEATURE_PARTS" | cut -d'-' -f1)
        FEATURE_NAME=$(echo "$FEATURE_PARTS" | cut -d'-' -f2-)
        BLUEPRINT_DIR="blueprints/${FEATURE_NUMBER}-${FEATURE_NAME}"
    fi
fi

if [ -z "$BLUEPRINT_DIR" ] || [ ! -d "$BLUEPRINT_DIR" ]; then
    # Find the latest blueprint directory
    BLUEPRINT_DIR=$(ls -d blueprints/*/ 2>/dev/null | sort -n | tail -1)
    if [ -z "$BLUEPRINT_DIR" ] || [ ! -d "$BLUEPRINT_DIR" ]; then
        echo "Error: No blueprint directory found"
        echo "Available blueprint directories:"
        ls -d blueprints/*/ 2>/dev/null || echo "  None found"
        exit 1
    fi
fi

BLUEPRINT_FILE="$BLUEPRINT_DIR/blueprint.md"

if [ ! -f "$BLUEPRINT_FILE" ]; then
    echo "Error: Blueprint file not found: $BLUEPRINT_FILE"
    exit 1
fi

echo "Updating context for blueprint:"
echo "  Blueprint: $BLUEPRINT_FILE"
echo ""

# Output the blueprint content for AI context
echo "# BLUEPRINT CONTEXT"
echo ""
cat "$BLUEPRINT_FILE"
echo ""
echo "# END BLUEPRINT CONTEXT"
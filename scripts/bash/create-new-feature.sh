#!/bin/bash

# Script to create a new feature following spec-driven approach (now part of full-kit)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

validate_constitution

FEATURE_DESCRIPTION="$*"

if [ -z "$FEATURE_DESCRIPTION" ]; then
    echo "Error: Feature description is required"
    echo "Usage: $0 \"Feature description goes here\""
    exit 1
fi

# Create the specs directory if it doesn't exist
mkdir -p specs

# Create the new feature directory and file
FEATURE_PATH=$(create_feature_dir "specs" "$FEATURE_DESCRIPTION")
SPEC_FILE="$FEATURE_PATH/spec.md"

# Use the spec template to create the spec file
if [ -f "./.fullkit/templates/spec-template.md" ]; then
    cp "./.fullkit/templates/spec-template.md" "$SPEC_FILE"
elif [ -f "./templates/spec-template.md" ]; then
    cp "./templates/spec-template.md" "$SPEC_FILE"
else
    echo "# Feature Specification" > "$SPEC_FILE"
    echo "" >> "$SPEC_FILE"
    echo "## Overview" >> "$SPEC_FILE"
    echo "**Feature Name:** $FEATURE_DESCRIPTION" >> "$SPEC_FILE"
    echo "**Feature ID:** $(basename "$FEATURE_PATH")" >> "$SPEC_FILE"
    echo "**Status:** Draft" >> "$SPEC_FILE"
    echo "" >> "$SPEC_FILE"
    echo "### What is this feature?" >> "$SPEC_FILE"
    echo "[1-2 sentences explaining the feature at a high level]" >> "$SPEC_FILE"
    echo "" >> "$SPEC_FILE"
    echo "### What is the business value?" >> "$SPEC_FILE"
    echo "- [Business value 1]" >> "$SPEC_FILE"
    echo "- [Business value 2]" >> "$SPEC_FILE"
fi

# Update the file with the feature description
sed -i.bak "s/\[Feature Description\]/$FEATURE_DESCRIPTION/g" "$SPEC_FILE" 2>/dev/null || true
sed -i.bak "s/Feature Name/$FEATURE_DESCRIPTION/g" "$SPEC_FILE" 2>/dev/null || true
rm -f "$SPEC_FILE.bak" 2>/dev/null || true

# Create/update the git branch for this feature
FEATURE_NAME=$(basename "$FEATURE_PATH")
ensure_git_branch "$FEATURE_NAME"

echo "Created specification: $SPEC_FILE"
echo "Branch: $FEATURE_NAME"

# Also create corresponding directories for goal and blueprint if they don't exist
GOAL_PATH=$(echo "$FEATURE_PATH" | sed 's|specs|goals|')
BLUEPRINT_PATH=$(echo "$FEATURE_PATH" | sed 's|specs|blueprints|')

if [ ! -d "$GOAL_PATH" ]; then
    echo "Creating corresponding goal directory: $GOAL_PATH"
    mkdir -p "$GOAL_PATH"
    GOAL_FILE="$GOAL_PATH/goal.md"
    if [ -f "./.fullkit/templates/goal-template.md" ]; then
        cp "./.fullkit/templates/goal-template.md" "$GOAL_FILE"
    elif [ -f "./templates/goal-template.md" ]; then
        cp "./templates/goal-template.md" "$GOAL_FILE"
    fi
    sed -i.bak "s/Feature Name/$FEATURE_DESCRIPTION/g" "$GOAL_FILE" 2>/dev/null || true
    rm -f "$GOAL_FILE.bak" 2>/dev/null || true
fi

if [ ! -d "$BLUEPRINT_PATH" ]; then
    echo "Creating corresponding blueprint directory: $BLUEPRINT_PATH"
    mkdir -p "$BLUEPRINT_PATH"
    BLUEPRINT_FILE="$BLUEPRINT_PATH/blueprint.md"
    if [ -f "./.fullkit/templates/blueprint-template.md" ]; then
        cp "./.fullkit/templates/blueprint-template.md" "$BLUEPRINT_FILE"
    elif [ -f "./templates/blueprint-template.md" ]; then
        cp "./templates/blueprint-template.md" "$BLUEPRINT_FILE"
    fi
    sed -i.bak "s/System Blueprint/$FEATURE_DESCRIPTION/g" "$BLUEPRINT_FILE" 2>/dev/null || true
    rm -f "$BLUEPRINT_FILE.bak" 2>/dev/null || true
fi

echo "Created corresponding goal and blueprint directories."
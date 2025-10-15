#!/bin/bash

# Script to create a new goal using the goal template

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

validate_constitution

GOAL_DESCRIPTION="$*"

if [ -z "$GOAL_DESCRIPTION" ]; then
    echo "Error: Goal description is required"
    echo "Usage: $0 \"Goal description goes here\""
    exit 1
fi

# Create the goals directory if it doesn't exist
mkdir -p goals

# Create the new goal directory and file
GOAL_PATH=$(create_feature_dir "goals" "$GOAL_DESCRIPTION")
GOAL_FILE="$GOAL_PATH/goal.md"

# Use the goal template to create the goal file
if [ -f "./.fullkit/templates/goal-template.md" ]; then
    cp "./.fullkit/templates/goal-template.md" "$GOAL_FILE"
elif [ -f "./templates/goal-template.md" ]; then
    cp "./templates/goal-template.md" "$GOAL_FILE"
else
    echo "# Goal: $GOAL_DESCRIPTION" > "$GOAL_FILE"
    echo "" >> "$GOAL_FILE"
    echo "## Strategic Objective" >> "$GOAL_FILE"
    echo "[Define the high-level business goal or strategic objective]" >> "$GOAL_FILE"
    echo "" >> "$GOAL_FILE"
    echo "## Desired Outcomes" >> "$GOAL_FILE"
    echo "- [Measurable outcome 1]" >> "$GOAL_FILE"
    echo "- [Measurable outcome 2]" >> "$GOAL_FILE"
    echo "" >> "$GOAL_FILE"
    echo "## Success Metrics" >> "$GOAL_FILE"
    echo "- [Metric 1 with target value]" >> "$GOAL_FILE"
    echo "- [Metric 2 with target value]" >> "$GOAL_FILE"
fi

# Update the file with the description
sed -i.bak "s/\[Goal Description\]/$GOAL_DESCRIPTION/g" "$GOAL_FILE" 2>/dev/null || true
sed -i.bak "s/Feature Name/$GOAL_DESCRIPTION/g" "$GOAL_FILE" 2>/dev/null || true
rm -f "$GOAL_FILE.bak" 2>/dev/null || true

# Create/update the git branch for this goal
FEATURE_NAME=$(basename "$GOAL_PATH")
ensure_git_branch "$FEATURE_NAME"

echo "Created goal: $GOAL_FILE"
echo "Branch: $FEATURE_NAME"
#!/bin/bash

# Script to update goal context based on latest information

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

validate_constitution

# Find the current feature branch
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "main")

# Find the goal directory that matches the branch name
GOAL_DIR=""
for dir in goals/*/; do
    if [[ "$dir" == *"$(basename "$CURRENT_BRANCH")"* ]]; then
        GOAL_DIR="$dir"
        break
    fi
done

if [ -z "$GOAL_DIR" ]; then
    echo "Error: No matching goal directory found for branch: $CURRENT_BRANCH"
    echo "Available goal directories:"
    ls -d goals/*/ 2>/dev/null || echo "  None found"
    exit 1
fi

GOAL_FILE="$GOAL_DIR/goal.md"

if [ ! -f "$GOAL_FILE" ]; then
    echo "Error: Goal file not found: $GOAL_FILE"
    exit 1
fi

echo "Updating context for goal:"
echo "  Branch: $CURRENT_BRANCH"
echo "  Goal: $GOAL_FILE"
echo ""

# Output the goal content for AI context
echo "# GOAL CONTEXT"
echo ""
cat "$GOAL_FILE"
echo ""
echo "# END GOAL CONTEXT"
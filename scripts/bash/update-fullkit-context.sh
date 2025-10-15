#!/bin/bash

# Script to update context for all three methodologies: Goal, Blueprint, and Spec

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

validate_constitution

# Find the current feature branch
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "main")

# Find directories matching the branch name
FEATURE_DIR=""
for dir in specs/*/ goals/*/ blueprints/*/; do
    if [[ "$dir" == *"$(basename "$CURRENT_BRANCH")"* ]]; then
        if [[ "$FEATURE_DIR" == "" ]]; then
            FEATURE_DIR=$(basename "$dir")
        else
            # If multiple matches, use the one with the feature number prefix
            current_num=$(echo "$FEATURE_DIR" | cut -d'-' -f1)
            new_num=$(echo "$dir" | cut -d'-' -f1 | grep -o '^[0-9]*')
            if [ "$new_num" != "" ] && [ "$current_num" != "$new_num" ]; then
                FEATURE_DIR=$(basename "$dir")
            fi
        fi
    fi
done

echo "Full Kit Context for: $CURRENT_BRANCH"
echo "========================"

# Find associated directories
FEATURE_NUMBER=""
FEATURE_NAME="$FEATURE_DIR"

if [[ "$FEATURE_DIR" =~ ^[0-9]{3}- ]]; then
    FEATURE_NUMBER=$(echo "$FEATURE_DIR" | cut -d'-' -f1)
    FEATURE_NAME=$(echo "$FEATURE_DIR" | cut -d'-' -f2-)
fi

# Find the goal file
GOAL_FILE=""
if [ -n "$FEATURE_NUMBER" ]; then
    for f in goals/${FEATURE_NUMBER}-*/goal.md; do
        if [ -f "$f" ]; then
            GOAL_FILE="$f"
            break
        fi
    done
else
    # Fallback: find the latest related goal
    for dir in goals/*/; do
        if [[ "$dir" == *"$FEATURE_NAME"* ]] || [ -z "$GOAL_FILE" ]; then
            if [ -f "$dir/goal.md" ]; then
                GOAL_FILE="$dir/goal.md"
            fi
        fi
    done
fi

# Find the blueprint file
BLUEPRINT_FILE=""
if [ -n "$FEATURE_NUMBER" ]; then
    for f in blueprints/${FEATURE_NUMBER}-*/blueprint.md; do
        if [ -f "$f" ]; then
            BLUEPRINT_FILE="$f"
            break
        fi
    done
else
    # Fallback: find the latest related blueprint
    for dir in blueprints/*/; do
        if [[ "$dir" == *"$FEATURE_NAME"* ]] || [ -z "$BLUEPRINT_FILE" ]; then
            if [ -f "$dir/blueprint.md" ]; then
                BLUEPRINT_FILE="$dir/blueprint.md"
            fi
        fi
    done
fi

# Find the spec file
SPEC_FILE=""
if [ -n "$FEATURE_NUMBER" ]; then
    for f in specs/${FEATURE_NUMBER}-*/spec.md; do
        if [ -f "$f" ]; then
            SPEC_FILE="$f"
            break
        fi
    done
else
    # Fallback: find the latest related spec
    for dir in specs/*/; do
        if [[ "$dir" == *"$FEATURE_NAME"* ]] || [ -z "$SPEC_FILE" ]; then
            if [ -f "$dir/spec.md" ]; then
                SPEC_FILE="$dir/spec.md"
            fi
        fi
    done
fi

# Output the context for each methodology

echo ""
echo "# GOAL CONTEXT"
echo "=============="
if [ -f "$GOAL_FILE" ]; then
    echo "Goal file: $GOAL_FILE"
    cat "$GOAL_FILE"
else
    echo "No goal file found for this feature"
fi

echo ""
echo "# BLUEPRINT CONTEXT" 
echo "==================="
if [ -f "$BLUEPRINT_FILE" ]; then
    echo "Blueprint file: $BLUEPRINT_FILE"
    cat "$BLUEPRINT_FILE"
else
    echo "No blueprint file found for this feature"
fi

echo ""
echo "# SPEC CONTEXT"
echo "=============="
if [ -f "$SPEC_FILE" ]; then
    echo "Spec file: $SPEC_FILE"
    cat "$SPEC_FILE"
else
    echo "No spec file found for this feature"
fi

echo ""
echo "# END FULL KIT CONTEXT"
echo "======================"
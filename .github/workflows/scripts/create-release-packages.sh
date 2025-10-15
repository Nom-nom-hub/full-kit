#!/bin/bash

set -e

VERSION="$1"
OUTPUT_DIR="$2"

if [ -z "$VERSION" ] || [ -z "$OUTPUT_DIR" ]; then
    echo "Usage: $0 <version> <output_dir>"
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Define supported agents and script types
ALL_AGENTS=(copilot claude gemini cursor-agent qwen opencode codex windsurf kilocode auggie codebuddy roo q)
SCRIPT_TYPES=(sh ps)

# Create a temporary directory for building
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

# Set up the base template structure
TEMPLATE_BASE="$TEMP_DIR/full-kit-template"
mkdir -p "$TEMPLATE_BASE/.fullkit/scripts" "$TEMPLATE_BASE/.fullkit/templates"
mkdir -p "$TEMPLATE_BASE/memory" "$TEMPLATE_BASE/goals" "$TEMPLATE_BASE/blueprints" "$TEMPLATE_BASE/specs"

# Copy templates from the current repo
cp -r templates/* "$TEMPLATE_BASE/.fullkit/templates/" 2>/dev/null || echo "No templates found in templates/"
cp -r scripts/* "$TEMPLATE_BASE/.fullkit/scripts/" 2>/dev/null || echo "No scripts found in scripts/"

# Create basic memory/constitution.md
cat > "$TEMPLATE_BASE/memory/constitution.md" << EOF
# Project Constitution

## Goal-Driven Development Principles

### Article I: Outcome Focus
Every feature must be tied to a measurable business outcome or user benefit. No feature shall be implemented without a clear connection to business value.

### Article II: Goal Hierarchy
Goals are organized in a hierarchy from high-level strategic objectives to specific, achievable targets.

### Article III: Success Metrics
All goals must define clear, quantifiable success metrics before implementation begins.

## Blueprint-Driven Development Principles

### Article IV: Architectural Integrity
Every system component must align with the overarching architectural blueprint. No component shall be implemented without blueprint compliance.

### Article V: Design Patterns
Pre-approved architectural patterns must be used consistently across the system to ensure maintainability.

### Article VI: System Boundaries
Clear boundaries must be established between system components, with explicit interfaces and contracts.

## Spec-Driven Development Principles

### Article VII: Specification Completeness
Every implementation must be based on a complete, validated specification. No code shall be written without a corresponding specification.

### Article VIII: Implementation Fidelity
Implementations must strictly adhere to the specifications without deviation from the documented requirements.

### Article IX: Test-First Implementation
All implementations must be accompanied by comprehensive test scenarios defined in the specification phase.
EOF

# Function to generate commands for each agent
generate_commands() {
    local agent="$1"
    local ext="$2"
    local arg_placeholder="$3"
    local output_dir="$4"
    local script_type="$5"
    
    mkdir -p "$output_dir"
    
    # Define all Full Kit commands
    commands=("constitution" "goal" "blueprint" "specify" "plan" "tasks" "implement" "clarify" "analyze" "checklist")
    
    for cmd in "${commands[@]}"; do
        if [ "$ext" = ".toml" ]; then
            # TOML format for Gemini, Qwen
            cat > "$output_dir/$cmd$ext" << EOF_TOML
description = "Full Kit $cmd command for $agent"

prompt = \"\"\"
Full Kit $cmd command implementation for $agent.

Script to execute: {\$script_type}
Arguments: $arg_placeholder
\"\"\"
EOF_TOML
        else
            # Markdown format for most other agents
            cat > "$output_dir/$cmd$ext" << EOF_MD
---
description: "Full Kit $cmd command for $agent"
---

Full Kit $cmd command implementation for $agent.

**Script to execute:** {SCRIPT} \$ARGUMENTS

EOF_MD
        fi
    done
}

# Create template packages for each agent and script type
for agent in "${ALL_AGENTS[@]}"; do
    for script_type in "${SCRIPT_TYPES[@]}"; do
        echo "Creating template for $agent with $script_type scripts..."
        
        # Create agent-specific directory structure
        case $agent in
            copilot)
                AGENT_DIR="$TEMPLATE_BASE/.github"
                mkdir -p "$AGENT_DIR/prompts"
                generate_commands "$agent" ".md" "{{args}}" "$AGENT_DIR/prompts" "$script_type"
                ;;
            claude)
                AGENT_DIR="$TEMPLATE_BASE/.claude"
                mkdir -p "$AGENT_DIR/commands"
                generate_commands "$agent" ".md" "\$ARGUMENTS" "$AGENT_DIR/commands" "$script_type"
                ;;
            gemini)
                AGENT_DIR="$TEMPLATE_BASE/.gemini"
                mkdir -p "$AGENT_DIR/commands"
                generate_commands "$agent" ".toml" "{{args}}" "$AGENT_DIR/commands" "$script_type"
                ;;
            cursor-agent)
                AGENT_DIR="$TEMPLATE_BASE/.cursor"
                mkdir -p "$AGENT_DIR/commands"
                generate_commands "$agent" ".md" "\$ARGUMENTS" "$AGENT_DIR/commands" "$script_type"
                ;;
            qwen)
                AGENT_DIR="$TEMPLATE_BASE/.qwen"
                mkdir -p "$AGENT_DIR/commands"
                generate_commands "$agent" ".toml" "{{args}}" "$AGENT_DIR/commands" "$script_type"
                ;;
            opencode)
                AGENT_DIR="$TEMPLATE_BASE/.opencode"
                mkdir -p "$AGENT_DIR/command"
                generate_commands "$agent" ".md" "\$ARGUMENTS" "$AGENT_DIR/command" "$script_type"
                ;;
            codex)
                AGENT_DIR="$TEMPLATE_BASE/.codex"
                mkdir -p "$AGENT_DIR/commands"
                generate_commands "$agent" ".md" "\$ARGUMENTS" "$AGENT_DIR/commands" "$script_type"
                ;;
            windsurf)
                AGENT_DIR="$TEMPLATE_BASE/.windsurf"
                mkdir -p "$AGENT_DIR/workflows"
                generate_commands "$agent" ".md" "\$ARGUMENTS" "$AGENT_DIR/workflows" "$script_type"
                ;;
            kilocode)
                AGENT_DIR="$TEMPLATE_BASE/.kilocode"
                mkdir -p "$AGENT_DIR/rules"
                generate_commands "$agent" ".md" "\$ARGUMENTS" "$AGENT_DIR/rules" "$script_type"
                ;;
            auggie)
                AGENT_DIR="$TEMPLATE_BASE/.augment"
                mkdir -p "$AGENT_DIR/rules"
                generate_commands "$agent" ".md" "\$ARGUMENTS" "$AGENT_DIR/rules" "$script_type"
                ;;
            codebuddy)
                AGENT_DIR="$TEMPLATE_BASE/.codebuddy"
                mkdir -p "$AGENT_DIR/commands"
                generate_commands "$agent" ".md" "\$ARGUMENTS" "$AGENT_DIR/commands" "$script_type"
                ;;
            roo)
                AGENT_DIR="$TEMPLATE_BASE/.roo"
                mkdir -p "$AGENT_DIR/rules"
                generate_commands "$agent" ".md" "\$ARGUMENTS" "$AGENT_DIR/rules" "$script_type"
                ;;
            q)
                AGENT_DIR="$TEMPLATE_BASE/.amazonq"
                mkdir -p "$AGENT_DIR/prompts"
                generate_commands "$agent" ".md" "\$ARGUMENTS" "$AGENT_DIR/prompts" "$script_type"
                ;;
            *)
                # Default case for other agents
                AGENT_DIR="$TEMPLATE_BASE/.$agent"
                mkdir -p "$AGENT_DIR/commands"
                generate_commands "$agent" ".md" "\$ARGUMENTS" "$AGENT_DIR/commands" "$script_type"
                ;;
        esac
        
        # Create the zip file for this agent and script type
        PACKAGE_NAME="full-kit-template-$agent-$script_type-v$VERSION.zip"
        (cd "$TEMP_DIR" && zip -r "$OUTPUT_DIR/$PACKAGE_NAME" full-kit-template)
        
        echo "Created $PACKAGE_NAME"
        
        # Clean up agent directory for next iteration
        rm -rf "$TEMPLATE_BASE/.github" "$TEMPLATE_BASE/.claude" "$TEMPLATE_BASE/.gemini" "$TEMPLATE_BASE/.cursor" "$TEMPLATE_BASE/.qwen" "$TEMPLATE_BASE/.opencode" "$TEMPLATE_BASE/.codex" "$TEMPLATE_BASE/.windsurf" "$TEMPLATE_BASE/.kilocode" "$TEMPLATE_BASE/.augment" "$TEMPLATE_BASE/.codebuddy" "$TEMPLATE_BASE/.roo" "$TEMPLATE_BASE/.amazonq" "$TEMPLATE_BASE/."*
    done
done

echo "All release packages created in $OUTPUT_DIR"
#!/bin/bash

# Common functions for Full Kit scripts

# Function to get the next feature number
get_next_feature_number() {
    local features_dir=$1
    local next_num
    
    if [ -d "$features_dir" ]; then
        # Find the highest numbered feature and increment
        next_num=$(ls "$features_dir" | grep -E '^[0-9]{3}-' | sed 's/^[0-9]*-//g' | sort -n | tail -1 | cut -d'-' -f1)
        if [ -z "$next_num" ]; then
            next_num=0
        fi
        next_num=$((next_num + 1))
    else
        next_num=1
    fi
    
    printf "%03d" $next_num
}

# Function to convert description to feature name
description_to_feature_name() {
    local desc="$1"
    local feature_name
    
    # Convert to lowercase, replace spaces with hyphens, remove special characters
    feature_name=$(echo "$desc" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
    echo "$feature_name"
}

# Function to create a new feature directory
create_feature_dir() {
    local base_dir=$1
    local feature_desc=$2
    local feature_num
    local feature_name
    local feature_path
    
    feature_num=$(get_next_feature_number "$base_dir")
    feature_name=$(description_to_feature_name "$feature_desc")
    feature_path="$base_dir/${feature_num}-${feature_name}"
    
    mkdir -p "$feature_path"
    echo "$feature_path"
}

# Function to validate constitution exists
validate_constitution() {
    if [ ! -f "./memory/constitution.md" ]; then
        echo "Error: Project constitution not found. Run /fullkit.constitution first."
        exit 1
    fi
}

# Function to check if git branch exists and create if needed
ensure_git_branch() {
    local branch_name=$1
    local exists
    
    exists=$(git branch --list "$branch_name" | wc -l)
    if [ "$exists" -eq 0 ]; then
        git checkout -b "$branch_name"
    else
        git checkout "$branch_name"
    fi
}
#!/bin/bash
# Copyright (c) [https://github.com/github/spec-kit]
# Modified by Trentin Barnard, 2025
# MIT License

# Load Constitution Sections
# Automatically loads all constitution files from .specify/memory/constitution/ or .specify/templates/constitution/

set -euo pipefail

TEMPLATE_DIR=".specify/templates/constitution"
MEMORY_DIR=".specify/memory"

# Determine which constitution directory to use (memory first, then templates)
if [[ -d "$MEMORY_DIR/constitution" ]] && [[ -n $(ls -A "$MEMORY_DIR/constitution"/*.md 2>/dev/null) ]]; then
    CONSTITUTION_DIR="$MEMORY_DIR/constitution"
    LOCATION="memory (project-specific)"
else
    CONSTITUTION_DIR="$TEMPLATE_DIR"
    LOCATION="templates (default)"
fi

# Function to load a markdown section
load_section() {
  local section="$1"
  local filename="$2"
  
  if [[ -f "$filename" ]]; then
    echo ""
    echo "<!-- Constitution Section: $section -->"
    echo ""
    cat "$filename"
    echo ""
    echo "---"
    echo ""
  else
    echo "⚠️  Warning: Missing section '$section' (expected at $filename)" >&2
  fi
}

# Discover all constitution markdown files
declare -a SECTIONS=()
declare -a FILENAMES=()
if [[ -d "$CONSTITUTION_DIR" ]]; then
  while IFS= read -r file; do
    section=$(basename "$file" .md)
    # Skip template suffix if present
    section="${section%-template}"
    SECTIONS+=("$section")
    FILENAMES+=("$file")
  done < <(find "$CONSTITUTION_DIR" -maxdepth 1 -name "*.md" -type f | sort)
fi

# Print header
echo "# Constitutional Standards"
echo ""
echo "**Loading Mode**: Auto-discovery"
echo "**Location**: ${LOCATION}"
echo "**Sections Found**: ${#SECTIONS[@]}"
echo ""
echo "---"
echo ""

# Load each discovered section
for i in "${!SECTIONS[@]}"; do
  load_section "${SECTIONS[$i]}" "${FILENAMES[$i]}"
done

# Always load branching from git-workflow.yaml with YAML code fencing
if [[ -f "$MEMORY_DIR/git-workflow.yaml" ]]; then
  echo ""
  echo "<!-- Constitution Section: branching -->"
  echo ""
  echo '```yaml'
  cat "$MEMORY_DIR/git-workflow.yaml"
  echo '```'
  echo ""
  echo "---"
  echo ""
else
  echo "⚠️  Warning: Missing git-workflow.yaml (expected at $MEMORY_DIR/git-workflow.yaml)" >&2
fi

# Print footer with metadata
echo ""
echo "<!-- End of Constitution Loading -->"
echo "<!-- Loaded ${#SECTIONS[@]} constitution sections + branching (git-workflow.yaml) -->"

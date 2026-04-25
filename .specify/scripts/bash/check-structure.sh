#!/bin/bash
# Copyright (c) [https://github.com/github/spec-kit]
# Modified by Trentin Barnard, 2025
# MIT License

set -euo pipefail

ROOT_DIR=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
PASS=true

required_paths=(
  ".specify/templates/constitution"
  ".specify/templates/spec-template.md"
  ".specify/templates/plan-template.md"
  ".specify/templates/tasks-template.md"
  ".specify/templates/commands/sdd-specify.md"
  ".specify/templates/commands/sdd-plan.md"
  ".specify/templates/commands/sdd-tasks.md"
  "prompts/sdd-specify.md"
  "prompts/sdd-plan.md"
  "prompts/sdd-tasks.md"
)

echo "[spec:check] Validating required structure..."
for p in "${required_paths[@]}"; do
  if [[ ! -e "$ROOT_DIR/$p" ]]; then
    echo "[MISSING] $p" >&2
    PASS=false
  else
    echo "[OK] $p"
  fi
done

if [[ "$PASS" = true ]]; then
  echo "[spec:check] SUCCESS"
  exit 0
else
  echo "[spec:check] FAIL" >&2
  exit 1
fi

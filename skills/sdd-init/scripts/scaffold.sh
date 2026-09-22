#!/usr/bin/env bash
# =============================================================================
# sdd-scaffold-plugin — scaffold.sh
# Creates the .agents/ SDD scaffold in a target project directory.
#
# Usage:
#   ./scaffold.sh --project-name "my-project" --stack "python/fastapi" [OPTIONS]
#
# Options:
#   --project-name   NAME    (required) Project name used in templates
#   --stack          STACK   (required) Primary technology stack (metadata only)
#   --specs-dir      DIR     (optional) Directory for spec files. Default: specs
#   --governance     MODE    (optional) personal | team. Default: personal
#   --target-dir     DIR     (optional) Target project root. Default: current dir
# =============================================================================

set -euo pipefail

# --- Defaults ---
PROJECT_NAME=""
STACK=""
SPECS_DIR="specs"
GOVERNANCE="personal"
TARGET_DIR="$(pwd)"
PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TEMPLATES_DIR="${PLUGIN_DIR}/skills/sdd-init/resources/templates"
DATE=$(date +%Y-%m-%d)

# --- Argument Parsing ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-name) PROJECT_NAME="$2"; shift 2 ;;
    --stack)        STACK="$2"; shift 2 ;;
    --specs-dir)    SPECS_DIR="$2"; shift 2 ;;
    --governance)   GOVERNANCE="$2"; shift 2 ;;
    --target-dir)   TARGET_DIR="$2"; shift 2 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

# --- Validation ---
if [[ -z "$PROJECT_NAME" || -z "$STACK" ]]; then
  echo "Error: --project-name and --stack are required."
  echo "Usage: $0 --project-name \"my-project\" --stack \"python/fastapi\""
  exit 1
fi

# --- Helper: substitute placeholders in a template file ---
render_template() {
  local template="$1"
  local output="$2"
  sed \
    -e "s/{{PROJECT_NAME}}/${PROJECT_NAME}/g" \
    -e "s/{{STACK}}/${STACK}/g" \
    -e "s/{{DATE}}/${DATE}/g" \
    -e "s/{{SPECS_DIR}}/${SPECS_DIR}/g" \
    -e "s/{{GOVERNANCE_MODE}}/${GOVERNANCE}/g" \
    "$template" > "$output"
}

# --- Create directories ---
AGENTS_DIR="${TARGET_DIR}/.agents"
SPECS_PATH="${TARGET_DIR}/${SPECS_DIR}"

mkdir -p "${AGENTS_DIR}"
mkdir -p "${SPECS_PATH}"

echo "  [+] Created .agents/"
echo "  [+] Created ${SPECS_DIR}/"

# --- Render templates ---
if [[ ! -f "${AGENTS_DIR}/AGENTS.md" ]]; then
  render_template "${TEMPLATES_DIR}/AGENTS.md.tmpl" "${AGENTS_DIR}/AGENTS.md"
  echo "  [+] Created .agents/AGENTS.md"
else
  echo "  [~] Skipped .agents/AGENTS.md (already exists)"
fi

if [[ ! -f "${AGENTS_DIR}/plugins.json" ]]; then
  render_template "${TEMPLATES_DIR}/plugins.json.tmpl" "${AGENTS_DIR}/plugins.json"
  echo "  [+] Created .agents/plugins.json"
else
  echo "  [~] Skipped .agents/plugins.json (already exists)"
fi

# --- Create specs placeholder ---
if [[ ! -f "${SPECS_PATH}/.gitkeep" ]]; then
  touch "${SPECS_PATH}/.gitkeep"
  echo "  [+] Created ${SPECS_DIR}/.gitkeep"
fi

echo ""
echo "✅ SDD scaffold created for '${PROJECT_NAME}' (${STACK})"
echo ""
echo "Next step: activate the 'spec-architect' skill to write your first spec."


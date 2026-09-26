#!/bin/sh
# validate-v3.sh — sdd-scaffold-plugin v3 Acceptance Validation Suite
# Run from the plugin root directory.

PASS=0
FAIL=0
ROOT="$(pwd)"

check() {
  LABEL="$1"
  CONDITION="$2"
  if eval "$CONDITION"; then
    echo "  ✅ PASS: $LABEL"
    PASS=$((PASS + 1))
  else
    echo "  ❌ FAIL: $LABEL"
    FAIL=$((FAIL + 1))
  fi
}

echo ""
echo "========================================"
echo " SDD Scaffold Plugin v3 — Validation"
echo "========================================"
echo ""

# --- [1] YAML Frontmatter: All new SKILL.md files ---
echo "[1] YAML Frontmatter Checks"
for skill in sdd-spec-validate sdd-spec-status sdd-skill-create sdd-rule-create sdd-agent-create sdd-hook-create sdd-mcp-create; do
  FILE="$ROOT/skills/$skill/SKILL.md"
  check "skills/$skill/SKILL.md — exists" "[ -f \"$FILE\" ]"
  check "skills/$skill/SKILL.md — has 'name:' frontmatter" "grep -q '^name:' \"$FILE\""
  check "skills/$skill/SKILL.md — has 'description:' frontmatter" "grep -q '^description:' \"$FILE\""
done

# --- [2] SKILL.md line count < 500 ---
echo ""
echo "[2] SKILL.md Line Count Checks (< 500 lines each)"
for skill in sdd-init sdd-spec-create sdd-spec-archive sdd-spec-validate sdd-spec-status sdd-skill-create sdd-rule-create sdd-agent-create sdd-hook-create sdd-mcp-create; do
  FILE="$ROOT/skills/$skill/SKILL.md"
  if [ -f "$FILE" ]; then
    LINES=$(wc -l < "$FILE")
    check "skills/$skill/SKILL.md — $LINES lines (< 500)" "[ $LINES -lt 500 ]"
  fi
done

# --- [3] AGENTS.md line count <= 55 ---
echo ""
echo "[3] AGENTS.md Line Count Check (<= 55 lines)"
AGENTS_FILE="$ROOT/rules/AGENTS.md"
AGENTS_LINES=$(wc -l < "$AGENTS_FILE")
check "rules/AGENTS.md — $AGENTS_LINES lines (<= 55)" "[ $AGENTS_LINES -le 55 ]"

# --- [4] Subagent files exist and have correct frontmatter ---
echo ""
echo "[4] Subagent Configuration Checks"
for agent in sdd-code-explorer sdd-spec-auditor; do
  FILE="$ROOT/agents/$agent.md"
  check "agents/$agent.md — exists" "[ -f \"$FILE\" ]"
  check "agents/$agent.md — subagent: true" "grep -q 'subagent: true' \"$FILE\""
  check "agents/$agent.md — mainAgent: false" "grep -q 'mainAgent: false' \"$FILE\""
  check "agents/$agent.md — model: flash" "grep -q 'model: flash' \"$FILE\""
  check "agents/$agent.md — commandExecutionPolicy: sandbox" "grep -q 'commandExecutionPolicy: sandbox' \"$FILE\""
done

# --- [5] JSON validity ---
echo ""
echo "[5] JSON Validity Checks"
if command -v python3 >/dev/null 2>&1; then
  for jsonfile in plugin.json hooks.json; do
    check "$jsonfile — valid JSON" "python3 -c \"import json,sys; json.load(open('$ROOT/$jsonfile'))\" 2>/dev/null"
  done
else
  echo "  ⚠️  SKIP: python3 not found. JSON validity not checked."
fi

# --- [6] Hard Stop rules present in AGENTS.md ---
echo ""
echo "[6] Hard Stop Rule Content Checks"
check "AGENTS.md — Hard Stop write_to_file prohibition" "grep -q 'write_to_file' \"$ROOT/rules/AGENTS.md\""
check "AGENTS.md — Mandatory sdd-code-explorer delegation" "grep -q 'sdd-code-explorer' \"$ROOT/rules/AGENTS.md\""
check "AGENTS.md — DO NOT scan codebase" "grep -q 'context bloat' \"$ROOT/rules/AGENTS.md\""

# --- [7] Proposal template security sections ---
echo ""
echo "[7] Proposal Template Security & Testing Section Checks"
PROPOSAL_TEMPLATE="$ROOT/skills/sdd-spec-create/resources/proposal-template.md"
check "proposal-template.md — Defensive Security section" "grep -q 'Defensive Security' \"$PROPOSAL_TEMPLATE\""
check "proposal-template.md — Testing Strategy section" "grep -q 'Testing Strategy' \"$PROPOSAL_TEMPLATE\""
check "proposal-template.md — Happy Path Tests" "grep -q 'Happy Path' \"$PROPOSAL_TEMPLATE\""
check "proposal-template.md — Edge Case Tests" "grep -q 'Edge Case' \"$PROPOSAL_TEMPLATE\""

# --- [8] Legacy sdd-skill-creator removed ---
echo ""
echo "[8] Legacy Cleanup Checks"
check "skills/sdd-skill-creator/ — deleted" "[ ! -d \"$ROOT/skills/sdd-skill-creator\" ]"
check "No remaining references to sdd-skill-creator" "! grep -r 'sdd-skill-creator' \"$ROOT\" --include='*.md' --include='*.json' --exclude='prompt.md' --exclude='*implementation_plan*.md' -q 2>/dev/null"

# --- [9] Resource files exist ---
echo ""
echo "[9] Resource File Existence Checks"
check "sdd-skill-create/resources/skill-template.md" "[ -f \"$ROOT/skills/sdd-skill-create/resources/skill-template.md\" ]"
check "sdd-rule-create/resources/rule-template.md" "[ -f \"$ROOT/skills/sdd-rule-create/resources/rule-template.md\" ]"
check "sdd-agent-create/resources/agent-template.md" "[ -f \"$ROOT/skills/sdd-agent-create/resources/agent-template.md\" ]"
check "sdd-hook-create/resources/hook-recipe-template.json" "[ -f \"$ROOT/skills/sdd-hook-create/resources/hook-recipe-template.json\" ]"
check "sdd-mcp-create/resources/mcp-server-template.json" "[ -f \"$ROOT/skills/sdd-mcp-create/resources/mcp-server-template.json\" ]"

# --- Summary ---
echo ""
echo "========================================"
TOTAL=$((PASS + FAIL))
echo " Results: $PASS/$TOTAL checks passed"
if [ $FAIL -eq 0 ]; then
  echo " 🎉 ALL CHECKS PASSED — v3 is valid."
else
  echo " ❌ $FAIL CHECKS FAILED — resolve failures before committing."
fi
echo "========================================"
echo ""

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
for skill in sdd-spec-validate sdd-spec-status sdd-skill-create sdd-rule-create sdd-agent-create sdd-hook-create sdd-mcp-create sdd-prompt-craft; do
  FILE="$ROOT/skills/$skill/SKILL.md"
  check "skills/$skill/SKILL.md — exists" "[ -f \"$FILE\" ]"
  check "skills/$skill/SKILL.md — has 'name:' frontmatter" "grep -q '^name:' \"$FILE\""
  check "skills/$skill/SKILL.md — has 'description:' frontmatter" "grep -q '^description:' \"$FILE\""
done

# --- [2] SKILL.md line count < 500 ---
echo ""
echo "[2] SKILL.md Line Count Checks (< 500 lines each)"
for skill in sdd-init sdd-spec-create sdd-spec-archive sdd-spec-validate sdd-spec-status sdd-skill-create sdd-rule-create sdd-agent-create sdd-hook-create sdd-mcp-create sdd-prompt-craft; do
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

# --- [4] Subagent files exist and have correct frontmatter & tools ---
echo ""
echo "[4] Subagent Configuration Checks"
for agent in sdd-code-explorer sdd-spec-auditor sdd-prompt-architect; do
  FILE="$ROOT/agents/$agent.md"
  check "agents/$agent.md — exists" "[ -f \"$FILE\" ]"
  check "agents/$agent.md — subagent: true" "grep -q 'subagent: true' \"$FILE\""
  check "agents/$agent.md — mainAgent: false" "grep -q 'mainAgent: false' \"$FILE\""
  check "agents/$agent.md — model: flash" "grep -q 'model: flash' \"$FILE\""
  check "agents/$agent.md — commandExecutionPolicy: sandbox" "grep -q 'commandExecutionPolicy: sandbox' \"$FILE\""
  check "agents/$agent.md — has read_file tool" "grep -q 'read_file' \"$FILE\""
  check "agents/$agent.md — has list_dir tool" "grep -q 'list_dir' \"$FILE\""
  check "agents/$agent.md — has send_message tool" "grep -q 'send_message' \"$FILE\""
done

# --- [5] JSON validity & Hook Schema / Guard Functional Checks ---
echo ""
echo "[5] JSON Validity & Hook Guard Checks"
for jsonfile in plugin.json hooks.json skills/sdd-hook-create/resources/hook-recipe-template.json; do
  check "$jsonfile — valid JSON" "node -e \"JSON.parse(require('fs').readFileSync('$jsonfile', 'utf8'))\" 2>/dev/null"
done

check "hooks.json — conforms to map[string]JSONHookSpec (no top-level string keys)" \
  "node -e \"const h = JSON.parse(require('fs').readFileSync('hooks.json', 'utf8')); if (Object.values(h).some(v => typeof v !== 'object' || v === null || Array.isArray(v))) process.exit(1);\""

for script in sdd-readonly-guard.mjs check-approved-proposal.mjs scope-prompt-writes.mjs run-linter.mjs; do
  check "scripts/$script — exists" "[ -f \"$ROOT/scripts/$script\" ]"
done

check "sdd-readonly-guard.mjs — auto-allows view_file on workspace file" \
  "echo '{\"toolCall\":{\"name\":\"view_file\",\"args\":{\"Path\":\"README.md\"}}}' | node scripts/sdd-readonly-guard.mjs | grep -q '\"decision\":\"allow\"'"

check "sdd-readonly-guard.mjs — blocks auto-allow on .env sensitive file" \
  "! (echo '{\"toolCall\":{\"name\":\"read_file\",\"args\":{\"Path\":\"/app/.env\"}}}' | node scripts/sdd-readonly-guard.mjs | grep -q '\"decision\":\"allow\"')"

check "sdd-readonly-guard.mjs — auto-allows safe git status run_command" \
  "echo '{\"toolCall\":{\"name\":\"run_command\",\"args\":{\"CommandLine\":\"git status\"}}}' | node scripts/sdd-readonly-guard.mjs | grep -q '\"decision\":\"allow\"'"

check "sdd-readonly-guard.mjs — rejects chained mutating run_command" \
  "! (echo '{\"toolCall\":{\"name\":\"run_command\",\"args\":{\"CommandLine\":\"git status && rm -rf build\"}}}' | node scripts/sdd-readonly-guard.mjs | grep -q '\"decision\":\"allow\"')"

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
check "sdd-prompt-craft/resources/prompt-guide.md" "[ -f \"$ROOT/skills/sdd-prompt-craft/resources/prompt-guide.md\" ]"

# --- [10] Canonical Living Specs Invariants ---
echo ""
echo "[10] Canonical Living Specs Invariants"
check "openspec/specs/ — no *-delta.md files exist" "[ -d \"$ROOT/openspec/specs\" ] && [ \$(find \"$ROOT/openspec/specs\" -maxdepth 1 -name '*-delta.md' | wc -l) -eq 0 ]"
check "openspec/specs/ — files do not contain '# Delta Spec:' header" "! grep -r '^# Delta Spec:' \"$ROOT/openspec/specs\" -q 2>/dev/null"

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

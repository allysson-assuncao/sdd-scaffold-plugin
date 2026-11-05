#!/usr/bin/env node
// sdd-readonly-guard.mjs
// PreToolUse hook for sdd-scaffold-plugin.
// Automatically approves ("decision": "allow") non-destructive read/search tools
// (view_file, read_file, grep_search, find_by_name, list_dir) and strictly
// read-only diagnostic commands (run_command), while returning {"decision": "ask"}
// on sensitive credential paths or mutating commands so Antigravity's standard
// permission prompt handles them.

import fs from "node:fs";

const READONLY_TOOLS = new Set([
  "view_file",
  "read_file",
  "grep_search",
  "find_by_name",
  "list_dir",
]);

const SENSITIVE_PATH_PATTERN =
  /(?:^|[\\/])(?:\.env(?:\.[^\\/]*)?|\.ssh|\.aws|\.npmrc|\.pypirc|id_rsa|id_ed25519|credentials\.json|secrets\.json)(?:$|[\\/])/i;

const DANGEROUS_SHELL_CHARS = /[;&|><`$]|\r|\n/;

const SAFE_COMMAND_PATTERNS = [
  /^git\s+(?:status|log|diff|show|branch|rev-parse)(?:\s+[-a-zA-Z0-9_./:~^=@]+)*$/,
  /^agy\s+plugin\s+(?:validate|list)(?:\s+[-a-zA-Z0-9_./\\]+)*$/,
  /^(?:Get-ChildItem|Get-Content|Select-String|Test-Path|Get-Location)(?:\s+[-a-zA-Z0-9_./\\:*]+)*$/i,
  /^(?:ls|pwd|wc|head|tail|find|grep|rg)(?:\s+[-a-zA-Z0-9_./\\:*]+)*$/,
];

function containsSensitivePath(value) {
  if (typeof value !== "string") return false;
  return SENSITIVE_PATH_PATTERN.test(value.trim());
}

function hasSensitiveArgs(args) {
  if (!args || typeof args !== "object") return false;
  for (const val of Object.values(args)) {
    if (typeof val === "string" && containsSensitivePath(val)) {
      return true;
    }
    if (Array.isArray(val) && val.some((item) => containsSensitivePath(item))) {
      return true;
    }
  }
  return false;
}

function isSafeReadOnlyCommand(cmd) {
  if (typeof cmd !== "string") return false;
  const trimmed = cmd.trim();
  if (!trimmed || DANGEROUS_SHELL_CHARS.test(trimmed)) {
    return false;
  }
  if (containsSensitivePath(trimmed)) {
    return false;
  }
  return SAFE_COMMAND_PATTERNS.some((pattern) => pattern.test(trimmed));
}

function main() {
  try {
    const rawInput = fs.readFileSync(0, "utf8");
    if (!rawInput || !rawInput.trim()) {
      process.stdout.write(JSON.stringify({ decision: "ask" }) + "\n");
      return;
    }

    const payload = JSON.parse(rawInput);
    const toolName = payload?.toolCall?.name;
    const toolArgs = payload?.toolCall?.args ?? {};

    if (typeof toolName !== "string") {
      process.stdout.write(JSON.stringify({ decision: "ask" }) + "\n");
      return;
    }

    if (READONLY_TOOLS.has(toolName)) {
      if (hasSensitiveArgs(toolArgs)) {
        process.stdout.write(
          JSON.stringify({
            decision: "ask",
            reason: "SDD Security Guard: Sensitive path requires explicit user confirmation",
          }) + "\n"
        );
        return;
      }
      process.stdout.write(
        JSON.stringify({
          decision: "allow",
          reason: `SDD Auto-Allow: Safe read-only tool (${toolName})`,
        }) + "\n"
      );
      return;
    }

    if (toolName === "run_command") {
      const cmdLine = toolArgs.CommandLine ?? toolArgs.command ?? "";
      if (isSafeReadOnlyCommand(cmdLine)) {
        process.stdout.write(
          JSON.stringify({
            decision: "allow",
            reason: "SDD Auto-Allow: Verified read-only inspection command",
          }) + "\n"
        );
        return;
      }
    }

    process.stdout.write(JSON.stringify({ decision: "ask" }) + "\n");
  } catch {
    process.stdout.write(JSON.stringify({ decision: "ask" }) + "\n");
  }
}

main();

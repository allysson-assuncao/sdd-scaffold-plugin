#!/usr/bin/env node
// scope-prompt-writes.mjs
// Opt-in PreToolUse recipe hook for agentic-dev-workflow ("sdd-scope-prompt-writes").
// When invoked during a prompt-generation turn, ensures write_to_file / write_file
// only writes to prompt.md or prompt-*.md in the workspace root.

import fs from "node:fs";
import path from "node:path";

function main() {
  try {
    const rawInput = fs.readFileSync(0, "utf8");
    if (!rawInput || !rawInput.trim()) {
      process.stdout.write(JSON.stringify({ decision: "allow" }) + "\n");
      return;
    }

    const payload = JSON.parse(rawInput);
    const lastUserInput = String(payload?.lastUserInput ?? "");
    const targetPath =
      payload?.toolCall?.args?.Path ??
      payload?.toolCall?.args?.TargetFile ??
      "";

    const isPromptArchitectContext =
      /prompt-guide\.md|sdd-prompt-architect/i.test(lastUserInput);

    if (!isPromptArchitectContext || typeof targetPath !== "string" || !targetPath) {
      process.stdout.write(JSON.stringify({ decision: "allow" }) + "\n");
      return;
    }

    const baseName = path.basename(targetPath);
    if (/^prompt(?:-[a-zA-Z0-9_-]+)?\.md$/.test(baseName)) {
      process.stdout.write(
        JSON.stringify({
          decision: "allow",
          reason: "SDD Prompt Scope: Valid root prompt file target",
        }) + "\n"
      );
      return;
    }

    process.stdout.write(
      JSON.stringify({
        decision: "deny",
        reason:
          "SDD Prompt Architect Hard Limit: Writes are restricted exclusively to prompt.md or prompt-*.md in the project root.",
      }) + "\n"
    );
  } catch {
    process.stdout.write(JSON.stringify({ decision: "allow" }) + "\n");
  }
}

main();

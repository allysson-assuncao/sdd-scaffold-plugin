#!/usr/bin/env node
// check-approved-proposal.mjs
// Opt-in PreToolUse recipe hook for sdd-scaffold-plugin ("sdd-enforce-proposal").
// Blocks file-mutation tool calls unless at least one active change in
// <workspace>/openspec/changes/<change-id>/proposal.md has Status: approved,
// or the target file itself is inside openspec/ or .agents/.

import fs from "node:fs";
import path from "node:path";

function hasApprovedProposal(workspaceRoot) {
  const changesDir = path.join(workspaceRoot, "openspec", "changes");
  if (!fs.existsSync(changesDir)) return false;

  const entries = fs.readdirSync(changesDir, { withFileTypes: true });
  for (const entry of entries) {
    if (!entry.isDirectory()) continue;
    const proposalPath = path.join(changesDir, entry.name, "proposal.md");
    if (fs.existsSync(proposalPath)) {
      const content = fs.readFileSync(proposalPath, "utf8");
      if (/\*\*Status:\*\*\s*approved/i.test(content)) {
        return true;
      }
    }
  }
  return false;
}

function main() {
  try {
    const rawInput = fs.readFileSync(0, "utf8");
    if (!rawInput || !rawInput.trim()) {
      process.stdout.write(JSON.stringify({ decision: "allow" }) + "\n");
      return;
    }

    const payload = JSON.parse(rawInput);
    const workspaceRoot = payload?.workspacePaths?.[0];
    const targetPath =
      payload?.toolCall?.args?.Path ??
      payload?.toolCall?.args?.TargetFile ??
      "";

    if (
      typeof targetPath === "string" &&
      /(?:^|[\\/])(?:openspec|\.agents)[\\/]/i.test(targetPath)
    ) {
      process.stdout.write(
        JSON.stringify({
          decision: "allow",
          reason: "SDD Proposal Gate: Spec/config namespace write allowed",
        }) + "\n"
      );
      return;
    }

    if (workspaceRoot && hasApprovedProposal(workspaceRoot)) {
      process.stdout.write(
        JSON.stringify({
          decision: "allow",
          reason: "SDD Proposal Gate: Active approved proposal found",
        }) + "\n"
      );
      return;
    }

    process.stdout.write(
      JSON.stringify({
        decision: "deny",
        reason:
          "SDD Hard Stop: No approved proposal found in openspec/changes/. Create and approve a proposal.md before modifying project code.",
      }) + "\n"
    );
  } catch {
    process.stdout.write(JSON.stringify({ decision: "allow" }) + "\n");
  }
}

main();

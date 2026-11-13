#!/usr/bin/env node
// check-approved-proposal.mjs
// Opt-in PreToolUse recipe hook for agentic-dev-workflow ("sdd-enforce-proposal").
// In SDD workspaces (where <workspace>/openspec/ exists), blocks file-mutation
// tool calls unless at least one active change in openspec/changes/<id>/proposal.md
// has Status: approved, or the target file itself is inside openspec/ or .agents/.
// In non-SDD workspaces (no openspec/ directory), fails open ({}) as a pass-through.

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

function isSafeNamespaceWrite(workspaceRoot, targetPath) {
  if (typeof targetPath !== "string" || !targetPath.trim()) return false;
  if (typeof workspaceRoot === "string" && workspaceRoot.trim()) {
    const resolvedRoot = path.resolve(workspaceRoot);
    const resolvedTarget = path.resolve(resolvedRoot, targetPath);
    const rel = path.relative(resolvedRoot, resolvedTarget);
    if (rel.startsWith("..") || path.isAbsolute(rel)) return false;
    return /^(?:openspec|\.agents)(?:[\\/]|$)/i.test(rel);
  }
  return /(?:^|[\\/])(?:openspec|\.agents)[\\/]/i.test(targetPath);
}

function main() {
  try {
    const rawInput = fs.readFileSync(0, "utf8");
    if (!rawInput || !rawInput.trim()) {
      process.stdout.write("{}\n");
      return;
    }

    const payload = JSON.parse(rawInput);
    const workspaceRoot = payload?.workspacePaths?.[0];
    const targetPath =
      payload?.toolCall?.args?.Path ??
      payload?.toolCall?.args?.TargetFile ??
      "";

    // Pass-through in non-SDD workspaces (where openspec/ does not exist)
    if (
      typeof workspaceRoot !== "string" ||
      !workspaceRoot.trim() ||
      !fs.existsSync(path.join(workspaceRoot, "openspec"))
    ) {
      process.stdout.write("{}\n");
      return;
    }

    if (isSafeNamespaceWrite(workspaceRoot, targetPath)) {
      process.stdout.write(
        JSON.stringify({
          decision: "allow",
          reason: "SDD Proposal Gate: Spec/config namespace write allowed",
        }) + "\n"
      );
      return;
    }

    if (hasApprovedProposal(workspaceRoot)) {
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
    process.stdout.write("{}\n");
  }
}

main();

#!/usr/bin/env node
/**
 * run-linter.mjs
 * Opt-in PostToolUse recipe hook stub for sdd-scaffold-plugin ("sdd-run-linter").
 * PostToolUse hooks must output an empty JSON object {} on stdout.
 */

import fs from "node:fs";

function main() {
  try {
    fs.readFileSync(0, "utf8");
    process.stdout.write("{}\n");
  } catch {
    process.stdout.write("{}\n");
  }
}

main();

---
name: sdd-mcp-create
description: >-
  Use this skill to scaffold a new MCP (Model Context Protocol) server entry in
  the workspace mcp_config.json file. Guides the user through selecting transport
  (stdio or SSE), providing server command or URL, and setting environment variable
  injections. Activate when the user wants to 'add an MCP server', 'configure MCP',
  'add a tool server', or 'scaffold mcp_config.json'.
---

# sdd-mcp-create — Scaffold an MCP Server Configuration

## Purpose
Add a new MCP server entry to `mcp_config.json` (or create the file if absent), following the Antigravity 2.0 MCP configuration schema for stdio and SSE transports.

## Step 1 — Gather MCP Server Configuration

Ask the user (one question at a time if not already provided):

1. **Server name**: A short identifier (kebab-case). Example: `github-tools`, `postgres-mcp`.
2. **Transport type**:
   - `stdio` — The server is launched as a local process (e.g., `npx`, `python`, `node`).
   - `sse` — The server is a remote HTTP endpoint that accepts SSE connections.
3. **If stdio**: What is the launch command? Example: `npx -y @modelcontextprotocol/server-filesystem /path/to/dir`
4. **If SSE**: What is the server URL? Example: `http://localhost:8080/sse`
5. **Environment variables**: Does the server require any env vars (e.g., API keys)? If yes, list the variable names (values will be read from the environment, NOT hardcoded).
6. **Target location**: `workspace` (`mcp_config.json` in workspace root) or `global` (`~/.gemini/config/mcp_config.json`).

## Step 2 — Resolve mcp_config.json Path

- **workspace**: `<workspace-root>/mcp_config.json`
- **global**: `<actual-home-dir>/.gemini/config/mcp_config.json`

Read `mcp_config.json` if it exists to understand the current structure. Warn if a server with the same name already exists.

## Step 3 — Confirm Before Writing

Display:
```
📋 New MCP Server — Execution Plan

Server name:  <name>
Transport:    <stdio | sse>
Command/URL:  <value>
Env vars:     <list or none>
Target:       <full-path to mcp_config.json>

Confirm? (yes / no)
```

Do NOT proceed until the user confirms with "yes".

## Step 4 — Update mcp_config.json

Read `resources/mcp-server-template.json` for the entry format.

Build the new server entry:

**For stdio:**
```json
"<server-name>": {
  "command": "<launch-command>",
  "args": [],
  "env": {
    "<ENV_VAR_NAME>": "$ENV_VAR_NAME"
  }
}
```

**For SSE:**
```json
"<server-name>": {
  "url": "<server-url>",
  "headers": {
    "Authorization": "Bearer $API_TOKEN"
  }
}
```

Merge the new entry into the `mcpServers` object in `mcp_config.json`. Preserve all existing entries.

## Step 5 — Confirm

```
✅ MCP server `<server-name>` added to: <target-path>

Security reminder:
  - NEVER hardcode API keys, tokens, or passwords in mcp_config.json.
  - Always inject secrets via environment variables (e.g., $API_TOKEN).
  - Commit mcp_config.json to version control ONLY if it contains no secrets.
  - Add mcp_config.json to .gitignore if it references secrets inline.

Next step: Restart the Antigravity session to load the new MCP server.
```

## Notes
- The MCP server binary/service must be independently installed and running for SSE transport.
- For stdio transport, the command is launched by Antigravity automatically.

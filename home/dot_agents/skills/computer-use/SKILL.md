---
name: computer-use
description: "Operating rules for Erik's Arch Linux machine: dev servers in Herdr, dotfiles with chezmoi, mcp-ctl recovery, scoped testing, and Chrome DevTools debug launches."
---

# Computer Use & Machine Rules

Operating guidelines for local development, background services, and system resources.

## Dotfiles (`chezmoi`)

The local filesystem is the source of truth.
- Sync modifications with `chezmoi re-add <path>` and new files with `chezmoi add <path>`.
- The dotfiles repository is public. If sensitive or machine-private data appears in a tracked directory, quarantine it immediately in `~/.local/share/chezmoi/.chezmoiignore`. Never sync credentials, tokens, or private keys.

## MCP Servers (`mcp-ctl`)

Manage MCP server health with `mcp-ctl`. When an MCP server disconnects or fails:
- Check health: `mcp-ctl status`
- Cycle servers: `mcp-ctl restart` (or `mcp-ctl up`)
- Inspect errors: `mcp-ctl logs`
Do not spawn ad-hoc background MCP processes manually.

## Dev Servers (`herdr`)

Always run development servers and long-running services inside **`herdr`**.
- Herdr provides the shared workspace for observing and controlling processes.
- Never spawn detached background subshells (`&`, `nohup`) for servers.

## Resource Safety & Freezing Prevention

Prevent system hangs under CPU/RAM pressure:
- **Server concurrency**: Multiple servers may run simultaneously only if they are small or lightweight. Never run multiple heavy, full-stack dev stacks at the same time.
- **Workload separation**: Never run broad test suites or heavy builds while a heavy dev server is active.
- **Targeted process control**: Stop services via `herdr`, `docker compose`, or explicit PID. Never run blanket process killers (`pkill -f node`, `killall`).

## Scoped Testing

Scope test runs to modified code:
- Target only tests directly covering or affected by changes (by file path, filter, or package).
- Avoid repository-wide full test suites unless explicitly requested.

## Browser Testing (`chrome-devtools`)

Test web applications using the `chrome-devtools` skill and MCP tools.
- Remote debugging endpoint runs on port `9222`.
- If the debug browser is not open, launch it with:
  ```bash
  gtk-launch chromium-debug
  ```
  *(Fallback: `chromium --remote-debugging-port=9222 --no-first-run --no-default-browser-check &`)*
- Confirm the endpoint is reachable before issuing DevTools MCP calls.

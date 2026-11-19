---
name: computer-use
description: "Manage dev servers and background commands in Herdr, sync dotfiles with chezmoi, recover MCP servers with mcp-ctl, run scoped tests, and launch Chrome DevTools. Trigger when running local dev servers, starting background services or commands in Herdr, managing dotfiles, diagnosing MCP errors, running tests, or debugging web UIs."
---

# Computer Use & Machine Rules

Operating reference for background services, local development, and system resources on this machine.

## Dev Servers & Background Services (`herdr`)

Run all development servers, background tasks, and long-running processes inside **Herdr** (managed terminal multiplexer talking over Unix domain sockets).

### External Orchestration (t3code, standalone agents, external shells)

When running from an external application like t3code where `HERDR_ENV` is unset or not `1`:
- **Do not stop on unset `HERDR_ENV`**: The `herdr` CLI communicates with the active Herdr daemon via socket (`~/.config/herdr/herdr.sock`) regardless of whether the agent runs inside a Herdr pane.
- **Never use `--current`**: External agents have no calling pane context (`HERDR_PANE_ID` is empty). Always specify an explicit pane ID or create a dedicated workspace.
- **Always pass `--no-focus`**: Prevent stealing focus from the user's active viewport.
- **Standard lifecycle**:
  1. Create a background workspace:
     ```bash
     WS_JSON=$(herdr workspace create --label "<project-name>" --cwd "$PWD" --no-focus)
     PANE_ID=$(echo "$WS_JSON" | jq -r '.result.root_pane.pane_id')
     ```
  2. Launch the service or command in the created pane:
     ```bash
     herdr pane run "$PANE_ID" "<command>"
     ```
  3. Inspect output or logs:
     ```bash
     herdr pane read "$PANE_ID" --source recent-unwrapped --lines 100
     ```
  4. Graceful teardown when done:
     ```bash
     herdr pane close "$PANE_ID"
     ```
- **No detached background processes**: Never spawn unmanaged background processes (`nohup`, `&`) for servers or services.

## Resource Safety & Freezing Prevention

Hardware resources have strict limits:
- **Server Concurrency**: Run at most one full-stack dev stack at a time.
- **Workload Separation**: Never run heavy compilations, test suites, or container builds concurrently with a heavy dev server to avoid swap thrashing.
- **Targeted Process Control**: Stop services via `herdr`, `docker compose`, or exact PID. Never run broad process killers (`pkill -f node`, `killall`).

## Dotfiles (`chezmoi`)

The local filesystem is the source of truth for configuration.
- **Status check**: `chezmoi status`
- **Sync changes**: Run `chezmoi re-add <path>` for modified tracked files, or `chezmoi add <path>` for new files.
- **Secrets & credentials**: The dotfiles repository is public on GitHub. Never sync credentials, tokens, cookies, or private keys. Add sensitive file patterns to `~/.local/share/chezmoi/.chezmoiignore`.

## MCP Servers (`mcp-ctl`)

Orchestrate all Model Context Protocol servers via `mcp-ctl`:
- **Health check**: `mcp-ctl status`
- **Restart & recover**: `mcp-ctl restart` (or `mcp-ctl up`)
- **View logs**: `mcp-ctl logs`
Never spawn unmanaged ad-hoc MCP server processes.

## Scoped Testing

Keep test runs tightly scoped to avoid machine freezes and slow feedback:
- Target only files covering modified code (by exact path, `-t <pattern>`, or project filter).
- Avoid full repository test suites unless explicitly requested by the user.

## Browser Testing (`chrome-devtools`)

Drive web applications using the `chrome-devtools` MCP server against port 9222:
- Launch debug browser if not running:
  ```bash
  gtk-launch chromium-debug
  ```
  *(Fallback: `chromium --remote-debugging-port=9222 --no-first-run --no-default-browser-check &`)*
- Verify endpoint health before DevTools calls:
  ```bash
  curl -s http://127.0.0.1:9222/json/version
  ```

---
name: computer-use
description: "Operating rules for Erik's Arch Linux machine: dev servers in Herdr, dotfiles with chezmoi, mcp-ctl recovery, scoped testing, and Chrome DevTools debug launches. Activate whenever running local servers, executing tests, modifying dotfiles, debugging MCP, or testing web UIs."
---

# Computer Use & Machine Rules

Operating guidelines for local development, background services, and system resources on Erik's machine.

## Dotfiles (`chezmoi`)

The local filesystem is the source of truth.
- **Workflow**: Check tracking status with `chezmoi status`. Sync modified tracked files with `chezmoi re-add <path>` and new files with `chezmoi add <path>`.
- **Public Repository Security**: The dotfiles repo is publicly hosted on GitHub. Never sync credentials, tokens, session cookies, or private keys.
- **Quarantine**: If private or machine-specific data appears in a tracked folder, immediately append its pattern to `~/.local/share/chezmoi/.chezmoiignore`.

## MCP Servers (`mcp-ctl`)

All MCP servers are orchestrated via `mcp-ctl`. When an MCP server disconnects, crashes, or fails to respond:
- Check service health: `mcp-ctl status`
- Cycle and recover: `mcp-ctl restart` (or `mcp-ctl up`)
- Diagnose errors: `mcp-ctl logs`
Never spawn ad-hoc, unmanaged Node or Python background MCP processes.

## Dev Servers & Long-Running Services (`herdr`)

Always run development servers inside **`herdr`**.
- **Shared Control Plane**: Herdr provides a persistent TTY that both the user and agents can inspect and attach to.
- **No Orphaned Processes**: Never spawn detached background subshells (`nohup`, `&`) for servers.

## Resource Safety & Freezing Prevention

The machine has strict hardware resource limits. Prevent CPU and memory exhaustion:
- **Server Concurrency**: Only small or lightweight services may run simultaneously. Never run more than one heavy, full-stack dev stack at a time.
- **Workload Separation**: Never run broad test suites, container builds, or heavy multi-package compilations while a heavy dev server is active (causes severe swap thrashing and UI freezes).
- **Targeted Process Control**: Stop services gracefully via `herdr`, `docker compose`, or explicit PID. Never run blanket process killers (`pkill -f node`, `killall`).

## Scoped Testing

Always prefer tightly scoped test executions:
- Run only tests directly covering modified code (by exact file path, `-t <pattern>`, or project filter).
- Avoid repository-wide full test suites unless explicitly requested by the user.

## Browser Testing (`chrome-devtools`)

Test web applications using the `chrome-devtools` skill and MCP tools.
- Remote debugging endpoint runs on port `9222`.
- If not running, launch the debug browser via:
  ```bash
  gtk-launch chromium-debug
  ```
  *(Fallback: `chromium --remote-debugging-port=9222 --no-first-run --no-default-browser-check &`)*
- Verify the endpoint is alive (`curl -s http://127.0.0.1:9222/json/version`) before making DevTools MCP calls.

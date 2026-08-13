# OpenCode Global System Rules & Guidelines

## Code & Refactoring Standards
- Write modular, readable, and idiomatic code adhering to project conventions.
- Maintain docstrings and comments when refactoring existing code.
- Avoid introducing unnecessary heavy external dependencies when native solutions exist.

## Verification & Quality Assurance
- **Verify Before Declaring Success**: Always run test suites (`npm test`, `cargo test`, `go test`, etc.) or build checks (`npm run build`) before confirming completion.
- Inspect exact error logs before diagnosing runtime failures. Do not mask errors with superficial `try/catch` fallbacks.

## Workspace & Tool Usage
- Use available MCP tools (`balcon-padel-dev`, `sentry`, `shadcn`, `next-devtools`, etc.) when inspecting databases, frontend components, or error tracebacks.
- Keep modifications cleanly scoped to requested files and directories.

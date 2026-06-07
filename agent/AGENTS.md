# Coding Agent Guidelines
This AGENTS.md should be treated as the over arching set of rules and guidelines for coding agents to follow. 

## Project Context 

**Tech Stack:** Python, Nix, NixOS, SQL, HCL/IaC, Ansbile, Go, Linux, Postgres, DuckDB

**Primary Use Case:** The primary use case for this document is to instruct coding agents on best practices, things to do, things to not do, and general context.

## Critical Rules 

- Match existing naming, tone, and folder layout 
- Keep docs concise — short sections, direct bullets, no filler 
- Update related indexes or READMEs when adding skills, agents, or integrations 
- Do not invent generated outputs; regenerate only when the workflow requires it 
- When you need to search docs, use Context7 

## Damage Control 

Safety-first rules that apply to every session. No exceptions. 

### Blocked Commands 

Never run destructive commands without explicit user approval: 

- `rm -rf`, `rm -r`, `rm` — always ask before deleting files or directories 
- `git reset --hard`, `git clean -fd`, `git push --force` — irreversible git operations 
- `DROP TABLE`, `DROP DATABASE`, `TRUNCATE`, `DELETE` without a `WHERE` clause — destructive SQL 
- `chmod -R 777`, `chown -R` — broad permission changes 
- `> file` (redirect overwriting a file) — silent data loss 

When the user asks you to delete, remove, or clean up files, **stop and confirm** the exact paths and scope before proceeding. 

### Verification on Vague Requests 

Always ask for clarification when a request is ambiguous or could be interpreted multiple ways: 

- "Clean this up" — ask what specifically should change 
- "Fix the errors" — confirm which errors and which files 
- "Delete the old stuff" — ask which files/directories, list them first 
- "Reset everything" — confirm scope (repo state, database, config, all of the above?) 
- "Update the config" — ask which values and to what 

**Rule:** If you are unsure about scope, targets, or intent — ask first, act second. 

### Protected Paths 

Never write to or modify these without explicit approval: 

- `.env`, `credentials.json`, `*.pem`, `*.key` — secrets and credentials 
- `~/.ssh/`, `~/.gnupg/` — authentication material 
- System configs (`/etc/`, `~/.bashrc`, `~/.zshrc`) — environment-altering files 

## Documentation Standards 

Pulled from the `documentation-writing` skill: 

- Write in active voice, present tense 
- Use concrete numbers over vague claims ("reduces latency by 40ms" not "significantly faster") 
- Avoid AI buzzwords: leverage, utilize, robust, seamless, innovative, comprehensive, cutting-edge 
- Avoid AI filler phrases: moreover, furthermore, it is important to note, in today's fast-paced world 
- Comments explain **why**, not **what** 
- Error messages should be specific and actionable 
- Read-aloud test: if it doesn't sound like something you'd say, rewrite it 

## Coding Style 

### Python 

From the `python-workflow` skill: 

- **Package manager:** Use `uv` exclusively; run via `uv run python`, never manual `.venv` paths 
- **Style:** PEP 8, 88-char line length, Ruff for linting and formatting 
- **Type hints:** Required on all parameters and return values (use `list[str]`, `dict[str, Any]` for 3.9+) 
- **Naming:** PascalCase classes, snake_case functions/variables, UPPER_SNAKE_CASE constants 
- **Comments:** Single-line `#` only, no multi-line `""" """` blocks 
- **Validation:** Pydantic for data models, `pathlib.Path` for file paths 
- **Testing:** pytest with fixtures, tests in `tests/unit/` and `tests/integration/` 
- **Errors:** Specific exception types with meaningful messages; never remove public methods for lint fixes 
- **Config:** `pyproject.toml` as single source of truth; `.env` files via python-dotenv (never committed) 

### Shell 

- Quote file paths containing spaces 
- Use `set -euo pipefail` in scripts 
- Prefer long-form flags for readability (`--recursive` over `-r`) 

### Markdown 

- Use GitHub-flavored markdown 
- One sentence per line in source for clean diffs 
- Prefer tables for structured data, lists for sequences 

### TypeScript 

- Strict mode enabled 
- Explicit return types on exported functions 
- Prefer `const` over `let`; avoid `any` 

## Skill Guidelines 

From the `writing-skills` skill: 

- **Structure:** Every skill needs a `SKILL.md` — concise, action-oriented 
- **Naming:** Lowercase with hyphens, verb-first when possible (`creating-skills` not `skill-creation`) 
- **Descriptions:** Start with "Use when..." — describe triggering conditions, not the workflow 
- **Content:** One excellent example beats many mediocre ones; inline code under 50 lines, separate file for heavy reference 
- **Testing:** No skill without a failing test first (TDD for documentation) 
- **Discovery:** Put searchable terms (error messages, symptoms, tool names) early and often 

### Adding or Updating a Skill 

- Edit canonical files in the appropriate `skills/` location 
- Keep `SKILL.md` under 500 words when possible 
- Update supporting references only when they add real value 
- Reflect new skills in repo docs when discoverability changes 

### Adding or Updating an Agent 

- Place definitions under the correct `agents/` category 
- Follow the `<domain>-<role>.md` naming pattern 
- Update strategy or integration docs when the new agent affects orchestration 

## Web Search 

- Always pass `workflow: "none"` when calling `web_search` — skip the browser curator by default 
- Use `workflow: "summary-review"` only when explicitly asked to curate results 
## Tool and Skill Routing 


## Notes for Agents 

- Check `skills/` before assuming a skill exists in only one place 
- Check `agents/` before describing the available catalog or integration coverage 
- Prefer small, targeted doc edits over broad rewrites 
- When you need to search docs, use Context7 
- Load relevant skills before starting work — they contain tested patterns and prevent common mistakes

MCP Servers Configured (pi-coding agent):
  - context7 (url MCP)
  - do_apps (url MCP)
  - do_databases (url MCP)
  - do_droplets (url MCP)
  - do_networking (url MCP)
  - flox (command: flox-mcp)
  - mcp-nixos (url MCP)
  - neon (url MCP)
  - postgres-mcp (url MCP)

---
Edit Tool Usage:
The edit tool requires a `path` (string) and `edits` array with `{oldText, newText}` objects.
Always include `path` in every edit call — it is required and cannot be omitted.
Each `oldText` must match a unique contiguous region in the original file.

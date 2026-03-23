# Neovim Dashboard Palette Match Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the Snacks dashboard match the `popping_and_locking` colorscheme palette without changing dashboard structure or introducing `lazy.nvim` dependencies.

**Architecture:** Keep the current Snacks `dashboard` and `notifier` setup in `home/shell/neovim.nix`, and add a small Lua highlight override block after the colorscheme is loaded. Reuse the existing palette values from `home/shell/nvim/colors/popping_and_locking.lua` so the dashboard surface, header, keys, and secondary text all align with the theme.

**Tech Stack:** Nix, Home Manager, nvf, Neovim Lua API, Snacks.nvim

---

## File Structure

- Modify: `home/shell/neovim.nix`
  - Keep the existing Snacks dashboard config intact
  - Add the dashboard highlight override block in `vim.luaConfigPost`
- Reference only: `home/shell/nvim/colors/popping_and_locking.lua`
  - Mirror the existing palette values; do not move or refactor the colorscheme file in this task

## Chunk 1: Add Palette-Matched Dashboard Highlights

### Task 1: Inspect current dashboard and palette wiring

**Files:**
- Modify: `home/shell/neovim.nix`
- Reference: `home/shell/nvim/colors/popping_and_locking.lua`

- [ ] **Step 1: Read the current dashboard config and colorscheme palette**

Review:

- `home/shell/neovim.nix`
- `home/shell/nvim/colors/popping_and_locking.lua`

Confirm:

- the dashboard uses only `header` and `keys`
- notifier is enabled
- the palette values to mirror are `bg`, `bg_alt`, `fg`, `muted`, `gray`, `red_bright`, `yellow_bright`, `blue_bright`, and `cyan_bright`

- [ ] **Step 2: Write the highlight override block in `vim.luaConfigPost`**

Add a Lua block after `vim.cmd.colorscheme("popping_and_locking")` that:

- defines a local palette table using the same hex values as the colorscheme
- defines a tiny helper like `local hl = function(group, opts) vim.api.nvim_set_hl(0, group, opts) end`
- sets Snacks dashboard highlight groups to match the theme

The block should cover at least these groups:

```lua
SnacksDashboardNormal
SnacksDashboardHeader
SnacksDashboardTitle
SnacksDashboardDesc
SnacksDashboardIcon
SnacksDashboardKey
SnacksDashboardFile
SnacksDashboardDir
SnacksDashboardFooter
SnacksDashboardSpecial
```

Recommended styling:

```lua
SnacksDashboardNormal  -> fg = p.fg, bg = p.bg
SnacksDashboardHeader  -> fg = p.yellow_bright, bold = true
SnacksDashboardTitle   -> fg = p.blue_bright, bold = true
SnacksDashboardDesc    -> fg = p.muted
SnacksDashboardIcon    -> fg = p.cyan_bright
SnacksDashboardKey     -> fg = p.yellow_bright, bold = true
SnacksDashboardFile    -> fg = p.fg
SnacksDashboardDir     -> fg = p.gray
SnacksDashboardFooter  -> fg = p.blue
SnacksDashboardSpecial -> fg = p.red_bright
```

Do not add:

- custom dashboard sections
- `example = ...`
- any `lazy.nvim` integration

- [ ] **Step 3: Keep the change minimal**

Do a quick pass to ensure:

- no duplicate `vim.utility.snacks-nvim.enable` entries are introduced
- no unrelated edits are made to LSP, completion, snippets, or lualine config
- the override code stays close to the colorscheme call for readability

### Task 2: Verify the dashboard styling works

**Files:**
- Modify: `home/shell/neovim.nix`

- [ ] **Step 1: Rebuild the system configuration**

Run:

```bash
sudo nixos-rebuild switch --flake .#nix-lemur
```

Expected:

- build succeeds
- no nvf option errors

- [ ] **Step 2: Verify headless startup still succeeds**

Run:

```bash
nvim --headless +qa
```

Expected:

- no output
- exit success

- [ ] **Step 3: Verify normal UI startup**

Run:

```bash
nvim
```

Expected:

- dashboard opens without `lazy.stats` errors
- dashboard colors clearly reflect the `popping_and_locking` palette
- header, key labels, and descriptions are visually distinct

- [ ] **Step 4: Sanity-check that the rest of the UI still looks normal**

In Neovim, open a file and confirm:

- the colorscheme is still `popping_and_locking`
- lualine still uses the existing theme block
- no obvious regression appears in normal editing highlights

- [ ] **Step 5: Commit**

```bash
git add home/shell/neovim.nix docs/superpowers/specs/2026-03-22-neovim-dashboard-palette-match-design.md docs/superpowers/plans/2026-03-22-neovim-dashboard-palette-match.md
git commit -m "feat: theme snacks dashboard to match popping and locking"
```

# Neovim Dashboard Palette Match Design

**Date:** 2026-03-22

**Goal**

Make the Snacks dashboard feel native to the `popping_and_locking` colorscheme by matching its palette and interaction styling, without adding new plugins, custom sections, or `lazy.nvim` dependencies.

## Current State

- The colorscheme lives in `home/shell/nvim/colors/popping_and_locking.lua`.
- The Neovim nvf config lives in `home/shell/neovim.nix`.
- Snacks dashboard is enabled with only `header` and `keys` sections, which avoids the `startup` section crash caused by `lazy.stats`.

## Design

### Palette Application

The dashboard will reuse the existing `popping_and_locking` palette values and assign them to Snacks dashboard highlight groups.

- Surface/background: `bg`, `bg_alt`
- Primary text: `fg`
- Secondary text: `muted`, `gray`
- Primary accents: `yellow_bright`, `blue_bright`, `cyan_bright`
- Destructive action: `red_bright`

This keeps the dashboard visually consistent with the colorscheme and existing lualine styling.

### Scope of Styling

The implementation should only style the existing Snacks dashboard.

- Keep the current `header` and `keys` sections
- Do not add custom ASCII header art in this pass
- Do not add startup stats or other sections that assume `lazy.nvim`
- Do not change notifier behavior beyond the current enablement

### Implementation Approach

Add a small Lua block after the colorscheme is loaded in `home/shell/neovim.nix` to override Snacks dashboard highlight groups with theme-matching colors.

The block should:

- define the palette inline from `popping_and_locking`
- create dashboard highlight overrides with `vim.api.nvim_set_hl`
- target the main Snacks dashboard groups used for:
  - dashboard background
  - header/title
  - keys
  - descriptions
  - file/path text
  - special/accent text

This keeps the change local, easy to maintain, and independent of upstream Snacks defaults.

## Error Handling

- The override block should be safe if Snacks is not currently visible.
- The styling must not depend on `lazy.nvim`, runtime plugin stats, or optional dashboard presets.

## Testing

- Rebuild with `sudo nixos-rebuild switch --flake .#nix-lemur`
- Open `nvim`
- Confirm no `lazy.stats` errors appear
- Confirm the dashboard colors match the `popping_and_locking` palette more closely than the default Snacks appearance
- Confirm standard editing highlights and lualine still look unchanged

## Files Affected

- Modify: `home/shell/neovim.nix`
- Reference only: `home/shell/nvim/colors/popping_and_locking.lua`

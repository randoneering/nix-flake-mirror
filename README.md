# Randoneering's Multi-System Nix Flake

NixOS flake for managing multiple machines with shared modules and per-host overrides.

## What This Repository Contains

- One `flake.nix` that defines 4 NixOS configurations.
- Shared NixOS modules in `modules/`.
- Shared Home Manager modules in `home/`.
- User entrypoints in `users/`.
- Host-specific hardware and system settings in `hosts/`.

## Hosts

| Flake target | Host folder | Hostname | Primary user |
| --- | --- | --- | --- |
| `.#nix-station` | `hosts/nix-station` | `nix-station` | `randoneering` |
| `.#nix-wks` | `hosts/wks` | `nix-wks` | `justin` |
| `.#nix-lemur` | `hosts/lemur` | `nix-lemur` | `justin` |
| `.#nix-L16` | `hosts/L16` | `nix-l16` | `justin` |

## Repository Layout

```text
.
├── flake.nix
├── flake.lock
├── hosts/
│   ├── nix-station/
│   ├── wks/
│   ├── lemur/
│   └── L16/
├── modules/
│   ├── system.nix
│   ├── desktop/
│   └── networking/
├── home/
│   ├── core.nix
│   ├── programs/
│   ├── shell/
│   ├── languages/
│   └── utils/
└── users/
    ├── justin/
    └── randoneering/
```

## Prerequisites

- NixOS with flakes enabled.
- A user with sudo access for `nixos-rebuild`.

Enable flakes if needed:

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

Apply:

```bash
sudo nixos-rebuild switch
```

## Quick Start

Clone and inspect outputs:

```bash
git clone <repo-url> ~/nix-flake
cd ~/nix-flake
nix flake show
```

Switch a host:

```bash
sudo nixos-rebuild switch --flake .#nix-station
# or
sudo nixos-rebuild switch --flake .#nix-wks
# or
sudo nixos-rebuild switch --flake .#nix-lemur
# or
sudo nixos-rebuild switch --flake .#nix-L16
```

## Common Workflow

Check evaluation before switching:

```bash
nix flake check
nix eval '.#nixosConfigurations."nix-wks".config.system.build.toplevel.drvPath'
```

Build without activating:

```bash
sudo nixos-rebuild build --flake .#nix-wks
```

Test activation path:

```bash
sudo nixos-rebuild test --flake .#nix-wks
```

## Home Manager and Neovim (nvf)

Neovim is configured in `home/shell/neovim.nix` through `programs.nvf`.

Current language blocks include:

- Nix (`nixd`, `nixfmt`, extra diagnostics)
- Python (`basedpyright`, `ruff`)
- SQL
- HCL
- YAML
- Go (`gopls`, `gofumpt`)
- Rust (rust-analyzer, `rustfmt`)

Autocomplete uses `blink-cmp` with keymap preset `enter`.

NVF option reference:

- https://nvf.notashelf.dev/options.html

## Updating Inputs

Update all inputs:

```bash
nix flake update
```

Update one input:

```bash
nix flake lock --update-input nixpkgs
```

After updates, rebuild the host you changed:

```bash
sudo nixos-rebuild switch --flake .#nix-wks
```

## Troubleshooting

Check flake structure:

```bash
nix flake show
```

Show traces on rebuild errors:

```bash
sudo nixos-rebuild switch --flake .#nix-wks --show-trace --print-build-logs
```

List system generations:

```bash
sudo nixos-rebuild list-generations
```

Rollback to previous generation:

```bash
sudo nixos-rebuild switch --rollback
```

## Resources

- https://nixos.wiki/wiki/Flakes
- https://nix-community.github.io/home-manager/
- https://search.nixos.org/packages
- https://nvf.notashelf.dev/options.html

## License

GPL. See `LICENSE`.

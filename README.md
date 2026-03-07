# Randoneering's Multi-System Nix Flake

NixOS flake for managing multiple machines with shared modules and per-host overrides.

## What This Repository Contains

- One `flake.nix` with 4 NixOS configurations.
- Shared system modules in `modules/` (desktop, networking, LLM, and database).
- Shared Home Manager modules in `home/` (programs, shell, languages, secrets, utilities).
- User entrypoints in `users/`.
- Host-specific hardware and system settings in `hosts/`.
- SOPS-managed secrets in `secrets/`.

## Hosts

| Flake target | Host folder | Hostname | Primary user | Notes |
| --- | --- | --- | --- | --- |
| `.#nix-station` | `hosts/nix-station` | `nix-station` | `randoneering` | Uses `flox` NixOS module |
| `.#nix-wks` | `hosts/wks` | `nix-wks` | `justin` | NVIDIA + Ollama host |
| `.#nix-lemur` | `hosts/lemur` | `nix-lemur` | `justin` | PostgreSQL 18 profile |
| `.#nix-L16` | `hosts/L16` | `nix-l16` | `justin` | Laptop profile |

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
│   ├── networking/
│   ├── llm/
│   └── database/
├── home/
│   ├── core.nix
│   ├── programs/
│   ├── shell/
│   ├── languages/
│   ├── secrets.nix
│   └── utils/
├── users/
│   ├── justin/
│   └── randoneering/
└── secrets/
    └── justin.yaml
```

## Prerequisites

- NixOS with flakes enabled.
- A user with sudo access for `nixos-rebuild`.
- If using secrets: an age key at `~/.config/sops/age/keys.txt`.

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

## Home Manager and Tooling

### Neovim (nvf)

Neovim is configured in `home/shell/neovim.nix` through `programs.nvf`.

Current language blocks include:

- Nix (`nixd`, `nixfmt`, extra diagnostics)
- Python (`basedpyright`, `ruff`)
- SQL (PostgreSQL dialect)
- HCL
- YAML
- Go (`gopls`, `gofumpt`)
- Rust (`rust-analyzer`, `rustfmt`)

Autocomplete uses `blink-cmp` with keymap preset `enter`.

### Opencode and MCP

`programs.opencode` is configured in `home/programs/opencode.nix` with:

- Remote Ollama provider (`https://ollama.randoneering.dev/v1`)
- Flox MCP wrapper (`flox-mcp`)
- DigitalOcean Apps and Databases MCP endpoints
- Neon MCP endpoint

### Secrets (sops-nix)

`home/secrets.nix` enables Home Manager SOPS integration when `secrets/justin.yaml` exists.

Current managed secret key:

- `digitalocean_api_token`

## Host Modules Added Recently

- `modules/database/postgres18.nix`: PostgreSQL 18 profile with `pg_stat_statements`, SSL settings, and logging defaults.
- `modules/llm/ollama.nix`: Ollama service module for GPU-backed local model serving.

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
- https://github.com/Mic92/sops-nix

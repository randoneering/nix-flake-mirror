# Randoneering's Multi-System Nix Flake

Personal NixOS flake configuration for managing multiple systems with reproducible, declarative configurations. This flake manages 4 different machines with consistent system settings, user environments, and hardware-specific adaptations.

## Overview

This repository contains a comprehensive Nix flake that provides:
- System configurations for 4 different machines (nix-station, nix-wks, nix-lemur, nix-L16)
- Modular, reusable NixOS modules
- Home Manager integration for user-level configurations
- Development environments with AI/LLM capabilities
- Consistent shell and tooling across all systems

Built on NixOS 25.11 with reproducible, locked dependencies.

## Features

- **Multi-system support**: Configurations for different machines and architectures
- **Reproducible environments**: Locked dependencies ensure consistent builds
- **Modular configuration**: Reusable modules for desktops, networking, and services
- **Home Manager integration**: User-specific configurations alongside system configs
- **LLM Infrastructure**: Ollama and Open-WebUI for local AI inference
- **Development tooling**: Comprehensive dev environment with Git, Docker, IaC tools
- **VPN networking**: Tailscale and WireGuard support
- **Desktop environments**: GNOME and Cosmic desktop configurations
- **NFS integration**: Auto-mounting network storage from central NAS

## System Configurations

### nix-station
**Primary workstation** for the `randoneering` user.
- GNOME desktop environment
- Ollama LLM services with Open-WebUI
- NFS mounts for Jellyfin and Nextcloud
- Full development toolchain

### nix-wks
**High-performance workstation** with GPU acceleration.
- NVIDIA GPU support with proprietary drivers
- Steam gaming platform
- LLM services (Ollama) with CUDA acceleration
- Loaded models: llama3.2:3b, deepseek-r1:1.5b, gemma3:12b, qwen3 variants
- Extended firewall rules for network services
- Open-WebUI on port 8080

### nix-lemur & nix-L16
**Lightweight configurations** for secondary machines.
- GNOME desktop
- Standard development tools
- Network connectivity via Tailscale

## Repository Structure

```
.
├── flake.nix              # Main entry point - defines 4 system configurations
├── flake.lock             # Locked dependency versions (NixOS 25.11)
├── README.md              # This file
├── LICENSE                # GPL license

├── hosts/                 # System-specific configurations
│   ├── nix-station/       # Main station (randoneering user)
│   ├── nix-wks/           # Workstation with NVIDIA, Steam, LLM
│   ├── nix-lemur/         # Secondary machine
│   └── L16/               # Laptop configuration

├── modules/               # Reusable NixOS modules
│   ├── system.nix         # Core system settings (Nix, time, printing, SSH)
│   ├── desktop/           # Desktop environment configurations
│   │   ├── gnome/         # GNOME desktop
│   │   └── cosmic/        # Cosmic desktop
│   ├── llm/               # LLM service modules
│   │   └── ollama.nix     # Ollama + Open-WebUI setup
│   └── networking/        # Network configuration
│       ├── tailscale.nix  # Tailscale VPN
│       └── wireguard.nix  # WireGuard VPN

├── home/                  # Home Manager user configurations
│   ├── core.nix           # Base home configuration
│   ├── programs/          # Application packages
│   │   ├── common.nix     # Dev tools, databases, IaC tools
│   │   ├── git.nix        # Git with SSH signing
│   │   ├── browsers.nix   # Browser configurations
│   │   └── unstable.nix   # Bleeding-edge packages
│   ├── shell/             # Shell configurations
│   │   ├── fish.nix       # Fish shell (primary)
│   │   ├── bash.nix       # Bash fallback
│   │   ├── starship.nix   # Shell prompt
│   │   ├── atuin.nix      # Shell history
│   │   └── terminals.nix  # Terminal emulators
│   └── utils/             # Utility packages

└── users/                 # User-specific configurations
    ├── justin/            # Main user
    │   ├── home.nix       # User packages and configs
    │   └── nixos.nix      # System-level settings
    └── randoneering/      # Secondary user
        ├── home.nix
        └── nixos.nix
```

## Quick Start

### Prerequisites

You need a NixOS system with flakes enabled.

### Enabling Flakes

If you haven't enabled flakes yet, add the following to your Nix configuration:

```nix
# Add this in your configuration.nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

```bash
# Apply the configuration
sudo nixos-rebuild switch
```

### Deploying a System Configuration

```bash
# Clone this repository
git clone <repo-url> ~/nix-flake
cd ~/nix-flake

# Build and switch to a specific system configuration
sudo nixos-rebuild switch --flake .#nix-station
# or
sudo nixos-rebuild switch --flake .#nix-wks
# or
sudo nixos-rebuild switch --flake .#nix-lemur
# or
sudo nixos-rebuild switch --flake .#nix-L16
```

## Configuration Management

### Updating Dependencies

```bash
# Update all flake inputs (nixpkgs, home-manager, etc.)
nix flake update

# Update and rebuild system
nix flake update && sudo nixos-rebuild switch --flake .#hostname
```

### Adding New Packages

**System-wide packages:**
Edit `hosts/<hostname>/configuration.nix` and add to `environment.systemPackages`.

**User packages:**
Edit `home/programs/common.nix` or create a new module in `home/programs/`.

**Unstable packages:**
Edit `home/programs/unstable.nix` to use bleeding-edge versions from nixpkgs-unstable.

### Testing Configuration Changes

```bash
# Test build without switching
sudo nixos-rebuild test --flake .#hostname

# Build without activating
sudo nixos-rebuild build --flake .#hostname

# Dry run to see what would change
sudo nixos-rebuild dry-build --flake .#hostname
```

## Key Technologies & Services

### Development Tools

The configuration includes a comprehensive development environment:

**Languages & Runtimes:**
- Python with ruff formatter and uv package manager
- Docker and Docker Compose
- Node.js ecosystem

**Infrastructure as Code:**
- OpenTofu (Terraform alternative)
- Ansible
- Nix package management

**Databases:**
- PostgreSQL client
- MySQL client
- MongoDB shell (mongosh)

**Cloud Tools:**
- AWS CLI v2
- Various cloud SDKs

**Version Control:**
- Git with SSH key signing configured
- SSH agent integration

### LLM/AI Services

**Ollama** - Local LLM inference engine:
- GPU acceleration via CUDA (on nix-wks)
- Network accessible at `10.10.1.232:11434`
- Pre-loaded models:
  - llama3.2:3b
  - deepseek-r1:1.5b
  - gemma3:12b
  - qwen3 variants

**Open-WebUI** - Web interface for LLM interaction:
- Accessible on port 8080
- Integrated with Ollama backend
- User-friendly chat interface

### Networking

**Tailscale VPN:**
- Mesh VPN for secure remote access
- Integrated with firewall rules

**WireGuard:**
- Additional VPN option
- Kernel-level performance

**NFS Mounts:**
- Auto-mounting network storage from `nas.randoneering.cloud`
- Jellyfin media library
- Nextcloud storage
- Timeout protection for network failures

### Shell Environment

**Fish Shell:**
- Primary shell (unstable version for latest features)
- Syntax highlighting and autosuggestions
- Custom abbreviations and functions

**Starship Prompt:**
- Fast, customizable shell prompt
- Git integration
- Directory context awareness

**Atuin:**
- Enhanced shell history
- Searchable command history across systems
- Sync capabilities

### Desktop Environment

**GNOME:**
- Modern, polished desktop
- Wayland support
- Extension ecosystem
- Configured on most systems

**Cosmic:**
- Alternative desktop option
- Modern Rust-based environment
- Available for testing

## Adding a New System

1. **Create host directory:**
   ```bash
   mkdir -p hosts/new-hostname
   ```

2. **Generate hardware configuration:**
   ```bash
   sudo nixos-generate-config --show-hardware-config > hosts/new-hostname/hardware-configuration.nix
   ```

3. **Create system configuration:**
   ```nix
   # hosts/new-hostname/configuration.nix
   { config, pkgs, ... }:
   
   {
     imports = [
       ./hardware-configuration.nix
       ../../modules/system.nix
       ../../modules/desktop/gnome
       ../../modules/networking
     ];
     
     networking.hostName = "new-hostname";
     
     # Add system-specific configuration here
   }
   ```

4. **Add to flake.nix:**
   ```nix
   nixosConfigurations = {
     # ... existing configs ...
     
     new-hostname = nixpkgs.lib.nixosSystem {
       system = "x86_64-linux";
       specialArgs = {
         inherit inputs;
         username = "yourusername";
         hostname = "new-hostname";
       };
       modules = [
         ./hosts/new-hostname/configuration.nix
         home-manager.nixosModules.home-manager
         {
           home-manager.useGlobalPkgs = true;
           home-manager.useUserPackages = true;
           home-manager.users.yourusername = import ./users/yourusername/home.nix;
         }
       ];
     };
   };
   ```

5. **Deploy:**
   ```bash
   sudo nixos-rebuild switch --flake .#new-hostname
   ```

## Module System

### Creating a New Module

1. **Create module file:**
   ```bash
   touch modules/myservice/default.nix
   ```

2. **Define module:**
   ```nix
   # modules/myservice/default.nix
   { config, pkgs, lib, ... }:
   
   {
     services.myservice = {
       enable = true;
       # ... service configuration
     };
     
     # Additional system configuration
   }
   ```

3. **Import in host configuration:**
   ```nix
   imports = [
     ../../modules/myservice
   ];
   ```

### Available Modules

- `modules/system.nix` - Core system settings (Nix daemon, SSH, printing)
- `modules/desktop/gnome` - GNOME desktop environment
- `modules/desktop/cosmic` - Cosmic desktop environment
- `modules/llm/ollama.nix` - Ollama LLM service
- `modules/networking/tailscale.nix` - Tailscale VPN
- `modules/networking/wireguard.nix` - WireGuard VPN

## Troubleshooting

### Common Issues

**Flake not recognized:**
```bash
# Ensure flakes are enabled
nix show-config | grep experimental-features

# One-time usage
nix --extra-experimental-features "nix-command flakes" flake show
```

**Build failures:**
```bash
# Update dependencies
nix flake update

# Clean build with traces
sudo nixos-rebuild switch --flake .#hostname --show-trace --print-build-logs

# Check for evaluation errors
nix flake check
```

**Permission issues:**
```bash
# Ensure proper ownership
sudo chown -R $USER:users ~/nix-flake

# Use sudo for system operations
sudo nixos-rebuild switch --flake .#hostname
```

**NFS mount failures:**
- Check network connectivity to `nas.randoneering.cloud`
- Verify NFS exports on the NAS
- Check firewall rules on both client and server
- Review mount options in host configuration

**Ollama service not starting:**
```bash
# Check service status
systemctl status ollama.service

# View logs
journalctl -u ollama.service -f

# Verify GPU availability (for CUDA)
nvidia-smi
```

### Debugging

```bash
# Check flake structure
nix flake show

# Evaluate configuration without building
nix eval .#nixosConfigurations.hostname.config.system.build.toplevel

# Debug build with full traces
sudo nixos-rebuild switch --flake .#hostname --show-trace --verbose

# Check what would be built
nix build .#nixosConfigurations.hostname.config.system.build.toplevel --dry-run

# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

### Rolling Back

```bash
# List previous generations
sudo nixos-rebuild list-generations

# Switch to previous generation
sudo nixos-rebuild switch --rollback

# Boot into specific generation (replace N with generation number)
sudo nixos-rebuild switch --switch-generation N
```

## Maintenance

### Garbage Collection

The configuration includes automatic weekly garbage collection. Manual cleanup:

```bash
# Delete old generations older than 30 days
sudo nix-collect-garbage --delete-older-than 30d

# Delete all old generations
sudo nix-collect-garbage -d

# Optimize Nix store
nix-store --optimize
```

### Updating System

```bash
# Update flake inputs
nix flake update

# Update and rebuild
nix flake update && sudo nixos-rebuild switch --flake .#hostname

# Update only nixpkgs
nix flake lock --update-input nixpkgs
```

## Resources

- [Nix Flakes Documentation](https://nixos.wiki/wiki/Flakes)
- [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/)
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Package Search](https://search.nixos.org/)
- [NixOS Discourse](https://discourse.nixos.org/)

## License

GPL - See LICENSE file for details.

## Contributing

This is a personal configuration repository. Feel free to fork and adapt for your own use.

## Contact

For questions or issues: justin@randoneering.tech

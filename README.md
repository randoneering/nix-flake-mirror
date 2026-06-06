# Randoneering's Multi-System Nix Flake

This flake manages my various computing environments, providing a unified way to configure different machines while allowing for necessary host-specific customizations.

## The Philosophy

My approach here is to treat each machine not as a standalone box, but as a specific instantiation of a shared, well-defined system. We pull in shared logic—like networking setups, my favorite editors, and database tooling—into central modules. Then, we apply tailored overrides in the host configuration to make each machine feel uniquely suited to its purpose.

## What's in This Repository?

This repository serves as my central configuration hub, containing:

*   **`flake.nix`**: The root of the system, tying everything together.
*   **`modules/`**: The shared brain. Here lives the generalized configuration for system features (like `desktop`, `llm`, `database`).
*   **`home/`**: My digital toolkit. This handles personal settings like shell configurations, preferred programming environments (Python, Rust, etc.), and secret management via Home Manager.
*   **`hosts/`**: The body of the system. These folders define *what* each specific machine is—the NixOS target, the hardware profile, the user context.
*   **`secrets/`**: Keeping things private. Configuration data that needs to be encrypted is managed here using SOPS.

## Hosts

I've defined several specific environments for different tasks:

| Environment Name | Folder | Purpose/Notes |
| :--- | :--- | :--- |
| `nix-wks` | `hosts/wks` | The primary workstation, configured for NVIDIA acceleration and local LLM serving (llama.cpp). |
| `nix-lemur` | `hosts/lemur` | My travel machine and one of my favorite laptops (system76 lemur pro |
| `nix-L16` | `hosts/L16` | My portible workstation (lenovo L16 Gen1) |

## Flake Structure

The architecture is designed for clarity and reuse:

```text
.
├── flake.nix
├── flake.lock
├── hosts/              # Defines specific machine instances (e.g., wks, lemur)
│   ├── nix-station/
│   ├── wks/
│   ├── lemur/
│   └── L16/
├── modules/            # Reusable system components (e.g., llm, database)
│   ├── system.nix
│   ├── desktop/
│   ├── networking/
│   ├── llm/
│   └── database/
├── home/               # User-specific configurations (e.g., programs, shell)
│   ├── core.nix
│   ├── programs/
│   ├── shell/
│   ├── languages/
│   ├── secrets.nix
│   └── utils/
├── users/              # User-specific profiles
│   ├── justin/
│   └── randoneering/
└── secrets/            # Encrypted sensitive data
    └── justin.yaml
```



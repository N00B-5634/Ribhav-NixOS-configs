
---

```markdown
# Ribhav’s NixOS Configs

> "Oh no. My libc, it's broken."
> - Ribhav (N00B-5634), Oct 28 2025 

Welcome to **Ribhav’s NixOS Config** — powered by **Nix Flakes**, **XFCE**, and **Zsh**.

---

## Overview

This setup focuses on:  
- **Usability:** Lightweight XFCE desktop environment.
- **Power:** Has games, and other fun video tools.
- **Productivity:** Has productivity software, as well as sane defaults.
- **Security:** Infrastructure secrets provisioned runtime via SOPS-nix.

---

## Directory Structure

```bash
.
├── alacritty.yml            # Terminal emulator styling
├── assets/                  # Application resources (e.g., PurpleDragonFTC.jar)
├── configuration.nix        # Main system entry point
├── flake.nix                # Flake entrypoint
├── flake.lock               # Pin lock for inputs
├── hardware-configuration.nix # Default target hardware definition
├── iso-config.nix           # Custom bootable ISO configurations
├── laptop-configuration.nix # Laptop host profile configuration
├── laptop-hardware.nix      # Laptop-specific hardware attributes
├── starship.toml            # Prompt styling configurations
├── secrets/                 # Encrypted credentials
│   └── secrets.yaml         # SOPS encrypted file data
├── nvim/                    # Neovim configuration files
│   ├── init.lua
│   └── lua/
└── nixos-modules/           # System feature layers
    ├── backup.nix           # Automated Restic tasks
    ├── boot.nix             # Sysctl adjustments and boot settings
    ├── desktop.nix          # XFCE and display servers
    ├── extra.nix            # Extra custom services (Tor onion services)
    ├── gatus.nix            # Health monitoring dashboards
    ├── keycloak-theme/      # Visual assets for identity services
    ├── php-env.nix          # Sandboxed PHP pool properties
    ├── secrets.nix          # SOPS-nix deployment configurations
    ├── services.nix         # Network apps, HTTPD, and routing
    └── users.nix            # Identity mappings

```
```
```
### ISO?

Yay! I built an ISO. See more here [Click Me!](ISO.md)


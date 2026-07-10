# Ribhav's NixOS Configurations

> "Oh no. My libc, it's broken."
> - Ribhav (N00B-5634), Oct 28 2025

A NixOS configuration repository featuring **Nix Flakes**, **XFCE desktop environment**, and **Zsh shell**, with extensive service management and security hardening.

## Overview

This configuration powers a NixOS deployment with focus on:
- **Usability**: Lightweight XFCE desktop environment with sensible defaults
- **Power**: Gaming support, video tools, and multimedia capabilities
- **Productivity**: Office software, development tools, and workflow optimizations
- **Security**: Runtime secret provisioning via SOPS-nix, firewall rules, and kernel hardening

## Features

### Desktop Environment
- XFCE desktop with LightDM display manager
- PipeWire audio server
- Alacritty terminal emulator
- Starship shell prompt
- Neovim with Lua configuration

### Services
- Cloudflare Tunnel integrations
- Tor onion services
- Samba file sharing
- OpenSSH with security hardening
- Apache HTTPD web server
- PHP-FPM application server
- MySQL/MariaDB database
- Keycloak identity management
- MediaWiki
- Navidrome music streaming
- MeshCentral remote management
- Filebrowser web file manager
- Restic backups
- Gatus health monitoring

### Security
- SOPS-nix for encrypted secrets management
- Comprehensive firewall configuration
- Kernel hardening via sysctl
- TLS certificate management
- HTTP security headers

## Directory Structure

```bash
.
├── alacritty.yml              # Terminal emulator configuration
├── assets/                    # Application resources
├── configuration.nix          # Main system entry point
├── flake.nix                  # Flake entrypoint with multi-machine configs
├── flake.lock                 # Pin lock for inputs
├── hardware-configuration.nix # Default target hardware definition
├── iso-config.nix             # Custom bootable ISO configurations
├── laptop-configuration.nix   # Laptop host profile
├── laptop-hardware.nix        # Laptop-specific hardware attributes
├── starship.toml              # Shell prompt configuration
├── secrets/                   # Encrypted credentials (SOPS)
│   └── secrets.yaml
├── nvim/                      # Neovim configuration
│   ├── init.lua
│   └── lua/
└── nixos-modules/             # System feature layers
    ├── backup.nix           # Automated Restic backup tasks
    ├── boot.nix             # Sysctl adjustments and boot settings
    ├── desktop.nix          # XFCE and display server configuration
    ├── extra.nix            # Extra services (Tor, custom services)
    ├── gatus.nix            # Health monitoring dashboard
    ├── keycloak-theme/      # Custom Keycloak visual assets
    ├── php-env.nix          # Sandboxed PHP pool properties
    ├── secrets.nix          # SOPS-nix deployment configurations
    ├── services.nix         # Network apps, HTTPD, routing, databases
    └── users.nix            # User identity mappings
```

## Machines

This flake manages multiple NixOS configurations:

- **nixos-lamp**: Main server with full service stack
- **nixos-laptop**: Mobile workstation with XFCE desktop

## Quick Start

```bash
# Build and switch to a configuration
sudo nixos-rebuild switch --flake .#nixos-lamp

# Or for the laptop
sudo nixos-rebuild switch --flake .#nixos-laptop
```

### Building a Custom ISO

```bash
# Build a bootable ISO with this configuration
nix build .#iso

# The ISO will be at ./result/iso/nixos-*.iso
```

See [ISO.md](ISO.md) for detailed ISO building instructions.

## Usage

1. Clone this repository
2. Copy `hardware-configuration.nix` to match your system
3. Update `secrets/secrets.yaml` with your credentials (encrypted via SOPS)
4. Build with `nixos-rebuild switch --flake .#your-hostname`

## Customization

### Adding a New Service

1. Create a new module in `nixos-modules/`
2. Import it in `configuration.nix`
3. Configure the service in the new module file

### Adding a New Machine

1. Add a new configuration in `flake.nix` under `nixosConfigurations`
2. Create a hardware configuration file
3. Create a machine-specific configuration file

## Troubleshooting

- **Hardware configuration**: Run `nixos-generate-config`
- **SOPS decryption**: Ensure your GPG key is available
- **Service issues**: Check logs with `journalctl -u service-name`
- **Flake inputs**: Run `nix flake update`

## Dependencies

- Nix package manager (with flakes enabled)
- SOPS for secrets management
- GPG for secrets encryption

## Resources

- [NixOS Manual](https://nixos.org/manual/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [SOPS-Nix](https://github.com/Mic92/sops-nix)
- [Home Manager](https://github.com/nix-community/home-manager)

## License

This configuration is provided as-is. Individual components may have their own licenses.

---

*Maintained by Ribhav (N00B-5634)*

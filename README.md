# Ribhav's NixOS Configurations

> "Oh no. My libc, it's broken."
> - Ribhav (N00B-5634), Oct 28 2025

A comprehensive NixOS configuration repository featuring **Nix Flakes**, **XFCE desktop environment**, and **Zsh shell**, with extensive service management and security hardening.

## Overview

This configuration powers a multi-machine NixOS deployment with focus on:
- **Usability**: Lightweight XFCE desktop environment with sensible defaults
- **Power**: Gaming support, video tools, and multimedia capabilities
- **Productivity**: Office software, development tools, and workflow optimizations
- **Security**: Runtime secret provisioning via SOPS-nix, firewall rules, and kernel hardening
- **Self-Hosting**: Complete infrastructure for hosting personal services

## Features

### Desktop Environment
- **XFCE**: Lightweight and customizable desktop
- **LightDM**: Display manager for graphical login
- **PipeWire**: Modern audio server
- **Alacritty**: GPU-accelerated terminal emulator
- **Starship**: Customizable shell prompt
- **Neovim**: Modern Vim-based editor with Lua configuration

### Network Services
- **Cloudflare Tunnels**: Secure exposure of multiple services (8+ tunnels)
  - WordPress (main site and blog)
  - Filebrowser (file management)
  - Keycloak (SSO/identity management)
  - MeshCentral (remote device management)
  - Navidrome/Swing Music (music streaming)
  - MediaWiki (team wiki)
  - Status page
  - RDP access
- **Tor Onion Services**: Anonymous access to services
- **Samba**: File sharing for local network
- **OpenSSH**: Secure shell access with Cloudflare compatibility
- **xrdp**: Remote desktop protocol server

### Web Services
- **Apache HTTPD**: Web server with multiple virtual hosts
  - Main site (ftc25671.com)
  - WordPress instances
  - MediaWiki
  - Keycloak
  - Filebrowser
  - Various reverse proxies
- **PHP-FPM**: PHP application server with security hardening
- **MySQL/MariaDB**: Database server with multiple databases

### Application Servers
- **Keycloak**: Identity and access management with custom themes
- **MediaWiki**: Collaborative wiki platform
- **Navidrome**: Music streaming server (Swing Music compatible)
- **MeshCentral**: Remote device management
- **Filebrowser**: Web-based file manager

### Security Features
- **SOPS-Nix**: Encrypted secrets management
- **Firewall**: Comprehensive port filtering
- **Kernel Hardening**: sysctl settings for security
- **TLS Certificates**: Self-signed and Cloudflare certificates
- **Security Headers**: HTTP security headers for all web services

### Development & Productivity
- **Home Manager**: User environment management
- **Nix-ld**: FHS compatibility for running non-Nix binaries
- **Restic**: Automated backup system
- **Gatus**: Health monitoring dashboard

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

### 1. nixos-lamp (Main Server)
- Full service stack including web, database, and application servers
- Cloudflare Tunnel integrations
- Tor onion services
- SOPS-nix for secrets management

### 2. nixos-laptop (Mobile Workstation)
- XFCE desktop environment
- Home Manager integration
- Laptop-specific hardware configuration
- Development tools and productivity software

## Quick Start

### Building the System

```bash
# Build and switch to the configuration
sudo nixos-rebuild switch --flake .#nixos-lamp

# For the laptop
sudo nixos-rebuild switch --flake .#nixos-laptop
```

### Building a Custom ISO

```bash
# Build a bootable ISO with this configuration
nix build .#iso

# The ISO will be at ./result/iso/nixos-*.iso
```

See [ISO.md](ISO.md) for detailed ISO building instructions.

## Services Configuration

### Cloudflare Tunnels

Multiple Cloudflare Tunnels are configured for secure remote access:

| Tunnel ID | Service | Domain |
|-----------|---------|--------|
| f3d06baf... | WordPress | wordpress.ftc25671.com |
| 9bcd38f4... | Default | ftc25671.com |
| (empty) | HTTP | http.ftc25671.com |
| 0657ba26... | Music | music.ftc25671.com |
| 27a037b8... | SSO | sso.ftc25671.com |
| ca273db4... | Management | management.ftc25671.com |
| 9e8a59ce... | Status | status.ftc25671.com |
| 7838f584... | SSH | ssh.ftc25671.com |
| b07a74dd... | RDP | rdp.ftc25671.com |
| 5070dedc... | Wiki | wiki.ftc25671.com |

### Tor Onion Services

Anonymous .onion addresses for privacy-focused access:

| Service | Onion Address |
|---------|---------------|
| WordPress | ftc25dgxyd6xxmo7mzhjjhuvpvfvrjntfxxsoczawuyrwri4evm5tgad.onion |
| Filebrowser | ftc25b7ejteyhn4pbnquterwubyixll7oih4czs6b47xhoypy23ewxid.onion |
| Keycloak | qq77i5bjsqsokgr7caxrgmqvdf6vnzslvrvh5cqchslg53mdzzc6v7qd.onion |
| MediaWiki | ftc25woc5kjvm3llabonsinjnsrch44x7huzd3kkm4upb33qqapbwzid.onion |
| Management | ftc25xqy2n3axu5gcu6egnw6j5zilylalgubbrllyf5mc44dsathyhyd.onion |
| Status | ftc25nkblwq5h36xf4hnmvl2hmiup66iapv5sb5euprvtcqwhivoe3qd.onion |
| Music | ftcmapicjbb2pmpyazralaoxwl2dkolk424mwtyhgdexxkuvncawload.onion |

### Apache Virtual Hosts

| Hostname | Port | Service | SSL |
|----------|------|---------|-----|
| ftc25671.com | 80 | Main site | No |
| wiki.ftc25671.com | 8086 | MediaWiki | No |
| sso.ftc25671.com | 443 | Keycloak | Yes |
| management.ftc25671.com | 443 | MeshCentral | Yes |
| music.ftc25671.com | 443 | Navidrome | Yes |
| guacamole.ftc25671.com | 443 | Guacamole | Yes |
| files.ftc25671.com | 443 | Filebrowser | Yes |
| status.ftc25671.com | 443 | Status Page | Yes |

## Security Configuration

### Firewall Rules

Allowed TCP ports:
- 22 (SSH)
- 80 (HTTP)
- 3000 (Development)
- 3389 (RDP)
- 4533 (Music streaming)

### Kernel Hardening (sysctl)

Network security settings:
- ICMP redirect blocking
- Source routing protection
- RP filter enforcement
- UDP memory limits
- Kernel pointer restriction

### SOPS-Nix Secrets

Encrypted secrets are managed via SOPS and provisioned at runtime:
- Database passwords
- Cloudflare Tunnel tokens
- API keys and credentials

## Usage

### For New Users

1. Clone this repository
2. Copy `hardware-configuration.nix` to match your system
3. Update `secrets/secrets.yaml` with your credentials (encrypted)
4. Build with `nixos-rebuild switch --flake .#your-hostname`

### For Development

```bash
# Enter a development shell
nix develop

# Update flake inputs
nix flake update

# Check for errors
nixos-rebuild dry-activate --flake .#nixos-lamp
```

## Customization

### Adding a New Service

1. Create a new module in `nixos-modules/`
2. Import it in `configuration.nix`
3. Configure the service in the new module file

### Adding a New Machine

1. Add a new configuration in `flake.nix` under `nixosConfigurations`
2. Create a hardware configuration file
3. Create a machine-specific configuration file

### Updating Secrets

```bash
# Edit encrypted secrets
sops secrets/secrets.yaml

# Rebuild to apply secret changes
sudo nixos-rebuild switch
```

## Troubleshooting

### Common Issues

**"Cannot find hardware configuration"**
- Run `nixos-generate-config` and copy the hardware file
- Or use `nixos-rebuild switch --build-host localhost`

**"SOPS decryption failed"**
- Ensure your GPG key is available
- Check the SOPS configuration in `secrets.nix`

**"Service failed to start"**
- Check logs with `journalctl -u service-name`
- Verify configuration with `systemctl cat service-name`

**"Flake input not found"**
- Run `nix flake update` to update inputs
- Or check your network connection

### Debugging Tips

```bash
# Check system generation
nixos-rebuild dry-activate

# View system configuration
nix eval .#nixosConfigurations.nixos-lamp.config

# Check service status
systemctl status service-name

# View logs
journalctl -u service-name -f

# Test configuration
nixos-rebuild test
```

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

## Credits

- **NixOS**: The purely functional Linux distribution
- **SOPS**: Secrets management tool
- **Cloudflare**: Tunnel service for secure remote access
- **All the Nix community**: For their excellent documentation and support

## Contributing

Feel free to fork and adapt this configuration for your own use. Pull requests with improvements are welcome!

---

*Maintained by Ribhav (N00B-5634)*

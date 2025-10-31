# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

   networking.hostName = "nixos";

   networking.networkmanager.enable = true;


   time.timeZone = "America/New_York";



  # Enable the X11 windowing system.
   services.xserver.enable = true;
   services.displayManager.sddm.enable = true;
   services.displayManager.sddm.wayland.enable = true;
   services.desktopManager.plasma6.enable = true;

  


   services.printing.enable = true;


   services.pulseaudio.enable = false;

    services.pipewire.enable = true;
   services.pipewire.pulse.enable = true;

   services.libinput.enable = true;
     programs.zsh.enable = true;

   users.users.ribhav = {
     isNormalUser = true;
     extraGroups = [ "wheel" ];
     shell = pkgs.zsh;
     # Enable ‘sudo’ for the user.
     packages = with pkgs; [
       eza
       tree
       bat
       firefox
       bat
       alacritty
       fastfetch
       zulu8
       zulu24
       python314
       guacamole-server
       git
       htop
       nmap
       rsync
       zip
       unzip
       zsh
       starship
       gitAndTools.gh
       fd
       zsh-syntax-highlighting
       zsh-autosuggestions
     ];
   };

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
   environment.systemPackages = with pkgs; [
   nerd-fonts.jetbrains-mono
   flatpak
   ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;



    system.extraSystemBuilderCommands = ''
    # Use bash explicitly
    #! /usr/bin/env bash

    BACKUP_DIR="/home/ribhav/Ribhav-NixOS-configs"
    CONFIG_DIR="$BACKUP_DIR/config"

    # Create directories as 'ribhav'
    sudo -u ribhav mkdir -p "$CONFIG_DIR/alacritty"

    # Copy /etc/nixos/configuration.nix (requires root/system access)
    cp /etc/nixos/configuration.nix "$BACKUP_DIR/configuration.nix"

    # Change ownership of the copied file to 'ribhav'
    chown ribhav:users "$BACKUP_DIR/configuration.nix"

    # Copy user-owned config files as 'ribhav'
    sudo -u ribhav cp -r /home/ribhav/.config/alacritty/* "$CONFIG_DIR/alacritty"
    sudo -u ribhav cp /home/ribhav/.config/starship.toml "$CONFIG_DIR/"

    # Change to the backup directory and run Git commands as 'ribhav'
    # The entire inner command is now enclosed in single quotes.
    sudo -u ribhav bash -c '
      cd "$BACKUP_DIR" || exit
      git add .
      # Use single quotes for the commit message, escaping the internal double quotes is no longer needed.
      git commit -m "Automated system update: $(date)" || echo "No changes to commit."
      git push -u origin master || echo "Git push failed. Check network/credentials for ribhav."
    '
  '';
  system.stateVersion = "25.05";

}

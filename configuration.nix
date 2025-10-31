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
       discord
       music-assistant
     ];
   };

   nixpkgs.config.allowUnfree = true;
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
   services.openssh.enable = true;

   networking.firewall.allowedTCPPorts = [52 443 80 1980];
  networking.firewall.allowedUDPPorts = [1144];

   networking.firewall.enable = false;

   system.copySystemConfiguration = true;




  system.stateVersion = "25.05";

}

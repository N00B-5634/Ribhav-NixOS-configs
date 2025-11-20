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

   networking.hostName = "nixos-btw";

   networking.networkmanager.enable = true;
# nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
 packages = with pkgs; [
    eza
  tree
  bat
  firefox
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
  gnome-network-displays
  ripgrep
  fzf
  btop
  duf
  tldr
  neofetch
  gcc
  gnumake
  cmake
  pkg-config
  nodejs_22
  pnpm
  rustup
  go
  docker
  curl
  wget
  jq
  yq
  lf
  zoxide
  rsnapshot
  restic
  openssh
  wireguard-tools
  curlie
  iperf3
  vlc
  mpv
  flameshot
  neovim
  nodePackages_latest.nodejs
  virtualbox
     ];
   };

   nixpkgs.config.allowUnfree = true;
   environment.systemPackages = with pkgs; [
   nerd-fonts.jetbrains-mono
   flatpak
   handbrake
   libdvdcss   
];
   programs.nano.enable = true;
   services.openssh.enable = true;
        programs.zsh = {
  enableCompletion = true;
  autosuggestions.enable = true;
  syntaxHighlighting.enable = true;
};


   networking.firewall.allowedTCPPorts = [52 443 80 1980];
  networking.firewall.allowedUDPPorts = [1144];

   networking.firewall.enable = false;
       services.httpd.enable = true;




  system.stateVersion = "25.05";


virtualisation.virtualbox.host.enable = true;
users.extraGroups.vboxusers.members = [ "ribhav" ];
virtualisation.virtualbox.guest.enable = true;
virtualisation.virtualbox.guest.dragAndDrop = true;

}

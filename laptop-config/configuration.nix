# Edit this configuration file to define what should be installed on

# your system.


{ config, lib, pkgs, ... }:


{

  imports = [

    # Include the results of the hardware scan.

    ./hardware-configuration.nix

  ];


  # Boot loader setup

  boot.loader.systemd-boot.enable = true;

  boot.loader.efi.canTouchEfiVariables = true;


  networking.hostName = "nixos-btw-secured";

  networking.networkmanager.enable = true;


  time.timeZone = "America/New_York";


  # X11 and Plasma setup

  services.xserver.enable = true;

  services.displayManager.sddm.enable = false;

  services.displayManager.sddm.wayland.enable = false;

  services.desktopManager.plasma6.enable = false;

  services.xserver.displayManager.gdm.enable = true;

  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.displayManager.gdm.wayland = true;
  services.printing.enable = true;

  # Audio setup

  services.pulseaudio.enable = false;

  services.pipewire = {

    enable = true;

    pulse.enable = true;

  };
i18n.defaultLocale = "en_US.UTF-8";  # Set default locale
i18n.extraLocales = ["en_US.UTF-8/UTF-8"];  # Support additional locales if needed
# Input

  services.libinput.enable = true;


  # Zsh

  programs.zsh = {

    enable = true;

    enableCompletion = true;

    autosuggestions.enable = true;

    syntaxHighlighting.enable = true;

  };


  users.users.ribhav = {

    isNormalUser = true;

    extraGroups = [ "wheel" ];

    shell = pkgs.zsh;

    packages = with pkgs; [

      eza tree bat firefox alacritty fastfetch

      zulu8 zulu24 python314 guacamole-client git

      htop nmap rsync zip unzip zsh starship

      gitAndTools.gh fd zsh-syntax-highlighting zsh-autosuggestions

      discord music-assistant gnome-network-displays ripgrep fzf

      btop duf tldr neofetch gcc gnumake cmake

      pkg-config nodejs_22 pnpm rustup go docker

      curl wget jq yq lf zoxide rsnapshot

      restic openssh wireguard-tools curlie iperf3 vlc

      mpv flameshot gnome-tweaks gnome-shell-extensions neovim prismlauncher zoom-us

    ];

  };


  nixpkgs.config.allowUnfree = true;


  environment.systemPackages = with pkgs; [

    nerd-fonts.jetbrains-mono

    flatpak
    vanilla-dmz
  ];


  programs.nano.enable = false;

  programs.neovim.enable = true;

  services.openssh.enable = true;


  # Firewall setup

  networking.firewall.allowedTCPPorts = [ 52 443 80 1980 ];

  networking.firewall.allowedUDPPorts = [ 1144 ];

  networking.firewall.enable = false;


  system.copySystemConfiguration = true;

  system.stateVersion = "25.05";
}

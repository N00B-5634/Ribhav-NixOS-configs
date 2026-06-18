# Edit this configuration file to define what should be installed on

# your system.


{ config, lib, pkgs, inputs, ... }:


{

  imports = [

    # Include the results of the hardware scan.

    ./laptop-hardware.nix
	 
  ];

  # Boot loader setup

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    };
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-btw-secured";

  networking.networkmanager.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes" ];
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  };
  time.timeZone = "America/New_York";
  

  # X11 and Plasma setup

  services.xserver.enable = true;

  services.displayManager.sddm.enable = false;

  services.displayManager.sddm.wayland.enable = false;

  services.desktopManager.plasma6.enable = false;

  services.xserver.displayManager.gdm.enable = true;
   security.pam.services.login.googleAuthenticator.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.printing.enable = true;
  services.flatpak.enable = true;
  
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
     python314 guacamole-client git

      htop nmap rsync zip unzip zsh starship

      gh fd zsh-syntax-highlighting zsh-autosuggestions

      discord music-assistant gnome-network-displays ripgrep fzf

      btop duf tldr fastfetch gcc gnumake cmake

      pkg-config nodejs pnpm rustup go docker

      curl wget jq yq lf zoxide rsnapshot

      restic openssh wireguard-tools curlie iperf3 vlc

      mpv flameshot gnome-tweaks gnome-shell-extensions neovim prismlauncher zoom-us nss

    ];

  };


  nixpkgs.config.allowUnfree = true;


  environment.systemPackages = with pkgs; [

    nerd-fonts.jetbrains-mono
    flatpak
    vanilla-dmz
    google-authenticator
  ];

  programs.nano.enable = true;

  programs.neovim.enable = true;

  services.openssh.enable = true;


  # Firewall setup

  networking.firewall.allowedTCPPorts = [ 52 443 80 1980 ];

  networking.firewall.allowedUDPPorts = [ 1144 ];

  networking.firewall.enable = false;



  system.stateVersion = "25.05";
}

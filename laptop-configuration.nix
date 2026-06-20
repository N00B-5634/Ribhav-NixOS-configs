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

  # Isolated Purity Shield (Channels are dead)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix = {
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

  # Locales
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = [ "en_US.UTF-8/UTF-8" ];

  # Input
  services.libinput.enable = true;

  # System-wide Zsh setup (Keeps the shell binary working for the OS)
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  # System-wide User definition
  users.users.ribhav = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
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
  
  home-manager.users.ribhav = { pkgs, ... }: {
    home.stateVersion = "25.05"; 

    # Link your dotfiles securely via the Nix store
	    home.file = {
	  ".zshrc".source = ./.zshrc;
	};
         xdg.configFile = {
  "alacritty/alacritty.yml" = {
    source = ./alacritty.yml;
    force = true;
  };

  "starship.toml" = {
    source = ./starship.toml;
    force = true;
  };

  "nvim" = {
    source = ./nvim;
    recursive = true;
    force = true;
   };
 };
     home.packages = with pkgs; [
      eza tree bat firefox alacritty fastfetch
      python314 guacamole-client git
      htop nmap rsync zip unzip zsh starship
      gh fd zsh-syntax-highlighting zsh-autosuggestions
      discord music-assistant gnome-network-displays ripgrep fzf
      btop duf tldr gcc gnumake cmake
      pkg-config nodejs pnpm rustup go docker
      curl wget jq yq lf zoxide rsnapshot
      restic openssh wireguard-tools curlie iperf3 vlc
      mpv flameshot gnome-tweaks gnome-shell-extensions neovim prismlauncher zoom-us nss
    ];

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zsh = {
      enable = true; 
      shellAliases = {
        nix-switch = "git add -A && sudo nixos-rebuild switch --flake .#nixos-laptop";
        nix-clean = "sudo nix-env --delete-generations old && sudo nix-store --gc";
        ls = "eza --icons --color=auto";
        cat = "bat";
        find = "fd";
        dir = "tree";
      };
    };

    programs.git = {
      enable = true;
      userName = "Ribhav Revalli";
      userEmail = "ribsai@outlook.com";
      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        core.editor = "nvim";
      };
    };
  };
}

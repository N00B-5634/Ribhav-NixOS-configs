{ config, lib, pkgs, ... }:

let
  myPhp = pkgs.php83.withExtensions ({ all, enabled }: enabled ++ [
    all.mysqli
    all.gd
    all.zip
    all.curl
    all.mbstring
    all.xml
  ]);
in

{
  users.users.ribhav = {
    isNormalUser = true;
    extraGroups = [ "wheel" "wwwrun" "mysql" "disk" ];
    shell = pkgs.zsh;

    packages = with pkgs; [
      eza
      tree
      bat
      fd
      fzf
      btop
      duf
      tldr
      fastfetch
      gcc
      gnumake
      cmake
      pkg-config
      nodejs_24
      pnpm
      go
      curl
      wget
      zoxide
      rsnapshot
      restic
      openssh
      wireguard-tools
      curlie
      iperf3
      neovim
      starship
      git
      gh
      kalker
      prismlauncher
      vscode
      vlc
      mpv
      flameshot
      alacritty
      fastfetch
      zsh-syntax-highlighting
      zsh-autosuggestions
      firefox
      myPhp
      mariadb
    ];
  };


  programs.zsh.enable = true;

  services.postgresql.enable = true;

  environment.systemPackages = with pkgs; [
    openjdk
    filebrowser
    xinit
    xauth
    perl
    xorg.xorgserver
    adwaita-icon-theme
    openssl
    navidrome
  ];
}

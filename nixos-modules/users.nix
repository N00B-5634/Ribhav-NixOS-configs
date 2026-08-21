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
    extraGroups = [ "wheel" "wwwrun" "mysql" "disk" "docker" ];
    shell = pkgs.zsh;

    packages = with pkgs; [
      ente-auth
      tor-browser
      unzip
      ncdu
      eza
      tree
      bat
      fd
      duf
      fastfetch
      pkg-config
      nodejs_24
      curl
      wget
      rsnapshot
      openssh
      iperf3
      neovim
      starship
      git
      gh
      vlc
      fastfetch
      zsh-syntax-highlighting
      zsh-autosuggestions
      firefox
      myPhp
      mariadb
    ];
  };

  users.users.keycloak = {
  isSystemUser = true;
  group = "keycloak";
  description = "Keycloak service user";
 };

users.groups.keycloak = {};
  
programs.zsh.enable = true;

  services.postgresql.enable = true;
   environment.systemPackages = with pkgs; [
    filebrowser
    perl
    adwaita-icon-theme
    openssl
    navidrome
    wl-clipboard # Modern Wayland replacement for xclip
  ];

}

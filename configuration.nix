{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./nixos-modules/boot.nix
    ./nixos-modules/desktop.nix
    ./nixos-modules/extra.nix
    ./nixos-modules/php-env.nix
    ./nixos-modules/services.nix
    ./nixos-modules/users.nix
    ./nixos-modules/backup.nix
    ./nixos-modules/gatus.nix
  ];

  system.stateVersion = "25.05";
}

# /etc/nixos/iso-config.nix

{ config, pkgs, lib,  ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
     ./configuration.nix    
  ];
  isoImage.volumeID = "Ribhav-NixOS";
  isoImage.isoName = "he-runs-nixos-btw.iso";
users.users.root.password = "LinuxLipnusLive11";
services.logrotate.enable = lib.mkForce true;
}

{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "kvm.enable_virt_at_load=0" "nomodeset" ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.hostName = "nixos-lamp";
  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
}

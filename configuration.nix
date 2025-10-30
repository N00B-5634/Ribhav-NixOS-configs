
{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];
 
boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
   networking.hostName = "nixos";
   networking.networkmanager.enable = true;  
   
time.timeZone = "America/New_York";
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
     ];
   };
   environment.systemPackages = with pkgs; [
   nerd-fonts.jetbrains-mono
   flatpak
   ];
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
   services.openssh.enable = true;
  # system.copySystemConfiguration = true;
  system.stateVersion = "25.05"; # Did you read the comment?

}

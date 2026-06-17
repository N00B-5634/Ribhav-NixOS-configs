{ config, pkgs, ... }:

{
  services.displayManager.sddm.enable = false;
  services.desktopManager.plasma6.enable = false;

  services.pulseaudio.enable = false;
  services.pipewire.enable = true;

  services.printing.enable = true;



  services.xserver = {
    enable = true;

    desktopManager.xfce.enable = true;
    displayManager.lightdm.enable = true;
  };
}

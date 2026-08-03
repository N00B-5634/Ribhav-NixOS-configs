{ config, pkgs, ... }:

{
  services.displayManager.sddm.enable = false;
  services.desktopManager.plasma6.enable = false;

  services.pulseaudio.enable = false;
  services.pipewire.enable = true;

  services.printing.enable = true;

  # --- LXQt Wayland Setup ---
  services.xserver = {
    enable = true; # Required for NixOS to load the desktopManager module
    desktopManager.lxqt.enable = true;
  };

  # Expose the native LXQt Wayland session to the login manager
  services.displayManager.sessionPackages = [ pkgs.lxqt.lxqt-wayland-session ];

  # Use Ly: a lightweight, console-based desktop manager that handles Wayland perfectly
  services.displayManager.ly.enable = true;
}

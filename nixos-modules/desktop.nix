{ config, pkgs, ... }:

{
  services.displayManager.sddm.enable = false;
  services.desktopManager.plasma6.enable = false;

  services.pulseaudio.enable = false;
  services.pipewire.enable = true;

  services.printing.enable = true;

  # --- LXQt Wayland Setup ---
  # Enable LXQt desktop environment
  services.desktopManager.lxqt.enable = true;

  # Expose the native LXQt Wayland session to the login manager
  services.displayManager.sessionPackages = [ pkgs.lxqt.lxqt-wayland-session ];

  # Use Ly: a lightweight, console-based desktop manager that handles Wayland perfectly
  services.displayManager.ly.enable = true;

  # Explicitly disable the legacy X11 server completely
  services.xserver.enable = false;
}

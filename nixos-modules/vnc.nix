{ pkgs, ... }:

{
  # 1. Install necessary packages
  environment.systemPackages = with pkgs; [
    novnc
    tigervnc
  ];

  # 2. Open the noVNC web port in the firewall
  networking.firewall.allowedTCPPorts = [ 6080 ];

  # 3. Systemd service for the VNC Server (creates display :1 on port 5901)
  systemd.services.vncserver = {
    description = "Headless VNC Server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      # Change "yourusername" to your actual NixOS username
      User = "yourusername"; 
      # Starts a persistent VNC server session
      ExecStart = "${pkgs.tigervnc}/bin/vncserver :1 -geometry 1920x1080 -depth 24 -localhost yes -SecurityTypes None";
      ExecStop = "${pkgs.tigervnc}/bin/vncserver -kill :1";
      Type = "forking";
      Restart = "always";
    };
  };

  # 4. Systemd service for noVNC (bridges VNC port 5901 to Web port 6080)
  systemd.services.novnc = {
    description = "noVNC Web Proxy Service";
    after = [ "vncserver.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "yourusername"; # Change to your actual NixOS username
      ExecStart = "${pkgs.novnc}/bin/novnc_proxy --vnc localhost:5901 --listen 6080";
      Restart = "always";
    };
  };
}

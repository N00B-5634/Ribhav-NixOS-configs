{ config, pkgs, ... }:

{
  services.gatus = {
    enable = true;

    settings = {
      web = {
        port = 3005;
        address = "0.0.0.0";
      };

      # Custom styling block using Go template string formats
      ui = {
        title = "Purple Dragon STATUS";
        header = "Core Network Infrastructure";
        # Inject raw CSS properties directly onto the DOM hooks
        custom-css = ''
          #global {
            font-family: 'Inter', sans-serif;
            background-color: #0f141c !important;
            color: #e2e8f0;
          }
          .dashboard-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
          }
          .endpoint {
            border-radius: 12px !important;
            border: 1px solid #1e293b !important;
            background-color: #1a2333 !important;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.5);
          }
          .endpoint-header {
            font-weight: 700;
            letter-spacing: -0.025em;
          }
        '';
      };

      # Monitor your domain endpoints
      endpoints = [
        {
          name = "WordPress";
          url = "https://ftc25671.com";
          interval = "1m";
          conditions = [ 
            "[STATUS] == 200" 
            "[CERTIFICATE_EXPIRATION] > 48h" # Alerts if TLS cert is dying
          ];
        }
        {
          name = "MeshCentral";
          url = "https://management.ftc25671.com";
          interval = "30s";
          conditions = [ 
            "[STATUS] == 200"
            "[BODY].status == up" # Parse JSON payload response maps
          ];
        }
        {
                name = "Navidrone";
                url = "https://music.ftc25671.com";
                interval = "30s";
                conditions = [
                  " [STATUS] == 200"
                  "[BODY].status == up"
                ];
            }
      ];
    };
  };
}


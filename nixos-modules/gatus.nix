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
        custom-css = '' /* Global Background - Deep Purple */
    #global { 
      background-color: #2D142C !important; 
      color: #FEE7F0 !important; /* Very light pink text */
    }
    
    /* Dashboard Area - Lavender */
    .dashboard-container { 
      background-color: #E6E6FA !important; 
      border-radius: 12px;
      padding: 20px;
    }

    /* Endpoint Cards - Pink */
    .endpoint, .endpoint-group { 
      background-color: #FFB6C1 !important; 
      border: 2px solid #C71585 !important; /* Medium Violet Red/Magenta border */
      border-radius: 10px;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      margin-bottom: 15px;
    }

    /* Endpoint Headers - Magenta */
    .endpoint-header, .endpoint-group-header { 
      background-color: #FF00FF !important; 
      color: #FFFFFF !important; 
      border-top-left-radius: 8px;
      border-top-right-radius: 8px;
    }

    /* Endpoint Content Area - Lighter Pink */
    .endpoint-content, .endpoint-group-content { 
      background-color: #FFF0F5 !important; /* Lavender Blush */
      color: #4B0082 !important; /* Indigo/Dark Purple text for readability */
    }

    /* Status Badges - Yellow & Purple */
    .bg-success { 
      background-color: #FFD700 !important; /* Yellow for UP status instead of green */
      color: #2D142C !important; /* Dark purple text inside yellow badge */
    }
    .bg-danger {
      background-color: #8A2BE2 !important; /* Blue-Violet for DOWN status instead of red */
      color: #FFFFFF !important;
    }

    /* Announcements Container (if used) */
    .announcement-container {
      background-color: #DDA0DD !important; /* Plum */
      border: 2px dashed #FFD700 !important; /* Yellow border */
    }
    .announcement-header {
      background-color: #800080 !important; /* Purple */
      color: #FFFFFF !important;
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
          interval = "1m";
          conditions = [ 
            "[STATUS] == 200"
          ];
        }
        {
                name = "Navidrone";
                url = "https://music.ftc25671.com";
                interval = "1m";
                conditions = [
                  " [STATUS] == 200"
                ];
            }
      ];
    };
  };
}


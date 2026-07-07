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
        custom-css = '' /* ==================================================================
   Purple Dragon Status
   One consistent design language across both modes:
   - Deep purple (#2D142C) is the shared anchor color everywhere
   - Dark mode  = deep purple + black
   - Light mode = deep purple + lavender
   ================================================================== */

/* ---------- LIGHT MODE (default) ---------- */

#global {
  background-color: #EDEBF7 !important; /* lavender canvas */
  color: #2D142C !important;            /* deep purple text - high contrast on lavender */
}

.dashboard-container {
  background-color: #F7F5FC !important; /* barely-there lavender, one shade up from global */
  border-radius: 14px;
  padding: 24px;
  box-shadow: 0 8px 24px rgba(45, 20, 44, 0.08);
}

.endpoint, .endpoint-group {
  background-color: #FFFFFF !important;
  border: 1px solid #D9CFE8 !important;
  border-left: 4px solid #2D142C !important; /* anchor color as the accent stripe */
  border-radius: 10px;
  box-shadow: 0 2px 8px rgba(45, 20, 44, 0.08);
  margin-bottom: 16px;
  transition: box-shadow 0.2s ease;
}

.endpoint:hover, .endpoint-group:hover {
  box-shadow: 0 4px 14px rgba(45, 20, 44, 0.16);
}

.endpoint-header, .endpoint-group-header {
  background-color: #2D142C !important; /* deep purple header - same anchor as dark mode's bg */
  color: #F7F5FC !important;
  border-top-left-radius: 9px;
  border-top-right-radius: 9px;
  font-weight: 600;
}

.endpoint-content, .endpoint-group-content {
  background-color: #FFFFFF !important;
  color: #2D142C !important;
}

.bg-success {
  background-color: #1FAA6D !important;
  color: #FFFFFF !important;
}

.bg-danger {
  background-color: #A31558 !important; /* deep purple-pink, not pure magenta */
  color: #FFFFFF !important;
}

.announcement-container {
  background-color: #F7F5FC !important;
  border: 1px solid #2D142C !important;
  border-radius: 10px;
}

.announcement-header {
  background-color: #2D142C !important;
  color: #F7F5FC !important;
}


/* ==================================================================
   DARK MODE OVERRIDES
   Covers both mechanisms Gatus may use to signal dark mode:
   1) OS-level preference -> @media (prefers-color-scheme: dark)
   2) manual toggle -> html.dark / body.dark class
   If your instance's toggle isn't picked up by one, the other will catch it.
   ================================================================== */

@media (prefers-color-scheme: dark) {
  #global {
    background-color: #150A14 !important; /* near-black with a purple undertone, not pure #000 */
    color: #EAD9E6 !important;            /* soft lavender-white text, easy on the eyes */
  }

  .dashboard-container {
    background-color: #1E0F1D !important;
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.5);
  }

  .endpoint, .endpoint-group {
    background-color: #241220 !important;
    border: 1px solid #3D1F3B !important;
    border-left: 4px solid #C9A0CF !important; /* pale purple accent pops against black */
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.4);
  }

  .endpoint-header, .endpoint-group-header {
    background-color: #150A14 !important; /* same black-purple as global bg, not deep purple - keeps dark mode reading as "dark" */
    color: #EAD9E6 !important;
  }

  .endpoint-content, .endpoint-group-content {
    background-color: #241220 !important;
    color: #EAD9E6 !important;
  }

  .bg-success {
    background-color: #2ECC81 !important; /* slightly brighter green so it still reads clearly on black */
    color: #0D0D0D !important;
  }

  .bg-danger {
    background-color: #E24E8C !important; /* brighter pink-magenta, needs more punch against black than it does on lavender */
    color: #150A14 !important;
  }

  .announcement-container {
    background-color: #1E0F1D !important;
    border: 1px solid #C9A0CF !important;
  }

  .announcement-header {
    background-color: #150A14 !important;
    color: #EAD9E6 !important;
  }
}

/* Manual toggle fallback - only applies if Gatus adds a .dark class to <html> or <body> */
html.dark #global, body.dark #global {
  background-color: #150A14 !important;
  color: #EAD9E6 !important;
}
html.dark .dashboard-container, body.dark .dashboard-container {
  background-color: #1E0F1D !important;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.5);
}
html.dark .endpoint, body.dark .endpoint,
html.dark .endpoint-group, body.dark .endpoint-group {
  background-color: #241220 !important;
  border: 1px solid #3D1F3B !important;
  border-left: 4px solid #C9A0CF !important;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.4);
}
html.dark .endpoint-header, body.dark .endpoint-header,
html.dark .endpoint-group-header, body.dark .endpoint-group-header {
  background-color: #150A14 !important;
  color: #EAD9E6 !important;
}
html.dark .endpoint-content, body.dark .endpoint-content,
html.dark .endpoint-group-content, body.dark .endpoint-group-content {
  background-color: #241220 !important;
  color: #EAD9E6 !important;
}
html.dark .bg-success, body.dark .bg-success {
  background-color: #2ECC81 !important;
  color: #0D0D0D !important;
}
html.dark .bg-danger, body.dark .bg-danger {
  background-color: #E24E8C !important;
  color: #150A14 !important;
}
html.dark .announcement-container, body.dark .announcement-container {
  background-color: #1E0F1D !important;
  border: 1px solid #C9A0CF !important;
}
html.dark .announcement-header, body.dark .announcement-header {
  background-color: #150A14 !important;
  color: #EAD9E6 !important;
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


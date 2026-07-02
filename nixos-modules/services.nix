{ config, lib, pkgs, ... }:

let
  myPhp = pkgs.php83.withExtensions ({ all, enabled }: enabled ++ [
    all.mysqli
    all.gd
    all.zip
    all.curl
    all.mbstring
    all.xml
  ]);
in

{
  services.xrdp = {
    enable = true;
    defaultWindowManager =
      "${pkgs.xfce.xfce4-session}/bin/xfce4-session";
    openFirewall = true;
  };

  systemd.services.xrdp.environment = {
    XDG_CONFIG_DIRS = "/run/current-system/sw/etc/xdg";
    XDG_DATA_DIRS = "/run/current-system/sw/share";
    XORG_XRDP_DISPLAY_NUMBER = "10";
  };
  
  services.openssh = {
    enable = true;

    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = true;
    };
    
    # FIX: Allows Cloudflare's web-rendered terminal to pass the SSH handshake safely
    extraConfig = ''
      HostKeyAlgorithms +ssh-rsa,ecdsa-sha2-nistp256
      PubkeyAcceptedKeyTypes +ssh-rsa
    '';
  };
  networking.firewall.allowedTCPPorts = [
    22
    3389
    80
    3000
    4533
  ];
  boot.kernel.sysctl = {
    "net.core.rmem_max" = 25000000;
    "net.core.rmem_default" = 25000000;
    "net.core.wmem_max" = 25000000;
    "net.core.wmem_default" = 25000000;
    "net.ipv4.udp_mem" = "65536 131072 262144";
  };
 
  services.cloudflared = {
    enable = true;

    tunnels = {
      "f3d06baf-166d-49a0-b5e3-ff8726be809a" = {
        credentialsFile =
          "/var/lib/cloudflare-tunnels/cld-tun.json";

        ingress = {
          "ftc25671.com" = "http://localhost:80";
        };

        default = "http_status:404";
      };
    };
  };

  systemd.services."cloudflared-tunnel-f3d06baf-166d-49a0-b5e3-ff8726be809a" = {
    serviceConfig.ExecStart = [
      ""
      "${pkgs.cloudflared}/bin/cloudflared tunnel --protocol http2 run f3d06baf-166d-49a0-b5e3-ff8726be809a"
    ];
  };

  systemd.services."cloudflared-tunnel-9bcd38f4-74d9-4804-8c00-64e244ddd3ef" = {
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      EnvironmentFile = "/var/lib/cloudflare-tunnels/token";

      ExecStart =
        "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token \${CLOUDFLARE_TUNNEL_TOKEN}";

      Restart = "always";
      RestartSec = "5";
      DynamicUser = true;
    };
  };

  systemd.services."cloudflared-tunnel-" = {
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      EnvironmentFile =
        "/var/lib/cloudflare-tunnels/token_http";

      ExecStart =
        "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token \${CLOUDFLARE_TUNNEL_TOKEN_HTTP}";

      Restart = "always";
      RestartSec = "5";
      DynamicUser = true;
    };
  };

  systemd.services."cloudflared-tunnel-ec5549da-385e-48f6-b8fb-761a6310510f" = {
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      EnvironmentFile =
        "/var/lib/cloudflare-tunnels/token_video";

      ExecStart =
        "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token \${CLOUDFLARE_TUNNEL_TOKEN_VIDEO}";

      Restart = "always";
      RestartSec = "5";
      DynamicUser = true;
    };
  };

  systemd.services."cloudflared-tunnel-0657ba26-d5ab-4733-a384-ad0c57b94f20" = {
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      EnvironmentFile =
        "/var/lib/cloudflare-tunnels/token_music";

      ExecStart =
        "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token \${CLOUDFLARE_TUNNEL_TOKEN_MUSIC}";

      Restart = "always";
      RestartSec = "5";
      DynamicUser = true;
    };
  };


  systemd.services."cloudflared-tunnel-27a037b8-e0c3-4ea6-84b0-87e18e435c6d" = {
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      EnvironmentFile =
        "/var/lib/cloudflare-tunnels/token_sso";

      ExecStart =
        "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token \${CLOUDFLARE_TUNNEL_TOKEN_SSO}";

      Restart = "always";
      RestartSec = "5";
      DynamicUser = true;
    };
  };

  systemd.services."cloudflared-tunnel-ca273db4-0a13-4eec-bcc8-709506b1896f" = {
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      EnvironmentFile =
        "/var/lib/cloudflare-tunnels/token_management";

      ExecStart =
        "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token \${CLOUDFLARE_TUNNEL_TOKEN_MANAGEMENT}";

      Restart = "always";
      RestartSec = "5";
      DynamicUser = true;
    };
  };

  systemd.services."cloudflared-tunnel-9c0932e3-e955-4c09-a4ee-244ac18d207f" = {
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      EnvironmentFile =
        "/var/lib/cloudflare-tunnels/token_dashboard";

      ExecStart =
        "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token \${CLOUDFLARE_TUNNEL_TOKEN_DASHBOARD}";

      Restart = "always";
      RestartSec = "5";
      DynamicUser = true;
    };
  };

  systemd.services."cloudflared-tunnel-9e8a59ce-9ab0-47cf-b9c7-dcf461642bfd" = {
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      EnvironmentFile =
        "/var/lib/cloudflare-tunnels/token_status";

      ExecStart =
        "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token \${CLOUDFLARE_TUNNEL_TOKEN_STATUS}";

      Restart = "always";
      RestartSec = "5";
      DynamicUser = true;
    };
  };
    systemd.services."cloudflared-tunnel-56cc2632-d9d7-4808-8694-799b30a49f70" = {
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      EnvironmentFile =
        "/var/lib/cloudflare-tunnels/token_guac";

      ExecStart =
        "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token \${CLOUDFLARE_TUNNEL_TOKEN_GUAC}";

      Restart = "always";
      RestartSec = "5";
      DynamicUser = true;
    };
  };
    systemd.services."cloudflared-tunnel-7838f584-fcd5-443c-b4a3-cd514a5be261" = {
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      EnvironmentFile =
        "/var/lib/cloudflare-tunnels/token_SSH";

      ExecStart =
        "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token \${CLOUDFLARE_TUNNEL_TOKEN_SSH}";

      Restart = "always";
      RestartSec = "5";
      DynamicUser = true;
      PrivateNetwork = false;
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
    };
  };
    systemd.services."cloudflared-tunnel-b07a74dd-4929-4d31-a3e5-419208083858" = {
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      EnvironmentFile =
        "/var/lib/cloudflare-tunnels/token_rdp";

      ExecStart =
        "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token \${CLOUDFLARE_TUNNEL_TOKEN_RDP}";

      Restart = "always";
      RestartSec = "5";
      DynamicUser = true;
    };
  };
   systemd.services."cloudflared-tunnel-5070dedc-f39a-4ace-b84b-ec9524e2d3e3" = {
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      EnvironmentFile =
        "/var/lib/cloudflare-tunnels/token_wiki";

      ExecStart =
        "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token \${CLOUDFLARE_TUNNEL_TOKEN_WIKI}";

      Restart = "always";
      RestartSec = "5";
      DynamicUser = true;
    };
  };
  systemd.services.vitepress = {
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    path = [
      pkgs.nodejs
      pkgs.coreutils
      pkgs.bash
    ];
   
    serviceConfig = {
      WorkingDirectory = "/srv/http/ftc25671";

      ExecStart =
        "${pkgs.nodejs}/bin/npm run docs:dev -- --host";

      Restart = "always";

      User = "ribhav";
      Group = "users";
    };
  };

  systemd.services.filebrowser = {
    description = "Filebrowser Service";

    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart =
        "${pkgs.filebrowser}/bin/filebrowser -a 127.0.0.1 -p 8080 -d /var/lib/filebrowser/filebrowser.db";

      Restart = "always";

      User = "ribhav";
      Group = "users";
      ProtectSystem = "true";
      ProtectHome = "false";

      PrivateTmp = true;
      NoNewPrivileges = true;

      ProtectKernelTunables = true;
      ProtectControlGroups = true;

      RestrictRealtime = true;

      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
      ];
    };
  };
		systemd.services.force-fios-wifi = {
	  description = "Force Fios Wi-Fi Connection on Boot";
	  wantedBy = [ "multi-user.target" ];
	  
	  # Tell systemd to wait until the network is actually supposed to be online
	  wants = [ "network-online.target" ];
	  after = [ "network-online.target" "NetworkManager.service" ];
	  
	  path = [ pkgs.networkmanager ];
	  
	  script = ''
	    # Wait a few seconds for the Wi-Fi card hardware to stop sleeping on the job
	    sleep 5
	    
	    # Force connection if it isn't already active
	    nmcli connection up fios-auto || nmcli dev wifi connect "Fios-WZMBD" password "solved0494poem2279" ifname wlp0s20f3 name "fios-auto"
	    
	    # Lock down system-wide settings so it never asks for a user keyring login again
	    nmcli connection modify fios-auto connection.autoconnect yes
	    nmcli connection modify fios-auto connection.autoconnect-priority 100
	    nmcli connection modify fios-auto connection.permissions ""
	    nmcli connection modify fios-auto 802-11-wireless-security.psk-flags 0
	  '';

	  serviceConfig = {
	    Type = "oneshot";
	    RemainAfterExit = true;
	  };
	};
	    services.keycloak = {
	    enable = true;

	    database = {
	      createLocally = false;
	      type = "postgresql";
	      passwordFile = "/etc/keycloak-db-pass";
	    };

	    settings = {
	      hostname-strict = false;
	      http-enabled = true;
	      http-port = 8089;
	      proxy-headers = "xforwarded";  # FIXED: Added the required missing hyphen
	    };
	  };
  services.keycloak.themes.PurpleDragonFTC =
  pkgs.linkFarm "PurpleDragonFTC" [
    {
      name = "login";
      path = ./keycloak-theme/login;
    }
  ];

    services.meshcentral = {
    enable = true;

    settings = {
      settings = {
        cert = "management.ftc25671.com";
        port = 8082;
        redirPort = 0;
        
        # FIXES: Change text string to proper boolean true for NixOS deployment
        tlsOffload = true; 
        
        # FIXES: Extend trust to Caddy local proxies alongside edge networks
        trustedProxy = true;
        
        allowNewAccounts = false;
        allowSelfAccountUpdate = false;
        ignoreSessionIP = true;
        allowedOrigin = true;
      };

      domains."".settings = {
        certUrl = "https://management.ftc25671.com";
        newAccounts = false;
        allowedOrigin = true;
      };

      users = {
        "ribhav" = {
          email = "ribsai@outlook.com";
          admin = true;
        };
      };
    };
  };

 services.mediawiki = {
    enable = true;
    name = "Purple Dragon FTC Wiki";

    passwordFile = "/etc/mediawiki/admin-password";

    database = {
      type = "mysql";
      host = "localhost";
      name = "mediawiki";
      user = "mediawiki";
      tablePrefix = "mw_";
      socket = "/run/mysqld/mysqld.sock";
    };

    httpd.virtualHost = {
      hostName = "wiki.ftc25671.com";

      serverAliases = [
        "www.wiki.ftc25671.com"
        "127.0.0.1"
      ];

      adminAddr = "ribsai@outlook.com";

      enableACME = false;
      forceSSL = false;
    };

    phpPackage = pkgs.php83.buildEnv {
      extensions = { all, enabled }: enabled ++ (with all; [ apcu ]);

      extraConfig = ''
        upload_max_filesize = 128M
        post_max_size = 128M
        memory_limit = 512M
        max_execution_time = 60
        date.timezone = UTC
      '';
    };

    extensions = {
      ParserFunctions = null;
      VisualEditor = null;
      TemplateStyles = null;
      WikiEditor = null;
      Cite = null;
      ImageMap = null;
      ConfirmEdit = null;
      Scribunto = null;
      Nuke = null;
    };

    extraConfig = ''
      $wgLanguageCode = "en";
      $wgJobRunRate = 1;
      $wgRunJobsAsync = false;
      $wgRateLimits['edit']['user'] = [ 100000000, 600000 ];
      $wgDefaultSkin = "vector-2022";
      $wgEnableUploads = true;
      $wgUseImageMagick = true;
      $wgImageMagickConvertCommand = "${pkgs.imagemagick}/bin/convert";

      # Explicitly output full error logs directly to the screen if any other bugs pop up
      $wgShowExceptionDetails = true;
      $wgShowDBErrorBacktrace = true;
      # Configure the native standalone engine mapping cleanly using the actual file class
      $wgScribuntoDefaultEngine = 'luastandalone';
      global $IP;
      $wgScribuntoEngineConf['luastandard']['class'] = 'MediaWiki\\Extension\\Scribunto\\Engines\\LuaStandalone\\LuaStandaloneEngine';
      $wgScribuntoEngineConf['luastandard']['luaPath'] = "$IP/extensions/Scribunto/includes/Engines/LuaStandalone/binaries/lua5_1_5_linux_64_generic/lua";
      wfLoadExtension( 'Cite' );
      wfLoadExtension( 'ParserFunctions' );
      wfLoadExtension( 'TemplateStyles' );
      wfLoadExtension( 'Nuke' );
      wfLoadExtension( 'Scribunto' );

      $wgLogos = [
        '1x' => 'https://wiki.ftc25671.com/images/thumb/a/a0/Logo.webp/450px-Logo.webp.png',
        'icon' => 'https://wiki.ftc25671.com/images/thumb/a/a0/Logo.webp/450px-Logo.webp.png'
      ];

      $wgVector2022LogoDimensions = [
        'width' => 160,
        'height' => 160
      ];

      $wgDefaultUserOptions['vector-theme'] = 'dark';
      $wgGroupPermissions['*']['edit'] = false;
      $wgGroupPermissions['*']['createaccount'] = true;
      $wgGroupPermissions['*']['autocreateaccount'] = true;

      $wgGroupPermissions['user']['move'] = false;
      $wgGroupPermissions['user']['move-subpages'] = false;
      $wgGroupPermissions['user']['upload'] = false;

      $wgGroupPermissions['autoconfirmed']['move'] = true;
      $wgGroupPermissions['autoconfirmed']['move-subpages'] = true;
      $wgGroupPermissions['autoconfirmed']['upload'] = true;

      $wgAutoConfirmAge = 3600 * 24 * 4;
      $wgAutoConfirmCount = 10;

      # ConfirmEdit/QuestyCaptcha setup
      wfLoadExtension( 'ConfirmEdit' );
      wfLoadExtension( 'ConfirmEdit/QuestyCaptcha' );
      $wgCaptchaClass = 'QuestyCaptcha';
      $wgCaptchaQuestions[] = [
        'question' => 'What year did we incorporate?',
        'answer' => '2024'
      ];
      $wgCaptchaQuestions[] = [
        'question' => 'What program of FIRST do we partake in? (Must be spelled out)',
        'answer' => 'First Tech Challenge'
      ];

      $wgCaptchaTriggers['edit']          = true;
      $wgCaptchaTriggers['create']        = true;
      $wgCaptchaTriggers['addurl']        = true;
      $wgCaptchaTriggers['createaccount'] = true;
      $wgCaptchaTriggers['badlogin']       = true;

      $wgPasswordAttemptThrottle = [
        [
          'count' => 5,
          'seconds' => 300
        ]
      ];

      # Load the base Parsedown library dependency safely
      if ( file_exists( "${pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/erusev/parsedown/master/Parsedown.php";
        hash = "sha256-NAdabxdoQdu5HKaiasdFW1u1duNoz624JJ7bedZ7GgY=";
      }}" ) ) {
          require_once "${pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/erusev/parsedown/master/Parsedown.php";
            hash = "sha256-NAdabxdoQdu5HKaiasdFW1u1duNoz624JJ7bedZ7GgY=";
          }}";
      }

      # Load ParsedownExtra safely
      if ( file_exists( "${pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/erusev/parsedown-extra/master/ParsedownExtra.php";
        hash = "sha256-R9WQ5gQz8nXrlRw3pANLeBTTbuIyRdOPC/Y1RGbcTlg=";
      }}" ) ) {
          require_once "${pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/erusev/parsedown-extra/master/ParsedownExtra.php";
            hash = "sha256-R9WQ5gQz8nXrlRw3pANLeBTTbuIyRdOPC/Y1RGbcTlg=";
          }}";
      }

      # Safe Hook Registration for PHP 8.3 runtimes
      $wgHooks['ParserFirstCallInit'][] = function ( $parser ) {
          $parser->setHook( 'markdown', function ( $text, $args, $parser, $frame ) {
              if ( class_exists( 'ParsedownExtra' ) ) {
                  $extra = new ParsedownExtra();
                  return [ $extra->text( $text ), 'markerType' => 'nowiki' ];
              }
              return htmlspecialchars( $text );
          } );
      };

      $wgMainCacheType = CACHE_ACCEL;
      $wgSessionCacheType = CACHE_ACCEL;
      
      $wgVisualEditorAvailableNamespaces = [
        NS_MAIN => true,
        NS_USER => true,
        NS_HELP => true,
        NS_PROJECT => true,
      ];

      $wgHooks['BeforePageDisplay'][] = function ( OutputPage &$out, Skin &$skin ) {
        $out->addHeadItem( 'onion-location', '<meta http-equiv="Onion-Location" content="http://ftc25woc5kjvm3llabonsinjnsrch44x7huzd3kkm4upb33qqapbwzid.onion" />' );
        return true;
      };

      if ( isset( $_SERVER['HTTP_HOST'] ) && strpos( $_SERVER['HTTP_HOST'], 'ftc25woc5kjvm3llabonsinjnsrch44x7huzd3kkm4upb33qqapbwzid.onion' ) !== false ) {
          $wgServer = "http://ftc25woc5kjvm3llabonsinjnsrch44x7huzd3kkm4upb33qqapbwzid.onion";
      } else {
          $wgServer = "https://wiki.ftc25671.com";
      }
    '';
  };
  systemd.services.meshagent = {
    description = "MeshCentral Agent";

    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "/home/ribhav/meshagent";
      WorkingDirectory = "/home/ribhav";
      Restart = "always";
      RestartSec = 5;
      User = "root";
     };
 };
		    systemd.services.swingmusic = {
		    description = "Swing Music";

		    after = [ "network.target" ];
		    wantedBy = [ "multi-user.target" ];

		    serviceConfig = {
		      ExecStart = "${pkgs.navidrome}/bin/navidrome";
		      WorkingDirectory = "/home/ribhav/Music";
		      Restart = "always";
		      RestartSec = 5;
		      User = "ribhav";
		    };
		 };


 systemd.services.status-page = {
  wantedBy = [ "multi-user.target" ];
  after = [ "network.target" ];

  serviceConfig = {
    ExecStart = "${pkgs.python3}/bin/python3 -m http.server 3001 --directory /var/www/status";
    Restart = "always";
   };
 }; 
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;

    ensureDatabases = [
      "wordpress"
      "wp_ftc"
      "wp_local"
    ];

    ensureUsers = [
      {
        name = "ribhav";

        ensurePermissions = {
          "wordpress.*" = "ALL PRIVILEGES";
          "wp_ftc.*" = "ALL PRIVILEGES";
          "wp_local.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };
  services.phpfpm.pools.wordpress = {
    user = "ribhav";
    group = "wwwrun";

    phpPackage = myPhp;

    settings = {
      "listen.owner" = "wwwrun";
      "listen.group" = "wwwrun";
      "listen.mode" = "0660";
      "pm" = "dynamic";
      "pm.max_children" = 5;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 3;
    };

    phpOptions = ''
      upload_max_filesize = 64M
      post_max_size = 64M
      disable_functions = ""
    '';

    phpEnv = {
      PATH =
        "/run/current-system/sw/bin:/usr/bin:/bin";
    };
  };
			services.httpd = {
	  enable = true;
	  adminAddr = "ribsai@outlook.com";
	  mpm = "event";

	  extraModules = [
	    "proxy"
	    "proxy_http"
	    "proxy_wstunnel"
	    "ssl"
	    "headers"
	    "rewrite"
	    "remoteip"
	    "proxy_fcgi"
	  ];

	  virtualHosts = {
	    "ftc25671.com" = {
	      hostName = "ftc25671.com";
	      listen = [ { port = 80; } ];
	      serverAliases = [ "ftc25dgxyd6xxmo7mzhjjhuvpvfvrjntfxxsoczawuyrwri4evm5tgad.onion" "ftc25671.com" "192.168.1.210/" ];
	      documentRoot = "/srv/http/wordpress";

	      extraConfig = ''
		Protocols http/1.1
		KeepAlive Off

		<Directory "/srv/http/wordpress">
		  AllowOverride All
		  Require all granted
		  DirectoryIndex index.php index.html
		</Directory>

		<FilesMatch "^(wp-config\.php|xmlrpc\.php|composer\.(json|lock)|readme\.html|license\.txt|\.htaccess|\.git)">
		  Require all denied
		</FilesMatch>

		<Directory "/srv/http/wordpress/wp-content/uploads">
		  <FilesMatch "\.php$">
		    Require all denied
		  </FilesMatch>
		</Directory>

		Alias /errors /srv/http/errors
		<Directory "/srv/http/errors">
		  AllowOverride None
		  Require all granted
		</Directory>

		ErrorDocument 403 /errors/403.html
		ErrorDocument 404 /errors/404.html

		RemoteIPHeader X-Forwarded-For
		SetEnvIf X-Forwarded-Proto "^https$" HTTPS=on

		Header always unset X-Frame-Options
		Header always set Content-Security-Policy "frame-ancestors 'self' ftc25671.com"

		<FilesMatch "\.php$">
		  SetHandler "proxy:unix:/run/phpfpm/wordpress.sock|fcgi://localhost"
		</FilesMatch>

		SSLProxyEngine On
		SSLProxyVerify none
		SSLProxyCheckPeerName off
		ProxyPreserveHost On

		ProxyPass "/haiku-api/" "https://depot.haiku-os.org/"
		ProxyPassReverse "/haiku-api/" "https://depot.haiku-os.org/"
	      '';
	    };

	    "wiki.ftc25671.com" = {
	      hostName = "wiki.ftc25671.com";
	      listen = [ { port = 8086; } ];
	      serverAliases = [ "www.wiki.ftc25671.com" "127.0.0.1" ];
	      adminAddr = "ribsai@outlook.com";
	      enableACME = false;
	      forceSSL = false;
	      documentRoot = "/srv/http/wiki";

	      extraConfig = ''
		<Directory "/srv/http/wiki">
		  AllowOverride None
		  Require all granted
		  DirectoryIndex index.php index.html
		</Directory>

		<FilesMatch "^(LocalSettings\.php|AdminSettings\.php|composer\.(json|lock)|\.htaccess|\.git)">
		  Require all denied
		</FilesMatch>

		<DirectoryMatch "^/srv/http/wiki/(images|cache)">
		  <FilesMatch "\.php$">
		    Require all denied
		  </FilesMatch>
		</DirectoryMatch>

		Alias /errors /srv/http/errors
		<Directory "/srv/http/errors">
		  AllowOverride None
		  Require all granted
		</Directory>

		ErrorDocument 403 /errors/403.html
		ErrorDocument 404 /errors/404.html
	      '';
	    };

	    # 1. KEYCLOAK
	    "sso.ftc25671.com" = {
	      hostName = "sso.ftc25671.com";
	      extraConfig = ''
               Header unset X-Frame-Options
		Header set X-Frame-Options "ALLOW-FROM http://localhost:5174"
		Header unset Content-Security-Policy
		Header set Content-Security-Policy "frame-ancestors 'self'"
		Header set Onion-Location "http://qq77i5bjsqsokgr7caxrgmqvdf6vnzslvrvh5cqchslg53mdzzc6v7qd.onion"
		ProxyPreserveHost On
		ProxyPass / http://127.0.0.1:8089/
		ProxyPassReverse / http://127.0.0.1:8089/
		RequestHeader set X-Forwarded-Port "443"
		RequestHeader set X-Forwarded-Proto "https"
	      '';
	    };

	    # 2.5. STATUS (NEW - SAME BACKEND, DIFFERENT ENTRYPOINT)
	    "status.ftc25671.com" = {
	      hostName = "status.ftc25671.com";
	      extraConfig = ''
		Header set Onion-Location "http://ftc25nkblwq5h36xf4hnmvl2hmiup66iapv5sb5euprvtcqwhivoe3qd.onion"
		ProxyPreserveHost On
		ProxyPass / http://127.0.0.1:3001/
		ProxyPassReverse / http://127.0.0.1:3001/
		RequestHeader set X-Forwarded-Port "443"
		RequestHeader set X-Forwarded-Proto "https"
	      '';
	    };

	    # 3. NEXTERM / GUACAMOLE
	    "guacamole.ftc25671.com" = {
	      hostName = "guacamole.ftc25671.com";
	      extraConfig = ''
		Header set Onion-Location "http://qq77i5bjsqsokgr7caxrgmqvdf6vnzslvrvh5cqchslg53mdzzc6v7qd.onion"
		ProxyPreserveHost On
		ProxyPass / http://127.0.0.1:9090/
		ProxyPassReverse / http://127.0.0.1:9090/
		RequestHeader set X-Forwarded-Port "443"
		RequestHeader set X-Forwarded-Proto "https"
	      '';
	    };

	    # 4. MUSIC
	    "music.ftc25671.com" = {
	      hostName = "music.ftc25671.com";
	      extraConfig = ''
		Header set Onion-Location "http://ftcmapicjbb2pmpyazralaoxwl2dkolk424mwtyhgdexxkuvncawload.onion"
		ProxyPreserveHost On
		ProxyPass / http://127.0.0.1:4533/
		ProxyPassReverse / http://127.0.0.1:4533/
		RequestHeader set X-Forwarded-Port "443"
		RequestHeader set X-Forwarded-Proto "https"
	      '';
	    };

	    # 5. MESHCENTRAL
	    "management.ftc25671.com" = {
	      hostName = "management.ftc25671.com";
	      extraConfig = ''
		Header set Onion-Location "http://ftc25xqy2n3axu5gcu6egnw6j5zilylalgubbrllyf5mc44dsathyhyd.onion"

		RewriteEngine On
		RewriteCond %{HTTP:Upgrade} =websocket [NC]
		RewriteRule /(.*) ws://127.0.0.1:8082/$1 [P,L]

		ProxyPreserveHost On
	ProxyPass / http://127.0.0.1:8082/
		ProxyPassReverse / http://127.0.0.1:8082/
		RequestHeader set X-Forwarded-Port "443"
		RequestHeader set X-Forwarded-Proto "https"
	      '';
	    };
		    # 6. Filebrowser
		    "files.ftc25671.com" = {
		      hostName = "files.ftc25671.com";
                      serverAliases = [ "ftc25b7ejteyhn4pbnquterwubyixll7oih4czs6b47xhoypy23ewxid.onion"];
		      extraConfig = ''
			Header set Onion-Location "http://ftc25b7ejteyhn4pbnquterwubyixll7oih4czs6b47xhoypy23ewxid.onion" 
			ProxyPreserveHost On
                        ProxyPass / http://127.0.0.1:8080/
			ProxyPassReverse / http://127.0.0.1:8080/
			RequestHeader set X-Forwarded-Port "443"
			RequestHeader set X-Forwarded-Proto "https"
		      '';
		    };

	    # 7. NEXTCLOUD
	  };
	};


		environment.etc."/srv/http/errors/403.html".text = ''
	  <!DOCTYPE html>
	  <html lang="en">
	  <head>
	      <meta charset="UTF-8">
	      <meta name="viewport" content="width=device-width, initial-scale=1.0">
	      <title>403 Forbidden</title>
	      <style>
		  body {
		      font-family: system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, sans-serif;
		      margin: 0;
		      background: #fff;
		      color: #111;
		      display: flex;
		      align-items: center;
		      justify-content: center;
		      height: 100vh;
		  }
		  .card {
		      max-width: 720px;
		      padding: 32px;
		      border-radius: 12px;
		      box-shadow: 0 6px 24px rgba(0,0,0,0.08);
		      text-align: center;
		  }
		  h1 {
		      margin: 0 0 8px;
		      font-size: 28px;
		  }
		  p {
		      margin: 0 0 16px;
		      color: #444;
		  }
		  a {
		      color: #1a73e8;
		      text-decoration: none;
		  }
		  a:hover {
		      text-decoration: underline;
		  }
	      </style>
	  </head>
	  <body>
	      <div class="card">
		  <h1>403 — Forbidden</h1>
		  <p>You don't have permission to access this resource.</p>
		  <a href="/">Return to homepage</a>
	      </div>
	  </body>
	  </html>
	'';

	environment.etc."/srv/http/errors/404.html".text = ''
	  <!DOCTYPE html>
	  <html lang="en">
	  <head>
	      <meta charset="UTF-8">
	      <meta name="viewport" content="width=device-width, initial-scale=1.0">
	      <title>404 Not Found</title>
	      <style>
		  body {
		      font-family: system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, sans-serif;
		      margin: 0;
		      background: #fff;
		      color: #111;
		      display: flex;
		      align-items: center;
		      justify-content: center;
		      height: 100vh;
		  }
		  .card {
		      max-width: 720px;
		      padding: 32px;
		      border-radius: 12px;
		      box-shadow: 0 6px 24px rgba(0,0,0,0.08);
		      text-align: center;
		  }
		  h1 {
		      margin: 0 0 8px;
		      font-size: 28px;
		  }
		  p {
		      margin: 0 0 16px;
		      color: #444;
		  }
		  a {
		      color: #1a73e8;
		      text-decoration: none;
		  }
		  a:hover {
		      text-decoration: underline;
		  }
	      </style>
	  </head>
	  <body>
	      <div class="card">
		  <h1>404 — Not Found</h1>
		  <p>The requested resource was not found on this server.</p>
		  <a href="/">Return to homepage</a>
	      </div>
	  </body>
	  </html>
	'';
           
  services.samba = {
    enable = true;
    openFirewall = true;

    settings = {
      global = {
        "server min protocol" = "SMB2";
        "vfs objects" = "fruit streams_xattr";
        "security" = "user";
        "workgroup" = "WORKGROUP";
        "server string" = "smbnixos";
        "netbios name" = "smbnixos";
      };

      "ftc25671" = {
        "path" = "/home/ribhav/Music";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "admin users" = "ribhav";
        "create mask" = "0664";
        "directory mask" = "1775";
        "force directory mode" = "1775";
      };
    };
  };
}

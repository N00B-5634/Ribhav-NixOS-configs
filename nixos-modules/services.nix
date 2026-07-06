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
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    # 2. Refuse to route malicious redirect packets (Mitigates Man-in-the-Middle)
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
    # 3. Prevent your server from acting as a gateway/router for outsiders
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    # 4. Ignore bogus ICMP errors to keep your log files clean and uncluttered
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    # 5. Shield the system layout from user-space privilege escalations
    "kernel.kptr_restrict" = 2;
  };
 
  services.cloudflared = {
    enable = true;
   };
	systemd.services."cloudflared-tunnel-f3d06baf-166d-49a0-b5e3-ff8726be809a" = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      EnvironmentFile = config.sops.templates."cloudflare-tunnels.env".path;
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token \${CLOUDFLARE_TUNNEL_TOKEN_WORDPRESS}";
      Restart = "always";
      RestartSec = "5";
      DynamicUser = true;
    };
  };

  systemd.services."cloudflared-tunnel-9bcd38f4-74d9-4804-8c00-64e244ddd3ef" = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      EnvironmentFile = config.sops.templates."cloudflare-tunnels.env".path;
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token \${CLOUDFLARE_TUNNEL_TOKEN_DEFAULT}";
      Restart = "always";
      RestartSec = "5";
      DynamicUser = true;
    };
  };

  systemd.services."cloudflared-tunnel-" = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      EnvironmentFile = config.sops.templates."cloudflare-tunnels.env".path;
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token \${CLOUDFLARE_TUNNEL_TOKEN_HTTP}";
      Restart = "always";
      RestartSec = "5";
      DynamicUser = true;
    };
  };

  systemd.services."cloudflared-tunnel-0657ba26-d5ab-4733-a384-ad0c57b94f20" = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      EnvironmentFile = config.sops.templates."cloudflare-tunnels.env".path;
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token \${CLOUDFLARE_TUNNEL_TOKEN_MUSIC}";
      Restart = "always";
      RestartSec = "5";
      DynamicUser = true;
    };
  };

  systemd.services."cloudflared-tunnel-27a037b8-e0c3-4ea6-84b0-87e18e435c6d" = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      EnvironmentFile = config.sops.templates."cloudflare-tunnels.env".path;
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token \${CLOUDFLARE_TUNNEL_TOKEN_SSO}";
      Restart = "always";
      RestartSec = "5";
      DynamicUser = true;
    };
  };

  systemd.services."cloudflared-tunnel-ca273db4-0a13-4eec-bcc8-709506b1896f" = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      EnvironmentFile = config.sops.templates."cloudflare-tunnels.env".path;
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token \${CLOUDFLARE_TUNNEL_TOKEN_MANAGEMENT}";
      Restart = "always";
      RestartSec = "5";
      DynamicUser = true;
    };
  };

  systemd.services."cloudflared-tunnel-9e8a59ce-9ab0-47cf-b9c7-dcf461642bfd" = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      EnvironmentFile = config.sops.templates."cloudflare-tunnels.env".path;
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token \${CLOUDFLARE_TUNNEL_TOKEN_STATUS}";
      Restart = "always";
      RestartSec = "5";
      DynamicUser = true;
    };
  };

  systemd.services."cloudflared-tunnel-7838f584-fcd5-443c-b4a3-cd514a5be261" = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      EnvironmentFile = config.sops.templates."cloudflare-tunnels.env".path;
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token \${CLOUDFLARE_TUNNEL_TOKEN_SSH}";
      Restart = "always";
      RestartSec = "5";
      DynamicUser = true;
      PrivateNetwork = false;
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
    };
  };

  systemd.services."cloudflared-tunnel-b07a74dd-4929-4d31-a3e5-419208083858" = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      EnvironmentFile = config.sops.templates."cloudflare-tunnels.env".path;
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token \${CLOUDFLARE_TUNNEL_TOKEN_RDP}";
      Restart = "always";
      RestartSec = "5";
      DynamicUser = true;
    };
  };

  systemd.services."cloudflared-tunnel-5070dedc-f39a-4ace-b84b-ec9524e2d3e3" = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      EnvironmentFile = config.sops.templates."cloudflare-tunnels.env".path;
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token \${CLOUDFLARE_TUNNEL_TOKEN_WIKI}";
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
	    services.keycloak = {
	    enable = true;

	    database = {
	      createLocally = false;
	      type = "postgresql";
	      passwordFile = config.sops.secrets.keycloak_db_password.path;
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
    passwordFile = config.sops.secrets.mediawiki_admin_password.path;

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
         # Upload limits
      upload_max_filesize = 128M
      post_max_size = 128M

      # Memory and execution limits
      memory_limit = 512M
      max_execution_time = 60

      # Timezone and charset
      date.timezone = UTC
      default_charset = "UTF-8"

      # Block dangerous functions
      disable_functions = exec,system,shell_exec,passthru,popen,proc_open,show_source

      # Don't expose PHP version
      expose_php = Off

      # Session cookie hardening (safe, doesn't break MW)
      session.cookie_httponly = 1
      session.cookie_secure = 1
      session.use_only_cookies = 1

      # Session GC tuning
      session.gc_divisor = 1000

      # OPcache (performance)
      opcache.enable = 1
      opcache.enable_cli = 1
      opcache.file_cache = "/var/cache/php-opcache"

      # Disallow remote includes (LFI protection), but keep URL fopen for extensions
      allow_url_include = Off
      # allow_url_fopen = Off   # ← DO NOT enable this; it breaks remote-fetching extensions
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

# Security: Log errors but don't expose them to users in production
# (You can keep these true on dev, but for general hardening, consider false in prod)
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

# Security: restrict permissions more tightly
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

# Security: rate limiting for sensitive actions
# (You already have edit rate limits; add more)
$wgRateLimits['login']['user'] = [ 5, 300 ];         # 5 logins per 5 minutes
$wgRateLimits['emailuser']['user'] = [ 5, 60 * 60 ]; # 5 emails per hour

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

# Security: password attempt throttle (you already have this)
$wgPasswordAttemptThrottle = [
  [ 'count' => 5, 'seconds' => 300 ]
];

# Security: disable email features if not needed (optional, but safer)
# If you do need email, keep these enabled; if not, set to false:
$wgEnableEmail = false;
$wgEnableUserEmail = false;
$wgEmailAuthentication = false;

# Security: disable or restrict API write operations if not needed
# Leave $wgEnableAPI = true (needed for many features), but restrict write API:
$wgEnableWriteAPI = false;

# Security: disable feeds and other unnecessary features
$wgFeed = false;
$wgUseAjax = false;
$wgUseTrackbacks = false;

# Security: restrict file types and sizes
# (You already have large limits; these are additional filters)
$wgTrustedMediaTypes = [
  'image/png',
  'image/jpeg',
  'image/gif',
  'image/webp',
  'application/pdf',
];

# Limit upload size per file (in bytes); 128M = 134217728
$wgMaxUploadSize = 134217728;

# Security: prevent certain dangerous file extensions
$wgFileExtensions = [
  'png',
  'gif',
  'jpg',
  'jpeg',
  'webp',
  'pdf',
  'txt',
  'md',
];

# Security: disallow risky HTML in uploaded files
$wgRawHtmlExtensions = [];

# Security: enforce HTTPS for session cookies and uploads if possible
# (Your Apache already does this; this is extra MW-level)
$wgForceHTTPS = true;

# Security: disable anonymous talking if you don't want it
$wgDisableAnonTalk = true;

# Security: require https for special pages like login
$wgLoginCookieEncryption = true;

# Cache config (you already have this)
$wgMainCacheType = CACHE_ACCEL;
$wgSessionCacheType = CACHE_ACCEL;

$wgVisualEditorAvailableNamespaces = [
  NS_MAIN => true,
  NS_USER => true,
  NS_HELP => true,
  NS_PROJECT => true,
];

$wgHooks['BeforePageDisplay'][] = function ( OutputPage &$out, Skin &$skin ) {
  $out->addHeadItem( 'onion-location',
    '<meta http-equiv="Onion-Location" content="http://ftc25woc5kjvm3llabonsinjnsrch44x7huzd3kkm4upb33qqapbwzid.onion" />'
  );
  return true;
};

if ( isset( $_SERVER['HTTP_HOST'] ) &&
     strpos( $_SERVER['HTTP_HOST'], 'ftc25woc5kjvm3llabonsinjnsrch44x7huzd3kkm4upb33qqapbwzid.onion' ) !== false
) {
  $wgServer = "http://ftc25woc5kjvm3llabonsinjnsrch44x7huzd3kkm4upb33qqapbwzid.onion";
} else {
  $wgServer = "https://wiki.ftc25671.com";
}

# Markdown hook (your existing code, kept)
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
    '';
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

	    # Block obvious shell/command execution
	    disable_functions = exec,system,shell_exec,passthru,popen,proc_open,show_source

	    # Don't expose PHP version in headers
	    expose_php = Off

	    # Standard charset
	    default_charset = "UTF-8"

	    # Session cookie hardening (no JS access, HTTPS only, cookie-only sessions)
	    session.cookie_httponly = 1
	    session.cookie_secure = 1
	    session.use_only_cookies = 1

	    # Session GC tuning
	    session.gc_divisor = 1000

	    # OPcache (performance + minor hardening)
	    opcache.enable = 1
	    opcache.enable_cli = 1
	    opcache.file_cache = "/var/cache/php-opcache"

	    # Disallow remote includes (saves against LFI via URL), but keep URL fopen for updates/firewall defs
	    allow_url_include = Off
	    # allow_url_fopen = Off   # ← DO NOT enable this; it breaks NinjaFirewall and similar
	  '';

	  phpEnv = {
	    PATH = "/run/current-system/sw/bin:/usr/bin:/bin";
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
		  extraConfig = ''
	    ServerTokens ProductOnly
	    ServerSignature Off
	  '';
	  virtualHosts = {
	    "a-main-ftc25671.com" = {
	      hostName = "ftc25671.com";
	      listen = [ { port = 80; } ];
	      serverAliases = [ "ftc25671.com" "192.168.1.210/" ];
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
		     "tor-wordpress-onion" = {
	    hostName = "ftc25dgxyd6xxmo7mzhjjhuvpvfvrjntfxxsoczawuyrwri4evm5tgad.onion";
	    onlySSL = true;
	    listen = [ 
	      { ip = "127.0.0.1"; port = 443; ssl = true; }
	      { ip = "::1"; port = 443; ssl = true; }
	    ];
	    sslServerCert = "/var/lib/httpd/onion-certs/onion.crt";
	    sslServerKey = "/var/lib/httpd/onion-certs/onion.key";
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
	      
	      SetEnv HTTPS on

	      RemoteIPHeader X-Forwarded-For
	      
	      # ── Tor Context Identity Hardening ──
	      <IfModule mod_headers.c>
		  # Strip signatures that reveal Apache/PHP processing structures
		  Header always unset X-Powered-By
		  Header always unset Server
		  Header always unset X-Pingback
		  Header always unset Link
		  
		  # Match your clear-net security baseline
		  Header always set X-Content-Type-Options "nosniff"
		  Header always set X-Frame-Options "SAMEORIGIN"
		  Header always set X-XSS-Protection "1; mode=block"
		  Header always set Content-Security-Policy "frame-ancestors 'self' ftc25dgxyd6xxmo7mzhjjhuvpvfvrjntfxxsoczawuyrwri4evm5tgad.onion"
		  
		  # Protect cookies over the Tor layer
		  Header always edit Set-Cookie "^(.*)$" "$1; HttpOnly; Secure; SameSite=Strict"
	      </IfModule>
	      
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
		ProxyPass / http://127.0.0.1:3005/
		ProxyPassReverse / http://127.0.0.1:3005/
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
            <IfModule mod_mime.c>
    # Force specific developer extensions to render as plain text
    AddType text/plain .nix
    AddType text/plain .log
    AddType text/plain .md
    AddType text/plain .sh
    AddType text/plain .conf
</IfModule>

		      '';
		    };
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

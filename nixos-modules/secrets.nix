{ config, pkgs, ... }:
{
  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.age.keyFile = "/root/.config/sops/age/keys.txt"; 

  sops.secrets = {
    root_password_hash = { neededForUsers = true; }; 
    keycloak_db_password = { 
      owner = "keycloak"; 
      group = "keycloak";
    };
    
    mediawiki_admin_password = { 
      owner = "wwwrun"; 
      group = "wwwrun";   
    };
    restic_backup_password = { }; 
    filebrowser_admin_password = { }; 

    cf_tunnel_wordpress   = { }; 
    cf_tunnel_default     = { }; 
    cf_tunnel_http        = { }; 
    cf_tunnel_music       = { }; 
    cf_tunnel_sso         = { };
    cf_tunnel_management  = { };
    cf_tunnel_status      = { }; 
    cf_tunnel_ssh         = { }; 
    cf_tunnel_rdp         = { };
    cf_tunnel_wiki        = { }; 
  };

  # Add the template generation block right here:
  sops.templates."cloudflare-tunnels.env".content = ''
    CLOUDFLARE_TUNNEL_TOKEN_DEFAULT=${config.sops.placeholder.cf_tunnel_default}
    CLOUDFLARE_TUNNEL_TOKEN_HTTP=${config.sops.placeholder.cf_tunnel_http}
    CLOUDFLARE_TUNNEL_TOKEN_MANAGEMENT=${config.sops.placeholder.cf_tunnel_management}
    CLOUDFLARE_TUNNEL_TOKEN_MUSIC=${config.sops.placeholder.cf_tunnel_music}
    CLOUDFLARE_TUNNEL_TOKEN_RDP=${config.sops.placeholder.cf_tunnel_rdp}
    CLOUDFLARE_TUNNEL_TOKEN_SSH=${config.sops.placeholder.cf_tunnel_ssh}
    CLOUDFLARE_TUNNEL_TOKEN_SSO=${config.sops.placeholder.cf_tunnel_sso}
    CLOUDFLARE_TUNNEL_TOKEN_STATUS=${config.sops.placeholder.cf_tunnel_status}
    CLOUDFLARE_TUNNEL_TOKEN_WIKI=${config.sops.placeholder.cf_tunnel_wiki}
    CLOUDFLARE_TUNNEL_TOKEN_WORDPRESS=${config.sops.placeholder.cf_tunnel_wordpress}
  '';
}

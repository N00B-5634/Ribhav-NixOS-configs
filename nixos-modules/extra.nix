{ config, pkgs, ... }:

{


  systemd.tmpfiles.rules = [
    "d /srv/http/wordpress 0755 ribhav wwwrun -"
    "d /srv/http/ftc25671 0755 ribhav wwwrun -"
    "d /var/tomcat 0755 tomcat tomcat -"
    "d /var/tomcat/logs 0755 tomcat tomcat -"
    "d /var/tomcat/temp 0755 tomcat tomcat -"
    "d /var/tomcat/webapps 0755 tomcat tomcat -"
    "d /var/tomcat/conf 0755 tomcat tomcat -"
    "d /srv/http 0755 root root - -"
    "d /srv/http/errors 0755 root root - -"
  ];



  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [
    zlib
    glibc
  ];

  nixpkgs.config.allowUnfree = true;
		   services.tor = {
	  enable = true;
	  client.enable = true;
	  hiddenServices = {
            wordpress-onion = { map = [ { port = 80; target.port = 80; } { port = 443; target.port = 443; } ]; version = 3; };	    
            filebrowser-onion = { map = [ { port = 80; target.port = 8080; } ]; version = 3; };
	    kuma-onion      = { map = [ { port = 80; target.port = 3001; } ]; version = 3; };
	    vitepress-onion = { map = [ { port = 80; target.port = 5173; } ]; version = 3; };
	    keycloak-onion  = { map = [ { port = 80; target.port = 8089; } ]; version = 3; };
	    nexterm-onion   = { map = [ { port = 80; target.port = 8089; } ]; version = 3; };
	    mediawiki-onion = { map = [ { port = 80; target.port = 8086; } ]; version = 3; };
	    node1-onion     = { map = [ { port = 80; target.port = 8082; } ]; version = 3; };
	    node2-onion     = { map = [ { port = 80; target.port = 4433; } ]; version = 3; };
            swing-onion     = { map = [ { port = 80; target.port = 4533; } ]; version = 3; };
	  };
	};
}

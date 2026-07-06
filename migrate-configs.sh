#!/usr/bin/env bash
set -euo pipefail

SERVICES_FILE="/etc/nixos/nixos-modules/services.nix"
EXTRA_FILE="/etc/nixos/nixos-modules/extra.nix"

echo ">> Starting precise NixOS inline migration script..."

if [ -f "$SERVICES_FILE" ]; then
    echo ">> Modifying $SERVICES_FILE directly in-place..."
    cp "$SERVICES_FILE" "${SERVICES_FILE}.bak"

    # 1. Inject the necessary "wants" network dependency right under your existing "after" lines
    sed -i 's/after = \[ "network-online.target" \];/after = \[ "network-online.target" \];\n    wants = \[ "network-online.target" \];/g' "$SERVICES_FILE"

    # 2. Swap out the literal multi-line EnvironmentFile token path assignments with their matching SOPS configurations
    sed -i 's|/var/lib/cloudflare-tunnels/token_wordpress|config.sops.secrets.cf_tunnel_wordpress.path|g' "$SERVICES_FILE"
    sed -i 's|/var/lib/cloudflare-tunnels/token_default|config.sops.secrets.cf_tunnel_default.path|g' "$SERVICES_FILE"
    sed -i 's|/var/lib/cloudflare-tunnels/token_http|config.sops.secrets.cf_tunnel_http.path|g' "$SERVICES_FILE"
    sed -i 's|/var/lib/cloudflare-tunnels/token_music|config.sops.secrets.cf_tunnel_music.path|g' "$SERVICES_FILE"
    sed -i 's|/var/lib/cloudflare-tunnels/token_sso|config.sops.secrets.cf_tunnel_sso.path|g' "$SERVICES_FILE"
    sed -i 's|/var/lib/cloudflare-tunnels/token_management|config.sops.secrets.cf_tunnel_management.path|g' "$SERVICES_FILE"
    sed -i 's|/var/lib/cloudflare-tunnels/token_status|config.sops.secrets.cf_tunnel_status.path|g' "$SERVICES_FILE"
    sed -i 's|/var/lib/cloudflare-tunnels/token_ssh|config.sops.secrets.cf_tunnel_ssh.path|g' "$SERVICES_FILE"
    sed -i 's|/var/lib/cloudflare-tunnels/token_rdp|config.sops.secrets.cf_tunnel_rdp.path|g' "$SERVICES_FILE"
    sed -i 's|/var/lib/cloudflare-tunnels/token_wiki|config.sops.secrets.cf_tunnel_wiki.path|g' "$SERVICES_FILE"

    # Note: Because Nix uses quotes for paths vs configuration calls, remove the surrounding string quotes around the newly mapped paths
    sed -i 's|EnvironmentFile =.*config.sops.secrets.\(.*\).path.*;|EnvironmentFile = config.sops.secrets.\1.path;|g' "$SERVICES_FILE"

    # 3. Swap the Keycloak & MediaWiki global parameters directly on their explicit declaration lines
    sed -i 's|services.keycloak.database.passwordFile = .*;|services.keycloak.database.passwordFile = config.sops.secrets.keycloak_db_password.path;|g' "$SERVICES_FILE"
    sed -i 's|services.mediawiki.passwordFile = .*;|services.mediawiki.passwordFile = config.sops.secrets.mediawiki_admin_password.path;|g' "$SERVICES_FILE"
    sed -i 's|passwordFile = /etc/mediawiki/.*|passwordFile = config.sops.secrets.mediawiki_admin_password.path;|g' "$SERVICES_FILE"
else
    echo "!! Error: $SERVICES_FILE not found!"
fi

if [ -f "$EXTRA_FILE" ]; then
    echo ">> Modifying $EXTRA_FILE..."
    cp "$EXTRA_FILE" "${EXTRA_FILE}.bak"

    # Fix Tor schema changes
    sed -i 's/services.tor.hiddenServices/services.tor.relay.onionServices/g' "$EXTRA_FILE"

    # Wipe obsolete keycloak baseline tmpfiles generation lines
    sed -i '/f \/var\/lib\/keycloak\/db-password/d' "$EXTRA_FILE"
else
    echo "!! Error: $EXTRA_FILE not found!"
fi

echo ">> Config alignment finished. Testing compiler state..."
nix-instantiate --parse "$SERVICES_FILE" > /dev/null
nix-instantiate --parse "$EXTRA_FILE" > /dev/null
echo ">> Syntax validated successfully!"
#!/usr/bin/env bash
set -euo pipefail

SECRETS_FILE="/etc/nixos/secrets/secrets.yaml"
OLD_TUNNEL_DIR="/var/lib/cloudflare-tunnels"

TMP_YAML=$(mktemp)
trap 'rm -f "$TMP_YAML"' EXIT

echo "=== Starting Cloudflare Tunnel Content-Aware Migration Script ==="

if [ ! -f "/etc/nixos/.sops.yaml" ]; then
    echo "ERROR: /etc/nixos/.sops.yaml not found."
    exit 1
fi

if [ ! -d "$OLD_TUNNEL_DIR" ]; then
    echo "ERROR: Directory $OLD_TUNNEL_DIR does not exist."
    exit 1
fi

# Initialize temporary yaml file
echo "### Cleaned Cloudflare Tunnels" > "$TMP_YAML"

# Loop through every file in the tunnel directory
for src_file in "$OLD_TUNNEL_DIR"/*; do
    [ -f "$src_file" ] || continue
    
    echo "Scanning file: $src_file..."
    file_content=$(cat "$src_file")
    
    # Skip empty files
    [ -n "$file_content" ] || continue

    # Determine which secret key this file belongs to by inspecting its contents or filename
    secret_key=""
    var_name=""
    
    if [[ "$file_content" =~ WORDPRESS ]] || [[ "$src_file" =~ wordpress ]]; then
        secret_key="cf_tunnel_wordpress"; var_name="CLOUDFLARE_TUNNEL_TOKEN_WORDPRESS"
    elif [[ "$file_content" =~ MUSIC ]] || [[ "$src_file" =~ music ]]; then
        secret_key="cf_tunnel_music"; var_name="CLOUDFLARE_TUNNEL_TOKEN_MUSIC"
    elif [[ "$file_content" =~ HTTP ]] || [[ "$src_file" =~ http ]]; then
        secret_key="cf_tunnel_http"; var_name="CLOUDFLARE_TUNNEL_TOKEN_HTTP"
    elif [[ "$file_content" =~ SSO ]] || [[ "$src_file" =~ sso ]]; then
        secret_key="cf_tunnel_sso"; var_name="CLOUDFLARE_TUNNEL_TOKEN_SSO"
    elif [[ "$file_content" =~ MANAGEMENT ]] || [[ "$src_file" =~ management ]]; then
        secret_key="cf_tunnel_management"; var_name="CLOUDFLARE_TUNNEL_TOKEN_MANAGEMENT"
    elif [[ "$file_content" =~ STATUS ]] || [[ "$src_file" =~ status ]]; then
        secret_key="cf_tunnel_status"; var_name="CLOUDFLARE_TUNNEL_TOKEN_STATUS"
    elif [[ "$file_content" =~ SSH ]] || [[ "$src_file" =~ ssh ]]; then
        secret_key="cf_tunnel_ssh"; var_name="CLOUDFLARE_TUNNEL_TOKEN_SSH"
    elif [[ "$file_content" =~ RDP ]] || [[ "$src_file" =~ rdp ]]; then
        secret_key="cf_tunnel_rdp"; var_name="CLOUDFLARE_TUNNEL_TOKEN_RDP"
    elif [[ "$file_content" =~ WIKI ]] || [[ "$src_file" =~ wiki ]]; then
        secret_key="cf_tunnel_wiki"; var_name="CLOUDFLARE_TUNNEL_TOKEN_WIKI"
    elif [[ "$(basename "$src_file")" == "token" ]] || [[ "$file_content" =~ CLOUDFLARE_TUNNEL_TOKEN= ]]; then
        secret_key="cf_tunnel_default"; var_name="CLOUDFLARE_TUNNEL_TOKEN"
    else
        echo "   -> Match not found for this file. Skipping."
        continue
    fi

    echo "   -> Matched to $secret_key ($var_name)"

    # Extract the token string safely
    # This strips 'CLOUDFLARE_TUNNEL_TOKEN_XXX=' prefixes, quotes, newlines, carriage returns, and % symbols
    clean_token=$(echo "$file_content" | sed -E 's/^CLOUDFLARE_TUNNEL_TOKEN_[A-Z]+==?//g' | sed -E 's/^CLOUDFLARE_TUNNEL_TOKEN==?//g')
    clean_token=$(echo "$clean_token" | tr -d '"'\''\r%' | xargs)

    # Output using YAML block scalar format to force a clean trailing newline
    echo "${secret_key}: |" >> "$TMP_YAML"
    echo "  ${var_name}=${clean_token}" >> "$TMP_YAML"
done

echo "=== Injecting cleanly formatted blocks into SOPS secrets.yaml ==="

# Using older nix-shell interface which is completely robust across all versions for --run
nix-shell -p sops --run "
  while IFS= read -r line; do
    if [[ \$line =~ ^([a-zA-Z0-9__]+):[[:space:]]*\\|[[:space:]]*\$ ]]; then
      key=\"\${BASH_REMATCH[1]}\"
      read -r val_line
      val=\$(echo \"\$val_line\" | sed 's/^  //')
      echo \"Updating \$key in SOPS...\"
      sops --set \"[\\\"\$key\\\"] \\\"\$val\\\"\" $SECRETS_FILE
    fi
  done < '$TMP_YAML'
"

echo "=== Done! Running configuration test to verify ==="
sudo nixos-rebuild test --flake .#nixos-lamp

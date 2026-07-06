#!/usr/bin/env bash
# migrate-secrets.sh
# Reads every plaintext secret currently sitting on disk and pushes it into
# the sops-encrypted secrets.yaml using `sops --set`, which updates one key
# at a time without needing to decrypt/edit/re-encrypt the whole file by hand.
#
# Run as root: sudo bash migrate-secrets.sh
# Safe to re-run — set_secret just overwrites the key each time.

set -euo pipefail

SECRETS_FILE=/etc/nixos/secrets/secrets.yaml
SOPS_RUN="nix shell nixpkgs#sops -c sops"

# ---- 0. bootstrap the encrypted file if it doesn't exist yet -------------
if [ ! -f "$SECRETS_FILE" ]; then
  echo ">> $SECRETS_FILE doesn't exist yet — creating it"
  mkdir -p "$(dirname "$SECRETS_FILE")"
  echo "placeholder: true" > "$SECRETS_FILE"
  $SOPS_RUN -e -i "$SECRETS_FILE"
fi

set_secret() {
  local key="$1" value="$2"
  echo ">> setting $key"
  $SOPS_RUN --set "[\"$key\"] \"$value\"" "$SECRETS_FILE"
}

set_secret_from_file() {
  local key="$1" file="$2"
  if [ -f "$file" ]; then
    local val
    val="$(cat "$file")"
    set_secret "$key" "$val"
  else
    echo "!! $file not found — skipping $key (nothing to migrate here)"
  fi
}

# ---- 1. Cloudflare tunnel tokens ------------------------------------------
# These files already contain the full "KEY=value" line systemd's
# EnvironmentFile= expects, so we copy them in verbatim.
set_secret_from_file cf_tunnel_wordpress   /var/lib/cloudflare-tunnels/token_wordpress
set_secret_from_file cf_tunnel_default     /var/lib/cloudflare-tunnels/token
set_secret_from_file cf_tunnel_http        /var/lib/cloudflare-tunnels/token_http
set_secret_from_file cf_tunnel_music       /var/lib/cloudflare-tunnels/token_music
set_secret_from_file cf_tunnel_sso         /var/lib/cloudflare-tunnels/token_sso
set_secret_from_file cf_tunnel_management  /var/lib/cloudflare-tunnels/token_management
set_secret_from_file cf_tunnel_status      /var/lib/cloudflare-tunnels/token_status
set_secret_from_file cf_tunnel_ssh         /var/lib/cloudflare-tunnels/token_SSH
set_secret_from_file cf_tunnel_rdp         /var/lib/cloudflare-tunnels/token_rdp
set_secret_from_file cf_tunnel_wiki        /var/lib/cloudflare-tunnels/token_wiki

# ---- 2. Application passwords already on disk -----------------------------
set_secret_from_file keycloak_db_password     /etc/keycloak-db-pass
set_secret_from_file mediawiki_admin_password  /etc/mediawiki/admin-password
set_secret_from_file restic_backup_password    /etc/restic-backup-password

# ---- 3. Secrets that don't exist as files yet — prompt for them ----------
read -r -s -p "New root password (will be hashed, never stored plain): " ROOT_PW
echo
ROOT_HASH="$(nix shell nixpkgs#mkpasswd -c mkpasswd -m sha-512 "$ROOT_PW")"
set_secret root_password_hash "$ROOT_HASH"
unset ROOT_PW ROOT_HASH

read -r -s -p "New filebrowser admin password: " FB_PW
echo
set_secret filebrowser_admin_password "$FB_PW"
unset FB_PW

echo
echo "Done. Review the full decrypted contents with:"
echo "  nix shell nixpkgs#sops -c sops -d $SECRETS_FILE"
echo
echo "Do NOT delete the original plaintext files yet — wait until"
echo "nixos-rebuild switch succeeds and every service confirms it's reading"
echo "from /run/secrets/<name> instead."

#!/usr/bin/env bash
#
# fix-vhost-order.sh
#
# Fixes the Apache default-vhost bug in a NixOS services.httpd.virtualHosts
# config caused by Nix attrset key sorting.
#
# Root cause: `virtualHosts = { "ftc25671.com" = {...}; "files.ftc25671.com" = {...}; ... }`
# is a Nix attrset. builtins.attrNames sorts keys alphabetically, and the
# NixOS httpd module walks vhosts in that order. "files.ftc25671.com" sorts
# before "ftc25671.com" (f-i < f-t), so it silently becomes the first vhost
# declared for IP:80 / IP:443 -- which Apache treats as the DEFAULT vhost
# for that address, catching any request that doesn't match another
# ServerName/ServerAlias.
#
# Fix: rename the ATTRSET KEY of the main vhost (not its hostName!) to
# something that sorts before "files...". This changes nothing about what
# Apache actually serves for ftc25671.com -- the key is purely a Nix-level
# label used for ordering/merging, the real ServerName still comes from
# `hostName`.
#
# Usage:
#   ./fix-vhost-order.sh [path-to-services.nix]
#
# Defaults to /etc/nixos/services.nix if no path given.

set -euo pipefail

FILE="${1:-/etc/nixos/nixos-modules/services.nix}"
OLD_KEY='"ftc25671.com" = {'
NEW_KEY='"a-main-ftc25671.com" = {'
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="${FILE}.bak-${TIMESTAMP}"

if [[ ! -f "$FILE" ]]; then
  echo "Error: $FILE not found. Pass the correct path as an argument, e.g.:"
  echo "  $0 /etc/nixos/services.nix"
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
  echo "This needs to write to $FILE and (optionally) run nixos-rebuild."
  echo "Re-run with sudo:  sudo $0 $FILE"
  exit 1
fi

echo "==> Backing up $FILE to $BACKUP"
cp -a "$FILE" "$BACKUP"

# Sanity check: make sure the exact key we expect is actually present,
# and that it's not already renamed (idempotency).
if grep -qF "$NEW_KEY" "$FILE"; then
  echo "==> Already patched (found '$NEW_KEY'). Nothing to do."
  exit 0
fi

if ! grep -qF "$OLD_KEY" "$FILE"; then
  echo "Error: could not find the expected vhost key line:"
  echo "  $OLD_KEY"
  echo "Your file may already differ from what this script expects."
  echo "Nothing was changed (backup at $BACKUP can be deleted)."
  exit 1
fi

echo "==> Renaming vhost attrset key so it sorts before \"files.ftc25671.com\""
echo "    (hostName stays \"ftc25671.com\" -- only the Nix attribute label changes)"
sed -i "s/$(printf '%s\n' "$OLD_KEY" | sed 's/[.[\*^$/]/\\&/g')/$NEW_KEY/" "$FILE"

echo "==> Diff of change:"
diff -u "$BACKUP" "$FILE" || true

echo
echo "==> Validating the NixOS configuration builds before switching..."
if nixos-rebuild build --fast 2>&1 | tail -n 40; then
  echo
  echo "==> Build succeeded."
else
  echo
  echo "==> Build FAILED. Restoring backup."
  cp -a "$BACKUP" "$FILE"
  exit 1
fi

read -r -p "Run 'nixos-rebuild switch' now? [y/N] " ans
if [[ "$ans" =~ ^[Yy]$ ]]; then
  nixos-rebuild switch --flake .#nixos-lamp
  echo
  echo "==> Done. Verify with:"
  echo "    sudo apachectl -S"
  echo "    (ftc25671.com should now be the default vhost, not files.ftc25671.com)"
else
  echo "==> Skipped switch. Backup left at: $BACKUP"
  echo "    Run 'sudo nixos-rebuild switch' manually when ready."
fi

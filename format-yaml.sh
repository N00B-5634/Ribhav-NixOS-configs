#!/usr/bin/env bash
set -euo pipefail

# Ensure we are anchored in /etc/nixos
cd /etc/nixos

REAL_SECRETS="secrets/secrets.yaml"
SOPS_CONFIG=".sops.yaml"

# Create temporary files in the same directory path structure to satisfy path_regex rules
TMP_DECRYPTED="secrets/secrets.decrypted.tmp"
TMP_FORMATTED="secrets/secrets.formatted.tmp"
trap 'rm -f "$TMP_DECRYPTED" "$TMP_FORMATTED"' EXIT

if [ ! -f "$SOPS_CONFIG" ]; then
    echo "ERROR: $SOPS_CONFIG not found in $(pwd)."
    exit 1
fi

echo "=== 1. Decrypting existing secrets securely ==="
nix shell nixpkgs#sops -c sops --config "$SOPS_CONFIG" -d "$REAL_SECRETS" > "$TMP_DECRYPTED"

echo "=== 2. Formatting tunnel paths into safe multiline block scalars ==="
grep -v "cf_tunnel_" "$TMP_DECRYPTED" > "$TMP_FORMATTED" || true

grep "cf_tunnel_" "$TMP_DECRYPTED" | while IFS= read -r line; do
    key=$(echo "$line" | cut -d':' -f1 | xargs)
    val=$(echo "$line" | cut -d':' -f2- | sed -E 's/^[[:space:]]*"//; s/"[[:space:]]*$//' | xargs)
    
    if [ -n "$val" ]; then
        echo "${key}: |" >> "$TMP_FORMATTED"
        echo "  ${val}" >> "$TMP_FORMATTED"
    fi
done

echo "=== 3. Encrypting layout to a separate testing file ==="
# Because it is inside secrets/, the path matching rules will pass perfectly
if nix shell nixpkgs#sops -c sops --config "$SOPS_CONFIG" -e "$TMP_FORMATTED" > "$REAL_SECRETS.tmp"; then
    echo "✅ Success! Staging file encrypted safely."
    echo "=== 4. Swapping staging file into production ==="
    mv "$REAL_SECRETS.tmp" "$REAL_SECRETS"
    
    echo "=== 5. Running test deployment ==="
    nixos-rebuild test --flake .#nixos-lamp
else
    echo "❌ ERROR: SOPS Encryption failed! Your production secrets.yaml was left completely untouched."
    rm -f "$REAL_SECRETS.tmp"
    exit 1
fi

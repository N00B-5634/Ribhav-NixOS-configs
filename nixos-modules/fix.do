# 1. Read the contents of your existing services file, skipping the first line
tail -n +2 /etc/nixos/nixos-modules/services.nix > /tmp/services_body.tmp

# 2. Re-write services.nix with the proper 'let' block injected at the top
cat << 'EOF' > /etc/nixos/nixos-modules/services.nix
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
EOF

# 3. Append the rest of your original services configuration back into the file
cat /tmp/services_body.tmp >> /etc/nixos/nixos-modules/services.nix

# 4. Clean up the temporary file
rm /tmp/services_body.tmp

echo "Successfully updated services.nix with the PHP definition!"

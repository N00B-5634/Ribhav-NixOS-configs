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
  environment.systemPackages = [
    myPhp
  ];
}

{ config, lib, pkgs, ... }:

let
  settings = import ../../settings.nix;
in
{
  networking.hostName = settings.system.hostname;
  networking.firewall.enable = false;
  
  services.openssh.enable = true;
}


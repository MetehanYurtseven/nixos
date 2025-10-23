{ config, lib, pkgs, ... }: {
  networking.hostName = "desktop";
  networking.firewall.enable = false;
  
  services.openssh.enable = true;
}


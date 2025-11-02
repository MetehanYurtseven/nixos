{ config, lib, pkgs, ... }:

let
  settings = import ../../settings.nix;
in
{
  users = {
    defaultUserShell = pkgs.xonsh;
    users.${settings.user.username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        settings.user.sshKey
      ];
    };
  };
}


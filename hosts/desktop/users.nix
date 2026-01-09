{ pkgs, settings, ... }:
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

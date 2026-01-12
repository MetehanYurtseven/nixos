{ settings, ... }:
{
  users = {
    users.${settings.user.username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        settings.user.sshKey
      ];
    };
  };
}

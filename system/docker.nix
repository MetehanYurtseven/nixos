{ settings, ... }:
{
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";

    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  users.extraGroups.docker.members = [ settings.user.username ];
}

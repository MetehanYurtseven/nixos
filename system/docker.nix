{ lib, settings, ... }:
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

  # Docker starts asynchronously without blocking boot
  systemd.services.docker.wantedBy = lib.mkForce [ ];
  systemd.services.docker-rootless.wantedBy = lib.mkForce [ ];
}

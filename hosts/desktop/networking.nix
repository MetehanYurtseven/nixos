{
  config,
  lib,
  settings,
  ...
}:
{
  networking = {
    hostName = settings.system.hostname;
    firewall.enable = false;

    wireless.enable = false;
    enableIPv6 = false;

    defaultGateway = "192.168.0.1";
    nameservers = [
      "192.168.0.1"
      "1.1.1.1"
      "8.8.8.8"
    ];

    interfaces."enp5s0" = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.0.100";
          prefixLength = 24;
        }
      ];
      wakeOnLan.enable = true;
    };

    resolvconf.extraOptions = [
      "single-request"
      "no-aaaa"
    ];

    wireguard = {
      enable = true;
      interfaces = {
        wg0 = {
          ips = [ "10.0.0.9" ];
          privateKeyFile = config.sops.secrets."wireguard/private_key".path;
          dynamicEndpointRefreshSeconds = 25;
          mtu = 1280;
          peers = [
            {
              publicKey = "m54PyD6ptUetZy17pExI6KnCvLumZEboXfd7YuSDVgA=";
              presharedKeyFile = config.sops.secrets."wireguard/preshared_key".path;
              allowedIPs = [
                "10.0.0.0/16"
              ];
              endpoint = "vpn.melthrox.de:51821";
              persistentKeepalive = 25;
            }
          ];
        };
      };
    };
  };

  # WireGuard starts asynchronously without blocking boot
  systemd.services.wireguard-wg0.wantedBy = lib.mkForce [ ];
}

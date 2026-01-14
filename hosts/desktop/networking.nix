{
  config,
  lib,
  pkgs,
  settings,
  ...
}:
{
  networking = {
    hostName = settings.system.hostname;
    firewall.enable = false;
    enableIPv6 = false;

    defaultGateway = "192.168.0.1";
    nameservers = [
      "192.168.0.1"
      "1.1.1.1"
      "8.8.8.8"
    ];

    resolvconf.extraOptions = [
      "single-request"
      "no-aaaa"
    ];

    wireless = {
      enable = true;
      networks."Vodafone-72C8".pskRaw =
        "29c234cea59ea76d6db251c62f15c89b4006cae8e46a0661febf3f3faac7949d";
    };

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

  # Disable wireless power management
  systemd.services.disable-wifi-powersave = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    script = ''
      ${pkgs.iw}/bin/iw dev wlp4s0 set power_save off
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}

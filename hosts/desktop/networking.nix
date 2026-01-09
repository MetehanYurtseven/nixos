{ config, settings, ... }:
{
  networking.hostName = settings.system.hostname;
  networking.firewall.enable = false;

  services.openssh.enable = true;

  networking.wireguard = {
    enable = true;
    interfaces = {
      wg0 = {
        ips = [ "10.0.0.9" ];
        # Nutze verschlüsselte Secrets
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
}

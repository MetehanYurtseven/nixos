{ pkgs, ... }:
{
  services.avahi.enable = true; # Avahi for AirPlay
  security.rtkit.enable = true; # RealtimeKit

  services.pipewire = {
    enable = true;

    pulse.enable = true;
    wireplumber.enable = true;

    alsa = {
      enable = true;
      support32Bit = true;
    };

    extraConfig.pipewire = {
      "10-airplay" = {
        "context.modules" = [
          {
            name = "libpipewire-module-raop-discover";
          }
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    pwvucontrol # PipeWire Volume Control
    playerctl # Media Player Control
  ];
}

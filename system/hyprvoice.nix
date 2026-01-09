{ pkgs, ... }:
{
  programs.ydotool.enable = true;

  environment.systemPackages = with pkgs; [
    hyprvoice
  ];

  systemd.user.services.hyprvoice = {
    description = "Hyprvoice voice-to-text daemon";
    documentation = [ "https://github.com/leonardotrapani/hyprvoice" ];
    after = [ "pipewire.service" ];
    wants = [ "pipewire.service" ];
    wantedBy = [ "default.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.hyprvoice}/bin/hyprvoice serve";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}

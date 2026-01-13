{ pkgs, ... }:
{
  programs.ydotool.enable = true;

  environment.systemPackages = with pkgs; [
    hyprvoice
  ];

  systemd.user.services.hyprvoice = {
    description = "Hyprvoice voice-to-text daemon";
    documentation = [ "https://github.com/leonardotrapani/hyprvoice" ];
    after = [
      "pipewire.service"
      "wayland-session-waitenv.service"
    ];
    requires = [ "wayland-session-waitenv.service" ];
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.uwsm}/bin/uwsm app -- ${pkgs.hyprvoice}/bin/hyprvoice serve";
      Restart = "on-failure";
      RestartSec = 5;
      PassEnvironment = [
        "WAYLAND_DISPLAY"
        "XDG_CURRENT_DESKTOP"
      ];
    };
  };
}

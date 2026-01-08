{ pkgs, ... }:
{
  # Profile Sync Daemon - Lädt Browser-Profil in RAM für schnelleren Start
  services.psd = {
    enable = true;
    resyncTimer = "1h";
  };

  # Chromium mit Performance-Optimierungen
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;

    commandLineArgs = [
      # Wayland Fix (aus settings.nix)
      "--disable-features=WaylandWpColorManagerV1"

      # Wayland native support mit nativen Benachrichtigungen
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"

      # Performance & Startup
      "--enable-zero-copy"
      "--enable-gpu-rasterization"
      "--disable-background-networking"
      "--enable-smooth-scrolling"
    ];
  };
}

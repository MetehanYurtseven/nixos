{ settings, pkgs, ... }:
{
  programs.vicinae = {
    enable = true;
    systemd.enable = true;
    package = pkgs.vicinae;
    settings = {
      search_files_in_root = false;
      font.normal.family = settings.appearance.displayFont;
      font.normal.size = 12;
      theme.dark.name = "rose-pine";
      launcher_window.opacity = 0.95;
    };
  };
}

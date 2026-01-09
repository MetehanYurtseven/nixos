{ settings, ... }:
{
  programs.git = {
    enable = true;
    settings.user.name = settings.user.fullName;
    settings.user.email = settings.user.email;
    settings.safe.directory = "/etc/nixos";
  };
}

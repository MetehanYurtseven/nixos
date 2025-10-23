{ config, pkgs, ... }: {
  programs.git = {
    enable = true;
    settings.user.name = "Metehan Yurtseven";
    settings.user.email = "metehan.yurtseven@itsolutions-gg.de";
    settings.safe.directory = "/etc/nixos";
  };
}


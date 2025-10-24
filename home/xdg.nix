{ config, pkgs, ... }: {
  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    desktop = "${config.home.homeDirectory}/desktop";
    download = "${config.home.homeDirectory}/downloads";
    pictures = "${config.home.homeDirectory}/pictures";
    documents = "${config.home.homeDirectory}/documents";

    music = null;
    publicShare = null;
    templates = null;
    videos = null;
  };
}


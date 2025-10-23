{ config, lib, pkgs, ... }: {
  environment.sessionVariables.FZF_DEFAULT_OPTS = "--layout reverse";
  environment.pathsToLink = [ "/share/zsh" ];
}


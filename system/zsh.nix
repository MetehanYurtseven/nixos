{ config, lib, pkgs, ... }: {
  programs.zsh = {
    enable = true;

    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    shellAliases = {
      ls = "lsd";
      sl = "ls";
      l = "ls";
      ll = "l -l";
      la = "l -lA";
      lt = "ll --tree --depth 3";
      tree = "ls --tree";
    };

    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "python"
        "fzf"
      ];
      theme = "dieter";
    };
  };
}


{ config, pkgs, ... }: {
  programs.zsh = {
    enable = true;

    autocd = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "lsd";
      sl = "ls";
      l = "ls";
      ll = "l -l";
      la = "l -lA";
      lt = "ll --tree --depth 3";
      tree = "ls --tree";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "sudo"
        "git"
        "fzf"
        "python"
      ];
      theme = "dieter";
    };
  };
}


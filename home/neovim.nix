{ config, pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
    ];

    extraConfig = ''
      " Use 2 spaces as tab
      set relativenumber
      set tabstop=2
      set shiftwidth=2
      set expandtab
      set softtabstop=2
    '';
  };
}


{ config, lib, pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    configure = {
      customRC = ''
        set relativenumber
        set tabstop=2
        set shiftwidth=2
        set expandtab
        set softtabstop=2
      '';
    };
  };
}


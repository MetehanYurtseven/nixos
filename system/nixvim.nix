{ config, lib, pkgs, ... }: {
  programs.nixvim = {
    enable = true;
    opts = {
      relativenumber = true;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
    };
  };
}


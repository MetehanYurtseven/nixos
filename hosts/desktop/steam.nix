{ config, lib, pkgs, ... }:
{
  programs.steam = {
    enable = true;
    
    # GE-Proton for better performance
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
  
  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };
  
  # Steam Hardware Support (Controller, VR, etc.)
  hardware.steam-hardware.enable = true;
}

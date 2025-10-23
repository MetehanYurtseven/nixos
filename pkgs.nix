{ pkgs, ... }: { environment.systemPackages = with pkgs; [
  fzf
  lsd
  htop
  btop
  nmap
];}

{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    remmina
    lutris
    steam
    uv
    nodejs_24
    neofetch
    nmap
    btop
    htop
    thunderbird
  ];
}

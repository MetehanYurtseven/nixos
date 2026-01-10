{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    remmina
    lutris
    steam
    nodejs_24
    neofetch
    nmap
    btop
    htop
    thunderbird
    p7zip
    gimp-with-plugins
    zed-editor
  ];
}

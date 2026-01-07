{ pkgs, ... }:
{
  networking.wireless.enable = true;
  networking.wireless.networks."Vodafone-72C8".pskRaw =
    "29c234cea59ea76d6db251c62f15c89b4006cae8e46a0661febf3f3faac7949d";
  environment.systemPackages = with pkgs; [ wpa_supplicant ];
}

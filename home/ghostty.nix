{ pkgs, ... }:
let
  settings = import ../settings.nix;
in
{
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    installVimSyntax = true;
    settings = {
      theme = "Rose Pine";
      font-size = 12;

      font-family = settings.appearance.monospaceFont;
      font-family-bold = "${settings.appearance.monospaceFont} Heavy";
      font-family-italic = "${settings.appearance.monospaceFont} Italic";
      font-family-bold-italic = "${settings.appearance.monospaceFont} Heavy Italic";
    };
  };
}

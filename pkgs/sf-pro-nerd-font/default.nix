{
  lib,
  stdenvNoCC,
  fetchurl,
  p7zip,
  cpio,
  fontforge,
  nerd-font-patcher,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sf-pro-nerd-font";
  version = "1.0";

  src = fetchurl {
    url = "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg";
    hash = "sha256-Lk14U5iLc03BrzO5IdjUwORADqwxKSSg6rS3OlH9aa4=";
  };

  nativeBuildInputs = [
    p7zip
    cpio
    fontforge
    nerd-font-patcher
  ];

  unpackPhase = ''
    runHook preUnpack
    7z x $src
    cd SFProFonts
    7z x 'SF Pro Fonts.pkg'
    cpio -i < Payload~
    cd ..
    runHook postUnpack
  '';

  sourceRoot = "SFProFonts/Library/Fonts";

  buildPhase = ''
    runHook preBuild
    for font in *.otf; do
      nerd-font-patcher "$font" --complete --careful
    done
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 *Nerd*.otf -t $out/share/fonts/opentype
    runHook postInstall
  '';

  meta = {
    description = "SF Pro Nerd Font - Apple's system font patched with Nerd Fonts";
    homepage = "https://developer.apple.com/fonts/";
    license = lib.licenses.apsl20;
    platforms = lib.platforms.all;
  };
})


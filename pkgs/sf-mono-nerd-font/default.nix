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
  pname = "sf-mono-nerd-font";
  version = "1.0";

  src = fetchurl {
    url = "https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg";
    hash = "sha256-bUoLeOOqzQb5E/ZCzq0cfbSvNO1IhW1xcaLgtV2aeUU=";
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
    cd SFMonoFonts
    7z x 'SF Mono Fonts.pkg'
    cpio -i < Payload~
    cd ..
    runHook postUnpack
  '';

  sourceRoot = "SFMonoFonts/Library/Fonts";

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
    description = "SF Mono Nerd Font - Apple's monospaced font patched with Nerd Fonts";
    homepage = "https://developer.apple.com/fonts/";
    license = lib.licenses.apsl20;
    platforms = lib.platforms.all;
  };
})


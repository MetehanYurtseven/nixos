{ lib
, stdenvNoCC
, fetchzip
, autoPatchelfHook
, makeWrapper
, qt6
, kdePackages
, wayland
, libxkbcommon
, libGL
, libqalculate
}:

stdenvNoCC.mkDerivation rec {
  pname = "vicinae";
  version = "0.15.5";

  src = fetchzip {
    url = "https://github.com/vicinaehq/vicinae/releases/download/v${version}/vicinae-linux-x86_64-v${version}.tar.gz";
    hash = "sha256-jYXxifHK74SBx7OhrXOAzqIcbDxZJomgRuBWH3bBfYQ=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
    kdePackages.qtkeychain
    kdePackages.layer-shell-qt
    libqalculate
    wayland
    libxkbcommon
    libGL
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r bin lib share $out/

    runHook postInstall
  '';

  meta = with lib; {
    description = "A high-performance, native launcher for Linux — built with C++ and Qt";
    homepage = "https://docs.vicinae.com";
    downloadPage = "https://github.com/vicinaehq/vicinae/releases";
    changelog = "https://github.com/vicinaehq/vicinae/releases/tag/v${version}";
    mainProgram = "vicinae";
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}

{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, nodejs
, qt6
, kdePackages
, protobuf
, cmark-gfm
, libqalculate
, minizip
, rapidfuzz-cpp
}:

stdenv.mkDerivation rec {
  pname = "vicinae";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "vicinaehq";
    repo = "vicinae";
    rev = "v${version}";
    hash = "sha256-1fw40nv5h3s7m8f3fka9m9hpfbay5cd3hlzc2bq7q0m27zvm7gs2";
  };

  nativeBuildInputs = [
    cmake
    ninja
    nodejs
    rapidfuzz-cpp
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
    kdePackages.qtkeychain
    kdePackages.layer-shell-qt
    protobuf
    cmark-gfm
    libqalculate
    minizip
  ];

  preConfigure = ''
    export HOME=$TMPDIR
  '';

  cmakeFlags = [
    "-G Ninja"
    "-DBUILD_TESTING=OFF"
  ];

  meta = with lib; {
    description = "A high-performance, native launcher for Linux — built with C++ and Qt";
    homepage = "https://docs.vicinae.com";
    mainProgram = "vicinae";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}

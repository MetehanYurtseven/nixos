{ lib
, stdenvNoCC
, makeWrapper
, bun
}:

stdenvNoCC.mkDerivation rec {
  pname = "copilot-api";
  version = "latest";

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    makeWrapper ${bun}/bin/bunx $out/bin/copilot-api \
      --add-flags "copilot-api@latest"

    runHook postInstall
  '';

  meta = with lib; {
    description = "GitHub Copilot API wrapper using Bun";
    longDescription = ''
      A wrapper script that runs the latest version of copilot-api
      via bunx, providing easy access to GitHub Copilot's API.
    '';
    homepage = "https://github.com/copilot-extensions/copilot-api";
    license = licenses.mit;
    mainProgram = "copilot-api";
    platforms = platforms.all;
    maintainers = [ ];
  };
}


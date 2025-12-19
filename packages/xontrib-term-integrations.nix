{ lib
, buildPythonPackage
, fetchPypi
, pdm-pep517
, xonsh
}:

buildPythonPackage rec {
  pname = "xontrib-term-integrations";
  version = "0.2.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ofxOtNGPNWiuUBtiLgARLqInKdkH4Ui8oSAROmSv6GA=";
  };

  nativeBuildInputs = [ pdm-pep517 ];

  propagatedBuildInputs = [ xonsh ];

  doCheck = false;

  meta = with lib; {
    description = "Shell integration for Xonsh with various terminal emulators (iTerm2, Kitty, WezTerm)";
    homepage = "https://github.com/jnoortheen/xontrib-term-integrations";
    license = licenses.mit;
  };
}


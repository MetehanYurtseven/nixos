{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "xontrib-fzf-widgets";
  version = "0.0.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-EpeOr9c3HwFdF8tMpUkFNu7crmxqbL1VjUg5wTzNzUk=";
  };

  build-system = [ setuptools ];

  doCheck = false;

  meta = with lib; {
    description = "fzf widgets for xonsh shell";
    homepage = "https://github.com/laloch/xontrib-fzf-widgets";
    license = licenses.gpl3;
  };
}

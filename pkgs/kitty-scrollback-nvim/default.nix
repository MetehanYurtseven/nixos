{ pkgs }:

pkgs.fetchFromGitHub {
  owner = "mikesmithgh";
  repo = "kitty-scrollback.nvim";
  rev = "v6.1.0";
  hash = "sha256-qCeAnP7kRi7Vh98YMymrWGZqFUCVewpYHYkwnZL6V5w=";
}


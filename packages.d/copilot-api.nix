{ pkgs, ... }: pkgs.writeShellScriptBin "copilot-api" ''
  exec ${pkgs.bun}/bin/bunx copilot-api@latest "$@"
''


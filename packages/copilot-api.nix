{ writeShellScriptBin, bun }:

writeShellScriptBin "copilot-api" ''
  exec ${bun}/bin/bunx copilot-api@latest "$@"
''


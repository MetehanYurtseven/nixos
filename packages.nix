{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "copilot-api" ''
      exec ${bun}/bin/bunx copilot-api@latest "$@"
    '')
  ];
}


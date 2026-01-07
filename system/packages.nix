{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    vim # Text Editor
    wget # Download Manager
    git # Git
    tmux # Terminal Multiplexer
    fzf # Enhanced CTRL+R Search
    lsd # Enhanced ls command
    busybox # Core utils
    nixd # Nix Language Server
    nil # Nix Language Server
  ];
}

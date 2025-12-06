{ config, pkgs, ... }: {
  programs.xonsh = {
    enable = true;
    
    extraPackages = ps: [
      (ps.callPackage ../packages/xontrib-fzf-widgets.nix { })
    ];
    
    config = ''
      import os

      # fzf widgets laden
      xontrib load fzf-widgets
      $fzf_history_binding = "c-r"
      $fzf_ssh_binding = "c-s"
      $fzf_file_binding = "c-t"
      $fzf_dir_binding = "c-g"

      $XONSH_CAPTURE_ALWAYS=True
      $VI_MODE=True
      $AUTO_CD = True
      $XONSH_HISTORY_BACKEND = 'sqlite'

      $PAGER = 'nvimpager'
      
      aliases.update({
          'cd': ['z'],
          'open': ['xdg-open'],
          
          # ls Aliase
          'ls': ['lsd'],
          'sl': ['lsd'],
          'l': ['lsd'],
          'll': ['lsd', '-l'],
          'la': ['lsd', '-lA'],
          'lt': ['lsd', '-l', '--tree', '--depth', '3'],
          'tree': ['lsd', '--tree'],

          # git aliases
          'gs': ['git', 'status'],
          'ga': ['git', 'add'],
          'gc': ['git', 'commit'],
          'gp': ['git', 'push'],
          
          # nixos aliases
          'update': ['_update'],
          'switch': ['sudo', 'nixos-rebuild', 'switch'],
          'test': ['sudo', 'nixos-rebuild', 'test'],
          'clean': ['sudo', 'nix-collect-garbage']
      })

      if 'SSH_TTY' not in os.environ:
          $SSH_AUTH_SOCK = $HOME + "/.1password/agent.sock"
    '';
  };

  programs.zoxide = {
    enable = true;
    enableXonshIntegration = true;
  };
  
  environment.systemPackages = with pkgs; [
    fzf
    lsd

    # Function to update the system
    (writeShellScriptBin "_update" ''
      set -e
      FLAKE_DIR="/etc/nixos"
      
      changes=$(git -C "$FLAKE_DIR" status --porcelain)
      
      if [ -n "$changes" ]; then
          git -C "$FLAKE_DIR" stash push --include-untracked -m "temp: before flake update"
      fi
      
      cleanup() {
          if [ -n "$changes" ]; then
              git -C "$FLAKE_DIR" stash pop
          fi
      }
      trap cleanup EXIT INT TERM
      
      nix flake update --flake "$FLAKE_DIR"
      
      if ! git -C "$FLAKE_DIR" diff --quiet flake.lock; then
          git -C "$FLAKE_DIR" add flake.lock
          git -C "$FLAKE_DIR" commit -m "flake update"
      fi

      sudo nixos-rebuild switch
    '')
  ];
}

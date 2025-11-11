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
      
      aliases.update({
          # Navigation
          'cd': ['z'],
          
          # ls-basierte Aliase
          'ls': ['lsd'],
          'sl': ['lsd'],
          'l': ['lsd'],
          'll': ['lsd', '-l'],
          'la': ['lsd', '-lA'],
          'lt': ['lsd', '-l', '--tree', '--depth', '3'],
          'tree': ['lsd', '--tree'],
          
          # NixOS System-Aliase
          'update': ['sudo', 'nixos-rebuild', 'switch', '--recreate-lock-file', '--flake', '/etc/nixos'],
          'clean': ['bash', '-c', 'sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d && sudo nix-collect-garbage --delete-old'],
          'switch': ['sudo', 'nixos-rebuild', 'switch'],
          'test': ['sudo', 'nixos-rebuild', 'test']
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
    fzf  # Benötigt für xontrib-fzf-widgets
    lsd
  ];
}

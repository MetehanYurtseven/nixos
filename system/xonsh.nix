{ pkgs, ... }:
{
  programs.xonsh = {
    enable = true;

    extraPackages = ps: [
      (ps.callPackage ../packages/xontrib-fzf-widgets.nix { })
      (ps.callPackage ../packages/xontrib-term-integrations.nix { })
    ];

    config = ''
      import os

      # fzf widgets integration
      xontrib load fzf-widgets
      $fzf_history_binding = "c-r"
      $fzf_ssh_binding = "c-s"
      $fzf_file_binding = "c-t"
      $fzf_dir_binding = "c-g"

      # kitty terminal integration
      $XONTRIB_TERM_INTEGRATIONS_SKIP_ALIAS = True
      xontrib load term_integration

      $XONSH_CAPTURE_ALWAYS = True
      $VI_MODE = True
      $AUTO_CD = True
      $XONSH_HISTORY_BACKEND = 'sqlite'
      $HISTCONTROL = 'ignoredups'
      $XONSH_HISTORY_SIZE = (10000, 'commands')

      $ENABLE_ASYNC_PROMPT = True
      $COMPLETION_IN_THREAD = True
      $COMPLETIONS_CONFIRM = True
      $CASE_SENSITIVE_COMPLETIONS = False
      $AUTO_SUGGEST = True

      $COLOR_RESULTS = True
      $XONSH_STORE_STDOUT = True
      $UPDATE_OS_ENVIRON = True

      $NVIMPAGER_NVIM = 'nvim'

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
          'update': ['nix', 'flake', 'update', '--flake', '/etc/nixos'],
          'switch': ['sudo', 'nixos-rebuild', 'switch'],
          'test': ['sudo', 'nixos-rebuild', 'test'],
          'clean': ['sudo', 'nix-collect-garbage'],

          # vim aliases
          'vi': ['nvim'],
          'vim': ['nvim']
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
  ];
}

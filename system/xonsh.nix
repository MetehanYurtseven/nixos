{ config, pkgs, ... }: {
  programs.xonsh = {
    enable = true;
    
    config = ''
      import os
      if 'SSH_TTY' not in os.environ:
          $SSH_AUTH_SOCK = $HOME + "/.1password/agent.sock"
      
      execx($(zoxide init xonsh))
    '';
  };
  
  environment.systemPackages = with pkgs; [
    zoxide
  ];
}

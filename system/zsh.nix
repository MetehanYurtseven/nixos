{ pkgs, ... }:
{
  users.defaultUserShell = pkgs.zsh;

  programs.zsh = {
    enable = true;

    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    enableBashCompletion = true;
    enableCompletion = true;

    histSize = 10000;

    shellAliases = {
      cd = "z";
      open = "xdg-open";
      zed = "zeditor -n";

      # ls Aliase
      ls = "lsd";
      sl = "lsd";
      l = "lsd -l";
      ll = "lsd -l";
      la = "lsd -lA";
      lt = "lsd -l --tree --depth 3";
      tree = "lsd --tree";

      # git aliases
      status = "git status";
      add = "git add";
      commit = "git commit";
      pull = "git pull";
      push = "git push";
      checkout = "git checkout";
      branch = "git branch";
      log = "git log";

      # nixos aliases
      nupdate = "nix flake update --flake /etc/nixos";
      nswitch = "sudo nixos-rebuild switch";
      ntest = "sudo nixos-rebuild test";
      nclean = "sudo nix-collect-garbage";

      # vim aliases
      vi = "nvim";
      vim = "nvim";
    };

    setOptions = [
      "EXTENDED_HISTORY"
      "AUTO_CD"
      "COMPLETE_ALIASES"
      "PROMPT_SUBST"
    ];

    promptInit = ''
      git_branch() {
        local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
        [[ -n $branch ]] && echo "($branch) "
      }

      env_name() {
        [[ -n $VIRTUAL_ENV ]] && echo "%F{red}($(basename $VIRTUAL_ENV)) %f"
        [[ -n $CONDA_DEFAULT_ENV ]] && echo "%F{red}($CONDA_DEFAULT_ENV) %f"
      }

      PROMPT='[%D{%H:%M:%S}] $(env_name)%B%F{yellow}%n%f%b%B%F{white}@%f%b%B%F{magenta}%m%f%b %B%F{green}%~%f%b %F{cyan}$(git_branch)%f%b
      %B%F{green}@%f%b '
    '';

    interactiveShellInit = ''
      # activate vi mode
      bindkey -v

      # escape delay to 10ms
      export KEYTIMEOUT=1

      # vi mode fixes
      bindkey -M viins '^?' backward-delete-char
      bindkey -M viins '^H' backward-delete-char

      # fzf
      eval "$(fzf --zsh)"

      # 1password ssh agent
      if [[ -z "$SSH_TTY" ]]; then
        export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"
      fi
    '';
  };

  environment.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "nvimpager";
    MANPAGER = "nvim +Man!";
    FZF_DEFAULT_OPTS = "--layout reverse";
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}

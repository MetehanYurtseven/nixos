{ config, lib, pkgs, ... }: {
  programs.zsh = {
    enable = true;

    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    shellAliases = {
      ls = "lsd";
      sl = "ls";
      l = "ls";
      ll = "l -l";
      la = "l -lA";
      lt = "ll --tree --depth 3";
      tree = "ls --tree";
      
      update = "cd /etc/nixos && nix flake update && sudo nixos-rebuild switch";
      clean = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d && sudo nix-collect-garbage --delete-old";
      rebuild = "sudo nixos-rebuild switch";
      apply = "sudo nixos-rebuild test";
    };

    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "python"
        "fzf"
      ];
      theme = "dieter";
    };

    interactiveShellInit = ''
      pkgs() {
        local file="/etc/nixos/pkgs"
        local hash_before=$(sha256sum "$file" | awk '{print $1}')
        
        ''${EDITOR:-vim} "$file"
        
        local hash_after=$(sha256sum "$file" | awk '{print $1}')
        
        if [ "$hash_before" != "$hash_after" ]; then
          echo "Changes detected..."
          
          echo "Committing to git..."
          cd /etc/nixos
          git add pkgs 2>/dev/null
          git commit -q -m "packages updated" 2>/dev/null || echo "⚠️  Git commit failed"
          
          echo "Applying configuration..."
          sudo nixos-rebuild switch
        else
          echo "No changes detected."
        fi
      }
    '';
  };
}


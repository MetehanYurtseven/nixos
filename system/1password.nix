{ config, lib, pkgs, ... }:

{
  # ============================================================================
  # 1PASSWORD ALL-IN-ONE CONFIGURATION
  # ============================================================================
  # Ein einziges Modul für System-Level UND User-Level Konfiguration
  # Import in configuration.nix genügt - alles wird automatisch eingerichtet
  # ============================================================================

  # ----------------------------------------------------------------------------
  # SYSTEM-LEVEL CONFIGURATION
  # ----------------------------------------------------------------------------
  
  # 1Password Programme
  programs._1password = {
    enable = true;
  };

  programs._1password-gui = {
    enable = true;
    # KRITISCH: Ermöglicht CLI Integration, System Auth, Browser Extension
    polkitPolicyOwners = [ "metehan.yurtseven" ];
  };

  # PolKit für System-Authentication
  security.polkit.enable = true;

  # GNOME Keyring für 2FA Token Persistence (funktioniert standalone)
  services.gnome.gnome-keyring.enable = true;
  
  # PAM Integration für automatisches Keyring-Unlock beim Login
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.greetd.enableGnomeKeyring = true;  # Für Display Manager

  # XDG Portal für bessere Wayland/Hyprland Integration
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    # Hyprland Portal als Standard für alle Interfaces
    config.common.default = [ "hyprland" ];
  };

  # ----------------------------------------------------------------------------
  # USER-LEVEL CONFIGURATION (via Home Manager)
  # ----------------------------------------------------------------------------
  # Automatische Konfiguration für den Haupt-User
  
  home-manager.users."metehan.yurtseven" = {
    # GNOME Keyring (User-Level)
    services.gnome-keyring = {
      enable = true;
      components = [ "secrets" ];
    };

    # gcr für SystemPrompter
    home.packages = with pkgs; [
      gcr
    ];

    # SSH Agent Configuration
    programs.ssh = {
      enable = true;
      # Keine automatischen Defaults - wir setzen alles explizit
      enableDefaultConfig = false;
      
      # Explizite Konfiguration für alle Hosts
      matchBlocks."*" = {
        # 1Password SSH Agent
        identityAgent = "~/.1password/agent.sock";
        
        # Standard SSH Defaults (manuell gesetzt für Zukunftssicherheit)
        addKeysToAgent = "yes";
        compression = true;
        serverAliveInterval = 60;
        serverAliveCountMax = 10;
        extraOptions = {
          HashKnownHosts = "yes";
        };
      };
    };

    # SSH_AUTH_SOCK Environment Variable
    home.sessionVariables = {
      SSH_AUTH_SOCK = "\${config.home.homeDirectory}/.1password/agent.sock";
    };

    # Git SSH Signing
    programs.git = {
      signing = {
        # TODO: Ersetze mit deinem Public Key aus 1Password!
        # Format: "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... comment"
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAplaceholder 1password-key";
        signByDefault = false;  # Auf true setzen wenn Key eingetragen
      };
      settings = {
        gpg.format = "ssh";
        gpg.ssh.program = "\${pkgs._1password-gui}/bin/op-ssh-sign";
      };
    };
  };

  # ============================================================================
  # SHELL PLUGINS (Manuelle Installation)
  # ============================================================================
  # Installiert CLI Tools mit 1Password Shell Plugin Support
  # Die Initialisierung erfolgt in der User-Config oben via zsh.initExtra
  
  environment.systemPackages = with pkgs; [
    _1password-cli  # 1Password CLI (für Shell Plugins benötigt)
    gh              # GitHub CLI
    awscli2         # AWS CLI
    # Weitere Tools die Shell Plugins unterstützen:
    # terraform     # Terraform mit 1Password Secrets
    # docker        # Docker mit 1Password Registry Auth
    # kubectl       # Kubernetes mit 1Password Configs
    # ansible       # Ansible mit 1Password Vault
  ];
  # ============================================================================

  # ============================================================================
  # SETUP ANLEITUNG
  # ============================================================================
  # 
  # Nach dem Rebuild:
  # 
  # 1. SSH Agent aktivieren:
  #    - 1Password öffnen → Settings → Developer
  #    - "Use the SSH agent" aktivieren
  #    - SSH Key erstellen oder importieren
  #    - Testen: ssh-add -l
  # 
  # 2. CLI Integration aktivieren:
  #    - 1Password öffnen → Settings → Developer
  #    - "Integrate with 1Password CLI" aktivieren
  #    - Testen: op account list
  # 
  # 3. Git Signing aktivieren (optional):
  #    - SSH Key in 1Password erstellen
  #    - Public Key kopieren
  #    - Oben bei signing.key eintragen
  #    - signByDefault = true setzen
  #    - Rebuild und testen: git commit --allow-empty -m "test"
  # 
  # 4. Shell Plugins nutzen:
  #    - AWS/GitHub Credentials in 1Password speichern
  #    - aws/gh Commands nutzen → 1Password Prompt erscheint
  # 
  # ============================================================================
  # TROUBLESHOOTING
  # ============================================================================
  # 
  # CLI funktioniert nicht:
  # - Check: op account list
  # - Lösung: Settings → Developer → "Integrate with 1Password CLI"
  # 
  # Prompts erscheinen nicht:
  # - Hyprland nutzt X11 Fallback (bereits in home.nix konfiguriert)
  # - Check: ps aux | grep polkit
  # 
  # Browser Extension verbindet nicht:
  # - Nur NixOS-Browser funktionieren (nicht Flatpak!)
  # - 1Password App neustarten
  # 
  # 2FA Token nicht persistent:
  # - Check: systemctl --user status gnome-keyring
  # - Bei Problemen: GNOME Keyring neustarten
  # ============================================================================
}

{ config, lib, pkgs, ... }:

let
  settings = import ../settings.nix;
in
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

  # ----------------------------------------------------------------------------
  # PAM RSSH - SSH-AGENT BASIERTE SUDO-AUTHENTIFIZIERUNG
  # ----------------------------------------------------------------------------
  # Ermöglicht sudo-Befehle mit SSH-Key aus 1Password statt Passwort
  # Basiert auf pam_rssh (moderne Alternative zu pam_ssh_agent_auth)
  
  # PAM rssh für SSH-Agent basierte Authentifizierung
  security.pam.rssh = {
    enable = true;
    settings = {
      # Sichere authorized_keys Datei (nicht user-writeable)
      # ${user} wird automatisch durch den Username ersetzt
      auth_key_file = "/etc/security/authorized_keys/\${user}";
    };
  };

  # sudo mit rssh aktivieren
  security.pam.services.sudo = {
    rssh = true;
  };

  # sudo Konfiguration
  security.sudo = {
    enable = true;
    # SSH_AUTH_SOCK für sudo erhalten (KRITISCH für pam_rssh)
    # Ohne diese Zeile kann sudo nicht auf den 1Password SSH-Agent zugreifen
    extraConfig = ''
      Defaults env_keep += "SSH_AUTH_SOCK"
    '';
  };

  # Erstelle authorized_keys Datei für pam_rssh
  # Diese Datei ist root-owned (mode 0444) und nicht user-writeable → sicher
  # Der SSH-Key wird aus settings.nix importiert
  environment.etc."security/authorized_keys/${settings.user.username}" = {
    text = settings.user.sshKey;
    mode = "0444";  # Read-only für alle
  };
  
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

    # SSH_AUTH_SOCK: Conditional setzen (nur in lokalen Sessions)
    # - Lokal (Hyprland): 1Password Agent aktiv
    # - SSH ohne ForwardAgent: Kein Agent → sudo Passwort-Fallback
    # - SSH mit ForwardAgent: Forwarded Agent bleibt aktiv
    programs.zsh.initContent = ''
      # SSH_AUTH_SOCK nur in lokalen Sessions setzen (nicht bei SSH)
      if [ -z "$SSH_CONNECTION" ]; then
        export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"
      fi
    '';

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
  # 5. sudo mit SSH-Key testen:
  #    - Terminal öffnen (neue Shell für Environment-Variablen)
  #    - Prüfen: echo $SSH_AUTH_SOCK (sollte ~/.1password/agent.sock sein)
  #    - Prüfen: ssh-add -l (sollte SSH-Keys anzeigen)
  #    - Testen: sudo ls /root
  #    - 1Password sollte Prompt zeigen → Authentifizierung mit SSH-Key
  #    - Kein Passwort nötig!
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
  # 
  # sudo fragt nach Passwort statt SSH-Key:
  # - Check: echo $SSH_AUTH_SOCK (muss ~/.1password/agent.sock sein)
  # - Check: ssh-add -l (muss Keys anzeigen)
  # - Check: cat /etc/security/authorized_keys/metehan.yurtseven
  # - Check: sudo cat /etc/pam.d/sudo (sollte pam_rssh enthalten)
  # - Lösung: 1Password SSH Agent aktivieren (Settings → Developer)
  # - Lösung: Neue Shell öffnen mit: exec $SHELL
  # 
  # pam_rssh funktioniert nicht:
  # - Check: ls -l /etc/security/authorized_keys/
  # - Check: journalctl -xe | grep pam
  # - Stelle sicher dass SSH-Key in 1Password vorhanden ist
  # - Private Key muss in 1Password sein, Public Key in settings.nix
  # ============================================================================
}

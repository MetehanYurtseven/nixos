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

    # SSH_AUTH_SOCK: Wird in system/xonsh.nix gesetzt

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
}

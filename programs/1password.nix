{ config, lib, pkgs, ... }:

{
  # ============================================================================
  # 1PASSWORD CONFIGURATION
  # ============================================================================
  # Diese Konfiguration implementiert alle Best Practices für 1Password auf NixOS
  # Basierend auf umfangreicher Community-Recherche und offizieller Dokumentation
  # ============================================================================

  # ----------------------------------------------------------------------------
  # UNFREE PACKAGES - KRITISCH für 1Password
  # ----------------------------------------------------------------------------
  # 1Password ist proprietäre Software und muss explizit erlaubt werden
  
  # Option A: Spezifisch nur 1Password (empfohlen für mehr Kontrolle)
  # nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  #   "1password"
  #   "1password-gui"
  #   "1password-cli"
  # ];

  # Option B: Global allowUnfree = true in configuration.nix (AKTIV)
  # Da in configuration.nix bereits nixpkgs.config.allowUnfree = true gesetzt ist,
  # ist keine zusätzliche Konfiguration hier nötig.

  # ----------------------------------------------------------------------------
  # SYSTEM-LEVEL 1PASSWORD CONFIGURATION
  # ----------------------------------------------------------------------------
  # Diese Konfiguration nutzt die offiziellen NixOS Module für 1Password
  # Vorteile:
  # - Automatische PolKit-Integration
  # - Korrekte Desktop-Integration
  # - Bessere System-Authentication
  # - Saubere Browser-Integration für Firefox, Chrome, Brave
  
  programs._1password = {
    enable = true;
    # package = pkgs._1password;  # Optional: spezifische Version
  };

  programs._1password-gui = {
    enable = true;
    # package = pkgs._1password-gui;  # Optional: spezifische Version
    
    # KRITISCH: polkitPolicyOwners muss gesetzt sein!
    # Ohne diese Einstellung funktionieren folgende Features NICHT:
    # - CLI Integration mit Desktop App
    # - System Authentication (Fingerprint, etc.)
    # - Browser Extension Unlock via Desktop App
    # - SSH Agent Integration
    polkitPolicyOwners = [ "metehan.yurtseven" ];
  };

  # ----------------------------------------------------------------------------
  # POLKIT CONFIGURATION
  # ----------------------------------------------------------------------------
  # PolKit ist essentiell für:
  # - System-level Authentication
  # - Privileged Operations
  # - Desktop Integration unter Wayland/X11
  security.polkit.enable = true;

  # ----------------------------------------------------------------------------
  # BROWSER INTEGRATION
  # ----------------------------------------------------------------------------
  # 1Password Desktop App kann Browser Extensions automatisch entsperren
  # Dies funktioniert automatisch für:
  # - Firefox
  # - Chrome/Chromium
  # - Brave
  # 
  # WICHTIG: Funktioniert NUR mit NixOS-installierten Browsern!
  # Flatpak-Browser werden NICHT unterstützt.
  #
  # Für andere Chromium-basierte Browser (z.B. Vivaldi):
  # environment.etc."1password/custom_allowed_browsers" = {
  #   text = ''
  #     vivaldi-bin
  #   '';
  # };

  # ----------------------------------------------------------------------------
  # SSH AGENT CONFIGURATION (System-Level)
  # ----------------------------------------------------------------------------
  # 1Password kann als SSH Agent fungieren und SSH Keys verwalten
  # Dies wird pro-User in home-manager konfiguriert (siehe unten)
  # Hier setzen wir nur globale Voraussetzungen
  
  # Keine zusätzliche System-Konfiguration nötig für SSH Agent
  # Die Socket-Konfiguration erfolgt im Home Manager

  # ----------------------------------------------------------------------------
  # KEYRING SUPPORT
  # ----------------------------------------------------------------------------
  # 1Password benötigt einen Keyring-Service für:
  # - 2FA Token Speicherung
  # - Session Persistence
  # - Sichere Credential Storage
  #
  # Wähle einen Keyring-Provider basierend auf deiner Desktop-Umgebung:

  # Option A: GNOME Keyring (für GNOME, oder als standalone)
  # services.gnome.gnome-keyring.enable = true;

  # Option B: KDE Wallet (für KDE Plasma)
  # Wird automatisch aktiviert wenn plasma6.enable = true ist
  # services.desktopManager.plasma6.enable = true;

  # Option C: Für minimale Setups ohne DE (wie Hyprland)
  # 1Password kann auch ohne Keyring arbeiten, aber 2FA Token
  # werden dann nur für die aktuelle Session gespeichert

  # ----------------------------------------------------------------------------
  # WAYLAND/HYPRLAND SPECIFIC CONFIGURATION
  # ----------------------------------------------------------------------------
  # Bei Wayland (besonders Hyprland) können Authentifizierungs-Prompts
  # manchmal nicht erscheinen. Fixes:
  
  # 1. XDG Desktop Portal (bereits in deiner Hyprland-Config empfohlen)
  # xdg.portal = {
  #   enable = true;
  #   extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  # };

  # 2. Alternative: X11 Fallback für 1Password
  # Dies wird in der Home Manager Konfiguration gesetzt (exec-once)

  # ----------------------------------------------------------------------------
  # ENVIRONMENT VARIABLES
  # ----------------------------------------------------------------------------
  # Keine speziellen System-Level Environment Variables nötig
  # SSH_AUTH_SOCK wird pro-User in Home Manager gesetzt

  # ----------------------------------------------------------------------------
  # ADDITIONAL PACKAGES (Optional)
  # ----------------------------------------------------------------------------
  # Diese Pakete können hilfreich sein:
  environment.systemPackages = with pkgs; [
    # 1password-cli wird automatisch durch programs._1password installiert
    # aber kann auch hier explizit gelistet werden wenn gewünscht
  ];

  # ============================================================================
  # HOME MANAGER CONFIGURATION TEMPLATE
  # ============================================================================
  # Die folgende Konfiguration sollte in home.nix oder einer separaten
  # 1password Home Manager Datei platziert werden:
  #
  # { config, pkgs, ... }:
  # {
  #   # -------------------------------------------------------------------------
  #   # SHELL INTEGRATION
  #   # -------------------------------------------------------------------------
  #   programs.zsh = {
  #     # Source 1Password Shell Plugins (falls installiert via Flake)
  #     initExtra = ''
  #       # 1Password Shell Plugins werden automatisch geladen wenn via Flake installiert
  #     '';
  #   };
  #
  #   # -------------------------------------------------------------------------
  #   # SSH CONFIGURATION
  #   # -------------------------------------------------------------------------
  #   programs.ssh = {
  #     enable = true;
  #     extraConfig = ''
  #       # 1Password als SSH Agent nutzen
  #       Host *
  #         IdentityAgent ~/.1password/agent.sock
  #     '';
  #   };
  #
  #   # SSH_AUTH_SOCK Environment Variable
  #   home.sessionVariables = {
  #     SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";
  #   };
  #
  #   # -------------------------------------------------------------------------
  #   # GIT SSH SIGNING (Optional aber empfohlen)
  #   # -------------------------------------------------------------------------
  #   programs.git = {
  #     signing = {
  #       key = "ssh-ed25519 AAAA...";  # Dein Public Key aus 1Password
  #       signByDefault = true;
  #     };
  #     extraConfig = {
  #       gpg.format = "ssh";
  #       gpg.ssh.program = "${pkgs._1password-gui}/bin/op-ssh-sign";
  #     };
  #   };
  #
  #   # -------------------------------------------------------------------------
  #   # HYPRLAND INTEGRATION (Falls verwendet)
  #   # -------------------------------------------------------------------------
  #   wayland.windowManager.hyprland = {
  #     settings = {
  #       exec-once = [
  #         # Option A: Standard Start
  #         "1password --silent &"
  #         
  #         # Option B: Mit X11 Fallback (falls Prompts nicht erscheinen)
  #         # "1password --ozone-platform-hint=x11 --silent &"
  #       ];
  #     };
  #   };
  # }

  # ============================================================================
  # TROUBLESHOOTING TIPPS
  # ============================================================================
  # 
  # Problem: CLI Integration funktioniert nicht
  # Lösung:
  # 1. Prüfe dass polkitPolicyOwners korrekt gesetzt ist
  # 2. In 1Password App: Settings → Developer → "Integrate with 1Password CLI" aktivieren
  # 3. Check Socket: ls -la ~/.1password/ und ~/.config/1Password/
  #
  # Problem: Browser Extension verbindet nicht
  # Lösung:
  # 1. Stelle sicher Browser ist via NixOS installiert (nicht Flatpak!)
  # 2. Für Custom Browsers: custom_allowed_browsers konfigurieren
  # 3. 1Password App neustarten
  #
  # Problem: Prompts erscheinen nicht unter Hyprland
  # Lösung:
  # 1. Nutze --ozone-platform-hint=x11 beim Start
  # 2. Prüfe dass hyprpolkitagent läuft
  # 3. XDG Portal aktivieren
  #
  # Problem: 2FA Token wird nicht gespeichert
  # Lösung:
  # 1. services.gnome.gnome-keyring.enable = true; aktivieren
  # 2. ODER: KDE Wallet nutzen wenn KDE Desktop
  #
  # Debugging:
  # - Logs: journalctl --user -u 1password.service -f
  # - Verbose: 1password --verbose
  # - CLI Test: op account list
  # - Socket Check: ls -la ~/.1password/agent.sock
  # ============================================================================
}


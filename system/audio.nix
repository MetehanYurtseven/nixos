{ config, pkgs, ... }: {
  # PipeWire Audio Configuration
  # Best practices from NixOS Wiki and community configs
  
  services.pipewire = {
    enable = true;
    
    # ALSA Support
    alsa = {
      enable = true;
      support32Bit = true;  # Für 32-bit Anwendungen
    };
    
    # PulseAudio Kompatibilitätsschicht
    pulse.enable = true;
    
    # JACK Support (optional, für professionelle Audio-Anwendungen)
    jack.enable = false;
    
    # WirePlumber ist der Standard Session Manager (wird automatisch aktiviert)
    wireplumber.enable = true;
  };
  
  # RealtimeKit für Echtzeit-Priorität
  # Wichtig für niedrige Audio-Latenz
  security.rtkit.enable = true;
  
  # User-Packages für Audio-Management
  environment.systemPackages = with pkgs; [
    pwvucontrol      # PipeWire Volume Control (moderne GUI)
    pavucontrol      # PulseAudio Volume Control (Fallback)
    playerctl        # Media Player Control
  ];
}


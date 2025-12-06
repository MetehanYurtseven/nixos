{ config, pkgs, ... }: {
  services.pipewire = {
    enable = true;

    pulse.enable = true;
    jack.enable = false;
    wireplumber.enable = true;
    
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };
  
  # RealtimeKit
  security.rtkit.enable = true;
  
  environment.systemPackages = with pkgs; [
    pwvucontrol # PipeWire Volume Control
    playerctl # Media Player Control
  ];
}


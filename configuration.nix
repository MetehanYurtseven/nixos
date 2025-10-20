{ config, lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./pkgs.nix
    ./wifi.nix
    ./programs/1password.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "desktop";
  time.timeZone = "Europe/Berlin";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  services.openssh.enable = true;
  networking.firewall.enable = false;

  hardware.graphics.enable = true;
  hardware.amdgpu.opencl.enable = true;

  nixpkgs.config.allowUnfree = true;

  security.polkit.enable = true;

  # Allow all users in the wheel group to edit the nixos configuration
  systemd.tmpfiles.rules = [
    "d /etc/nixos 2775 root wheel -"
    "A+ /etc/nixos - - - - d:u::rwx,d:g::rwx,d:o::rx"
  ];

  users = {
    defaultUserShell = pkgs.zsh;
    users."metehan.yurtseven" = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDyY8tYHfwirh+GaWBb1MKtB8M/UiL9+Yz5FoFqw4qBEEMJIpfXiS5W9qYD8ghbEa0QhpwEEqSkk2lfKUA3dR5ncKquZ3AtUIfYTjR5B4nCYBqmfcObVgLW9O0H0AjopUJRVSmXDFZEy9Ts4iAlcKpu4qM9pmaFleEq71A2Ud3lKU340chLxd0QjsPgbpwprXqBOAh2Wg1K8zej+L3/FUHco+4X3bgFXkdP0BsHWWQbKAxObPKaccAuJQg2PLcXIVOz+VHxqvijKqXw3jgzzkWAW9ynhrVLmbYYX9/sd3mY0oP+WXxiJ0tIacKCojlFxqkdoU9OtXOTe3S6TRKWzq0oRzhHfmLGubANev2mgrXlNPzxOJvKWFZQsKURjgxQjxu1Fgt9VxgRmSniIJl/s1QUnVobdnhoZk4sZu3fXFSXAMb3V6Za54s5aKYU9t7Xh066OzqRgtGeWerjbQ/LmdbOzrXUD4Zyp3xQzYduB/SxXzS3gLBFfTePHHMnWNO68jkUDghRvdBGDA4rr4tnQFUnde6y5nU4LKeZ+TRfA9rnJlALpJxNXSBtnKidouTxq7B0GzWEh8nSxDRoWG1qwpXYuGzcclVVg7IUIhKrmmo3VqOVdrwK54rRJzQONL8zoK/ZrxUDY88a6UgnXC3d656KgSu6/rGBPW1YCo21yjdBrw=="
      ];
    };
  };

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
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    configure = {
      customRC = ''
        set relativenumber
        set tabstop=2
        set shiftwidth=2
        set expandtab
        set softtabstop=2
      '';
    };
  };
  
  environment.sessionVariables.FZF_DEFAULT_OPTS = "--layout reverse";
  environment.pathsToLink = [ "/share/zsh" ];

  system.stateVersion = "25.05";
}

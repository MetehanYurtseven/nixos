{
  description = "NixOS Configuration with Home Manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aish = {
      url = "git+file:/home/metehan.yurtseven/repos/aish?ref=master&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, aish, ... }:
    let
      settings = import ./settings.nix;
    in
    {
      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit aish; };
        modules = [
          ./hosts/desktop/configuration.nix # NixOS Configuration
          sops-nix.nixosModules.sops # Sops for NixOS
          home-manager.nixosModules.home-manager # Home Manager for NixOS
          { # Home Manager Configuration
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${settings.user.username} = import ./hosts/desktop/home.nix;
          }
          # Custom packages overlay
          {
            nixpkgs.overlays = [
              (final: prev: {
                sf-mono-nerd-font = final.callPackage ./pkgs/sf-mono-nerd-font {};
                sf-pro-nerd-font = final.callPackage ./pkgs/sf-pro-nerd-font {};
              })
            ];
          }
        ];
      };
    };
}


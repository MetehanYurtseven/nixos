{
  description = "NixOS Configuration with Home Manager";

  # Cachix für Vicinae - wird SOFORT beim Flake-Eval aktiv!
  nixConfig = {
    extra-substituters = [ "https://vicinae.cachix.org" ];
    extra-trusted-public-keys = [ "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc=" ];
  };

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

    vicinae.url = "github:vicinaehq/vicinae";
    
    aish = {
      url = "git+file:/home/metehan.yurtseven/repos/aish?ref=master&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, vicinae, aish, ... }:
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
            home-manager.sharedModules = [ vicinae.homeManagerModules.default ];
            home-manager.users.${settings.user.username} = import ./hosts/desktop/home.nix;
          }
        ];
      };
    };
}


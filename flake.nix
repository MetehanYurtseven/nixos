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

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, sops-nix, aish, nixvim, ... }:
    let
      settings = import ./settings.nix;
    in
    {
      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit aish; };
        modules = [
          ./hosts/desktop/configuration.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          nixvim.nixosModules.nixvim
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${settings.user.username} = import ./hosts/desktop/home.nix;
          }
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


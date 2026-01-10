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

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rwpspread = {
      url = "github:MetehanYurtseven/rwpspread?ref=hyprpaper-cleanup";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      sops-nix,
      rwpspread,
      nixvim,
      ...
    }:
    let
      settings = import ./settings.nix;
    in
    {
      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit rwpspread settings; };
        modules = [
          ./hosts/desktop/configuration.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          nixvim.nixosModules.nixvim
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit settings; };
            home-manager.users.${settings.user.username} = import ./hosts/desktop/home.nix;
          }
          {
            nixpkgs.overlays = [
              (final: prev: {
                sf-mono-nerd-font = final.callPackage ./pkgs/sf-mono-nerd-font { };
                sf-pro-nerd-font = final.callPackage ./pkgs/sf-pro-nerd-font { };
                hyprvoice = final.callPackage ./pkgs/hyprvoice { };
                kitty-scrollback-nvim = final.callPackage ./pkgs/kitty-scrollback-nvim { };
                copilot-api = final.callPackage ./pkgs/copilot-api { };
                rwpspread = rwpspread.packages.${final.stdenv.hostPlatform.system}.default;
              })
            ];
          }
        ];
      };
    };
}

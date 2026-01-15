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

    tts-cli = {
      url = "git+file:///home/metehan.yurtseven/repos/tts-cli?ref=main&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      sops-nix,
      rwpspread,
      nixvim,
      tts-cli,
      ...
    }:
    let
      settings = import ./settings.nix;
    in
    {
      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit settings; };
        # NixOS Modules
        modules = [
          ./hosts/desktop/configuration.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          nixvim.nixosModules.nixvim
          {
            # Home Manager
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit settings; };
            home-manager.users.${settings.user.username} = import ./hosts/desktop/home.nix;
          }
          {
            # Custom Packages
            nixpkgs.overlays = [
              (final: prev: {
                sf-mono-nerd-font = final.callPackage ./pkgs/sf-mono-nerd-font { };
                sf-pro-nerd-font = final.callPackage ./pkgs/sf-pro-nerd-font { };
                hyprvoice = final.callPackage ./pkgs/hyprvoice { };
                kitty-scrollback-nvim = final.callPackage ./pkgs/kitty-scrollback-nvim { };
                copilot-api = final.callPackage ./pkgs/copilot-api { };
                rwpspread = rwpspread.packages.${final.stdenv.hostPlatform.system}.default;
                tts-cli = tts-cli.packages.${final.stdenv.hostPlatform.system}.default;
              })
            ];
          }
          {
            # Set system label and git revision as generation
            system.nixos.label = nixpkgs.lib.mkForce (
              let
                rev = self.rev or "dirty";
                shortRev = self.shortRev or (builtins.substring 0 7 rev);
                date = self.lastModifiedDate or "unknown";
                formattedDate = builtins.substring 0 8 date;
              in
              "${formattedDate}-${shortRev}"
            );
            system.configurationRevision = self.rev or "dirty";
          }
        ];
      };
    };
}

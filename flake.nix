{
  description = "NixOS configuration for Dell Inspiron 15 3525";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Hermes Agent - provides packages, a NixOS module and a Home Manager module.
    hermes-agent = {
      url = "github:NousResearch/hermes-agent";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Zen Browser (not packaged in nixpkgs).
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # OneNote Linux desktop client.
    onenote-linux = {
      url = "github:Baustinlynch/onenote-linux";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Helium Browser (not packaged in nixpkgs).
    helium = {
      url = "github:oxcl/nix-flake-helium-browser";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Slick, a Slack client mod (bring your own Slack).
    slick = {
      url = "github:3kh0/slick";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Stylix theming.
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      hermes-agent,
      zen-browser,
      onenote-linux,
      helium,
      slick,
      stylix,
      ...
    }:
    let
      system = "x86_64-linux";
    in
    {
      # Formatter for nix files
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;

      # Checks run by `nix flake check`
      checks.${system} = {
        toplevel = self.nixosConfigurations.laptop.config.system.build.toplevel;
      };

      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/laptop/configuration.nix
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = [ hermes-agent.overlays.default ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.brenden = {
              imports = [
                hermes-agent.homeManagerModules.default
                ./home
              ];
            };
          }
          # Zen Browser comes from its own flake (not in nixpkgs).
          # Slick, a Slack client mod (bring your own Slack).
          # Function module: `pkgs` is the system pkgs instance, which has
          # allowUnfree set (below and in configuration.nix).
          ({ pkgs, ... }: {
            nixpkgs.config.allowUnfree = true;
            environment.systemPackages = [
              zen-browser.packages.${system}.default
              onenote-linux.packages.${system}.default
              helium.packages.${system}.default
              slick.packages.${system}.default
              pkgs.qdirstat
              pkgs.pandoc
              pkgs.slack
            ];
          })
        ];
      };

      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/desktop/configuration.nix
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = [ hermes-agent.overlays.default ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.brenden = {
              imports = [
                hermes-agent.homeManagerModules.default
                ./home
              ];
            };
          }
          # Zen Browser comes from its own flake (not in nixpkgs).
          ({ pkgs, ... }: {
            nixpkgs.config.allowUnfree = true;
            environment.systemPackages = [
              zen-browser.packages.${system}.default
              onenote-linux.packages.${system}.default
              helium.packages.${system}.default
              slick.packages.${system}.default
              pkgs.qdirstat
              pkgs.pandoc
              pkgs.slack
            ];
          })
        ];
      };
    };
}
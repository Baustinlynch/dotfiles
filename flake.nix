{
  description = "NixOS configuration for Dell Inspiron 15 3525";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Hermes Agent - provides packages, a NixOS module and a Home Manager module.
    hermes-agent.url = "github:NousResearch/hermes-agent";
    # Zen Browser (not packaged in nixpkgs).
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = { self, nixpkgs, home-manager, hermes-agent, zen-browser, ... }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/laptop/configuration.nix
          home-manager.nixosModules.home-manager
          {
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
          {
            environment.systemPackages = [
              zen-browser.packages.${system}.default
            ];
          }
        ];
      };
    };
}

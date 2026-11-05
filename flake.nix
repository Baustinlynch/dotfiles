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
    # LLM Agents - provides Ori CLI and coding agents (Claude Code, OpenCode, etc.)
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Nix User Repository - provides community packages not in nixpkgs.
    nur = {
      url = "github:nix-community/nur";
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
      llm-agents,
      nur,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # Slick pins its node-modules hash in packaging/nix/pins.json. Upstream's
      # committed hash sometimes doesn't match the actual `bun install` output,
      # causing a fixed-output hash mismatch on rebuild (verified mismatch at
      # slick rev 7237dffe). We patch pins.json with the real hash so `slick-fixed`
      # builds even when `nix flake update` bumps the slick input.
      slickSrc = builtins.fetchGit {
        url = "https://github.com/3kh0/slick";
        rev = "7237dffe1f71c75370a10654c3ac6941e44952b9";
        narHash = "sha256-e77PaCLJa0NqnRHrQEvgmmG7lI+J39yjvefBlnLiqzs=";
      };
      # Create corrected pins.json using writeText to avoid sandbox permission issues
      correctedPins = pkgs.writeText "corrected-pins.json" ''
        {
          "build": 144,
          "electron": 43,
          "nodeModulesHash": "sha256-Bw1wYMOcdV1ECzVfdyu6NBcTI9v2H/YwYJR7Lu4YvP0="
        }
      '';
      slickSrcPatched = pkgs.runCommand "slick-src-patched" { } ''
        cp -r ${slickSrc}/. $out/
        chmod -R u+w $out
        printf '%s\n' '{' '  "build": 144,' '  "electron": 43,' '  "nodeModulesHash": "sha256-Bw1wYMOcdV1ECzVfdyu6NBcTI9v2H/YwYJR7Lu4YvP0="' '}' > $out/packaging/nix/pins.json
      '';
      slick-fixed = pkgs.callPackage (slickSrcPatched + "/packaging/nix") {
        src = slickSrcPatched;
      };
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
          nur.modules.nixos.default
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
              slick-fixed
              llm-agents.packages.${system}.ori
              nur.legacyPackages.x86_64-linux.repos.mio.autodesk-fusion-360
              pkgs.qdirstat
              pkgs.pandoc
              pkgs.rpi-imager
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
          nur.modules.nixos.default
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
              slick-fixed
              llm-agents.packages.${system}.ori
              nur.legacyPackages.x86_64-linux.repos.mio.autodesk-fusion-360
              pkgs.qdirstat
              pkgs.pandoc
              pkgs.rpi-imager
              pkgs.slack
            ];
          })
        ];
      };
    };
}
{
  description = "brenden's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      lib = pkgs.lib;
      username = "brenden";
      hostName = "nixos";
    in
    {
      nixosConfigurations = {
        ${hostName} = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ({ config, pkgs, ... }: {
              imports = [
                ./system/base.nix
                ./system/desktop.nix
                ./system/hardware.nix
                ./system/networking.nix
                ./system/users.nix
                ./system/services.nix
                ./home/home.nix
              ];
              # Host-specific overrides
              networking.hostName = hostName;
              users.users.${username} = {
                isNormalUser = true;
                extraGroups = [ "wheel" "networkmanager" "video" "audio" "docker" "libvirt" "kvm" "render" ];
                packages = with pkgs; [
                  # User packages (also available via home-manager)
                ];
              };
            })
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = import ./home/home.nix { inherit pkgs lib username; };
            }
          ];
        };
      };

      # Helper for nixos-rebuild
      nixosConfigurations.${hostName}.config.system.build.toplevel = nixosConfigurations.${hostName}.config.system.build.toplevel;
    };
}
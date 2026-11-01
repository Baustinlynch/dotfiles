{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;

  # System packages that need to be available globally (not just user)
  environment.systemPackages = with pkgs; [
    # docker-compose is included in docker package
  ];
}
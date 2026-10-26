{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    git
    gh
    docker-compose
    vim
    neovim
    wget
    curl
    htop
    ripgrep
    fd
    gcc
    gnumake
    python3
    nodejs_22
    go
    rustup
  ];
}

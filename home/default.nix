{ config, pkgs, ... }:

{
  home.username = "brenden";
  home.homeDirectory = "/home/brenden";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "brenden";
    userEmail = "brenden@example.com";
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      g = "git";
      rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles#laptop";
    };
    interactiveShellInit = ''
      set -g fish_greeting ""
      # Add cargo/npm-style user bins if they exist.
      fish_add_path --global ~/.local/bin
    '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

  # Hermes Agent CLI (Home Manager module imported in flake.nix).
  # First run: `hermes setup` to add API keys. Do NOT also enable
  # services.hermes-agent here unless you want the persistent gateway daemon.
  programs.hermes-agent.enable = true;

  home.packages = with pkgs; [
    firefox
  ];
}

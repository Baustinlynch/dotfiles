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

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

  home.packages = with pkgs; [
    firefox
  ];
}

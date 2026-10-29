{ config, pkgs, ... }:

{
  home.username = "brenden";
  home.homeDirectory = "/home/brenden";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings.user.name = "brenden";
    settings.user.email = "brenden@brenden.zip";
  };

  # GitHub CLI: let git use gh's stored OAuth token as a credential helper.
  # (Keeps ~/.config/git/config managed by Home Manager; gh must not try
  # to rewrite that read-only store file itself.)
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings = {
      git_protocol = "https";
    };
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      g = "git";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#laptop";
      secrets = "cd ~/nixos-config; and gitleaks git . --redact --no-banner -v";
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

  programs.obsidian = {
    enable = true;
    vaults.personal.target = "Documents/Obsidian";
  };

  home.packages = with pkgs; [
    firefox
    btop
    gitleaks
    lunar-client
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    fontconfig
  ];

  # --- Dotfiles (real files in ../dotfiles/, symlinked in by Home Manager) ---
  # Static: edit file + `git add` + rebuild to apply.
  xdg.configFile."waybar/config".source     = ../dotfiles/waybar/config;
  xdg.configFile."waybar/style.css".source  = ../dotfiles/waybar/style.css;
  xdg.configFile."fuzzel/fuzzel.ini".source = ../dotfiles/fuzzel/fuzzel.ini;
  xdg.configFile."mako/config".source       = ../dotfiles/mako/config;

  # Mutable: out-of-store symlink, so the app writes back into the repo.
  # Content is NOT captured by the Nix generation (rollback won't restore it).
  xdg.configFile."waypaper/config.ini" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos-config/dotfiles/waypaper/config.ini";
    force = true;
  };
  xdg.configFile."zed/settings.json" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos-config/dotfiles/zed/settings.json";
    force = true;
  };
  xdg.configFile."obsidian/obsidian.json" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos-config/dotfiles/obsidian/obsidian.json";
    force = true;
  };

  fonts.fontconfig.enable = true;
}

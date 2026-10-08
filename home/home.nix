{ config, pkgs, lib, username, ... }:

{
  imports = [
    ./packages.nix
    ./programs.nix
    ./files.nix
    ./services.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Home directory setup
  home.file.".config".source = null;

  # Session environment (for graphical sessions)
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "bat";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_STYLE_OVERRIDE = "kvantum";
    GTK_THEME = "Adwaita:dark";
    ICON_THEME = "Papirus-Dark";
    CURSOR_THEME = "Bibata-Modern-Ice";
    XDG_CURRENT_DESKTOP = "bspwm";
    XDG_SESSION_DESKTOP = "bspwm";
    XDG_SESSION_TYPE = "x11";
    _JAVA_AWT_WM_NONREPARENTING = 1;
    MOZ_ENABLE_WAYLAND = 1;
    MOZ_DBUS_REMOTE = 1;
  };

  # XDG directories
  xdg = {
    enable = true;
    userDirs = {
      DESKTOP = "Desktop";
      DOWNLOAD = "Downloads";
      TEMPLATES = "Templates";
      PUBLICSHARE = "Public";
      DOCUMENTS = "Documents";
      MUSIC = "Music";
      PICTURES = "Pictures";
      VIDEOS = "Videos";
    };
  };

  # Shell
  programs = {
    zsh = {
      enable = true;
      ohMyZsh = {
        enable = true;
        theme = "agnoster";
        plugins = [
          "git"
          "sudo"
          "command-not-found"
          "zsh-autosuggestions"
          "zsh-syntax-highlighting"
          "fzf"
          "zoxide"
          "eza"
          "bat"
          "delta"
          "docker"
          "docker-compose"
          "kubectl"
          "rust"
          "cargo"
          "python"
          "pip"
          "poetry"
          "virtualenv"
        ];
      };
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;
      completions.enable = true;
      shellAliases = {
        ls = "eza --icons";
        ll = "eza -l --icons";
        la = "eza -la --icons";
        lt = "eza --tree --icons";
        cat = "bat";
        grep = "rg";
        find = "fd";
        du = "dust";
        ps = "procs";
        top = "btop";
        vim = "nvim";
        vi = "nvim";
        nixos-rebuild-switch = "sudo nixos-rebuild switch --flake ~/Documents/nixos-config#nixos";
        nixos-rebuild-test = "sudo nixos-rebuild test --flake ~/Documents/nixos-config#nixos";
        nixos-rebuild-boot = "sudo nixos-rebuild boot --flake ~/Documents/nixos-config#nixos";
        nixos-update = "sudo nix flake update ~/Documents/nixos-config && sudo nixos-rebuild switch --flake ~/Documents/nixos-config#nixos";
        hm-switch = "home-manager switch --flake ~/Documents/nixos-config#${username}";
        gc = "nix-collect-garbage -d && sudo nix-collect-garbage -d";
      };
    };

    fish = {
      enable = true;
      shellAbbr = {
        ls = "eza --icons";
        ll = "eza -l --icons";
        la = "eza -la --icons";
        lt = "eza --tree --icons";
        cat = "bat";
        grep = "rg";
        find = "fd";
        du = "dust";
        ps = "procs";
        top = "btop";
        vim = "nvim";
        vi = "nvim";
        ns = "sudo nixos-rebuild switch --flake ~/Documents/nixos-config#nixos";
        nt = "sudo nixos-rebuild test --flake ~/Documents/nixos-config#nixos";
        nb = "sudo nixos-rebuild boot --flake ~/Documents/nixos-config#nixos";
        nu = "sudo nix flake update ~/Documents/nixos-config && sudo nixos-rebuild switch --flake ~/Documents/nixos-config#nixos";
        hs = "home-manager switch --flake ~/Documents/nixos-config#${username}";
        gc = "nix-collect-garbage -d && sudo nix-collect-garbage -d";
      };
    };

    bash.enable = true;
  };
}
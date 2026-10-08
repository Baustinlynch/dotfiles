{ config, pkgs, lib, username, ... }:

let
  dots = "/home/${username}/Documents/dots/config";
  dotfiles = "/home/${username}/Documents/dots/dotfiles";
in
{
  # XDG config files managed via home-manager
  # Using mkOutOfStoreSymlink for configs that:
  # - Are complex / script-heavy (waybar, niri, picom, rofi)
  # - Are rewritten by the app at runtime (btop, neovim lock files)
  # - Have custom scripts that reference system tools
  xdg.configFile = {
    # Configs that live in Documents/dots and are edited in place
    "btop/btop.conf" = {
      source = pkgs.lib.mkOutOfStoreSymlink "${dots}/btop/btop.conf";
      # btop rewrites its config on exit, needs writable target
    };

    "waybar" = {
      source = pkgs.lib.mkOutOfStoreSymlink "${dots}/waybar";
      recursive = true;
    };

    "niri" = {
      source = pkgs.lib.mkOutOfStoreSymlink "${dots}/niri";
      recursive = true;
    };

    "picom" = {
      source = pkgs.lib.mkOutOfStoreSymlink "${dots}/picom.conf";
    };

    "rofi" = {
      source = pkgs.lib.mkOutOfStoreSymlink "${dots}/rofi";
      recursive = true;
    };

    "wlogout" = {
      source = pkgs.lib.mkOutOfStoreSymlink "${dots}/wlogout";
      recursive = true;
    };

    "fuzzel" = {
      source = pkgs.lib.mkOutOfStoreSymlink "${dots}/fuzzel";
      recursive = true;
    };

    "mako" = {
      source = pkgs.lib.mkOutOfStoreSymlink "${dots}/mako";
      recursive = true;
    };

    "swaylock" = {
      source = pkgs.lib.mkOutOfStoreSymlink "${dots}/swaylock";
      recursive = true;
    };

    "swayidle" = {
      source = pkgs.lib.mkOutOfStoreSymlink "${dots}/swayidle/config";
    };

    "dunst" = {
      source = pkgs.lib.mkOutOfStoreSymlink "${dots}/dunst/dunstrc";
    };

    "kitty" = {
      source = pkgs.lib.mkOutOfStoreSymlink "${dots}/kitty";
      recursive = true;
    };

    "alacritty" = {
      source = pkgs.lib.mkOutOfStoreSymlink "${dots}/alacritty";
      recursive = true;
    };

    "fish" = {
      source = pkgs.lib.mkOutOfStoreSymlink "${dots}/fish";
      recursive = true;
    };

    "ranger" = {
      source = pkgs.lib.mkOutOfStoreSymlink "${dots}/ranger";
      recursive = true;
    };

    "thunar" = {
      source = pkgs.lib.mkOutOfStoreSymlink "${dots}/Thunar";
      recursive = true;
    };

    "gtk-3.0" = {
      source = pkgs.lib.mkOutOfStoreSymlink "${dots}/gtk-3.0";
      recursive = true;
    };

    "gtk-4.0" = {
      source = pkgs.lib.mkOutOfStoreSymlink "${dots}/gtk-4.0";
      recursive = true;
    };

    "qt5ct" = {
      source = pkgs.lib.mkOutOfStoreSymlink "${dots}/qt5ct";
      recursive = true;
    };

    "qt6ct" = {
      source = pkgs.lib.mkOutOfStoreSymlink "${dots}/qt6ct";
      recursive = true;
    };

    "Kvantum" = {
      source = pkgs.lib.mkOutOfStoreSymlink "${dots}/Kvantum";
      recursive = true;
    };

    "ncmpcpp" = {
      source = pkgs.lib.mkOutOfStoreSymlink "${dots}/ncmpcpp/config";
    };

    "mpd" = {
      source = pkgs.lib.mkOutOfStoreSymlink "${dots}/mpd/mpd.conf";
    };

    "environment.d" = {
      source = pkgs.lib.mkOutOfStoreSymlink "${dots}/environment.d";
      recursive = true;
    };

    "systemd/user" = {
      source = pkgs.lib.mkOutOfStoreSymlink "${dots}/systemd/user";
      recursive = true;
    };

    # Configs managed by home-manager native modules (generated in store)
    # "git" = "";  # managed by programs.git
    # "tmux" = ""; # managed by programs.tmux
    # "starship" = ""; # managed by programs.starship
    # "zoxide" = ""; # managed by programs.zoxide
    # "fzf" = ""; # managed by programs.fzf
    # "dunst" = ""; # managed by programs.dunst
    # "btop" = ""; # managed by programs.btop
    # "yazi" = ""; # managed by programs.yazi
    # "ranger" = ""; # managed by programs.ranger
    # "neovim" = ""; # managed by programs.neovim
    # "bat" = ""; # managed by programs.bat
    # "delta" = ""; # managed by programs.delta
    # "eza" = ""; # managed by programs.eza
    # "direnv" = ""; # managed by programs.direnv
    # "atuin" = ""; # managed by programs.atuin
  };

  # Home directory files (non-XDG)
  home.file = {
    # Git config - safe to manage (no secrets in current config)
    ".gitconfig" = pkgs.lib.mkOutOfStoreSymlink "${dotfiles}/.gitconfig";

    # Shell configs - NOT managed yet (keeping custom omz setup)
    # ".zshrc" = pkgs.lib.mkOutOfStoreSymlink "${dotfiles}/.zshrc";
    # ".zshenv" = pkgs.lib.mkOutOfStoreSymlink "${dotfiles}/.zshenv";

    # Vim config - NOT managed (neovim is primary)
    # ".vimrc" = pkgs.lib.mkOutOfStoreSymlink "${dotfiles}/.vimrc";
    # ".vim_runtime" = pkgs.lib.mkOutOfStoreSymlink "${dotfiles}/.vim_runtime";

    # Local bin scripts
    ".local/bin/env" = pkgs.lib.mkOutOfStoreSymlink "${dotfiles}/local_bin/env";
    ".local/bin/env.fish" = pkgs.lib.mkOutOfStoreSymlink "${dotfiles}/local_bin/env.fish";
    ".local/bin/free-claude-code" = pkgs.lib.mkOutOfStoreSymlink "${dotfiles}/local_bin/free-claude-code";
    ".local/bin/steam" = pkgs.lib.mkOutOfStoreSymlink "${dotfiles}/local_bin/steam";

    # Local share
    ".local/share/applications" = pkgs.lib.mkOutOfStoreSymlink "${dotfiles}/local_share/applications";

    # SSH config (if you want to manage it)
    # ".ssh/config" = pkgs.lib.mkOutOfStoreSymlink "${dotfiles}/.ssh/config";

    # GPG config
    # ".gnupg/gpg.conf" = pkgs.lib.mkOutOfStoreSymlink "${dotfiles}/.gnupg/gpg.conf";
    # ".gnupg/gpg-agent.conf" = pkgs.lib.mkOutOfStoreSymlink "${dotfiles}/.gnupg/gpg-agent.conf";

    # Starship config (if not using native module)
    # ".config/starship.toml" = pkgs.lib.mkOutOfStoreSymlink "${dots}/starship.toml";
  };

  # Explicitly EXCLUDED from management (secrets, state, browser profiles)
  # - gh/hosts.yml (contains OAuth token)
  # - wakatime.cfg (contains API key)
  # - ~/.ssh/ (keys)
  # - zen/ (browser profile)
  # - .var/ (flatpak data)
  # - vscode-user/ (stateful, has extensions)
  # - evolution/ (mail accounts)
  # - .config/opencode/ (state)
  # - .config/yay/ (config)
  # - .config/uv/ (state)
}
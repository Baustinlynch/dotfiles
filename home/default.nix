{ config, pkgs, ... }:

let
  # qcalc: terminal calculator (Rust crate, not packaged in nixpkgs).
  qcalc = pkgs.rustPlatform.buildRustPackage rec {
    pname = "qcalc";
    version = "0.15.4";
    src = pkgs.fetchCrate {
      inherit pname version;
      hash = "sha256-dQ9q15zXy7FcfNpKgF22sVJVdX9khzFAMUDxKGbJxJQ=";
    };
    cargoHash = "sha256-UuKmea0SZ4VdA6BJ6czV5nh/6INp5n4yD+x818RQSbU=";
    doCheck = false;
  };
in
{
  home.username = "brenden";
  home.homeDirectory = "/home/brenden";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  # Stylix: disable targets whose config files we manage manually (static or
  # mutable dotfiles) to avoid conflicting declarations.
  stylix.targets.alacritty.enable = true;
  stylix.targets.waybar.enable = true;
  stylix.targets.fuzzel.enable = false;
  stylix.targets.mako.enable = false;
  stylix.targets.btop.enable = false;
  stylix.targets.obsidian.enable = false;
  stylix.targets.zed.enable = false;

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

  # Fish config: split rebuild/update, guard hyfetch to login shells only
  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      g = "git";
      rebuild = "cd ~/nixos-config; and git pull; and git add .; and sudo nixos-rebuild switch --flake ~/nixos-config#laptop";
      secrets = "cd ~/nixos-config; and gitleaks git . --redact --no-banner -v";
      c = "clear; and hyfetch";
    };
    interactiveShellInit = ''
      set -g fish_greeting ""
      # ~/.local/bin is now on PATH via home.sessionPath
      # Launch hyfetch only on login shells (not every tmux pane/nested shell),
      # and only when the terminal is alacritty (dotfiles/alacritty sets TERM=alacritty).
      if status is-login; or string match -q "*alacritty*" "$TERM"
        hyfetch
      end
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
  programs.hermes-agent = {
    enable = true;
    desktop.enable = true; # Electron desktop app + XDG launcher
  };

  programs.obsidian = {
    enable = true;
    vaults.personal.target = "Documents/Obsidian";
  };

  home.packages = with pkgs; [
    tor-browser
    btop
    gitleaks
    wtype
    macchina
    nil
    nixd
    lunar-client
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    fontconfig
    spotify
    awww # waypaper backend
    hyfetch # shell greeting (fish alias 'c')
    # opencode-desktop
    # opencode # CLI (ai coding agent for the terminal)
    #   ^ Temporarily disabled: nixpkgs-unstable opencode 2.2.5 hangs rebuilding
    #   `opencode-node_modules` (bun install needs network during build; broken on
    #   this TLS-intercepted network, see NixOS/nixpkgs#582673). Re-add once fixed
    #   or install opencode standalone via `nix run github:anomalyco/opencode`.
    teams-for-linux
    rpm
    # Dev tools (moved from dev.nix)
    vim
    neovim
    wget
    curl
    htop
    ripgrep
    fd
    jq
    gcc
    gnumake
    python3
    nodejs_22
    go
    rustup
    qcalc
  ];

  # --- Dotfiles (real files in ../dotfiles/, symlinked in by Home Manager) ---
  # Static: edit file + `git add` + rebuild to apply.
  # Enable Home Manager's waybar module so Stylix can generate a themed style.css.
  programs.waybar.enable = true;
  programs.waybar.systemd.enable = false;
  xdg.configFile."waybar/config".source = ../dotfiles/waybar/config;
  xdg.configFile."fuzzel/fuzzel.ini".source = ../dotfiles/fuzzel/fuzzel.ini;
  xdg.configFile."mako/config".source = ../dotfiles/mako/config;
  xdg.configFile."niri/config.kdl".source = ../dotfiles/niri/config.kdl;
  programs.alacritty.enable = true;
  programs.alacritty.package = null;
  programs.alacritty.settings = {
    general = {
      import = [];
      live_config_reload = true;
    };
    terminal.shell = { program = "fish"; };
    env.TERM = "alacritty";
    window = {
      padding = { x = 6; y = 6; };
      decorations = "None";
      dynamic_title = true;
    };
    scrolling.history = 10000;
    cursor.style = { shape = "Block"; blinking = "On"; };
    keyboard.bindings = [
      { key = "Return"; mods = "Control|Shift"; action = "CreateNewWindow"; }
    ];
  };
  xdg.configFile."mimeapps.list".source = ../dotfiles/mimeapps.list;
  xdg.configFile."hyfetch.json".source = ../dotfiles/hyfetch.json;

  # Mutable: out-of-store symlink, so the app writes back into the repo.
  # Content is NOT captured by the Nix generation (rollback won't restore it).
  xdg.configFile."waypaper/config.ini" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/waypaper/config.ini";
    force = true;
  };
  xdg.configFile."zed/settings.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/zed/settings.json";
    force = true;
  };
  xdg.configFile."obsidian/obsidian.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/obsidian/obsidian.json";
    force = true;
  };
  xdg.configFile."btop/btop.conf" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/btop/btop.conf";
    force = true;
  };
  xdg.configFile."btop/themes/catppuccin_frappe.theme" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/btop/themes/catppuccin_frappe.theme";
    force = true;
  };

  # Desktop entries
  xdg.configFile."applications/dev.slick.Slick.desktop".source =
    ../dotfiles/applications/dev.slick.Slick.desktop;

  fonts.fontconfig.enable = true;

  # Put ~/.local/bin on PATH for all sessions (GUI apps, non-interactive shells)
  home.sessionPath = [ "$HOME/.local/bin" ];

  # (systemd user units are managed by systemd.user.services above, which
  # writes them as xdg.configFile entries — do not disable them here.)

  # User systemd services (raw-unit style required by the pinned Home Manager:
  # sections are Unit/Service/Install with systemd's capitalized keys).
  systemd.user.services = {
    waybar = {
      Unit.Description = "Waybar status bar";
      Service = {
        ExecStart = "${pkgs.waybar}/bin/waybar";
        Restart = "on-failure";
        RestartSec = 2;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    awww-daemon = {
      Unit.Description = "awww wallpaper daemon";
      Service = {
        ExecStart = "${pkgs.awww}/bin/awww-daemon";
        Restart = "on-failure";
        RestartSec = 2;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    waypaper = {
      Unit.Description = "Waypaper wallpaper restore";
      # Don't attempt the restore until the awww daemon is up — it hangs otherwise.
      Unit.After = [ "awww-daemon.service" ];
      Unit.Wants = [ "awww-daemon.service" ];
      Service = {
        Type = "oneshot";
        RemainAfterExit = true;
        # Retry so the session (outputs, sockets) has time to settle after login.
        ExecStart = "${pkgs.bash}/bin/bash -lc 'for i in 1 2 3 4 5; do ${pkgs.waypaper}/bin/waypaper --restore && break; sleep 2; done'";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    "hermes-gateway" = {
      Unit.Description = "Hermes Agent gateway daemon";
      # user must run `hermes setup` first
      Service = {
        ExecStart = "${pkgs.hermes-agent}/bin/hermes gateway";
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    "nixos-config-update-check" = {
      Unit.Description = "Check the NixOS config repository for remote updates";
      Service = {
        Type = "oneshot";
        Environment = [
          "HOME=${config.home.homeDirectory}"
          "PATH=/run/current-system/sw/bin:/etc/profiles/per-user/${config.home.username}/bin"
        ];
        ExecStart = "${config.home.homeDirectory}/.local/bin/check-nixos-config-updates";
      };
    };
  };

  systemd.user.timers = {
    "nixos-config-update-check" = {
      Unit.Description = "Check NixOS config updates after login and periodically";
      Unit.PartOf = [ "timers.target" ];
      Install.WantedBy = [ "timers.target" ];
      Timer = {
        OnBootSec = "3min";
        OnUnitInactiveSec = "30min";
        AccuracySec = "1min";
        Unit = "nixos-config-update-check.service";
      };
    };
  };

  # Update check script (was ~/.local/bin/check-nixos-config-updates)
  home.file.".local/bin/check-nixos-config-updates" = {
    executable = true;
    text = ''
      #!/run/current-system/sw/bin/sh
      set -eu

      repo="$HOME/nixos-config"
      git -C "$repo" fetch --quiet
      upstream=$(git -C "$repo" rev-parse --abbrev-ref --symbolic-full-name '@{upstream}')
      count=$(git -C "$repo" rev-list --count "HEAD..$upstream")

      if [ "$count" -gt 0 ]; then
          summary="$count new commit(s) on $upstream. Review ~/nixos-config; nothing was applied."
          /run/current-system/sw/bin/busctl --user call \
              org.freedesktop.Notifications /org/freedesktop/Notifications \
              org.freedesktop.Notifications Notify susssasa{sv}i \
              "NixOS config update check" 0 "" "Config updates available" "$summary" 0 0 >/dev/null
          printf '%s\n' "$summary"
      else
          printf 'No new commits on %s.\n' "$upstream"
      fi
    '';
  };


}

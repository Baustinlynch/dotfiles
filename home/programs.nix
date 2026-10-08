{ config, pkgs, lib, username, ... }:

{
  programs = {
    # Git
    git = {
      enable = true;
      userName = "Baustinlynch";
      userEmail = "brenden@users.noreply.github.com";
      aliases = {
        co = "checkout";
        st = "status";
        br = "branch";
        lg = "log --oneline --graph --decorate --all";
        ci = "commit";
        d = "diff";
        ds = "diff --staged";
        push = "push";
        pull = "pull";
        fetch = "fetch";
        merge = "merge";
        rebase = "rebase";
        amend = "commit --amend";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        visual = "!gitk";
      };
      delta = true;
      includes = [];
      signing = {
        signByDefault = false;
        gpgSign = false;
      };
      lfs.enable = true;
    };

    # Tmux
    tmux = {
      enable = true;
      plugins = with pkgs.tmuxPlugins; [
        tmux-yank
        tmux-cpu
        tmux-battery
        tmux-continuum
        tmux-resurrect
      ];
      clockMode = "24";
      baseIndex = 1;
      escapeTime = 0;
      focusEvents = true;
      historyLimit = 50000;
      mouse = true;
      prefix = "C-Space";
      terminalOverrides = "xterm-256color:Tc";
      statusRight = "#[fg=colour233,bg=colour241,bold] %d/%m #[fg=colour233,bg=colour245,bold] %H:%M:%S ";
      statusLeft = "#[fg=colour232,bg=colour154] #S ";
      windowStatusCurrentFormat = "#[fg=colour234,bg=colour39,bold] #I:#W#F ";
      windowStatusFormat = "#[fg=colour244,bg=colour234] #I:#W#F ";
    };

    # Starship
    starship = {
      enable = true;
      settings = {
        add_newline = true;
        prompt_order = [
          "username"
          "hostname"
          "directory"
          "git_branch"
          "git_status"
          "cmd_duration"
          "character"
        ];
        username = {
          show_always = true;
          format = "[$user](bold green) ";
          disabled = false;
        };
        hostname = {
          ssh_only = false;
          format = "[$hostname](bold blue) ";
          disabled = false;
        };
        directory = {
          truncation_length = 3;
          truncation_symbol = "…/";
          format = "[$path](bold cyan) ";
          disabled = false;
        };
        git_branch = {
          symbol = "🌱 ";
          format = "[$symbol$branch](bold purple) ";
          disabled = false;
        };
        git_status = {
          format = "([$all_status$ahead_behind](bold red) )";
          disabled = false;
          conflicted = "=";
          ahead = "⇡${count}";
          behind = "⇣${count}";
          diverged = "⇕⇡${ahead_count}⇣${behind_count}";
          untracked = "?";
          stashed = "$";
          modified = "!";
          staged = "+";
          renamed = "»";
          deleted = "✘";
        };
        cmd_duration = {
          min_time = 2000;
          format = "[$duration](bold yellow) ";
          disabled = false;
        };
        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
          vicmd_symbol = "[❮](bold yellow)";
        };
      };
    };

    # Zoxide
    zoxide = {
      enable = true;
      aliases = {
        cd = "z";
        cdi = "zi";
      };
    };

    # FZF
    fzf = {
      enable = true;
      keyBindings = true;
      fuzzyCompletion = true;
      defaultOptions = "--height 40% --layout=reverse --border --preview 'bat --color=always {}'";
    };

    # Btop
    btop = {
      enable = true;
    };

    # Yazi
    yazi = {
      enable = true;
    };

    # Ranger
    ranger = {
      enable = true;
    };

    # Neovim
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      editorAlias = true;
    };

    # Dunst
    dunst = {
      enable = true;
      settings = {
        global = {
          monitor = 0;
          follow = "mouse";
          geometry = "300x5-30+20";
          indicate_hidden = true;
          shrink = false;
          transparency = 0;
          separator_height = 2;
          padding = "8 12";
          horizontal_padding = 12;
          text_icon_padding = 0;
          frame_width = 2;
          frame_color = "#89b4fa";
          font = "JetBrains Mono 10";
          markup = "full";
          format = "<b>%s</b>\n%b";
          alignment = "left";
          show_age_threshold = 60;
          word_wrap = true;
          ignore_newline = false;
          stack_duplicates = true;
          hide_duplicate_count = false;
          show_indicators = true;
          icon_position = "left";
          min_width = 300;
          max_width = 500;
          icon_theme = "Papirus-Dark";
        };
        frame = {
          width = 2;
          color = "#89b4fa";
        };
        shortcuts = {
          close = "ctrl+space";
          close_all = "ctrl+shift+space";
          history = "ctrl+grave";
          context = "ctrl+shift+period";
        };
        urgency_low = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
          timeout = 10;
        };
        urgency_normal = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
          timeout = 10;
        };
        urgency_critical = {
          background = "#1e1e2e";
          foreground = "#f38ba8";
          frame_color = "#f38ba8";
          timeout = 0;
        };
      };
    };

    # Bat
    bat = {
      enable = true;
      theme = "Catppuccin Mocha";
    };

    # Delta
    delta = {
      enable = true;
      theme = "Catppuccin Mocha";
    };

    # Eza
    eza = {
      enable = true;
    };

    # Atuin
    atuin = {
      enable = true;
      import = {
        bash = true;
        zsh = true;
        fish = true;
      };
    };

    # Direnv
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # Gh
    github-cli = {
      enable = true;
    };

    # Docker
    docker = {
      enable = true;
      compose.enable = true;
    };

    # Kubernetes
    # kubernetes = {
    #   enable = true;
    #   kubectl.enable = true;
    #   helm.enable = true;
    #   kustomize.enable = true;
    # };

    # Rust
    rust = {
      enable = true;
      defaultToolchain = "stable";
    };

    # Python
    python = {
      enable = true;
      pipx.enable = true;
    };

    # Node
    nodejs = {
      enable = true;
      pnpm.enable = true;
    };

    # Go
    go = {
      enable = true;
    };

    # Java
    # jdk = {
    #   enable = true;
    #   version = "21";
    # };

    # Dotnet
    # dotnet = {
    #   enable = true;
    #   version = "8.0";
    # };

    # Flatpak
    flatpak = {
      enable = true;
    };

    # Steam
    steam = {
      enable = true;
    };

    # Mpd
    mpd = {
      enable = true;
      musicDirectory = "/home/${username}/Music";
      playlistDirectory = "/home/${username}/.config/mpd/playlists";
      dbFile = "/home/${username}/.config/mpd/mpd.db";
      logFile = "/home/${username}/.config/mpd/mpd.log";
      pidFile = "/home/${username}/.config/mpd/mpd.pid";
      stateFile = "/home/${username}/.config/mpd/mpdstate";
      stickerFile = "/home/${username}/.config/mpd/sticker.sql";
      port = 6600;
      bindToAddress = "localhost";
      autoUpdate = true;
      followOutsideSymlinks = true;
      followInsideSymlinks = true;
      zeroconf = {
        enabled = true;
        name = "Music Player";
      };
    };

    # Ncmpcpp
    ncmpcpp = {
      enable = true;
    };

    # PulseAudio
    # pulseaudio = {
    #   enable = true;
    # };

    # PipeWire (system-wide)
    # pipewire = {
    #   enable = true;
    # };

    # Bluetooth
    # bluetooth.enable = true;

    # SSH
    ssh = {
      enable = true;
      startAgent = true;
      extraConfig = ''
        Host *
          AddKeysToAgent yes
          UseKeychain yes
          IdentityFile ~/.ssh/id_ed25519
          IdentityFile ~/.ssh/id_rsa
          ServerAliveInterval 60
          ServerAliveCountMax 3
          ForwardAgent no
          ForwardX11 no
          StrictHostKeyChecking accept-new
          UserKnownHostsFile ~/.ssh/known_hosts
      '';
    };

    # GPG
    gnupg = {
      enable = true;
      agent = {
        enable = true;
        enableSSHSupport = true;
        defaultCacheTtl = 3600;
        maxCacheTtl = 86400;
        pinentryFlavor = "gtk";
      };
    };

    # Password store
    pass = {
      enable = true;
      extensions = with pkgs; [ pass-otp pass-git-helper ];
    };

    # Gopass
    gopass = {
      enable = true;
    };

    # Bitwarden
    bitwarden = {
      enable = true;
    };

    # Restic
    restic = {
      enable = true;
    };

    # Borg
    borgbackup = {
      enable = true;
    };

    # Syncthing
    syncthing = {
      enable = true;
      user = username;
      openDefaultPorts = true;
    };

    # Tailscale
    tailscale = {
      enable = true;
    };

    # Vpn
    # wireguard = {
    #   enable = true;
    # };

    # Systemd user services
    systemd = {
      enable = true;
      userServices = {
        "mpd" = {
          enable = true;
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.mpd}/bin/mpd --no-daemon";
            Restart = "on-failure";
          };
        };
        "syncthing" = {
          enable = true;
        };
      };
    };
  };
}
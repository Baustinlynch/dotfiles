{ config, pkgs, lib, username, ... }:

{
  # User services managed by home-manager
  services = {
    # MPD (Music Player Daemon)
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
      extraConfig = ''
        audio_output {
          type    "pipewire"
          name    "PipeWire"
        }
        audio_output {
          type    "pulse"
          name    "PulseAudio"
        }
      '';
    };

    # Syncthing
    syncthing = {
      enable = true;
      user = username;
      openDefaultPorts = true;
      settings = {
        gui = {
          address = "127.0.0.1:8384";
          apikey = "";
          theme = "default";
        };
      };
    };

    # Docker (user-level, rootless)
    # docker = {
    #   enable = true;
    #   rootless = true;
    # };

    # Podman (user-level)
    # podman = {
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
            RestartSec = 5;
          };
        };
        "syncthing" = {
          enable = true;
        };
        # PipeWire (already system-wide)
        # "pipewire" = { enable = true; };
        # "pipewire-pulse" = { enable = true; };
        # "wireplumber" = { enable = true; };
      };
    };

    # Gnome keyring (for SSH/GPG secrets)
    # gnome-keyring = {
    #   enable = true;
    #   startAtLogin = true;
    #   components = [ "pkcs11" "secrets" "ssh" "gpg" ];
    # };

    # Automatic updates (home-manager)
    # home-manager = {
    #   autoUpgrade = {
    #     enable = true;
    #     interval = "daily";
    #   };
    # };

    # Backup
    # restic = {
    #   enable = true;
    #   backup = {
    #     enable = true;
    #     paths = [ "/home/${username}/Documents" "/home/${username}/Pictures" ];
    #     repository = "s3:https://s3.amazonaws.com/bucket/path";
    #     environmentFile = "/home/${username}/.config/restic/env";
    #     timerConfig = {
    #       OnCalendar = "daily";
    #       RandomizedDelaySec = "2h";
    #     };
    #   };
    # };

    # Borg
    # borgbackup = {
    #   enable = true;
    #   backup = {
    #     enable = true;
    #     paths = [ "/home/${username}/Documents" "/home/${username}/Pictures" ];
    #     repository = "user@host:/path/to/repo";
    #     timerConfig = {
    #       OnCalendar = "daily";
    #       RandomizedDelaySec = "2h";
    #     };
    #   };
    # };

    # Log rotation for user logs
    logrotate = {
      enable = true;
      config = ''
        /home/${username}/.local/share/*.log {
          daily
          missingok
          rotate 7
          compress
          delaycompress
          notifempty
          create 644 ${username} users
        }
      '';
    };

    # D-Bus user session
    dbus = {
      enable = true;
    };

    # PipeWire (if not system-wide)
    # pipewire = {
    #   enable = true;
    #   pipewire.enable = true;
    #   pipewire-pulse.enable = true;
    #   wireplumber.enable = true;
    # };

    # XDG Desktop Portal
    xdg-desktop-portal = {
      enable = true;
      wlr.enable = true;
      gtk.enable = true;
    };

    # AppIndicator (for tray icons)
    # appindicator = {
    #   enable = true;
    # };

    # Notify daemon (handled by dunst)
    # notifications = {
    #   enable = true;
    #   dunst = {
    #     enable = true;
    #   };
    # };

    # Clipboard manager
    # clipboard = {
    #   enable = true;
    #   history.enable = true;
    #   history.maxItems = 100;
    # };

    # Screenshot tools
    # grim = {
    #   enable = true;
    # };

    # Screen recording
    # wf-recorder = {
    #   enable = true;
    # };

    # Wallpaper
    # hyprpaper = {
    #   enable = true;
    # };

    # Idle management
    # swayidle = {
    #   enable = true;
    # };

    # Lock screen
    # swaylock = {
    #   enable = true;
    # };

    # Waybar
    # waybar = {
    #   enable = true;
    # };

    # Rofi
    # rofi = {
    #   enable = true;
    # };

    # Mako notifications
    # mako = {
    #   enable = true;
    # };

    # Fuzzel
    # fuzzel = {
    #   enable = true;
    # };

    # Wlogout
    # wlogout = {
    #   enable = true;
    # };

    # Power profiles
    # power-profiles-daemon = {
    #   enable = true;
    # };

    # TLP (system-wide)
    # tlp = {
    #   enable = true;
    # };

    # Auto-cpufreq (system-wide)
    # auto-cpufreq = {
    #   enable = true;
    # };

    # Thermald (system-wide)
    # thermald = {
    #   enable = true;
    # };

    # Laptop mode tools (system-wide)
    # laptop-mode-tools = {
    #   enable = true;
    # };

    # Bluetooth (system-wide)
    # bluez = {
    #   enable = true;
    # };

    # NetworkManager (system-wide)
    # networkmanager = {
    #   enable = true;
    # };

    # Firewall (system-wide)
    # firewall = {
    #   enable = true;
    # };

    # SSH server (system-wide)
    # openssh = {
    #   enable = true;
    # };

    # Fail2ban (system-wide)
    # fail2ban = {
    #   enable = true;
    # };

    # Audit (system-wide)
    # auditd = {
    #   enable = true;
    # };

    # Cron (system-wide)
    # cronie = {
    #   enable = true;
    # };

    # Logrotate (system-wide)
    # logrotate = {
    #   enable = true;
    # };

    # MLocate (system-wide)
    # mlocate = {
    #   enable = true;
    # };

    # AppArmor (system-wide)
    # apparmor = {
    #   enable = true;
    # };
  };
}
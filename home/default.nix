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
    # Register existing vaults. Paths are relative to $HOME.
    vaults.personal.target = "Documents/Obsidian";
  };

  home.packages = with pkgs; [
    firefox
    btop
  ];

  # Waybar config
  xdg.configFile."waybar/config".text = builtins.toJSON {
    layer = "top";
    position = "top";
    height = 30;
    modules-left = ["niri/workspaces" "niri/window"];
    modules-center = ["clock"];
    modules-right = ["pulseaudio" "network" "battery" "tray" "custom/power"];
    "niri/workspaces" = { format = "{icon}"; format-icons = { default = ""; active = ""; }; };
    "niri/window" = { max-length = 50; };
    clock = { format = "{:%Y-%m-%d %H:%M}"; tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>"; };
    pulseaudio = { format = "{volume}% {icon}"; format-muted = ""; format-icons = { default = ["" "" ""]; }; on-click = "pavucontrol"; };
    network = { format-wifi = "{essid} ({signalStrength}%) "; format-ethernet = "{ipaddr} "; format-disconnected = "Disconnected ⚠"; tooltip-format = "{ifname} via {gwaddr} "; };
    battery = { states = { warning = 30; critical = 15; }; format = "{capacity}% {icon}"; format-icons = ["" "" "" "" ""]; };
    tray = { spacing = 10; };
    "custom/power" = { format = ""; on-click = "wlogout || fuzzel --dmenu -p 'Power:' <<< $'Logout\\nSuspend\\nReboot\\nShutdown' | xargs -r sh -c 'case \"$1\" in Logout) loginctl terminate-session $(loginctl session-status | head -n1 | awk \"{print \\$1}\");; Suspend) systemctl suspend;; Reboot) systemctl reboot;; Shutdown) systemctl poweroff;; esac' _"; tooltip = false; };
  };

  xdg.configFile."waybar/style.css".text = ''
    * {
      font-family: "JetBrainsMono Nerd Font", monospace;
      font-size: 13px;
    }
    window#waybar {
      background: rgba(30, 30, 46, 0.8);
      color: #cdd6f4;
    }
    #workspaces button {
      padding: 0 5px;
      color: #cdd6f4;
    }
    #workspaces button.active {
      color: #89b4fa;
    }
    #clock, #pulseaudio, #network, #battery, #tray, #custom-power {
      padding: 0 10px;
    }
  '';

  # Fuzzel config
  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    [main]
    font=JetBrainsMono Nerd Font:size=12
    dpi-aware=auto
    width=50
    horizontal-pad=20
    vertical-pad=10
    inner-pad=5
    line-height=20
    icons-enabled=yes
    show-actions=no
    terminal=alacritty

    [colors]
    background=1e1e2eff
    text=cdd6f4ff
    match=f38ba8ff
    selection-match=f38ba8ff
    selection=313244ff
    selection-text=cdd6f4ff
    border=89b4faff
  '';

  # Mako config
  xdg.configFile."mako/config".text = ''
    font=JetBrainsMono Nerd Font 10
    background-color=#1e1e2eAA
    text-color=#cdd6f4
    border-color=#89b4fa
    border-radius=8
    border-size=2
    default-timeout=5000
    max-visible=5
    layer=overlay
    anchor=top-right
  '';
}

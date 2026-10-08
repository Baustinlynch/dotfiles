{ config, pkgs, lib, ... }:

{
  # Graphics
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    vulkan = {
      enable = true;
      layers = [ pkgs.vulkan-tools pkgs.renderdoc ];
    };
    video = {
      amdgpu = {
        enable = true;
        settings = {
          ppfeaturemask = "0xffffffff";
        };
      };
    };
  };

  # X11
  services.xserver = {
    enable = true;
    layout = "gb";
    xkbVariant = "";
    xkbOptions = "caps:escape";
    displayManager = {
      sddm = {
        enable = true;
        theme = pkgs.sddm-themes.sugar-candy;
        themeOpts = {
          background = "/usr/share/backgrounds/nixos.png";
        };
      };
    };
    desktopManager = {
      # We use bspwm/niri manually, not a full DE
      xterm.enable = false;
    };
    windowManager = {
      bspwm = {
        enable = true;
      };
      # Also install niri as an option
    };
    windowManagers = {
      i3.enable = false;
      sway.enable = false;
    };
    libinput = {
      enable = true;
      accelerationProfile = "flat";
      scrollMethod = "two-finger";
      tapToClick = true;
      naturalScrolling = true;
    };
    xkb = {
      layout = "gb";
      variant = "";
      options = "caps:escape";
    };
  };

  # Wayland
  wayland = {
    enable = true;
    compositor = {
      niri = {
        enable = true;
      };
    };
  };

  # Fonts
  fonts = {
    enableDefaultFonts = true;
    enableFontDir = true;
    fontconfig = {
      enable = true;
      penultimate = {
        enable = true;
        alias = {
          "sans-serif" = [ "Noto Sans" "Noto Color Emoji" ];
          "serif" = [ "Noto Serif" ];
          "monospace" = [ "JetBrains Mono" "Noto Sans Mono" ];
        };
      };
    };
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
      jetbrains-mono
      fira-code
      fira-code-symbols
      cascadia-code
      inter
      roboto
      roboto-mono
      terminus-font
      font-awesome
      font-awesome-ttf
      nerd-fonts
    ];
  };

  # Theming
  gtk = {
    enable = true;
    theme = "Adwaita-dark";
    iconTheme = "Papirus-Dark";
    cursorTheme = "Bibata-Modern-Ice";
    cursorSize = 24;
    extraGtk3Modules = [ pkgs.gtk3-print-backends ];
  };

  # Qt theming
  qt = {
    enable = true;
    platformTheme = "gtk3";
    style = "kvantum";
    qt5ct.enable = true;
    qt6ct.enable = true;
  };

  # Kvantum
  environment.systemPackages = with pkgs; [
    kvantum
    kvantum-qt5
    kvantum-qt6
    qt5ct
    qt6ct
    adw-gtk3
    adw-gtk3-dark
    papirus-icon-theme
    breeze-icons
  ];

  # Terminal emulators
  environment.systemPackages = with pkgs; [
    alacritty
    kitty
    foot
  ];

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
        ];
        custom = "~/.oh-my-zsh/custom";
      };
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;
      completions.enable = true;
    };

    fish = {
      enable = true;
      shellAbbr = {
        ls = "eza --icons";
        ll = "eza -l --icons";
        la = "eza -la --icons";
        cat = "bat";
        grep = "rg";
        find = "fd";
        du = "dust";
        ps = "procs";
        top = "btop";
        vim = "nvim";
        vi = "nvim";
      };
    };

    bash.enable = true;
  };

  # Shell tools (system-wide)
  environment.systemPackages = with pkgs; [
    zsh
    fish
    bash
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-history-substring-search
    fzf
    zoxide
    eza
    bat
    delta
    ripgrep
    fd
    dust
    procs
    bottom
    tealdeer
    starship
    direnv
    atuin
    mcfly
    nu
    elvish
  ];

  # Editors
  environment.systemPackages = with pkgs; [
    neovim
    helix
    micro
    vim
    nano
    vscode
  ];

  # Development tools
  environment.systemPackages = with pkgs; [
    git
    git-extras
    lazygit
    tig
    github-cli
    git-delta
    diff-so-fancy
    nodejs
    nodejs-22
    pnpm
    yarn
    bun
    deno
    python3
    python312
    python312Packages.pipx
    python312Packages.poetry
    python312Packages.ruff
    python312Packages.black
    python312Packages.mypy
    python312Packages.pytest
    rustup
    cargo
    gcc
    clang
    llvm
    cmake
    meson
    ninja
    pkg-config
    make
    patchelf
    mold
    lld
    glibc
    linuxHeaders
  ];

  # Containers
  virtualisation = {
    docker = {
      enable = true;
      autoStart = true;
    };
    podman = {
      enable = true;
    };
    libvirtd = {
      enable = true;
      driver = "kvm";
      qemu = {
        enable = true;
        options = [ "+kvm" "+virtio" "+vhost-net" "+vhost-vsock" "+spice" "+gtk" "+sdl" "+vnc" "+curses" "+virgl" ];
      };
      virtiofsd.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    buildah
    skopeo
    dive
    ctop
    lazydocker
  ];

  # Media
  environment.systemPackages = with pkgs; [
    mpv
    vlc
    gimp
    inkscape
    blender
    obs-studio
    simplescreenrecorder
    ffmpeg
    ffmpeg-full
    imagemagick
    graphicsmagick
    yt-dlp
    gallery-dl
    mpv
    celluloid
    cava
    ncmpcpp
    mpd
    pulsemixer
    pavucontrol
    pamixer
    playerctl
    grim
    slurp
    swappy
    satty
    wl-clipboard
    cliphist
  ];

  # Browsers
  environment.systemPackages = with pkgs; [
    firefox
    firefox-devedition
    zen-browser
    chromium
    tor-browser
  ];

  # Communication
  environment.systemPackages = with pkgs; [
    slack
    zoom-us
    discord
    signal-desktop
    element-desktop
    thunderbird
  ];

  # Office
  environment.systemPackages = with pkgs; [
    libreoffice
    libreoffice-fresh
    zathura
    zathura-pdf-mupdf
    zathura-djvu
    zathura-ps
    zathura-cb
    okular
    atril
  ];

  # File managers / CLI tools
  environment.systemPackages = with pkgs; [
    yazi
    ranger
    nnn
    lf
    vifm
    mc
    tree
    eza
    lsd
    exa
    fd
    ripgrep
    jq
    yq
    xq
    mlr
    csvkit
    pandoc
    pandoc-crossref
    mdcat
    glow
    bat
    delta
    difftastic
    tokei
    hyperfine
    just
    taskwarrior
    timewarrior
    calc
    bc
    units
    gcal
    khal
    khard
    vdirsyncer
    syncthing
    rclone
    restic
    borgbackup
    kopia
    age
    sops
    pass
    gopass
    bitwarden-cli
    rbw
  ];

  # System monitoring
  environment.systemPackages = with pkgs; [
    btop
    htop
    glances
    nethogs
    iftop
    iotop
    iotop-c
    powertop
    turbostat
    stress-ng
    sysstat
    dstat
    hdparm
    nvme-cli
    smartmontools
    lm-sensors
    cpupower
    thermald
    tlp
    tlp-rdw
    powertop
    auto-cpufreq
  ];

  # Network tools
  environment.systemPackages = with pkgs; [
    networkmanager
    network-manager-applet
    nm-connection-editor
    nmap
    wireshark-cli
    tcpdump
    netcat
    socat
    openssh
    mosh
    rsync
    rclone
    curl
    wget
    httpie
    xh
    aria2
    torrent
    transmission-cli
    qbittorrent-nox
    syncthing
    tailscale
    wireguard-tools
    openvpn
    openconnect
    vpnc
  ];

  # Archive / compression
  environment.systemPackages = with pkgs; [
    tar
    gzip
    bzip2
    xz
    lz4
    zstd
    brotli
    p7zip
    unzip
    unrar
    7zip
    ark
    file-roller
  ];

  # Virtualization
  environment.systemPackages = with pkgs; [
    qemu-full
    libvirt
    virt-manager
    virt-viewer
    virt-install
    swtpm
    edk2-ovmf
    edk2-shell
    guestfs-tools
    libguestfs
  ];

  # Gaming
  environment.systemPackages = with pkgs; [
    steam
    lutris
    heroic-games-launcher
    bottles
    gamemode
    lib32-gamemode
    mangohud
    lib32-mangohud
    vkbasalt
    lib32-vkbasalt
    gamescope
    protontricks
    winetricks
    wine
    wine-gecko
    wine-mono
  ];

  # Flatpak
  flatpak.enable = true;
  flatpak.systemPackages = with pkgs.flatpak; [
    org.flatpak.Builder
  ];

  # Snap (optional, but user had it)
  # snapd.enable = true;

  # Printing
  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint pkgs.hplip ];
    systemGroups = [ "wheel" "lp" ];
  };

  # Audio
  sound = {
    enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      pipewire-alsa.enable = true;
      pipewire-pulse.enable = true;
      pipewire-jack.enable = true;
      media-session.enable = true;
    };
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.bluez = {
    enable = true;
    settings = {
      General = {
        Enable = [ "Source" "Sink" "Media" "Socket" ];
      };
    };
  };
  environment.systemPackages = with pkgs; [
    bluez
    bluez-utils
    blueman
    pavucontrol
    pulsemixer
    pamixer
  ];

  # Power management
  services.tlp = {
    enable = true;
    enableRdw = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;
    };
  };

  # Laptop specific
  services.thermald.enable = true;
  services.auto-cpufreq.enable = true;

  # Firmware updates
  services.fwupd.enable = true;

  # AppArmor
  security.apparmor.enable = true;

  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 8080 8443 ];
    allowedUDPPorts = [ 53 67 68 51820 ];
    trustedInterfaces = [ "docker0" "virbr0" ];
  };

  # SSH
  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
    challengeResponseAuthentication = false;
    usePAM = true;
  };

  # Log rotation
  services.logrotate.enable = true;

  # MLocate
  services.mlocate.enable = true;

  # Auto updates (optional)
  # system.autoUpgrade.enable = true;
}
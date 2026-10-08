{ config, pkgs, lib, username, ... }:

{
  home.packages = with pkgs; [
    # CLI / TUI tools
    btop
    htop
    tmux
    neovim
    lazygit
    yazi
    ranger
    starship
    zoxide
    fastfetch
    hyfetch
    jq
    fzf
    ripgrep
    fd
    gh
    ncdu
    mpc
    ncmpcpp
    cava
    pastel
    calc
    maim
    slop
    swappy
    xclip
    xdotool
    wmctrl
    wmname
    nethogs
    p7zip
    pnpm
    uv
    pandoc-cli
    inotify-tools
    git-extras
    tree
    bat
    eza
    delta
    dust
    procs
    bottom
    zellij
    helix
    micro
    git-delta
    difftastic
    tealdeer
    mcfly
    atuin
    nu
    direnv
    just
    taskwarrior
    timewarrior
    khal
    khard
    vdirsyncer
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
    yt-dlp
    gallery-dl
    grim
    slurp
    satty
    wl-clipboard
    cliphist
    playerctl
    grimblast
    wf-recorder
    wob
    mako
    fuzzel
    bemenu
    rofi
    dunst
    swaylock
    swayidle
    swaybg
    wlogout
    waybar
    waypaper
    hyprpaper
    kanshi
    wlr-randr
    gammastep
    redshift
    hyprland
    river
    cage
    hikari
    labwc
    wayfire
    # niri - already in system config

    # Terminal emulators
    alacritty
    kitty
    foot
    wezterm

    # Editors
    helix
    micro
    vim
    nano
    vscode

    # Shell
    zsh
    fish
    bash
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-history-substring-search

    # Development
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

    # Containers
    docker-compose
    buildah
    skopeo
    dive
    ctop
    lazydocker

    # Media
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
    cava
    ncmpcpp
    mpd
    pulsemixer
    pavucontrol
    pamixer

    # Browsers
    firefox
    firefox-devedition
    zen-browser
    chromium
    tor-browser

    # Communication
    slack
    zoom-us
    discord
    signal-desktop
    element-desktop
    thunderbird

    # Office
    libreoffice
    libreoffice-fresh
    zathura
    zathura-pdf-mupdf
    zathura-djvu
    zathura-ps
    zathura-cb
    okular
    atril

    # File managers
    thunar
    thunar-archive-plugin
    thunar-media-tags-plugin
    thunar-volman
    nnn
    lf
    vifm
    mc

    # Network
    nmap
    wireshark-cli
    tcpdump
    netcat
    socat
    openssh
    mosh
    rsync
    curl
    wget
    httpie
    xh
    aria2
    transmission-cli
    qbittorrent-nox
    syncthing
    tailscale
    wireguard-tools
    openvpn
    openconnect
    vpnc

    # Archive
    tar
    gzip
    bzip2
    xz
    lz4
    zstd
    brotli
    unzip
    unrar
    7zip
    ark
    file-roller

    # Virtualization
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

    # Gaming
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

    # System monitoring
    glances
    iftop
    iotop
    iotop-c
    powertop
    turbostat
    stress-ng
    sysstat
    dstat
    hdparm
    smartmontools
    lm-sensors
    cpupower
    thermald
    tlp
    tlp-rdw
    auto-cpufreq

    # Unfree
    spotify
    spicetify-cli
    google-earth-pro
    todoist
    obsidian
  ];
}
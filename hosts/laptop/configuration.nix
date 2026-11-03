{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/dev.nix
    ../../modules/nixos/hardware/touchpad.nix
  ];

  networking.hostName = "breadlaptop-nixos";
  networking.networkmanager.enable = true;
  # Disable Wi-Fi power saving: the RTL8821CE (rtw88) drops off the
  # corporate 802.1X network when power save / deep LPS kicks in.
  networking.networkmanager.wifi.powersave = false;

  # Bypass school/Tailscale DNS on LT_OPEN WiFi so the captive portal doesn't
  # kill resolution after the grace period.
  networking.networkmanager.dispatcherScripts = [
    {
      source = ./scripts/school-dns-bypass.sh;
    }
  ];

  # RTL8821CE stability: disable PCIe ASPM and deep low-power save.
  boot.extraModprobeConfig = ''
    options rtw88_pci disable_aspm=1
    options rtw88_core disable_lps_deep=1
  '';

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  services.xserver.xkb.layout = "gb";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Cap the number of boot menu entries kept in the ESP (default is unlimited
  # on some setups; 10 is plenty for rollbacks and keeps /boot small).
  boot.loader.systemd-boot.configurationLimit = 10;

  hardware.cpu.amd.updateMicrocode = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  users.users.brenden = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.fish;
  };

  # fish is the login shell; keep bash enabled as a fallback for scripts.
  programs.fish.enable = true;
  programs.bash.enable = true;
  # zsh stays installed so existing workflows/scripts still work.
  programs.zsh.enable = true;

  programs.git.enable = true;

  # Run dynamically linked binaries from generic-Linux releases (Zed
  # extension language servers, GitHub tarballs, etc.). Without this, the
  # stub loader at /lib64/ld-linux-x86-64.so.2 refuses to start them.
  programs.nix-ld.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  # Garbage collection and store optimisation
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 14d";
  nix.settings.auto-optimise-store = true;
  nix.optimise.automatic = true;

  # Boroughmuir High School; "LT_OPEN" TLS interception root CA.
  # The network MITMs TLS; without this, nix/curl/firefox fail cert validation.
  security.pki.certificateFiles = [ ./lt-rootca.pem ];

  # UK keyboard on TTY as well as X11/Wayland
  console.keyMap = "uk";

  # Stylix theming (base16 scheme; no wallpaper image).
  stylix = {
    enable = true;
    polarity = "light";
    base16Scheme = {
      base00 = "eff1f5";
      base01 = "ccd0da";
      base02 = "bcc0cc";
      base03 = "9ca0b0";
      base04 = "6c6f85";
      base05 = "4c4f69";
      # Pastel accents (Catppuccin Frappe) for a softer look
      base06 = "f2d5cf";
      base07 = "babbf1";
      base08 = "e78284";
      base09 = "ef9f76";
      base0A = "e5c890";
      base0B = "a6d189";
      base0C = "81c8be";
      base0D = "8caaee";
      base0E = "ca9ee6";
      base0F = "eebebe";
    };
    opacity.terminal = 0.95;
    opacity.desktop = 0.85;
    fonts.sizes.terminal = 10.5;
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };

  system.stateVersion = "24.11";

  # Enable syncthing
  services.syncthing = {
    enable = true;
    user = "brenden";
    group = "users";
    # Running as a normal user, so keep data/config in a state dir, not $HOME.
    dataDir = "/home/brenden/.local/state/syncthing";
    openDefaultPorts = true; # Open firewall ports
  };
  # Enable Tailscale
  services.tailscale.enable = true;

  # GVFS for Nautilus trash/removable media
  services.gvfs.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  # Resume from hibernate (swapfile on root). Offset updated by filefrag -v /swapfile.
  boot.kernelParams = [ "resume=UUID=9eda2a55-0b2a-4f3a-8147-df2a7eb641f4" "resume_offset=74409984" ];
}

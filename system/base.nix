{ config, pkgs, lib, ... }:

{
  # Boot configuration
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        canTouchEfiVariables = true;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
    kernelParams = [ "amdgpu.ppfeaturemask=0xffffffff" "amdgpu.vm_fault_stop_engine=0" ];
    initrd.kernelModules = [ "amdgpu" "nvme" ];
    supportedFilesystems = [ "btrfs" "ext4" "xfs" "ntfs" "exfat" "vfat" ];
  };

  # File systems - will be filled by hardware-configuration.nix
  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-label/ESP";
    fsType = "vfat";
  };

  # Swap
  swapDevices = [ ];

  # Time
  time.timeZone = "Europe/London";

  # Locale
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    supportedLocales = [ "en_GB.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
  };

  # Console
  console = {
    font = "ter-v22b";
    keyMap = "uk";
    useXkbConfig = true;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    # Core utilities
    git
    curl
    wget
    unzip
    p7zip
    tree
    htop
    btop
    ncdu
    fastfetch
    man-db
    man-pages
    less
    which
    psmisc
    lsof
    strace
    tcpdump
    nmap
    net-tools
    iproute2
    ethtool
    usbutils
    pciutils
    dmidecode
    hwloc
    smartmontools
    hdparm
    nvme-cli
    fwupd
    fwupd-efi
    bolt
    udisks2
    udiskie
    gvfs
    gvfs-afc
    gvfs-gphoto2
    gvfs-mtp
    gvfs-smb
    thunar
    thunar-archive-plugin
    thunar-media-tags-plugin
    thunar-volman
    tumbler
    ffmpegthumbnailer
    xdg-utils
    xdg-user-dirs
    xdg-user-dirs-gtk
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
  ];

  # Services
  services = {
    # Hardware
    udev.enable = true;
    hwclock.enable = true;

    # Firmware
    fwupd.enable = true;

    # Logging
    systemd-journald.extraConfig = ''
      SystemMaxUse=500M
      MaxFileSec=1week
    '';

    # Cron
    cronie.enable = true;
  };

  # Security
  security = {
    apparmor.enable = true;
    sudo.wheelNeedsPassword = false;
    pam.services.sudo = {
      auth = [
        { type = "sufficient"; module = "pam_fingerprint.so"; }
        { type = "include"; module = "system-auth"; }
      ];
    };
  };

  # Systemd
  systemd = {
    enableEmergencyMode = true;
    defaultTarget = "graphical.target";
    services = {
      # User services
      "systemd-homed" = { enable = false; };
    };
  };

  # Nix
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      max-jobs = "auto";
      cores = 0;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Users
  users = {
    mutableUsers = false;
    users.brenden = {
      isNormalUser = true;
      description = "Brenden";
      extraGroups = [ "wheel" "networkmanager" "video" "audio" "docker" "libvirt" "kvm" "render" "input" "storage" "scanner" "lp" "optical" ];
      shell = pkgs.zsh;
      home = "/home/brenden";
      createHome = true;
      useDefaultShell = true;
    };
  };
}
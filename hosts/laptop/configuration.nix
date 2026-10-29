{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/dev.nix
  ];

  networking.hostName = "inspiron-3525";
  networking.networkmanager.enable = true;
  # Disable Wi-Fi power saving: the RTL8821CE (rtw88) drops off the
  # corporate 802.1X network when power save / deep LPS kicks in.
  networking.networkmanager.wifi.powersave = false;

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
    extraGroups = [ "wheel" "networkmanager" "docker" "video" "audio" ];
    shell = pkgs.fish;
  };

  # fish is the login shell; keep bash enabled as a fallback for scripts.
  programs.fish.enable = true;
  programs.bash.enable = true;
  # zsh stays installed so existing workflows/scripts still work.
  programs.zsh.enable = true;

  programs.git.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Boroughmuir High School; "LT_OPEN" TLS interception root CA.
  # The network MITMs TLS; without this, nix/curl/firefox fail cert validation.
  security.pki.certificates = [ (builtins.readFile ./lt-rootca.pem) ];

  programs.niri.enable = true;

  system.stateVersion = "24.11";

  #Enable syncthing
  services.syncthing = {
    enable = true;
    user = "brenden";
    group = "users";
    # Running as a normal user, so keep data/config in the home directory.
    # (The default /var/lib/syncthing is only writable by the dedicated
    # "syncthing" user that the module creates when user is left at default.)
    dataDir = "/home/brenden";
    openDefaultPorts = true; #Open firewall ports
  };
  # Enable Tailscale
  services.tailscale.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

}

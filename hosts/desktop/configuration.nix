{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/dev.nix
  ];

  networking.hostName = "desktop";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  services.xserver.xkb.layout = "gb";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  hardware.cpu.amd.updateMicrocode = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  users.users.brenden = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "disk" ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
  programs.bash.enable = true;
  programs.zsh.enable = true;

  programs.git.enable = true;

  programs.nix-ld.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 14d";
  nix.settings.auto-optimise-store = true;
  nix.optimise.automatic = true;

  console.keyMap = "uk";

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

  services.syncthing = {
    enable = true;
    user = "brenden";
    group = "users";
    dataDir = "/home/brenden/.local/state/syncthing";
    openDefaultPorts = true;
  };
  services.tailscale.enable = true;

  services.gvfs.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
}

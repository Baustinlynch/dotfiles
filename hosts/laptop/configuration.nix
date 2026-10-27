{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/dev.nix
  ];

  networking.hostName = "inspiron-3525";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  # University of Edinburgh "LT_OPEN" TLS interception root CA.
  # The network MITMs TLS; without this, nix/curl/firefox fail cert validation.
  security.pki.certificates = [ (builtins.readFile ./lt-rootca.pem) ];

  system.stateVersion = "24.11";
}

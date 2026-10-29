{ config, pkgs, ... }:

{
  programs.niri.enable = true;

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.niri}/bin/niri-session";
      user = "brenden";
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  services.power-profiles-daemon.enable = true;

  # Bluetooth: BlueZ daemon + blueman GUI (blueman-manager needs this)
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;


  # Power profiles (balanced / performance / power-saver).
  # Toggle with: powerprofilesctl set power-saver


  # Lid close behavior: suspend-then-hibernate with 1 min delay
  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    lidSwitchDocked = "ignore";
  };
  systemd.sleep.settings.Sleep.HibernateDelaySec = "1min";

  # Disable ACPI wakeup sources that abort hibernation ("Wakeup pending.
  # Abort CPU freeze" — see journal around hibernate attempts). Resuming
  # from hibernate is a cold boot, so no ACPI wake is needed for it.
  # NOTE: if opening the lid no longer wakes the machine from S3 suspend,
  # re-enable only PNP0C0D here.
  systemd.services.disable-hibernate-wakeup-sources = {
    description = "Disable ACPI wakeup sources that abort hibernation";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "disable-hibernate-wakeup" ''
        echo disabled > /sys/devices/platform/PNP0C0D:00/power/wakeup  # lid
        echo disabled > /sys/devices/platform/PNP0C0C:00/power/wakeup  # power button
        echo GPP1 > /proc/acpi/wakeup
        echo GP17 > /proc/acpi/wakeup
      '';
    };
  };
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    nerd-fonts.jetbrains-mono
  ];

  # niri is a wlroots compositor: the GTK portal is the correct backend
  # (the GNOME portal drags in the GNOME desktop stack).
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "gtk" ];
  };

  environment.systemPackages = with pkgs; [
    waybar
    fuzzel
    mako
    alacritty
    zed-editor
    nautilus
    # Niri essentials
    swaylock
    brightnessctl
    playerctl
    wl-clipboard
    grim
    slurp
    swappy
    networkmanagerapplet
    blueman
    pavucontrol
    pamixer
    xdg-utils
    waypaper
    swaybg
    # Polkit agent
    polkit_gnome
  ];
}

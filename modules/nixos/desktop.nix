{ config, pkgs, ... }:

{
  # Explicitly enable graphics (steam module sets it but we want it regardless)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

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

  # Lid close behavior: suspend-then-hibernate with 1 min delay
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchDocked = "ignore";
  };
  systemd.sleep.settings.Sleep.HibernateDelaySec = "1min";

  # Disable ACPI wakeup sources that abort hibernation ("Wakeup pending.
  # Abort CPU freeze" — see journal around hibernate attempts). Resuming
  # from hibernate is a cold boot, so no ACPI wake is needed for it.
  # NOTE: if opening the lid no longer wakes the machine from S3 suspend,
  # re-enable only PNP0C0D here.
  # Idempotent: only disable if currently enabled.
  systemd.services.disable-hibernate-wakeup-sources = {
    description = "Disable ACPI wakeup sources that abort hibernation";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "disable-hibernate-wakeup" ''
        # Idempotent: only disable if currently enabled
        grep -q "enabled" /sys/devices/platform/PNP0C0D:00/power/wakeup 2>/dev/null && echo disabled > /sys/devices/platform/PNP0C0D:00/power/wakeup  # lid
        grep -q "enabled" /sys/devices/platform/PNP0C0C:00/power/wakeup 2>/dev/null && echo disabled > /sys/devices/platform/PNP0C0C:00/power/wakeup  # power button
        grep -q "GPP1.*enabled" /proc/acpi/wakeup 2>/dev/null && echo GPP1 > /proc/acpi/wakeup
        grep -q "GP17.*enabled" /proc/acpi/wakeup 2>/dev/null && echo GP17 > /proc/acpi/wakeup
        true  # Ensure script succeeds even if all greps fail
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
    geany
    nautilus
    rpi-imager # Raspberry Pi OS SD card flashing (elevates via pkexec)
    # Niri essentials
    xwayland-satellite # X11 bridge for niri (Steam and other X11 apps)
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
    # swaybg removed - waypaper uses awww backend
    # Polkit agent
    polkit_gnome
    ampcode
  ];
}

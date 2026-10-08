{ config, pkgs, lib, ... }:

{
  # Networking
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      dispatcherScripts = {
        "99-dns" = {
          source = pkgs.writeShellScript "99-dns" ''
            #!/bin/sh
            # Dispatcher script for NetworkManager
            case "$2" in
              up)
                # Restart systemd-resolved on interface up
                systemctl reload systemd-resolved
                ;;
            esac
          '';
        };
      };
    };
    useDHCP = true;
    useHostResolvConf = true;
    resolvconf = {
      enable = true;
      useSystemdResolved = true;
    };
    systemd-resolved = {
      enable = true;
      config = {
        Resolve = {
          DNS = [ "1.1.1.1" "9.9.9.9" "8.8.8.8" ];
          FallbackDNS = [ "1.0.0.1" "149.112.112.112" "8.8.4.4" ];
          DNSSEC = "allow-downgrade";
          DNSOverTLS = "opportunistic";
          Cache = "yes";
          LLMNR = "yes";
          MulticastDNS = "yes";
        };
      };
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 80 443 8080 8443 5900 5901 ];
      allowedUDPPorts = [ 53 67 68 51820 ];
      trustedInterfaces = [ "docker0" "virbr0" "tailscale0" ];
    };
    wireless.enable = true;
    wireless.networks = {
      # Example: "SSID" = { psk = "password"; };
    };
    nameservers = [ "1.1.1.1" "9.9.9.9" ];
    search = [ "local" "lan" ];
  };

  # Time
  time = {
    timeZone = "Europe/London";
    ntp = {
      enable = true;
      servers = [ "0.uk.pool.ntp.org" "1.uk.pool.ntp.org" "2.uk.pool.ntp.org" "3.uk.pool.ntp.org" ];
    };
  };

  # Locale
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    supportedLocales = [ "en_GB.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.enable = true;
      fcitx5.addons = with pkgs; [ fcitx5-mozc fcitx5-gtk fcitx5-qt fcitx5-anthy ];
    };
  };
}
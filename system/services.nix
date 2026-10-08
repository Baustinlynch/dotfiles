{ config, pkgs, lib, ... }:

{
  # System services
  services = {
    # D-Bus
    dbus.enable = true;

    # Systemd
    systemd = {
      enableEmergencyMode = true;
      defaultTarget = "graphical.target";
      services = {
        "systemd-homed" = { enable = false; };
        "systemd-resolved" = { enable = true; };
        "systemd-timesyncd" = { enable = true; };
        "systemd-logind" = {
          enable = true;
          lidSwitch = "suspend";
          lidSwitchDocked = "ignore";
        };
      };
    };

    # Logging
    systemd-journald = {
      extraConfig = ''
        SystemMaxUse=500M
        MaxFileSec=1week
        Compress=yes
        ForwardToSyslog=no
      '';
    };

    # Cron
    cronie.enable = true;

    # PC/SC (smart cards)
    pcscd.enable = true;

    # Avahi (mDNS)
    avahi = {
      enable = true;
      nssmdns = true;
      publish = {
        enable = true;
        workstation = true;
      };
    };

    # CUPS (printing)
    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint pkgs.hplip pkgs.foo2zjs ];
      systemGroups = [ "wheel" "lp" "sys" ];
      cupsdConfig = ''
        LogLevel warn
        MaxLogSize 1m
        Listen localhost:631
        Listen /run/cups/cups.sock
        Browsing On
        BrowseLocalProtocols dnssd
        DefaultAuthType Basic
        WebInterface Yes
        WebInterface Local
      '';
    };

    # Bluetooth
    bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = [ "Source" "Sink" "Media" "Socket" ];
          AutoEnable = true;
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };

    # Bluetooth frontend
    blueman.enable = true;

    # NetworkManager
    networkmanager = {
      enable = true;
      dispatcherScripts = {
        "99-dns" = {
          source = pkgs.writeShellScript "99-dns" ''
            #!/bin/sh
            case "$2" in
              up)
                systemctl reload systemd-resolved
                ;;
            esac
          '';
        };
      };
      wifi = {
        backend = "wpa_supplicant";
        iwd.enable = false;
      };
      dns = "systemd-resolved";
      globalDns = {
        configuration = {
          servers = [ "1.1.1.1" "9.9.9.9" ];
        };
      };
    };

    # Tailscale
    tailscale = {
      enable = true;
      flags = [ "--accept-dns" "--accept-routes" ];
    };

    # Syncthing (user service)
    syncthing = {
      enable = true;
      user = "brenden";
      openDefaultPorts = true;
      settings = {
        gui = {
          address = "127.0.0.1:8384";
          apikey = "";
          theme = "default";
        };
      };
    };

    # Docker
    docker = {
      enable = true;
      autoStart = true;
      logDriver = "json-file";
      logOpts = {
        "max-size" = "10m";
        "max-file" = "3";
      };
      storageDriver = "overlay2";
      experimental = false;
    };

    # Libvirt
    libvirtd = {
      enable = true;
      driver = "kvm";
      qemu = {
        enable = true;
        options = [ "+kvm" "+virtio" "+vhost-net" "+vhost-vsock" "+spice" "+gtk" "+sdl" "+vnc" "+curses" "+virgl" ];
      };
      virtiofsd.enable = true;
      network = {
        defaultNetwork.enable = true;
        defaultNetwork.bridgeName = "virbr0";
        defaultNetwork.forward.mode = "nat";
        defaultNetwork.forward.nat.addresses = [ "192.168.122.0/24" ];
      };
    };

    # UFW (alternative firewall)
    # ufw.enable = true;

    # Fail2ban
    fail2ban = {
      enable = true;
      configFile = ''
        [DEFAULT]
        bantime = 1h
        findtime = 10m
        maxretry = 5
        backend = systemd
        action = %(action_mw)s
        destemail = root@localhost
        sendername = Fail2Ban
        mta = sendmail
        protocol = tcp
        chain = INPUT
        port = 0:65535
        fail2ban_agent = Fail2Ban/%(version)s

        [sshd]
        enabled = true
        filter = sshd
        action = iptables-multiport[name=sshd, port="ssh", protocol=tcp]
        logpath = %(syslog_authpriv)s
        backend = systemd
        maxretry = 3
        bantime = 1h
      '';
    };

    # Audit
    auditd.enable = true;

    # Thermald
    thermald.enable = true;

    # Auto-cpufreq
    auto-cpufreq.enable = true;

    # Laptop mode
    # laptop-mode-tools.enable = true;

    # NFS
    # nfs.client.enable = true;

    # Samba
    # samba.enable = true;

    # SSH server
    openssh = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
      challengeResponseAuthentication = false;
      usePAM = true;
      settings = {
        AllowAgentForwarding = "no";
        AllowTcpForwarding = "yes";
        GatewayPorts = "no";
        X11Forwarding = "yes";
        PrintMotd = "no";
        ClientAliveInterval = 300;
        ClientAliveCountMax = 2;
        MaxAuthTries = 3;
        MaxSessions = 10;
        LoginGraceTime = 60;
        PermitEmptyPasswords = "no";
        PermitUserEnvironment = "no";
        UseDNS = "no";
        AuthenticationMethods = "publickey";
        PubkeyAuthentication = "yes";
        AuthorizedKeysFile = ".ssh/authorized_keys";
        PasswordAuthentication = "no";
        ChallengeResponseAuthentication = "no";
        KbdInteractiveAuthentication = "no";
        GSSAPIAuthentication = "no";
        KerberosAuthentication = "no";
        HostbasedAuthentication = "no";
      };
    };

    # Logrotate
    logrotate.enable = true;

    # MLocate
    mlocate.enable = true;

    # Cache cleanup
    systemd-tmpfiles = {
      rules = [
        "d /tmp 1777 root root 1d"
        "d /var/tmp 1777 root root 30d"
      ];
    };
  };

  # Nix settings
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      max-jobs = "auto";
      cores = 0;
      substituters = [ "https://cache.nixos.org" "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    registry = {
      pinned = {
        nixpkgs = {
          from = {
            id = "nixpkgs";
            type = "indirect";
          };
          to = {
            type = "github";
            owner = "NixOS";
            repo = "nixpkgs";
            ref = "nixos-unstable";
          };
        };
      };
    };
  };

  # Kernel
  boot = {
    kernelParams = [
      "amdgpu.ppfeaturemask=0xffffffff"
      "amdgpu.vm_fault_stop_engine=0"
      "amdgpu.aspm=0"
      "amdgpu.runpm=0"
      "nvme_core.default_ps_max_latency_us=0"
      "transparent_hugepage=always"
      "mitigations=off"
    ];
    kernel.sysctl = {
      "vm.swappiness" = 10;
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_ratio" = 15;
      "vm.dirty_background_ratio" = 5;
      "net.core.netdev_max_backlog" = 250000;
      "net.core.somaxconn" = 65535;
      "net.ipv4.tcp_max_syn_backlog" = 8192;
      "net.ipv4.tcp_fin_timeout" = 15;
      "net.ipv4.tcp_keepalive_time" = 300;
      "net.ipv4.tcp_keepalive_intvl" = 30;
      "net.ipv4.tcp_keepalive_probes" = 5;
    };
  };

  # Systemd coredump
  systemd.coredump.enable = false;
}
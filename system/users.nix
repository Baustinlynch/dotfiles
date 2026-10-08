{ config, pkgs, lib, ... }:

{
  users = {
    mutableUsers = false;
    users.brenden = {
      isNormalUser = true;
      description = "Brenden";
      extraGroups = [
        "wheel"
        "networkmanager"
        "video"
        "audio"
        "docker"
        "libvirt"
        "kvm"
        "render"
        "input"
        "storage"
        "scanner"
        "lp"
        "optical"
        "users"
        "power"
        "rfkill"
        "uucp"
        "dialout"
        "tty"
        "cdrom"
        "floppy"
        "plugdev"
      ];
      shell = pkgs.zsh;
      home = "/home/brenden";
      createHome = true;
      useDefaultShell = true;
      # SSH keys - add your public keys here
      openssh.authorizedKeys.keys = [
        # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... user@host"
      ];
      # GPG keys (optional)
      # gpg.key = "-----BEGIN PGP PUBLIC KEY BLOCK-----\n...\n-----END PGP PUBLIC KEY BLOCK-----";
    };
  };

  # Groups
  groups = {
    docker.gid = 999;
    libvirt.gid = 998;
    kvm.gid = 997;
  };

  # Sudo
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
    configFile = "/etc/sudoers.d/wheel";
  };

  # PAM
  security.pam = {
    services.sudo = {
      auth = [
        { type = "sufficient"; module = "pam_fingerprint.so"; }
        { type = "include"; module = "system-auth"; }
      ];
    };
    services.system-auth = {
      auth = [
        { type = "sufficient"; module = "pam_fingerprint.so"; }
        { type = "include"; module = "system-login"; }
      ];
    };
  };
}
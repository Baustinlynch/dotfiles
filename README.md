# NixOS Configuration

Declarative NixOS system + home-manager configuration. Run this on a fresh NixOS install to reproduce the full environment.

## Structure

```
~/Documents/nixos-config/
├── flake.nix              # Flake entry point
├── flake.lock             # Locked inputs (generated)
├── .gitignore
├── README.md              # This file
├── system/
│   ├── base.nix           # Core system: boot, kernel, users, nix, security
│   ├── desktop.nix        # Desktop: graphics, fonts, themes, apps, WM (bspwm/niri)
│   ├── hardware.nix       # Hardware config (generate on target machine)
│   ├── networking.nix     # Network: NetworkManager, firewall, DNS, time, locale
│   ├── users.nix          # User accounts, groups, sudo, PAM
│   └── services.nix       # System services: docker, libvirt, tailscale, etc.
└── home/
    ├── home.nix           # Home-manager entry point
    ├── packages.nix       # User packages (~80 packages)
    ├── programs.nix       # Native HM modules: git, tmux, starship, zoxide, etc.
    ├── files.nix          # Dotfiles symlinks → Documents/dots
    └── services.nix       # User services: mpd, syncthing, etc.
```

## Quick Start (Fresh NixOS Install)

### 1. Boot NixOS installer

Download NixOS ISO (minimal or graphical), boot, and get to a root shell.

### 2. Partition & format disks

```bash
# Example for UEFI + Btrfs (adjust for your disk)
lsblk
# /dev/nvme0n1 - target disk

# Wipe
wipefs -a /dev/nvme0n1

# Partition
parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 1GiB
parted /dev/nvme0n1 -- set 1 esp on
parted /dev/nvme0n1 -- mkpart primary btrfs 1GiB 100%

# Format
mkfs.fat -F32 -n ESP /dev/nvme0n1p1
mkfs.btrfs -L nixos /dev/nvme0n1p2

# Mount
mount /dev/disk/by-label/nixos /mnt
mkdir /mnt/boot
mount /dev/disk/by-label/ESP /mnt/boot

# Create subvolumes (optional but recommended)
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@nix
btrfs subvolume create /mnt/@persist
btrfs subvolume create /mnt/@log

# Remount with subvolumes
umount /mnt
mount -o subvol=@,compress=zstd,noatime /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/{home,nix,persist,var/log,boot}
mount -o subvol=@home,compress=zstd,noatime /dev/disk/by-label/nixos /mnt/home
mount -o subvol=@nix,compress=zstd,noatime /dev/disk/by-label/nixos /mnt/nix
mount -o subvol=@persist,compress=zstd,noatime /dev/disk/by-label/nixos /mnt/persist
mount -o subvol=@log,compress=zstd,noatime /dev/disk/by-label/nixos /mnt/var/log
mount /dev/disk/by-label/ESP /mnt/boot
```

### 3. Generate hardware config

```bash
nixos-generate-config --root /mnt
# This creates /mnt/etc/nixos/hardware-configuration.nix
# Copy it to this repo:
cp /mnt/etc/nixos/hardware-configuration.nix ~/Documents/nixos-config/system/hardware.nix
```

### 4. Clone this config & install

```bash
# In the installer environment:
nix-shell -p git
git clone <your-repo-url> /mnt/home/brenden/Documents/nixos-config
# OR copy the config manually if no network yet

# Install
nixos-install --flake /mnt/home/brenden/Documents/nixos-config#nixos

# Set root password
nixos-enter --root /mnt -c "passwd root"

# Set user password
nixos-enter --root /mnt -c "passwd brenden"
```

### 5. Reboot

```bash
reboot
```

### 6. Post-install (as user `brenden`)

```bash
# Add SSH keys
ssh-keygen -t ed25519 -C "brenden@nixos"

# Home-manager is already applied via NixOS module
# But you can manually switch:
home-manager switch --flake ~/Documents/nixos-config#brenden

# Verify
fastfetch
```

## Daily Workflow

```bash
# System updates
sudo nixos-rebuild switch --flake ~/Documents/nixos-config#nixos

# Test without making permanent
sudo nixos-rebuild test --flake ~/Documents/nixos-config#nixos

# Update flake inputs + rebuild
sudo nix flake update ~/Documents/nixos-config && sudo nixos-rebuild switch --flake ~/Documents/nixos-config#nixos

# Home-manager only (user packages/dotfiles)
home-manager switch --flake ~/Documents/nixos-config#brenden

# Rollback
sudo nixos-rebuild switch --rollback
home-manager switch --rollback

# List generations
sudo nixos-rebuild list-generations
home-manager generations

# Garbage collection
nix-collect-garbage -d
sudo nix-collect-garbage -d
```

## What's Included

### System (system/)
- **Boot**: systemd-boot, UEFI, AMD GPU kernel params
- **Graphics**: amdgpu, vulkan, OpenGL, VA-API
- **Fonts**: Noto, JetBrains Mono, Fira Code, Cascadia, Nerd Fonts
- **Theming**: GTK (Adwaita-dark), Qt (Kvantum), icons (Papirus-Dark)
- **Display**: SDDM (Sugar Candy theme), bspwm + niri (Wayland)
- **Audio**: PipeWire + WirePlumber
- **Bluetooth**: bluez + blueman
- **Network**: NetworkManager + systemd-resolved + firewall
- **Virtualization**: Docker, Podman, libvirt/KVM
- **Security**: AppArmor, firewall, fail2ban, auditd
- **Power**: TLP, thermald, auto-cpufreq
- **Printing**: CUPS + Gutenprint/HPLIP

### Home (home/)
- **Shells**: zsh (Oh My Zsh + agnoster), fish, bash
- **Editors**: neovim, helix, micro, vscode
- **Terminals**: alacritty, kitty, foot, wezterm
- **CLI tools**: btop, htop, tmux, lazygit, yazi, ranger, starship, zoxide, fzf, ripgrep, fd, bat, eza, delta, dust, procs, jq, yq, pandoc, yt-dlp, grim, slurp, wl-clipboard
- **Dev**: git, gh, nodejs/pnpm/bun/deno, python/poetry/ruff, rustup/cargo, gcc/clang/cmake, docker-compose, buildah, skopeo
- **Media**: mpv, vlc, gimp, inkscape, blender, obs-studio, cava, ncmpcpp, mpd
- **Browsers**: firefox, zen-browser, chromium, tor-browser
- **Comms**: slack, zoom, discord, signal, element, thunderbird
- **Office**: libreoffice, zathura, okular, atril
- **Files**: thunar, nnn, lf, rclone, syncthing, restic, borg, age, sops, pass, bitwarden
- **Network**: nmap, wireshark, mosh, tailscale, wireguard, openvpn
- **VMs**: qemu, libvirt, virt-manager
- **Gaming**: steam, lutris, heroic, bottles, gamemode, mangohud, vkbasalt, gamescope, protontricks
- **Unfree**: spotify, spicetify, zoom, google-earth, vscode, todoist, obsidian, tor-browser

### Dotfiles (hybrid)
- **Native HM modules**: git, tmux, starship, zoxide, fzf, btop, yazi, neovim, dunst, bat, delta, eza, direnv, atuin
- **Out-of-store symlinks** → `~/Documents/dots/config/`: waybar, niri, picom, rofi, btop, kitty, alacritty, fish, ranger, thunar, gtk, qt5ct/qt6ct, Kvantum, mako, fuzzel, wlogout, swaylock, swayidle, dunst
- **Home files**: .gitconfig, local bin scripts, local share applications

### Excluded from management
- `gh/hosts.yml` (OAuth token)
- `wakatime.cfg` (API key)
- `~/.ssh/`
- Browser profiles (`zen/`, `.var/`)
- `vscode-user/`, `evolution/`, `opencode/`, `yay/`, `uv/`

## Customization

### Change hostname
Edit `flake.nix`: `hostName = "your-hostname";`

### Add SSH keys
Edit `system/users.nix` → `users.brenden.openssh.authorizedKeys.keys`

### Add WiFi networks
Edit `system/networking.nix` → `networking.wireless.networks`

### Add/remove packages
- System: `system/desktop.nix` → `environment.systemPackages`
- User: `home/packages.nix` → `home.packages`

### Enable/disable services
- System: `system/services.nix`
- User: `home/services.nix`

### Window manager
Currently: bspwm (X11) + niri (Wayland)
- To use only one, disable the other in `system/desktop.nix`

## Hardware Config

The file `system/hardware.nix` is a placeholder. On the target machine, run:

```bash
sudo nixos-generate-config --root /mnt --show-hardware-config > ~/Documents/nixos-config/system/hardware.nix
```

Or after install:

```bash
sudo nixos-generate-config --show-hardware-config > ~/Documents/nixos-config/system/hardware.nix
```

Then rebuild.

## Secrets

For secrets (SSH keys, GPG keys, API tokens), use:
- **sops-nix** (encrypted in repo)
- **agenix** (age-encrypted in repo)
- **pass** / **gopass** / **bitwarden-cli** (external password managers)

Current config uses external managers (pass/gopass/bitwarden) for user secrets.

## Troubleshooting

### Boot issues
- Check kernel params in `system/base.nix` → `boot.kernelParams`
- Regenerate initrd: `sudo nixos-rebuild switch --flake ~/Documents/nixos-config#nixos`

### Graphics issues
- AMD: ensure `amdgpu` in `boot.initrd.kernelModules` and `boot.kernelModules`
- NVIDIA: switch to `services.xserver.videoDrivers = [ "nvidia" ];` and add `hardware.nvidia`

### Audio issues
- `systemctl --user status pipewire pipewire-pulse wireplumber`
- `pactl info`

### Network issues
- `systemctl status NetworkManager systemd-resolved`
- `resolvectl status`

### Home-manager not applying
- `home-manager switch --flake ~/Documents/nixos-config#brenden`
- Check `home-manager generations`

### Flake eval errors
- `nix flake check ~/Documents/nixos-config`

## References

- [NixOS Manual](https://nixos.org/manual/nix/stable/)
- [Home-Manager Manual](https://nix-community.github.io/home-manager/)
- [Nixpkgs Search](https://search.nixos.org/packages)
- [NixOS Options](https://search.nixos.org/options)
- [NixOS Wiki](https://nixos.wiki/)
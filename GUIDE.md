# NixOS Config Guide

This document explains how this repository is structured, how NixOS and Home Manager work together, and how to make changes.

## What is NixOS?

NixOS is a Linux distribution built on the Nix package manager. Instead of installing packages imperatively (`apt install foo`), you declare your entire system configuration in `.nix` files, and Nix builds a complete system generation from those declarations.

Key concepts:

- **Declarative**: You describe what you want, not how to get there. Nix figures out the steps.
- **Reproducible**: The same config produces the same system. `flake.lock` pins every input to an exact revision.
- **Atomic upgrades/rollbacks**: Every `nixos-rebuild switch` creates a new system generation. If it breaks, boot into the previous generation from the bootloader.
- **Store**: All packages live in `/nix/store/<hash>-name`. Multiple versions coexist; the store is garbage-collected when unreferenced.

## What is Home Manager?

Home Manager is a Nix module that manages user-level configuration (dotfiles, user packages, systemd user services, shell config). It runs as part of `nixos-rebuild` because this repo uses `home-manager.nixosModules.home-manager` in `flake.nix`.

- **System config** (in `hosts/` and `modules/`): applies to the whole machine — kernel, drivers, system services, firewall, users.
- **Home config** (in `home/default.nix`): applies to user `brenden` — dotfiles, packages, shell, user services.

When you run `nixos-rebuild switch`, both system and home configurations are applied together.

## Repository Structure

```
nixos-config/
├── flake.nix                    # Entry point: defines inputs + nixosConfigurations.laptop
├── flake.lock                   # Pinned input revisions (commit this!)
├── AGENTS.md                    # Instructions for coding agents
├── README.md                    # Setup documentation
├── .gitignore                   # Ignores build artifacts, editor files
├── .githooks/pre-commit         # Runs gitleaks on every commit
├── .gitleaks.toml               # gitleaks config (extends defaults)
├── hosts/laptop/
│   ├── configuration.nix        # Host-specific system config
│   ├── hardware-configuration.nix  # Generated hardware detection (do not hand-edit)
│   └── lt-rootca.pem            # School TLS interception CA
├── modules/nixos/
│   ├── desktop.nix              # Desktop environment (niri, pipewire, bluetooth, etc.)
│   ├── dev.nix                  # Development tools (git, docker, compilers)
│   └── hardware/
│       └── touchpad.nix         # Dell Inspiron touchpad quirks
├── home/
│   └── default.nix             # Home Manager config for user brenden
└── dotfiles/
    ├── waybar/                 # Status bar config
    ├── fuzzel/                 # App launcher
    ├── mako/                   # Notification daemon
    ├── niri/                   # Window manager (config.kdl)
    ├── waypaper/               # Wallpaper manager
    ├── zed/                    # Editor settings
    ├── obsidian/               # Notes app config
    ├── alacritty/              # Terminal emulator
    ├── btop/                   # Process monitor
    └── zen/                    # Zen browser (empty - app-managed)
```

## How the flake works (`flake.nix`)

A flake is a pure function: inputs → outputs. The `flake.nix` file defines:

1. **Inputs**: Dependencies (nixpkgs, home-manager, zen-browser, etc.). Each input is pinned in `flake.lock`.
2. **Outputs**: `nixosConfigurations.laptop` — the system configuration.

```nix
outputs = { self, nixpkgs, home-manager, ... }:
  let system = "x86_64-linux";
  in {
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./hosts/laptop/configuration.nix       # Host config
        home-manager.nixosModules.home-manager  # Home Manager integration
        { home-manager.users.brenden = { imports = [ ./home ]; }; }
        # Zen browser + OneNote as system packages
        { environment.systemPackages = [ ... ]; }
      ];
    };
  };
```

When you run `nixos-rebuild switch --flake .#laptop`, Nix evaluates this function, builds the system, and activates it.

### Inputs and follows

Inputs can depend on other inputs. `home-manager.inputs.nixpkgs.follows = "nixpkgs"` means Home Manager uses the same nixpkgs as the system, avoiding duplicate copies. This repo sets `follows` for all inputs.

### Updating inputs

`nix flake update` updates `flake.lock` to the latest revisions. This is separate from rebuilding — run `update` when you want newer packages, then `rebuild` to apply.

## How modules work

NixOS uses a module system. Each `.nix` file is a function `{ config, pkgs, ... }:` that returns an attribute set of options. Modules are merged together.

```nix
# modules/nixos/desktop.nix
{ config, pkgs, ... }:
{
  programs.niri.enable = true;
  services.pipewire.enable = true;
  # ...
}
```

- **`config`**: The final merged configuration (read-only in most cases).
- **`pkgs`**: The package set (nixpkgs).
- **`lib`**: Helper functions (imported via `with lib;`).

Modules can define new options, set existing ones, or conditionally enable features. The module system resolves conflicts and merges lists.

## How Home Manager works

Home Manager manages user-level config. In this repo, it's integrated into NixOS via:

```nix
home-manager.users.brenden = {
  imports = [ ./home ];
};
```

`home/default.nix` is the Home Manager entry point. It defines:

### Packages (`home.packages`)
```nix
home.packages = with pkgs; [
  firefox
  btop
  # ...
];
```
These are installed into the user's profile (`~/.nix-profile/bin/`).

### Programs (`programs.*`)
Home Manager has modules for many apps that generate config files:
```nix
programs.git = {
  enable = true;
  settings.user.name = "brenden";
};
```
This creates `~/.config/git/config` with the specified settings.

### Dotfiles (`xdg.configFile`)
For apps without a Home Manager module, you link files directly:
```nix
# Static: copied into Nix store, read-only
xdg.configFile."waybar/config".source = ../dotfiles/waybar/config;

# Mutable: symlink to repo file, app writes land in repo
xdg.configFile."zed/settings.json" = {
  source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixos-config/dotfiles/zed/settings.json";
  force = true;
};
```

- **Static** (`source = ../dotfiles/...`): File is copied into the Nix store. Changes require `git add` + rebuild. Good for stable configs.
- **Mutable** (`mkOutOfStoreSymlink`): Creates a symlink pointing at the repo file. App writes land in the repo. Good for app-rewritten configs. But `nixos-rebuild --rollback` won't restore these.

### User systemd services
```nix
systemd.user.services.waybar = {
  description = "Waybar status bar";
  serviceConfig = {
    Type = "simple";
    ExecStart = "${pkgs.waybar}/bin/waybar";
  };
  wantedBy = [ "graphical-session.target" ];
};
```
These are managed declaratively and start when the graphical session starts.

## How to make changes

### Adding a system package

Edit `hosts/laptop/configuration.nix` or `modules/nixos/desktop.nix`:

```nix
environment.systemPackages = with pkgs; [
  # ... existing packages ...
  new-package
];
```

Then `git add` the file and rebuild.

### Adding a user package

Edit `home/default.nix`:

```nix
home.packages = with pkgs; [
  # ... existing packages ...
  new-package
];
```

### Adding a dotfile

1. Create the file in `dotfiles/<app>/`.
2. Add a link in `home/default.nix`:
   ```nix
   xdg.configFile."<app>/<file>".source = ../dotfiles/<app>/<file>;
   ```
3. `git add` both files, then rebuild.

### Changing an app config

1. Edit the file in `dotfiles/<app>/`.
2. `git add` the file.
3. Rebuild.

### Adding a systemd user service

Add to `home/default.nix`:
```nix
systemd.user.services.my-service = {
  description = "My service";
  serviceConfig = {
    Type = "simple";
    ExecStart = "${pkgs.my-package}/bin/my-binary";
  };
  wantedBy = [ "graphical-session.target" ];
};
```

## Key pitfalls

1. **`git add` new files first.** Flakes only see tracked files. An untracked dotfile fails with "path does not exist".
2. **Niri reads `config.kdl`**, not `config`. The dotfile must be named `config.kdl` in `dotfiles/niri/`.
3. **Mutable symlinks can break.** Apps that save via atomic rename (temp file + rename) replace the symlink with a real file. Waypaper and Obsidian are prone to this.
4. **`nix profile` packages are not declarative.** Don't use `nix profile install` — add packages to the Nix config instead.
5. **Hibernation needs swap ≥ RAM.** Currently 8 GiB swap vs 14 GiB RAM.
6. **`nix flake update` on every rebuild** makes builds non-reproducible. Use `update` and `rebuild` aliases separately.
7. **`result` is gitignored.** Never commit build artifacts.
8. **`gitleaks` may not be on PATH pre-rebuild.** The pre-commit hook falls back to `nix run`.
9. **The `rebuild` alias does not run `nix flake update`.** If you want newer packages, run `update` first.
10. **`hardware-configuration.nix`** is generated — don't hand-edit it except for resume params (which should be in `configuration.nix`).

## How the system boots

1. **BIOS/UEFI** → systemd-boot (from `boot.loader.systemd-boot.enable`)
2. **systemd-boot** → NixOS kernel + initrd
3. **initrd** → mounts root, resumes from hibernate if applicable
4. **systemd** → reaches `multi-user.target` (system services: NetworkManager, Tailscale, Syncthing, Docker)
5. **greetd** → displays login screen
6. **niri-session** → starts niri compositor, graphical session
7. **graphical-session.target** → starts waybar, waypaper (restore), mako, polkit, nm-applet, blueman-applet, xwayland-satellite
8. **Home Manager** → symlinks dotfiles, sets up shell, installs packages

## Flake inputs

| Input | Source | Purpose |
|-------|--------|---------|
| nixpkgs | github:NixOS/nixpkgs/nixos-unstable | Package set |
| home-manager | github:nix-community/home-manager | User config management |
| hermes-agent | github:NousResearch/hermes-agent | Hermes Agent CLI + desktop |
| zen-browser | github:0xc000022070/zen-browser-flake | Zen Browser |
| onenote-linux | github:Baustinlynch/onenote-linux | OneNote client |

All inputs follow nixpkgs (via `inputs.nixpkgs.follows = "nixpkgs"`) to avoid duplicate closures.
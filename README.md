# NixOS Config

Flake-based NixOS configuration for Dell Inspiron 15 3525 (AMD Ryzen, Radeon graphics).

## Setup on target laptop

1. Install NixOS (minimal) from USB.
2. Clone this repo:
   ```
   git clone https://github.com/Baustinlynch/dotfiles /etc/nixos
   ```
3. Generate hardware config:
   ```
   sudo nixos-generate-config --show-hardware-config > hosts/laptop/hardware-configuration.nix
   ```
4. Apply:
   ```
   sudo nixos-rebuild switch --flake .#laptop
   ```

## Testing in a VM

Use `nixos-rebuild build-vm --flake .#laptop` on a NixOS machine, or install NixOS in a VM (Hyper-V/VirtualBox) and run the steps above.

## Dotfiles

Hand-edited app configs live in `dotfiles/<app>/` as real files and are wired in
`home/default.nix`. Two link modes:

**Static** — file is copied into the Nix store and symlinked in (read-only). Edit
the repo file, then `git add` and rebuild to apply.

```nix
xdg.configFile."waybar/config".source = ../dotfiles/waybar/config;
```

Used for: waybar, fuzzel, mako.

**Mutable** — symlink points at the repo file directly, so the app's own writes land
in the repo and show up in `git diff`. Content is *not* captured by the Nix
generation, so `nixos-rebuild --rollback` won't restore it.

```nix
xdg.configFile."zed/settings.json".source =
  config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixos-config/dotfiles/zed/settings.json";
```

Used for: waypaper, zed, obsidian.

Rules:
- **`git add` new files before rebuilding.** Flakes only see git-tracked files; an
  untracked config fails the build with "path does not exist".
- **Never symlink a whole app directory into the store** for apps that create files —
  the parent becomes read-only. Link per-file, or use an out-of-store symlink.
- **Never commit credentials.** Not covered: `zen/` (cookies, `logins.db`, `key4.db`,
  regenerated `prefs.js`), `btop` (writes `btop.conf` only on first launch), anything
  under `gh/`, and app API keys. See below for the guard.

## Secret scanning

`gitleaks` runs as a git pre-commit hook over staged changes and blocks the commit
on a hit:

```
git config core.hooksPath .githooks   # already set on this machine
```

Full history scan (run before pushing, or after adding credentials anywhere):

```
gitleaks git . --redact --no-banner -v     # or the `secrets` fish alias
```

A false positive goes in `.gitleaks.toml` as an allowlist entry — not into a
`--no-verify` habit. Note gitleaks ships allowlist entries for well-known example
keys (e.g. AWS's `AKIAIOSFODNN7EXAMPLE`), so that string won't trip the hook.

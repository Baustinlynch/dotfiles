# AGENTS.md

NixOS flake configuration for a Dell Inspiron 15 3525. Single host: `laptop` (`x86_64-linux`, nixos-unstable). Home Manager for user `brenden`. No test suite, linter, formatter, or CI exists in this repo — verification is `nixos-rebuild` itself (`build-vm` for testing).

## Commands (run from repo root)

- Apply to the laptop: `sudo nixos-rebuild switch --flake .#laptop`
  (fish alias `rebuild` = `cd ~/nixos-config; and git pull; and git add .; and sudo nixos-rebuild switch --flake ~/nixos-config#laptop`)
- Test in a VM: `nixos-rebuild build-vm --flake .#laptop` (NixOS host only)
- Regenerate hardware detection: `sudo nixos-generate-config --show-hardware-config > hosts/laptop/hardware-configuration.nix`
- Full secret history scan: `gitleaks git . --redact --no-banner -v` (fish alias `secrets`)
- Format nix files: `nix fmt`
- Verify flake: `nix flake check`

## Repo layout

- `flake.nix` — the only entrypoint. Defines `nixosConfigurations.laptop`, imports `hosts/laptop/configuration.nix` + home-manager (user `brenden`, imports `./home` and the hermes-agent HM module), adds zen-browser + onenote-linux as system packages. Also provides `formatter` and `checks`.
- `hosts/laptop/configuration.nix` — imports `hardware-configuration.nix`, `modules/nixos/{desktop,dev}`, `modules/nixos/hardware/touchpad.nix`.
- `home/default.nix` — Home Manager config; all dotfile sources are declared here.
- `dotfiles/<app>/` — real config files (waybar, fuzzel, mako, niri, waypaper, zed, obsidian, btop, zen, alacritty).
- `scripts/` — helper scripts (update check).

## Rules that break the build if ignored

- `git add` any new file before rebuilding. Flakes only see git-tracked files; an untracked file fails the build with "path does not exist".
- Dotfile link modes (see `home/default.nix`):
  - Static (`source = ../dotfiles/...`): copied into the Nix store, read-only. Edit the repo file, then `git add` + rebuild to apply. (waybar, fuzzel, mako, niri, alacritty)
  - Mutable (`mkOutOfStoreSymlink`: waypaper, zed, obsidian): app writes land directly in the repo and show up in `git diff`; `nixos-rebuild --rollback` will NOT restore them. Never symlink a whole app directory into the store for apps that create files — link per file.
- Never commit credentials. `gitleaks` runs on every commit via `.githooks/pre-commit` (`git config core.hooksPath .githooks` — already set on this machine). Fallback if gitleaks is not on PATH: `nix run nixpkgs#gitleaks -- git --pre-commit --staged --redact --no-banner -v`. False positive → add an allowlist entry to `.gitleaks.toml` (with `[extend] useDefault = true` so default rules stay active), not a `--no-verify` habit.
- Niri reads `config.kdl` (not `config`). The dotfile must be named `config.kdl` in `dotfiles/niri/`.
- `result` build artifact is gitignored. Never commit it.

## Environment quirks

- Login shell is fish; bash and zsh remain installed as fallbacks.
- `nix.settings.experimental-features = [ "nix-command" "flakes" ]`; `nixpkgs.config.allowUnfree = true`.
- On the Boroughmuir LT_OPEN network the TLS interception root CA (`hosts/laptop/lt-rootca.pem`) must be trusted or nix/curl/firefox fail certificate validation.
- Hermes Agent: `programs.hermes-agent.enable = true`. First run: `hermes setup` to add API keys. Do not also enable `services.hermes-agent` unless you want the persistent gateway daemon.
- User systemd services (waybar, waypaper, hermes-gateway, update-check) are declared in `home/default.nix` under `systemd.user.services`, not as standalone files in `~/.config/systemd/user/`.
- `nix profile` packages have been migrated to declarative config. Do not re-add packages via `nix profile install`.

## Pitfalls

- `nix flake update` on every rebuild makes builds non-reproducible. Use `update` (flake update) and `rebuild` (rebuild only) separately.
- Niri config is `config.kdl` — editing the repo's old `config` file has no effect.
- Waypaper/Zed/Obsidian configs use `mkOutOfStoreSymlink` (mutable). App writes via atomic rename can replace the symlink with a real file, breaking the link.
- Hibernation requires swap ≥ RAM (currently 8 GiB swap vs 14 GiB RAM — may fail under load). Update `resume_offset` after any swapfile recreation.
- `gitleaks` may not be on PATH pre-rebuild; the pre-commit hook falls back to `nix run` which needs network.
- `hardware.graphics.enable` was previously set only by the Steam module; now set explicitly in `desktop.nix`.
- `dotfiles/niri/config` is dead code — niri reads `config.kdl`. Do not edit the old file.
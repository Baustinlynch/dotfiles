# AGENTS.md

NixOS flake configuration for a Dell Inspiron 15 3525. Single host: `laptop` (`x86_64-linux`, nixos-unstable). Home Manager for user `brenden`. No test suite, linter, formatter, or CI exists in this repo — verification is `nixos-rebuild` itself (`build-vm` for testing).

## Commands (run from repo root)

- Apply to the laptop: `sudo nixos-rebuild switch --flake .#laptop`
  (fish alias `rebuild` = `sudo nixos-rebuild switch --flake ~/nixos-config#laptop`)
- Test in a VM: `nixos-rebuild build-vm --flake .#laptop` (NixOS host only)
- Regenerate hardware detection: `sudo nixos-generate-config --show-hardware-config > hosts/laptop/hardware-configuration.nix`
- Full secret history scan: `gitleaks git . --redact --no-banner -v` (fish alias `secrets`)

## Repo layout

- `flake.nix` — the only entrypoint. Defines `nixosConfigurations.laptop`, imports `hosts/laptop/configuration.nix` + home-manager (user `brenden`, imports `./home` and the hermes-agent HM module), and adds zen-browser + onenote-linux as system packages.
- `hosts/laptop/configuration.nix` — imports `hardware-configuration.nix`, `modules/nixos/{desktop,dev}`, `modules/nixos/hardware/touchpad.nix`.
- `home/default.nix` — Home Manager config; all dotfile sources are declared here.
- `dotfiles/<app>/` — real config files (waybar, fuzzel, mako, niri, waypaper, zed, obsidian, btop, zen).

## Rules that break the build if ignored

- `git add` any new file before rebuilding. Flakes only see git-tracked files; an untracked file fails the build with "path does not exist".
- Dotfile link modes (see `home/default.nix`):
  - Static (`source = ../dotfiles/...`): copied into the Nix store, read-only. Edit the repo file, then `git add` + rebuild to apply. (waybar, fuzzel, mako, niri)
  - Mutable (`mkOutOfStoreSymlink`: waypaper, zed, obsidian): app writes land directly in the repo and show up in `git diff`; `nixos-rebuild --rollback` will NOT restore them. Never symlink a whole app directory into the store for apps that create files — link per file.
- Never commit credentials. `gitleaks` runs on every commit via `.githooks/pre-commit` (`git config core.hooksPath .githooks` — already set on this machine). Fallback if gitleaks is not on PATH: `nix run nixpkgs#gitleaks -- git --pre-commit --staged --redact --no-banner -v`. False positive → add an allowlist entry to `.gitleaks.toml` (create it if missing), not a `--no-verify` habit.

## Environment quirks

- Login shell is fish; bash and zsh remain installed as fallbacks.
- `nix.settings.experimental-features = [ "nix-command" "flakes" ]`; `nixpkgs.config.allowUnfree = true`.
- On the Boroughmuir LT_OPEN network the TLS interception root CA (`hosts/laptop/lt-rootca.pem`) must be trusted or nix/curl/firefox fail certificate validation.
- Hermes Agent: `programs.hermes-agent.enable = true`. First run: `hermes setup` to add API keys. Do not also enable `services.hermes-agent` unless you want the persistent gateway daemon.

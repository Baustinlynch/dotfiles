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

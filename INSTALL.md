# Installing NixOS with the Graphical ISO (dual-boot with Windows)

This guide uses the NixOS **graphical** ISO to install alongside Windows on the
Dell Inspiron 15 3525, then applies this flake config.

## 1. Prepare install media
- Download the NixOS graphical ISO from https://nixos.org/download
- Write it to a USB stick (Rufus on Windows, or `dd`).

## 2. Boot the ISO
- Plug in the USB, reboot, press F12 for the boot menu, select the USB.
- Disable Secure Boot in BIOS if the ISO won't boot.
- Choose "NixOS (graphical)" from the boot menu.

## 3. Partition with the graphical installer
- Open the installer (Calamares). Choose "Manual partitioning".
- **Do not reformat the existing Windows EFI partition** — reuse it as `/boot`.
- Create an ext4 partition in the free space for the root filesystem (`/`).
  - Label it `nixos` so the placeholder hardware config matches.
- Set mount points: root → `/`, EFI → `/boot`.
- Finish the installer and let it install a default NixOS system.

## 4. First boot into the default system
- Reboot, remove the USB. The installer's bootloader should show NixOS.
- Log in with the user you created.

## 5. Apply this flake config
Open a terminal and run:

```bash
git clone https://github.com/Baustinlynch/dotfiles /etc/nixos
cd /etc/nixos
sudo nixos-generate-config --show-hardware-config > hosts/laptop/hardware-configuration.nix
```

## 6. Dual-boot note
The install now uses **systemd-boot** (`hosts/laptop/configuration.nix`), not GRUB.
GRUB/os-prober is only needed if you deliberately switch loaders; the live config
does not use GRUB on this machine.

## 7. Apply
```bash
sudo nixos-rebuild switch --flake .#laptop
```

## 8. Verify WiFi
After reboot, check the WiFi card:
```bash
lspci | grep -i net
```
- RTL8821CE → add `boot.extraModulePackages = [ config.boot.kernelPackages.rtl8821ce ];` to configuration.nix and rebuild.
- MediaTek MT7921 → works with the default kernel driver.

## 9. Reboot
You now boot straight into the systemd-boot menu (niri session via greetd).
Select the NixOS generation to boot.

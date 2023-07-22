{ config, lib, pkgs, ... }:

{
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  fileSystems."/"         = { label = "root"; fsType = "ext4"; };
  fileSystems."/boot/efi" = { label = "boot"; fsType = "vfat"; };
  fileSystems."/data"     = { label = "data"; fsType = "ext4"; };
  fileSystems."/borg"     = { label = "borg"; fsType = "ext4"; };

  swapDevices = [];

  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableAllFirmware = true;

  networking.interfaces.enp8s0.useDHCP = true;

  nixpkgs.hostPlatform = "x86_64-linux";
}

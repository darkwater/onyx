{ config, lib, modulesPath, ... }:

# this is a mix of nixos-generate-config and nixos-infect
let
  cfg = config.onyx.hetzner;
in
{
  options.onyx.hetzner = {
    enable = lib.mkEnableOption "Hetzner specific configuration";
  };

  config = lib.mkIf cfg.enable {
    boot.initrd.availableKernelModules = [
      "9p"
      "9pnet_virtio"
      "ahci"
      "ata_piix"
      "sd_mod"
      "sr_mod"
      "uhci_hcd"
      "virtio_blk"
      "virtio_mmio"
      "virtio_net"
      "virtio_pci"
      "virtio_scsi"
      "vmw_pvscsi"
      "xen_blkfront"
      "xhci_pci"
    ];

    boot.initrd.kernelModules = [ "nvme" "virtio_balloon" "virtio_console" "virtio_rng" ];
    boot.kernelModules = [ ];
    boot.extraModulePackages = [ ];

    boot.loader.grub.device = "/dev/sda";
    fileSystems."/" = { device = "/dev/sda1"; fsType = "ext4"; };

    swapDevices = [ ];

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}

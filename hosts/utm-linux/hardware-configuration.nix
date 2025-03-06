{ config, lib, modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "virtio_pci" "usbhid" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
    "/mnt/mac" = {
      device = "share"; # UTM's default qemu_mount_tag is "share".
      fsType = "9p";
      options = [
        "trans=virtio"
        "version=9p2000.L"
        "nofail"
        "rw"
      ];
    };
  };
  swapDevices = [
    { device = "/dev/disk/by-label/swap"; }
  ];
  networking.useDHCP = lib.mkDefault true;
}

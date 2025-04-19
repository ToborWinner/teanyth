{ pkgs, ... }:

{
  disko.devices.disk.main.device = "/dev/sda";

  hardware.enableRedistributableFirmware = true;

  # Some settings from https://github.com/NixOS/nixpkgs/blob/43bdffa3ba277122239d17a4b7792af8e322f698/nixos/modules/virtualisation/google-compute-config.nix#L61
  boot.initrd.availableKernelModules = [
    "virtio_net"
    "virtio_pci"
    "virtio_mmio"
    "virtio_blk"
    "virtio_scsi"
    "9p"
    "9pnet_virtio"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [
    "virtio_balloon"
    "virtio_console"
    "virtio_rng"
    "virtio_gpu"
  ];
  boot.kernelModules = [
    "virtio_pci"
    "virtio_net"
  ];
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    configurationLimit = 0;
    splashImage = null;
  };
  boot.loader.timeout = 0;

  services.udev.packages = [ pkgs.google-guest-configs ];
  services.udev.path = [ pkgs.google-guest-configs ];

  networking.extraHosts = ''
    169.254.169.254 metadata.google.internal metadata
  '';
  networking.timeServers = [ "metadata.google.internal" ];
  networking.usePredictableInterfaceNames = false;
  networking.interfaces.eth0.mtu = 1460;
}

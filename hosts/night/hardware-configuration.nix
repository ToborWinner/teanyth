{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  pers.disko = {
    deviceName = "/dev/sda";
    biosSupport = false;
    swapSize = "3G";
  };

  boot.initrd.availableKernelModules = [
    "uhci_hcd"
    "ehci_pci"
    "ahci"
    "virtio_pci"
    "virtio_scsi"
    "sd_mod"
    "sr_mod"
    # from https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/proxmox-image.nix
    "uas"
    "virtio_blk"
  ]; # TODO: Verify after installation
  boot.kernelModules = [ "kvm-amd" ];

  boot.kernelParams = [ "console=ttyS0,115200n8" ];

  hardware.enableRedistributableFirmware = true;

  # TODO: Can we do better? Maybe disable most features?
  services.cloud-init = {
    enable = true;
    network.enable = true;
    settings = {
      preserve_hostname = true;
      ssh_deletekeys = false;
      vendor_data.enabled = false;
      resize_rootfs = false;
      growpart.mode = "off";
      # allow_public_ssh_keys = false; # Voluntarily
    };
  };
  networking.useDHCP = false;

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    splashImage = null;
  };
  boot.loader.timeout = 2;
}

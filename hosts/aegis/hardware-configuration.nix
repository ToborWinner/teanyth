{
  inputs,
  ...
}:

{
  imports = [
    inputs.nixos-hardware.nixosModules.apple-macbook-pro-12-1
  ];

  pers.disko = {
    deviceName = "/dev/sda";
    swapSize = "15G";
  };

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.efiInstallAsRemovable = true;

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.kernelModules = [ "kvm-intel" ];
}

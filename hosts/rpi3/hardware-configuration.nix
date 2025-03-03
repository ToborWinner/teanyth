{ lib, inputs, ... }:

{
  # File systems are already defined by https://github.com/NixOS/nixpkgs/blob/22255ddec41b459f7f480ab6422ad10d0c4a98b7/nixos/modules/installer/sd-card/sd-image.nix
  # There is a root fs (ext4) and a /boot/firmware fs (vfat 30MB default size, configurable)

  imports = [ inputs.nixos-hardware.nixosModules.raspberry-pi-3 ];

  # The correct kernel packages are already specified by nixos-hardware, along with the ahci kernel module problem fix

  swapDevices = [
    {
      device = "/swapfile";
      size = 1024;
    }
  ];

  hardware.enableRedistributableFirmware = true;

  # boot.kernelParams = [ "cma=128M" ];
  # TODO: Check which are necessary for audio to work, if any
  boot.kernelParams = [
    "snd_bcm2835.enable_headphones=1"
    "snd-bcm2835.enable_compat_alsa=0"
    "snd_bcm2835.enable_hdmi=1"
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlan0.useDHCP = lib.mkDefault true;
}

{
  lib,
  modulesPath,
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix") # hardware.enableRedistributableFirmware = lib.mkDefault true;
    inputs.apple-silicon.nixosModules.apple-silicon-support
  ];

  boot.initrd.availableKernelModules = [ "usb_storage" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelParams = [ "apple_dcp.show_notch=1" ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  boot.m1n1CustomLogo = "${pkgs.nixos-icons}/share/icons/hicolor/256x256/apps/nix-snowflake.png";
  boot.loader.grub.useOSProber = false;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/7025b786-c4dc-4c54-b53c-d88a1b7c53a0";
    fsType = "btrfs";
    options = [
      "subvol=root"
      "ssd"
      "noatime"
    ];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/7025b786-c4dc-4c54-b53c-d88a1b7c53a0";
    fsType = "btrfs";
    options = [
      "subvol=persist"
      "ssd"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/7025b786-c4dc-4c54-b53c-d88a1b7c53a0";
    fsType = "btrfs";
    options = [
      "subvol=nix"
      "ssd"
      "noatime"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/745B-19FD";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/61126fb7-e038-4262-bf9e-7b8527779226"; } ];

  hardware = {
    asahi = {
      enable = true;
      useExperimentalGPUDriver = true;
      peripheralFirmwareDirectory = inputs.sensitive + "/firmware";
      setupAsahiSound = true;
      withRust = true;
    };
    graphics = {
      enable = true;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  # Widevine support
  environment.sessionVariables.MOZ_GMP_PATH = [
    "${pkgs.widevine-cdm-lacros}/gmp-widevinecdm/system-installed"
  ];
  nixpkgs.overlays = [ inputs.nixos-aarch64-widevine.overlays.default ];

  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", KERNEL=="macsmc-battery", ATTR{charge_control_end_threshold}="90"
  '';

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlan0.useDHCP = lib.mkDefault true;
}

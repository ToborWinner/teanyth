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
      useExperimentalGPUDriver = false;
      peripheralFirmwareDirectory = inputs.sensitive + "/firmware";
      setupAsahiSound = true;
    };
    graphics = {
      enable = true;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  # TODO: Remove this when upgrading

  nixpkgs.overlays = [
    (final: prev: {
      aquamarine = prev.aquamarine.overrideAttrs (old: {
        src = final.fetchFromGitHub {
          owner = "hyprwm";
          repo = "aquamarine";
          # rev = "498f46686dcf45589d820ede6a023175d7c8ad74";
          rev = "50637ed23e962f0db294d6b0ef534f37b144644b";
          hash = "sha256-EjaD8+d7AiAV2fGRN4NTMboWDwk8szDfwbzZ8DL1PhQ=";
          # hash = "sha256-iGLp5IkBm6nYdaoSr0/O4U0Ea2f9DRHuKIc5q9bnhkU=";
        };
      });

      hyprutils = prev.hyprutils.overrideAttrs (old: {
        src = final.fetchFromGitHub {
          owner = "hyprwm";
          repo = "hyprutils";
          # rev = "69efb6291c7343e936f2ddce622990ed018b7fdb";
          rev = "b364dcb7391709acb4492e100fe750ca722992e1";
          hash = "sha256-9QoDVkjLwjiZDR+y4cMWc/FVudRu5jCIG4rn15Afa9w=";
          # hash = "sha256-aWnI+0+qdCgwbbB/TH5RUW+PgC4u+z+xXnIceCxYUO4=";
        };
      });

      hyprland = prev.hyprland.overrideAttrs (old: {
        src = final.fetchFromGitHub {
          # owner = "gulafaran";
          owner = "hyprwm";
          repo = "hyprland";
          fetchSubmodules = true;
          # rev = "43f67a270c5b85b2f33866aff258ca4c0890f6e2"; NOT EVEN FIRST
          # hash = "sha256-2nXk3XVA/q78qEyu45oo5hQlYc0Fv5JloimO8EgCnSw=";
          rev = "8968db9b0e42ff0b41e3be78bc24572414dd1399";
          hash = "sha256-7lQH9AVSvLGWSviRhpAzSfMcLIglRiIvcHkldTC0QiE=";
          # hash = "sha256-tpaosPXe/JBPnFZ7HIDcOtkDU0CjEwgGh8pWOy7cn1E=";
        };
      });
    })
  ];

  # Widevine support
  environment.sessionVariables.MOZ_GMP_PATH = [
    "${pkgs.pers.firefox-widevine}/gmp-widevinecdm/system-installed"
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", KERNEL=="macsmc-battery", ATTR{charge_control_end_threshold}="90"
  '';

  virtualisation.vmVariant = {
    hardware.asahi.enable = lib.mkVMOverride false;
    virtualisation = {
      memorySize = 3072;
      cores = 4;
    };
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlan0.useDHCP = lib.mkDefault true;
}

{
  lib,
  config,
  inputs,
  ...
}:

let
  cfg = config.pers.disko;
in
{
  imports = [
    inputs.disko.nixosModules.disko
  ];

  options = {
    pers.disko = {
      enable = lib.mkEnableOption "disko";
      biosSupport = lib.mkEnableOption "bios support";
      swapSize = lib.mkOption {
        type = lib.types.str;
        default = "3G";
        example = "3G";
        description = "Size of the swap partition.";
      };
      deviceName = lib.mkOption {
        type = lib.types.str;
        default = "/dev/disk/by-diskseq/1";
        example = "/dev/sda";
        description = "Name of the disk.";
      };
    };

    # Documentation fix for core/lib/docs.nix
    # TODO: Better fix
    disko.devices = lib.mkOption {
      visible = "shallow";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = lib.mkIf cfg.enable [
      {
        assertion = config.pers.impermanence.enable;
        message = "At the moment the disko module only supports btrfs impermanence setups.";
      }
    ];

    boot.loader.grub = lib.mkIf (!cfg.biosSupport) {
      efiSupport = true;
      device = "nodev";
    };

    disko.devices.disk.main = {
      type = "disk";
      device = cfg.deviceName;
      content = {
        type = "gpt";
        partitions = {
          boot = lib.mkIf cfg.biosSupport {
            name = "boot";
            size = "1M";
            type = "EF02";
          };
          ESP = {
            name = "ESP";
            size = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          swap = {
            size = cfg.swapSize;
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [
                "-L"
                "nixos"
                "-f"
              ];
              subvolumes = {
                "/root" = {
                  mountpoint = "/";
                  mountOptions = [
                    "subvol=root"
                    "noatime"
                  ];
                };

                "/persist" = {
                  mountOptions = [
                    "subvol=persist"
                    "noatime"
                  ];
                  mountpoint = "/persist";
                };

                "/nix" = {
                  mountOptions = [
                    "subvol=nix"
                    "noatime"
                  ];
                  mountpoint = "/nix";
                };
              };
            };
          };
        };
      };
    };
  };
}

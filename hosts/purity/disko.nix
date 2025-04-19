{ lib, ... }:

{
  disko.devices.disk.main = {
    type = "disk";
    device = lib.mkDefault "/dev/disk/by-diskseq/1";
    content = {
      type = "gpt";
      partitions = {
        boot = {
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
          size = "3G";
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
}

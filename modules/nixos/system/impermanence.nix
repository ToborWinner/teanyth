{
  lib,
  config,
  inputs,
  settings,
  ...
}:

{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.pers.impermanence = {
    enable = lib.mkEnableOption "impermanence";
    configureUser = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to configure the user's impermanent directories and files automatically.";
    };
    daysToKeep = lib.mkOption {
      type = lib.types.ints.positive;
      description = "The amount of days to keep old roots around.";
      default = 15;
    };
    amountToKeep = lib.mkOption {
      type = lib.types.ints.positive;
      description = "The amount of old roots to keep around. If exceeded, older ones will be deleted.";
      default = 10;
    };
    persistFileSystem = lib.mkOption {
      type = lib.types.str;
      description = "The folder where the persistent filesystem will be mounted. Should be the same as the one used in the fileSystems option.";
      default = "/persist";
    };
  };

  config = lib.mkMerge [
    { virtualisation.vmVariant.pers.impermanence.enable = lib.mkVMOverride false; }
    (lib.mkIf config.pers.impermanence.enable {
      boot.initrd.postResumeCommands = lib.mkAfter ''
        mkdir /btrfs_tmp
        mount ${config.fileSystems."/".device} /btrfs_tmp
        if [[ -e /btrfs_tmp/root ]]; then
            mkdir -p /btrfs_tmp/old_roots
            timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
            mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
        fi

        delete_subvolume_recursively() {
            IFS=$'\n'
            for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                delete_subvolume_recursively "/btrfs_tmp/$i"
            done
            btrfs subvolume delete "$1"
        }

        for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +${builtins.toString config.pers.impermanence.daysToKeep}); do
            delete_subvolume_recursively "$i"
        done

        for i in $(ls -t /btrfs_tmp/old_roots/ | tail -n +${
          builtins.toString (config.pers.impermanence.amountToKeep + 1)
        } | awk -v dir="/btrfs_tmp/old_roots/" '{print dir $0}'); do
            delete_subvolume_recursively "$i"
        done

        btrfs subvolume create /btrfs_tmp/root
        umount /btrfs_tmp
      '';

      fileSystems.${config.pers.impermanence.persistFileSystem}.neededForBoot = true;

      security.sudo.extraConfig = "Defaults lecture = never"; # To avoid needing to make sudo data persistent

      environment.persistence."${config.pers.impermanence.persistFileSystem}/system" = {
        enable = true;
        hideMounts = true;
        directories = [
          "/var/log"
          (lib.mkIf config.hardware.bluetooth.enable "/var/lib/bluetooth")
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
          (lib.mkIf config.networking.networkmanager.enable "/etc/NetworkManager/system-connections")
          (lib.mkIf config.networking.wireless.iwd.enable {
            directory = "/var/lib/iwd";
            mode = "0700";
          })
          (lib.mkIf config.services.postgresql.enable {
            directory = "/var/lib/postgresql";
            user = "postgres";
            group = "postgres";
            mode = "u=rwx,g=rx,o=";
          })
        ];
        files = [ "/etc/machine-id" ];
        # TODO: Do this in home-manager (mostly to access hm config) and
        # add those based on pers options in home-manager and try to minimize stuff like .mozilla
        users.${settings.username} = lib.mkIf config.pers.impermanence.configureUser {
          directories = [
            "Downloads"
            "Documents"
            "Music"
            "Images"
            "sensitive"
            "teanyth"
            ".local/share/PrismLauncher"
            ".local/share/direnv"
            ".local/share/zoxide"
            ".local/share/mpd"
            ".config/wordtui"
            ".config/raspberry"
            ".config/Element"
            ".config/vesktop/sessionData"
            ".mozilla"
            # Maybe .cargo
            # { directory = ".gnupg"; mode = "0700"; }
            {
              directory = ".ssh";
              mode = "0700";
            }
            # { directory = ".nixops"; mode = "0700"; }
            # { directory = ".local/share/keyrings"; mode = "0700"; }
          ];
          files = [
            ".zsh_history"
            ".config/vesktop/state.json"
          ];
        };
      };
    })
  ];
}

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
    extraUserDirectories = lib.mkOption {
      type = lib.types.listOf lib.types.anything;
      default = [ ];
      description = "Additional directories to add to the ones kept if configureUser is true.";
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
      assertions = [
        {
          assertion =
            config.pers.impermanence.configureUser
            -> (config.pers.users.enable && config.pers.home-manager.enable);
          message = "If pers.impermanence.configureUser is set to true, then pers.users.enable and pers.home-manager.enable must also be set to true.";
        }
      ];

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
          (lib.mkIf config.pers.jolly.enable {
            directory = "/var/lib/redis/db";
            user = "redis";
            group = "redis";
            mode = "u=rwx,g=,o=";
          })
          (lib.mkIf config.pers.jolly.enable {
            directory = "/var/db/mongodb";
            user = config.services.mongodb.user;
            group = config.services.mongodb.user;
            mode = "u=rwx,g=,o=";
          })
        ] ++ config.pers.hypixel-bridge.impermanence;

        files = [ "/etc/machine-id" ];

        users.${settings.username} =
          let
            hmCfg = config.home-manager.users.${settings.username};
          in
          lib.mkIf config.pers.impermanence.configureUser {
            directories = [
              "Downloads"
              "Documents"
              "Music"
              "Images"
              "sensitive"
              "teanyth"
              (lib.mkIf hmCfg.pers.direnv.enable ".local/share/direnv")
              (lib.mkIf hmCfg.pers.zoxide.enable ".local/share/zoxide")
              (lib.mkIf hmCfg.pers.mpd.enable ".local/share/mpd")
              (lib.mkIf hmCfg.pers.nixcord.enable ".config/vesktop/sessionData")
              (lib.mkIf hmCfg.pers.firefox.enable ".mozilla")
              {
                directory = ".ssh";
                mode = "0700";
              }
            ] ++ config.pers.impermanence.extraUserDirectories;
            files = [
              (lib.mkIf hmCfg.pers.zsh.enable ".zsh_history")
              (lib.mkIf hmCfg.pers.nixcord.enable ".config/vesktop/state.json")
            ];
          };
      };
    })
  ];
}

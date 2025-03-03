{ lib, config, ... }:

# This file contains default common values for server configurations
# Heavy inspiration taken from https://github.com/nix-community/srvos/blob/main/nixos/server/default.nix
{
  options.pers.server.enable = lib.mkEnableOption "server";

  config = lib.mkIf config.pers.server.enable {
    environment = {
      # Print the URL instead on servers
      variables.BROWSER = "echo";
      # Don't install the /lib/ld-linux.so.2 and /lib64/ld-linux-x86-64.so.2
      # stubs. Server users should know what they are doing.
      stub-ld.enable = lib.mkDefault false;
    };

    # Ensure a clean & sparkling /tmp on fresh boots.
    boot.tmp.cleanOnBoot = lib.mkDefault true;

    # Save space
    documentation.nixos.enable = lib.mkDefault false;

    # No need for fonts on a server
    fonts.fontconfig.enable = lib.mkDefault false;

    programs.command-not-found.enable = lib.mkDefault false;

    # freedesktop xdg files
    xdg.autostart.enable = lib.mkDefault false;
    xdg.icons.enable = lib.mkDefault false;
    xdg.menus.enable = lib.mkDefault false;
    xdg.mime.enable = lib.mkDefault false;
    xdg.sounds.enable = lib.mkDefault false;

    programs.vim = {
      defaultEditor = lib.mkDefault true;
      enable = lib.mkDefault true;
    };

    # Make sure firewall is enabled
    networking.firewall.enable = true;

    # If the user is in @wheel they are trusted by default.
    nix.settings.trusted-users = [ "@wheel" ];

    # No mutable users by default
    users.mutableUsers = false;

    # Given that our systems are headless, emergency mode is useless.
    # We prefer the system to attempt to continue booting so
    # that we can hopefully still access it remotely.
    boot.initrd.systemd.suppressedUnits = lib.mkIf config.systemd.enableEmergencyMode [
      "emergency.service"
      "emergency.target"
    ];

    systemd = {
      # Given that our systems are headless, emergency mode is useless.
      # We prefer the system to attempt to continue booting so
      # that we can hopefully still access it remotely.
      enableEmergencyMode = false;

      # For more detail, see:
      #   https://0pointer.de/blog/projects/watchdog.html
      watchdog = {
        # systemd will send a signal to the hardware watchdog at half
        # the interval defined here, so every 7.5s.
        # If the hardware watchdog does not get a signal for 15s,
        # it will forcefully reboot the system.
        runtimeTime = "15s";
        # Forcefully reboot if the final stage of the reboot
        # hangs without progress for more than 30s.
        # For more info, see:
        #   https://utcc.utoronto.ca/~cks/space/blog/linux/SystemdShutdownWatchdog
        rebootTime = "30s";
        # Forcefully reboot when a host hangs after kexec.
        # This may be the case when the firmware does not support kexec.
        kexecTime = "1m";
      };

      sleep.extraConfig = ''
        AllowSuspend=no
        AllowHibernation=no
      '';
    };

    services.openssh = {
      # require public key authentication for better security
      settings.PasswordAuthentication = false;
      settings.KbdInteractiveAuthentication = false;
      # Prevent root login via ssh by default
      settings.PermitRootLogin = lib.mkDefault "no";
    };

    security.sudo = {
      # Server applications should not run on an user with wheel anyways and we connect via ssh
      wheelNeedsPassword = false;
      # Non-wheel users don't need access to sudo
      execWheelOnly = true;
    };

    # Make sure the serial console is visible in qemu when testing the server configuration
    # with nixos-rebuild build-vm
    virtualisation.vmVariant.virtualisation.graphics = lib.mkDefault false;
  };
}

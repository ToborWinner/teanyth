{
  lib,
  config,
  settings,
  pkgs,
  ...
}:

{
  options.pers.virtualisation = {
    enable = lib.mkEnableOption "virtualisation";
    isVmVariant = (lib.mkEnableOption null) // {
      description = "Whether this is currently a vm variant of the configuration.";
    };
  };

  # TODO: Refine module

  config = lib.mkMerge [
    {
      virtualisation.vmVariant.pers.virtualisation.isVmVariant = lib.mkOverride 0 true;
      pers.virtualisation.isVmVariant = lib.mkOverride 1 false;
    }
    (lib.mkIf config.pers.virtualisation.enable {
      boot.kernelModules = [ "kvm" ];

      users.users.${settings.username}.extraGroups = [ "libvirtd" ];

      virtualisation = {
        libvirtd = {
          enable = true;
          qemu = {
            package = pkgs.qemu;
            swtpm.enable = true;
            ovmf.enable = true;
            ovmf.packages = [ pkgs.OVMF.fd ];
          };
        };
        spiceUSBRedirection.enable = true;
      };

      environment.systemPackages = with pkgs; [
        spice
        spice-gtk
        spice-protocol
        virtio-win
        win-spice
      ];

      programs.virt-manager.enable = true;

      home-manager.users.${settings.username} = {
        dconf.settings = {
          "org/virt-manager/virt-manager/connections" = {
            autoconnect = [ "qemu:///system" ];
            uris = [ "qemu:///system" ];
          };
        };
      };

      services.spice-vdagentd.enable = true;
    })
  ];
}

{
  lib,
  config,
  settings,
  pkgs,
  ...
}:

{
  options.pers.virtualisation.enable = lib.mkEnableOption "virtualisation";

  # TODO: Refine module

  config = lib.mkIf config.pers.virtualisation.enable {
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
  };
}

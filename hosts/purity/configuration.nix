{
  inputs,
  settings,
  ...
}:

{
  imports = [
    inputs.disko.nixosModules.disko
    ./disko.nix
  ];

  pers = {
    server.enable = true;
    openssh.enable = true;
    git.enable = true;
    users.enable = true;
    basic.enable = true;
    shell.enable = true;
    impermanence = {
      enable = true;
      configureUser = false;
      amountToKeep = 5;
      daysToKeep = 10;
    };
    sops.enable = true;
    nixos-anywhere.enable = true;
  };

  hardware.enableRedistributableFirmware = true;
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking.hostName = settings.hostname;
  nix.settings.auto-optimise-store = true;
  system.stateVersion = "25.05";
}

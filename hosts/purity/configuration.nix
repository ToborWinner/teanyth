{
  settings,
  config,
  lib,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

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
    sops = {
      enable = true;
      extraSecrets = [
        "high-bridge"
        "low-bridge"
      ];
    };
    nixos-anywhere.enable = true;
    disko.enable = true;

    jolly = {
      enable = true;
      nginx = true;
      openFirewall = true;
      disableUnits = true;
    };

    hypixel-bridge.bridges = {
      high.configFile = config.pers.info.getSecretFilePath "high-bridge";
      low.configFile = config.pers.info.getSecretFilePath "low-bridge";
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "mongodb-ce" ];

  networking.hostName = settings.hostname;
  nix.settings.auto-optimise-store = true;
  system.stateVersion = "25.05";
}

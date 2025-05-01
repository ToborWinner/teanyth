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
    tailscale.enable = true;

    jolly = {
      enable = true;
      nginx = true;
      openFirewall = true;
    };
    hypixel-bridge.bridges = {
      high.configFile = config.pers.info.getSecretFilePath "high-bridge";
      low.configFile = config.pers.info.getSecretFilePath "low-bridge";
    };
    guildbot.enable = true;
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "mongodb-ce" ];

  networking.hostName = settings.hostname;
  nix.settings.auto-optimise-store = true;
  system.stateVersion = "25.05";

  # TODO: Zswap when module comes to NixOS (boot.kernel.sysctl)
  # https://github.com/NixOS/nixpkgs/issues/119244
}

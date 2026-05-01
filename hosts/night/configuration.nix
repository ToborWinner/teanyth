{ settings, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    (inputs.sensitive + "/modules/night.nix")
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
      extraSystemDirectories = [
        {
          directory = "/home/${settings.username}/persist";
          user = "tobor";
          group = "users";
          mode = "u=rwx,g=rw,o=";
        }
      ];
    };
    sops = {
      enable = true;
      user = true;
    };
    nixos-anywhere.enable = true;
    disko.enable = true;
    tailscale.enable = true;
    minecraft-server.enable = true;
    distrobox.enable = true;
  };

  networking.hostName = settings.hostname;
  nix.settings.auto-optimise-store = true;
  system.stateVersion = "26.05";
}

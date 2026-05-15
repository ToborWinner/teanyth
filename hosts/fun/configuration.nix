{ settings, inputs, ... }:

{
  imports = [
    (inputs.sensitive + "/modules/fun.nix")
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
      configureWipe = false;
      amountToKeep = 5;
      daysToKeep = 10;
      extraSystemDirectories = [
        {
          directory = "/home/${settings.username}/persist";
          user = "${settings.username}";
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
    tailscale.enable = true;
    distrobox.enable = true;
    # No disko because we have a custom setup in sensitive.
  };

  networking.hostName = settings.hostname;
  nix.settings.auto-optimise-store = true;
  system.stateVersion = "26.05";
}

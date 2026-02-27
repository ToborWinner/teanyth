{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:

{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  options.pers.minecraft-server.enable = lib.mkEnableOption "minecraft server";

  config.services.minecraft-servers = lib.mkIf config.pers.minecraft-server.enable {
    enable = true;
    eula = true;
    openFirewall = true;
    dataDir = "/var/lib/minecraft";
    servers.fabric-redstone = {
      enable = true;
      autoStart = false;
      jvmOpts = "-Xmx3G -Xms2G";
      enableReload = true;
      package =
        inputs.nix-minecraft.legacyPackages.${pkgs.stdenv.hostPlatform.system}.fabricServers.fabric-1_21_11.override
          { loaderVersion = "0.18.4"; };

      symlinks.mods = pkgs.linkFarmFromDrvs "mods" [
        (pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/1u6JkXh5/versions/o645q0Oo/worldedit-mod-7.4.0.jar";
          sha256 = "1c0f589j2bvw6z5jsp5642kaz8c5yvxrr4a3f52l65i928pv2kl6";
        })
      ];
    };
  };
}

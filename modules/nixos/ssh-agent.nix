{ lib, config, ... }:

{
  options.pers.ssh-agent.enable = lib.mkEnableOption "ssh-agent";

  config = lib.mkIf config.pers.ssh-agent.enable {
    programs.ssh = {
      startAgent = true;
      askPassword = "";
    };
  };
}

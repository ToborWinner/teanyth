{
  lib,
  config,
  sharedInfo,
  ...
}:

{
  options.pers.git.enable = lib.mkEnableOption "git";

  config = lib.mkIf config.pers.git.enable {
    programs.git = {
      enable = true;
      userName = "toborwinner";
      userEmail = "102221758+ToborWinner@users.noreply.github.com";
      extraConfig = {
        init.defaultBranch = "main";
        credential.helper = "";
        user.signingkey = "key::${sharedInfo.sshpub} 102221758+ToborWinner@users.noreply.github.com";
        gpg.format = "ssh";
        commit.gpgSign = true;
        tag.gpgSign = true;
      };
    };
  };
}

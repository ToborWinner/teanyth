{
  lib,
  config,
  pkgs,
  osOptions,
  osConfig,
  options,
  ...
}:

{
  options.pers.neovim.enable = lib.mkEnableOption "neovim";

  config = lib.mkIf config.pers.neovim.enable {
    home.sessionVariables.EDITOR = "nvim";

    home.packages =
      let
        nixosDocs = lib.pers.docs {
          options = osOptions;
          allowBroken = true; # For faster evaluation. `extendModules` is a better solution, but it has to evaluate options again.
        };

        hmDocs =
          # TODO: Find out why this is being evaluated again in a theme (seems to be because of fontconfig)
          if config.pers.isTheme then
            {
              optionsJSON = "{}";
              optionsCTAGS = "";
            }
          else
            lib.pers.docs {
              options = options;
              # `accounts.email.accounts.<name>.maildir.path` does not have a default set
              assumeDefault = false;
              # `accounts.email.accounts.<name>.maildir.absPath` default value depends on
              # `accounts.email.accounts.<name>.maildir.path`, which does not have a default set, causing
              # an error about accessing an option that was not defined.
              allowBroken = true;
              # This is not necessarily a good solution, but tryEval doesn't catch this and I don't want to add a nixpkgs overlay for this.
              # https://github.com/nix-community/home-manager/blob/2f23fa308a7c067e52dfcc30a0758f47043ec176/modules/programs/chromium.nix#L208
              # google-chrome-beta and google-chrome-dev don't exist in nixpkgs, yet they are required for defaultText of
              # `programs.${one-of-the-above}.package`
              transformOption =
                option:
                let
                  prefixToRemove =
                    if osConfig.pers.virtualisation.isVmVariant then
                      "virtualisation.vmVariant.home-manager.users.${config.home.username}"
                    else
                      "home-manager.users.${config.home.username}";
                  name = "hm" + (lib.removePrefix prefixToRemove option.name);
                  optionToUse =
                    if
                      name == "hm.programs.google-chrome-beta.package" || name == "hm.programs.google-chrome-dev.package"
                    then
                      builtins.removeAttrs option [
                        "defaultText"
                        "default"
                      ]
                    else
                      option;
                in
                optionToUse
                // {
                  inherit name;
                };
            };

        ctagsPath = pkgs.writeText "ctags" ''
          ${nixosDocs.optionsCTAGS}
          ${hmDocs.optionsCTAGS}
        '';

        jsonNixosPath = pkgs.writeText "nixos-options.json" nixosDocs.optionsJSON;
        hmNixosPath = pkgs.writeText "hm-options.json" hmDocs.optionsJSON;
      in
      [
        (pkgs.pers.neovim.passthru.extend [
          {
            pers.nix-options-nvim.keybinds = [
              {
                name = "NixOS";
                key = "n";
                filepath = jsonNixosPath;
              }
              {
                name = "home-manager";
                key = "h";
                filepath = hmNixosPath;
              }
            ];

            vim.luaConfigRC.flake_tags = ''
              vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
                  pattern = "*.nix",
                  callback = function()
                      vim.opt.tags:append("${ctagsPath}")
                  end,
              })

              vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                  -- Unset 'tagfunc' so that I can use :tj in nix with a tags file
                  vim.bo[args.buf].tagfunc = nil
                end,
              })
            '';
          }
        ])
      ];
  };
}

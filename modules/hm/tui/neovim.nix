{
  lib,
  config,
  pkgs,
  osOptions,
  options,
  ...
}:

{
  options.pers.neovim.enable = lib.mkEnableOption "neovim";

  config = lib.mkIf config.pers.neovim.enable {
    home.sessionVariables.EDITOR = "nvim";

    home.packages =
      let
        ctagsPath = pkgs.writeText "ctags" ''
          ${(lib.pers.docs {
            options = osOptions;
            allowBroken = true; # For faster evaluation. `extendModules` is a better solution, but it has to evaluate options again.
          }).optionsCTAGS
          }
          ${(lib.pers.docs {
            options = options;
            transformOption =
              option:
              option
              // {
                name = "hm" + (lib.removePrefix "home-manager.users.${config.home.username}" option.name);
              };
          }).optionsCTAGS
          }
        '';
      in
      [
        (pkgs.pers.neovim.passthru.extend [
          {
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

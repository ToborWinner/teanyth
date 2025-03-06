{
  pers,
  pkgs,
  options,
  lib,
  config,
  ...
}:

let
  options-path = pkgs.writeText "vim-options.json" (pers.docs { inherit options; }).optionsJSON;
in
{
  options.pers.nix-options-nvim.keybinds = lib.mkOption {
    type =
      with lib.types;
      listOf (submodule {
        options = {
          name = lib.mkOption {
            type = str;
            description = "The name to be dispalyed in the description of the keybind";
          };
          key = lib.mkOption {
            type = str;
            description = "The key for the keymap. The keymap will be <leader>fn<key-specified-here>.";
          };
          filepath = lib.mkOption {
            type = pathInStore;
            description = "The path to the JSON file containing the Nix options.";
          };
        };
      });
    description = "List of keybindings for nix-options-nvim.";
    default = [ ];
  };

  config = {
    pers.nix-options-nvim.keybinds = lib.singleton {
      name = "NVF";
      key = "v";
      filepath = options-path;
    };

    vim.lazy.plugins = {
      vimplugin-nix-options-nvim = {
        package = pkgs.pers.nix-options-nvim;
        lazy = true;
        priority = 1000;

        keys = map (keybind: {
          mode = "n";
          key = "<leader>fn${keybind.key}";
          action = "function() require(\"nix-options-nvim\").nix_options_picker(\"${keybind.filepath}\") end";
          lua = true;
          desc = "${keybind.name} Nix options";
        }) config.pers.nix-options-nvim.keybinds;
      };
    };
  };
}

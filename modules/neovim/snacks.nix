{
  vim = {
    utility.snacks-nvim = {
      enable = true;
      setupOpts = {
        picker.enabled = true;

        # Disable things like LSP for big files
        bigfile = {
          enabled = true;
          notify = true;
          size = 1.5 * 1024 * 1024; # 1.5MB
        };
      };
    };

    # TODO: I still have telescope for some reason

    keymaps = [
      {
        mode = [ "n" ];
        key = "<leader>sf";
        action = "Snacks.picker.smart";
        desc = "Fuzzy find files in a smart way [Snacks]";
        lua = true;
      }
      {
        mode = [ "n" ];
        key = "<leader>ff";
        action = "Snacks.picker.smart";
        desc = "Fuzzy find files [Snacks]";
        lua = true;
      }
      {
        mode = [ "n" ];
        key = "<leader>fb";
        action = "Snacks.picker.buffers";
        desc = "Fuzzy find buffers [Snacks]";
        lua = true;
      }
      {
        mode = [ "n" ];
        key = "<leader>fr";
        action = "Snacks.picker.resume";
        desc = "Resume previous search [Snacks]";
        lua = true;
      }
      {
        mode = [ "n" ];
        key = "<leader>fg";
        action = "Snacks.picker.grep";
        desc = "Live grep [Snacks]";
        lua = true;
      }
      {
        mode = [ "n" ];
        key = "<leader>fz";
        action = "Snacks.picker.zoxide";
        desc = "Zoxide picker [Snacks]";
        lua = true;
      }
      {
        mode = [ "n" ];
        key = "<leader>fd";
        action = "Snacks.picker.diagnostics";
        desc = "Search diagnostics [Snacks]";
        lua = true;
      }
    ];
  };
}

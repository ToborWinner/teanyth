{ pkgs, ... }:

{
  vim = {
    extraPackages = [ pkgs.ripgrep ]; # Needed for :ObsidianQuickSearch

    options.conceallevel = 2; # Needed by some Obsidian features

    notes.obsidian = {
      enable = true;
      setupOpts = {
        workspaces = [
          {
            name = "personal";
            path = "~/Documents/Vaults/personal";
          }
        ];

        notes_subdir = "notes";

        new_notes_location = "notes_subdir";
        preferred_link_style = "wiki"; # Or markdown

        templates = {
          folder = "templates";
          date_format = "%Y-%m-%d";
          time_format = "%H:%M";
        };

        picker = {
          name = "telescope.nvim";
          note_mappings = {
            # Telescope mappings for notes
            new = "<C-x>"; # New note from query
            insert_link = "<C-l>"; # Insert link to note
          };

          tag_mappings = {
            # Telescope mappings for tags
            tag_note = "<C-x>";
            insert_tag = "<C-l>";
          };
        };

        search_max_lines = 1000;
      };
    };

    keymaps = [
      {
        mode = [ "n" ];
        key = "<leader>on";
        action = ":ObsidianNew<CR>";
        desc = "New obsidian note";
      }
      {
        mode = [ "n" ];
        key = "<leader>oo";
        action = ":ObsidianQuickSwitch<CR>";
        desc = "Quick switch obsidian note";
      }
      {
        mode = [ "n" ];
        key = "<leader>os";
        action = ":ObsidianSearch<CR>";
        desc = "Search notes by grep";
      }
      {
        mode = [ "n" ];
        key = "<leader>ob";
        action = ":ObsidianBacklinks<CR>";
        desc = "View backlinks of current note";
      }
      {
        mode = [ "n" ];
        key = "<leader>or";
        action = ":ObsidianRename<CR>";
        desc = "Rename current note";
      }
    ];
  };
}

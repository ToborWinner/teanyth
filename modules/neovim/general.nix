{ pkgs, ... }:

{
  vim = {
    theme = {
      enable = true;
      name = "catppuccin";
      style = "mocha";
      transparent = true;
    };

    mini.statusline.enable = true;
    telescope = {
      enable = true;
      mappings.findFiles = "<leader>sf";
    };

    binds.whichKey.enable = true;

    filetree.neo-tree = {
      enable = true;
      setupOpts.window = {
        position = "right";
      };
    };

    git = {
      enable = true;
      git-conflict.mappings = {
        both = "<leader>rb";
        none = "<leader>r0";
        ours = "<leader>ro";
        theirs = "<leader>rt";
      };
      gitsigns.mappings = {
        stageHunk = "<leader>vs";
        undoStageHunk = "<leader>vu";
        resetHunk = "<leader>vr";
        stageBuffer = "<leader>vS";
        resetBuffer = "<leader>vR";
        previewHunk = "<leader>vP";
        blameLine = "<leader>vb";
        toggleBlame = "<leader>tb";
        diffThis = "<leader>vd";
        diffProject = "<leader>vD";
        toggleDeleted = "<leader>td";
      };
    };

    notes.todo-comments.enable = true;

    options = {
      autoindent = true;
      smartindent = true;
      expandtab = false;
      shiftwidth = 4;
      tabstop = 4;
      scrolloff = 4;
      inccommand = "split"; # Preview subsitutions live, as you type!
    };

    scrollOffset = 4;
    searchCase = "smart";
    useSystemClipboard = true;

    snippets.luasnip.enable = true;

    spellcheck = {
      enable = true;
      programmingWordlist.enable = true;
    };

    tabline.nvimBufferline = {
      enable = true;
      mappings = {
        closeCurrent = "<leader>m";
        cycleNext = "<leader>l";
        cyclePrevious = "<leader>h";
      };
      setupOpts.options = {
        numbers = "none";
      };
    };

    utility = {
      ccc.enable = true;
      images.image-nvim.enable = true;
      leetcode-nvim = {
        enable = true;
        setupOpts.image_support = true;
      };
      motion.leap.enable = true;
      surround.enable = true;
    };

    visuals = {
      fidget-nvim.enable = true;
      # highlight-undo.enable = true;
      indent-blankline.enable = true;
      rainbow-delimiters.enable = true;
      nvim-web-devicons.enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
        silent = true;
      }
      {
        mode = "n";
        key = "\\";
        action = "<cmd>Neotree toggle<cr>";
        silent = true;
        desc = "NeoTree toggle";
      }
    ];

    extraPlugins = {
      # Automatically detect shiftwidth, tabstop, ...
      vim-sleuth = {
        package = pkgs.vimPlugins.vim-sleuth;
      };
    };

    lazy.plugins = {
      vim-tmux-navigator = {
        package = pkgs.vimPlugins.vim-tmux-navigator;
        lazy = true;

        cmd = [
          "TmuxNavigateLeft"
          "TmuxNavigateDown"
          "TmuxNavigateUp"
          "TmuxNavigateRight"
          "TmuxNavigatePrevious"
          "TmuxNavigatorProcessList"
        ];

        keys = [
          {
            mode = "n";
            key = "<c-h>";
            action = "<cmd><C-U>TmuxNavigateLeft<cr>";
          }
          {
            mode = "n";
            key = "<c-j>";
            action = "<cmd><C-U>TmuxNavigateDown<cr>";
          }
          {
            mode = "n";
            key = "<c-k>";
            action = "<cmd><C-U>TmuxNavigateUp<cr>";
          }
          {
            mode = "n";
            key = "<c-l>";
            action = "<cmd><C-U>TmuxNavigateRight<cr>";
          }
          {
            mode = "n";
            key = "<c-\\>";
            action = "<cmd><C-U>TmuxNavigatePrevious<cr>";
          }
        ];
      };
    };

    luaConfigRC.highlight_yank = ''
      vim.api.nvim_create_augroup("highlight_yank", { clear = true })

      vim.api.nvim_create_autocmd("TextYankPost", {
          group = "highlight_yank",
          callback = function()
              -- vim.highlight.on_yank({ higroup = "IncSearch", timeout = 700 })
              vim.highlight.on_yank()
          end,
      })
    '';
  };
}

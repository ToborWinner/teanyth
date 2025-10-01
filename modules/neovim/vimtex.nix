{
  pkgs,
  ...
}:
{
  vim = {
    lazy.plugins.vimtex = {
      enabled = true;
      package = pkgs.vimPlugins.vimtex;
      lazy = false;
      # The vimtex_callback_progpath is to ensure that the command passed with `-x` to Zathura uses the wrapped neovim. Using the one from $PATH is not a perfect solution, but already better. If it's unwrapped neovim, the :VimtexInverseSearch command won't be available.
      before = ''
        vim.g.vimtex_view_method = "zathura"
        vim.g.vimtex_mappings_prefix = "<leader>x"
        vim.g.vimtex_callback_progpath = vim.fn.exepath('nvim')
      '';
    };
  };
}

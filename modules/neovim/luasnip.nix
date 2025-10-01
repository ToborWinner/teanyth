{
  vim = {
    snippets.luasnip = {
      enable = true;
      loaders = "require(\"luasnip.loaders.from_lua\").lazy_load({paths = \"${./snippets}\"})";
      setupOpts = {
        enable_autosnippets = true; # Enable auto triggered snippets
        store_selection_keys = "<Tab>"; # Use Tab to trigger visual selection. Basically you press tab afer selecting and then you can use snippets.
        update_events = "TextChanged,TextChangedI"; # Allow typing in multiple locations at once. Default event is InsertLeave (updates when you leave insert mode)
      };
    };

    luaConfigRC.luasnip_keymaps = ''
      local ls = require("luasnip")

      vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true, desc = "[Luasnip] Expand snippet"})
      vim.keymap.set({"i", "s"}, "jk", function() ls.jump( 1) end, {silent = true, desc = "[Luasnip] Jump forward in snippet"})
      vim.keymap.set({"i", "s"}, "kj", function() ls.jump(-1) end, {silent = true, desc = "[Luasnip] Jump backwards in snippet"})
      vim.keymap.set({"i", "s"}, "<C-L>", function()
          if ls.choice_active() then
              ls.change_choice(1)
          end
      end, {silent = true, desc = "[Luasnip] Cycle through choices"})
    '';
  };
}

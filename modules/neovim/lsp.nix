{ ... }:

{
  vim.languages = {
    enableTreesitter = true;
    enableFormat = true;

    assembly.enable = true;
    nix = {
      enable = true;
      format = {
        type = "nixfmt";
      };
    };
    rust.enable = true;
    clang.enable = true;
    bash.enable = true;
    ts.enable = true;
    css.enable = true;
    html.enable = true;
    java.enable = true;
    markdown = {
      enable = true;
      extensions.render-markdown-nvim.enable = true;
    };
    lua.enable = true;
    # TODO: Why in the world is this 7.5gb??
    haskell.enable = true;
  };

  vim.lsp = {
    enable = true;
    formatOnSave = true;
    lspkind.enable = true;

    mappings = {
      goToDefinition = "<leader>cgd";
      goToDeclaration = "<leader>cgD";
      goToType = "<leader>cgt";
      listImplementations = "<leader>cgi";
      listReferences = "<leader>cgr";
      nextDiagnostic = "<leader>cgn";
      previousDiagnostic = "<leader>cgp";
      openDiagnosticFloat = "<leader>ce";
      documentHighlight = "<leader>cH";
      listDocumentSymbols = "<leader>cS";
      addWorkspaceFolder = "<leader>cwa";
      removeWorkspaceFolder = "<leader>cwr";
      listWorkspaceFolders = "<leader>cwl";
      listWorkspaceSymbols = "<leader>cws";
      hover = "<leader>ch";
      signatureHelp = "<leader>cs";
      renameSymbol = "<leader>cn";
      codeAction = "<leader>ca";
      format = "<leader>cf";
      toggleFormatOnSave = "<leader>ctf";
    };
  };
}

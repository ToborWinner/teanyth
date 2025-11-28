{
  lib,
  config,
  pkgs,
  ...
}:

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
    python.enable = true;
  };

  vim.lsp = {
    enable = true;
    formatOnSave = true;
    lspkind.enable = true;

    lspconfig.sources.jdtls = lib.mkForce ''
      lspconfig.jdtls.setup {
        capabilities = capabilities,
        on_attach = default_on_attach,
        init_options = {
          settings = {
            java = {
              configuration = {
                runtimes = {
                  {
                    name = "JavaSE-1.8",
                    path = "${pkgs.jdk8}",
                  },
                },
              },
              project = {
                updateBuildConfiguration = 'disabled',
                referencedLibraries = {},
              },
              import = {
                gradle = {
                  enabled = false,
                },
                maven = {
                  enabled = false,
                },
              },
              format = {
                enabled = true,
              },
              contentProvider = {
                preferred = 'fernflower',
              },
              references = {
                includeDecompiledSources = true,
              },
              implementationsCodeLens = {
                enabled = true,
              },
              referencesCodeLens = {
                enabled = true,
              },
            },
          },
        },
          settings = {
            java = {
              configuration = {
                runtimes = {
                  {
                    name = "JavaSE-1.8",
                    path = "${pkgs.jdk8}",
                  },
                },
              },
              project = {
                updateBuildConfiguration = 'disabled',
                referencedLibraries = {},
              },
              import = {
                gradle = {
                  enabled = false,
                },
                maven = {
                  enabled = false,
                },
              },
              format = {
                enabled = true,
              },
              contentProvider = {
                preferred = 'fernflower',
              },
              references = {
                includeDecompiledSources = true,
              },
              implementationsCodeLens = {
                enabled = true,
              },
              referencesCodeLens = {
                enabled = true,
              },
            },
          },
        cmd = ${
          if lib.lists.isList config.vim.languages.java.lsp.package then
            lib.nvim.expToLua config.vim.languages.java.lsp.package
          else
            let
              # TODO: Fix -configuration (supposed to be ${jdtls}/config_linux, but it being read-only is promlematic)
              # Currently I copied it to .local/share/jdtls-config, but that's a terrible solution
              jdtls = "${config.vim.languages.java.lsp.package}/share/java/jdtls";
            in
            ''
              {
                "${lib.getExe config.vim.languages.java.lsp.package}",
                "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                "-Dosgi.bundles.defaultStartLevel=4",
                "-Declipse.product=org.eclipse.jdt.ls.core.product",
                "-Dgradle.autoSync=false",
                "-Dorg.eclipse.core.resources.refresh.build=false",
                "-Dlog.protocol=true",
                "-Dlog.level=ALL",
                "-Xms1g",
                "--add-modules=ALL-SYSTEM",
                "--add-opens", "java.base/java.util=ALL-UNNAMED",
                "--add-opens", "java.base/java.lang=ALL-UNNAMED",
                "-jar", vim.fn.glob("${jdtls}/plugins/org.eclipse.equinox.launcher_*.jar"),
                "-configuration", "/home/tobor/.local/share/jdtls-config",
                "-data", vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
              }
            ''
        },
      }
    '';

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

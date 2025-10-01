{
  lib,
  config,
  extendModules,
  pkgs,
  name,
  ...
}:

with lib;

# TODO: Remove the need for extendModules in flake. Might be possible due to the type attrsOf submodule being mergeable.

# TODO: Proper uninstall procedure (right now all files are just left there, including current-theme)
# Something similar to home-manager's uninstall = true can be done.

# This module requires proper helper functions in flake.nix to work
let
  cfg = config.pers;
in
{
  options.pers = {
    isTheme = mkOption {
      type = types.bool;
      default = false;
      internal = true;
      description = "Whether you are inside a theme configuration";
    };

    themeName = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "The name of the current theme configuration or null if in none.";
    };

    extraThemeActivation = mkOption {
      type = types.lines;
      default = "";
      description = "Extra theme activation commands to run after the onChange file hooks.";
    };

    extraThemePackageCommands = mkOption {
      type = types.lines;
      default = "";
      description = "Extra commands to run when creating the theme package.";
    };

    defaultTheme = mkOption {
      type = types.str;
      default = head (attrNames cfg.theme);
      defaultText = literalExpression "head (attrNames cfg.theme)";
      description = "The default theme (theme to activate if there is no other specified option)";
    };

    theme = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            configuration = mkOption {
              type =
                (extendModules {
                  modules = lib.singleton {
                    pers.isTheme = mkOverride 0 true;

                    # If used inside the NixOS/nix-darwin module, we get conflicting definitions
                    # of `name` inside the specialisation: one is the user name coming from the
                    # NixOS module definition and the other is `configuration`, the name of this
                    # option. Thus we need to explicitly wire the former into the module arguments.
                    # See discussion at https://github.com/nix-community/home-manager/issues/3716
                    _module.args.name = mkForce name;

                    # Prevent infinite recursion (I believe this is required in case you have specialisations that define themes)
                    specialisation = mkOverride 0 { };

                    # Prevent infinite recursion, as the themes from this config are by default incldued in that config, creating infinite recursion.
                    pers.theme = mkOverride 0 { };
                  };
                }).type;
              default = { };
              visible = "shallow"; # Hide sub-options, but not this
              description = "Configuration of the file specialisation. (home manager configuraiton)";
            };
          };
        }
      );
      default = { };
      description = "Fast file specialisations, usually used for themes. Made to evaluate faster than normal home manager specialisations, because they only evaluate home.file instead of home.activationPackage.";
    };

    themePackage = mkOption {
      type = types.package;
      description = "Package containing the activation script and a link to the files";
      internal = true;
    };

    themeActivationScript = mkOption {
      type = types.package;
      description = "Package containing the activation script";
      internal = true;
    };
  };

  config = mkMerge [
    (mkIf (cfg.theme != { }) {
      assertions =
        (map (n: {
          assertion = !lib.hasInfix "/" n;
          message = "<name> in pers.theme.<name> cannot contain a forward slash.";
        }) (attrNames cfg.theme))
        ++ [
          {
            assertion = cfg.theme ? "${cfg.defaultTheme}";
            message = "pers.defaultTheme must be an existing pers.theme. Currently it's: '${cfg.defaultTheme}'. Available themes: ${concatStringsSep ", " (attrNames cfg.theme)}.";
          }
        ];

      pers.isTheme = mkOverride 1 false;

      home.extraBuilderCommands =
        let
          mkLink =
            name: value: "ln -s ${value.configuration.pers.themePackage} $out/theme/${escapeShellArg name}";
        in
        ''
          mkdir -p $out/theme
          ${concatStringsSep "\n" (mapAttrsToList mkLink cfg.theme)}
        '';

      # Activate the default theme
      # TODO: Activate the equivalent of the previous theme instead of the default
      home.activation.activateTheme = hm.dag.entryBetween [ "onFilesChange" ] [ "linkGeneration" ] ''
        themeName=${escapeShellArg cfg.defaultTheme}
        echo "Activating Theme $themeName"
        export newHmGenPath=$newGenPath
        run ${escapeShellArg cfg.theme.${cfg.defaultTheme}.configuration.pers.themePackage}/activate
      '';
    })
    (mkIf cfg.isTheme {
      pers.themePackage = pkgs.runCommandLocal "theme-package" { } ''
        mkdir -p $out

        cat > $out/activate << EOF
        #!${pkgs.runtimeShell}
        # Define variables from Nix passed into the script
        export storeDir=${escapeShellArg builtins.storeDir}
        export newThemeGenPath=$out

        # Call the activation script
        ${cfg.themeActivationScript} "\$@"
        EOF

        chmod +x $out/activate

        ln -s ${config.home-files} $out/files

        ${cfg.extraThemePackageCommands}
      '';

      pers.themeActivationScript =
        let
          # TODO: Find out why I can't just use pkg path. This is taken from home-manager. I haven't tried just using path yet, nor have I tried understanding the snippet.
          sourceStorePath =
            file:
            let
              sourcePath = toString file.source;
              sourceName = config.lib.strings.storeFileName (baseNameOf sourcePath);
            in
            if builtins.hasContext sourcePath then
              file.source
            else
              builtins.path {
                path = file.source;
                name = sourceName;
              };

          homeDirArg = escapeShellArg config.home.homeDirectory;

          enabledFiles = filterAttrs (_: f: f.enable) config.home.file;

          compareFiles = concatMapStrings (
            v:
            let
              sourceArg = escapeShellArg (sourceStorePath v);
              targetArg = escapeShellArg v.target;
            in
            ''
              _cmp ${sourceArg} ${homeDirArg}/${targetArg} \
                && themeChangedFiles[${targetArg}]=0 \
                || themeChangedFiles[${targetArg}]=1
            ''
          ) (filter (v: v.onChange != "") (attrValues enabledFiles));

          onChangeHooks = concatMapStrings (v: ''
            if (( ''${themeChangedFiles[${escapeShellArg v.target}]} == 1 )); then
              fileTarget=${escapeShellArg v.target}
              _iVerbose "Running onChange hook for $fileTarget"
              ${v.onChange}
            fi
          '') (filter (v: v.onChange != "") (attrValues enabledFiles));

          onActivationHooks = cfg.extraThemeActivation;

          # Programs that always should be available on the activation
          # script's PATH.
          # From https://github.com/nix-community/home-manager/blob/97ac0801d187b2911e8caa45316399de12f6f199/modules/home-environment.nix#L687
          # This is added because it might be needed for the onChange scripts (they assume those packages are installed. For example Hyprland's script uses jq without specifying the nix store path).
          activationBinPaths =
            lib.makeBinPath (
              with pkgs;
              [
                bash
                coreutils
                diffutils # For `cmp` and `diff`.
                findutils
                gettext
                gnugrep
                gnused
                jq
                ncurses # For `tput`.
              ]
              ++ config.home.extraActivationPath
            )
            + (
              # Add path of the Nix binaries, if a Nix package is configured, then
              # use that one, otherwise grab the path of the nix-env tool.
              if config.nix.enable && config.nix.package != null then
                ":${config.nix.package}/bin"
              else
                ":$(${pkgs.coreutils}/bin/dirname $(${pkgs.coreutils}/bin/readlink -m $(type -p nix-env)))"
            )
            + optionalString (!config.home.emptyActivationPath) "\${PATH:+:}$PATH";
        in
        pkgs.writeShellScript "theme-activation" ''
          set -eu
          set -o pipefail
          cd $HOME
          export PATH="${activationBinPaths}"

          function _cmp() {
            if [[ -d $1 && -d $2 ]]; then
              diff -rq "$1" "$2" &> /dev/null
            else
              cmp --quiet "$1" "$2"
            fi
          }
          declare -A themeChangedFiles

          # Compare files
          ${compareFiles}

          unset -f _cmp

          declare -r expectedHome=${config.home.homeDirectory}

          ${readFile ./theme-activation-init.sh}

          # Run onChnage hooks
          ${onChangeHooks}

          # Run onActivation hooks
          _i "Running extra activation scripts"
          ${onActivationHooks}

          _i "Done switching to theme!"
        '';
    })
  ];
}

/**
  This file is evaluated in a derivation that parses its traces.
*/
{ parameters, args }:
let
  evaluator = parameters args;

  inherit (evaluator) lib;

  unwrapped = evaluator.evalWithBaseModules evaluator.baseModules;

  modules = lib.modules.collectModules evaluator.modulesPath evaluator.baseModules (
    {
      config = unwrapped.config // {
        inherit (unwrapped) _module;
      };
      inherit (unwrapped) options;
      inherit lib;
      inherit (unwrapped._module) specialArgs;
    }
    // unwrapped._module.specialArgs
  );

  /**
    Map each option to trace its path when evaluated.

    # Type
    mapOptions :: Attrs -> Attrs
  */
  mapOptions = lib.mapAttrsRecursiveCond (x: !lib.isOption x) (
    path: value: builtins.trace "-|${builtins.toJSON path}|-" value
  );

  /**
    Map each config value to trace its path when evaluated. Also requires options as argument to know which config value is an option and which isn't.

    # Type
    mapConfig :: Attrs -> Attrs -> Attrs
  */
  mapConfig =
    options:
    mapAttrsRecursiveCond' (path: _: !lib.isOption (lib.attrByPath path null options)) (
      path: value: builtins.trace "-|${builtins.toJSON path}|-" value
    );

  /**
    Wrap both options and config using mapOptions and mapConfig.

    # Type
    wrapped :: Attrs -> Attrs -> { options :: Attrs; config :: Attrs; }
  */
  wrap = options: config: {
    options = mapOptions options;
    config = mapConfig options config;
  };

  /**
    Like mapAttrsRecursiveCond except the condition function also gets passed the path.

    # Type
    mapAttrsRecursiveCond' :: ([String] -> AttrSet -> Bool) -> ([String] -> a -> b) -> AttrSet -> AttrSet
  */
  mapAttrsRecursiveCond' =
    cond: f: set:
    let
      recurse =
        path:
        builtins.mapAttrs (
          name: value:
          if builtins.isAttrs value && cond (path ++ [ name ]) value then
            recurse (path ++ [ name ]) value
          else
            f (path ++ [ name ]) value
        );
    in
    recurse [ ] set;

  checkModule =
    module:
    let
      isOption =
        path:
        lib.isOption (
          lib.attrByPath path (throw "Unmatched definition. Path: ${lib.showOption path}.") unwrapped.options
        );
      checkConfigAttr =
        path: config:
        if isOption path then
          config._type or null == "if" && !config.condition
        else if config._type or null == "if" then
          !config.condition
        else
          builtins.all (
            pushedconfig:
            builtins.all ({ name, value }: checkConfigAttr (path ++ [ name ]) value) (
              lib.attrsToList pushedconfig
            )
          ) (lib.pushDownProperties config);
    in
    builtins.all (checkConfigAttr [ ]) (lib.pushDownProperties module.config);

  configlessKeys = builtins.concatMap (m: if checkModule m then [ m.key ] else [ ]) modules;

  wrapped = wrap configuration.options (configuration.config // { inherit (configuration) _module; });

  wrappedModules = lib.modules.collectModules evaluator.modulesPath evaluator.baseModules (
    {
      inherit (wrapped) options config;
      lib = lib.extend (
        final: prev: {
          modules = prev.modules // {
            # From https://github.com/NixOS/nixpkgs/blob/8cc0451ead532078052ac7d3aa82e23572047acf/final/modules.nix#L1535
            mkRenamedOptionModule =
              from: to:
              doRename {
                inherit from to;
                visible = false;
                warn = true;
                use = final.trace "Obsolete option `${final.showOption from}' is used. It was renamed to `${final.showOption to}'.";
              };

            # From https://github.com/NixOS/nixpkgs/blob/8cc0451ead532078052ac7d3aa82e23572047acf/final/modules.nix#L1544
            mkRenamedOptionModuleWith =
              {
                from,
                to,
                sinceRelease,
              }:
              doRename {
                inherit from to;
                visible = false;
                warn = final.oldestSupportedReleaseIsAtLeast sinceRelease;
                use = final.warnIf (final.oldestSupportedReleaseIsAtLeast sinceRelease) "Obsolete option `${final.showOption from}' is used. It was renamed to `${final.showOption to}'.";
              };

            # From https://github.com/NixOS/nixpkgs/blob/8cc0451ead532078052ac7d3aa82e23572047acf/final/modules.nix#L1703
            mkAliasOptionModule =
              from: to:
              doRename {
                inherit from to;
                visible = true;
                warn = false;
                use = final.id;
              };

            # From https://github.com/NixOS/nixpkgs/blob/8cc0451ead532078052ac7d3aa82e23572047acf/final/modules.nix#L1717
            mkAliasOptionModuleMD = final.modules.mkAliasOptionModule;

            # From https://github.com/NixOS/nixpkgs/blob/8cc0451ead532078052ac7d3aa82e23572047acf/final/modules.nix#L1426C3-L1426C21
            mkAliasDefinitions = final.modules.mkAliasAndWrapDefinitions final.id;
            mkAliasAndWrapDefinitions =
              wrap: option: final.modules.mkAliasIfDef option (wrap (final.mkMerge option.definitions));
            mkAliasAndWrapDefsWithPriority =
              wrap: option:
              let
                prio = option.highestPrio or final.modules.defaultOverridePriority;
                defsWithPrio = map (final.mkOverride prio) option.definitions;
              in
              final.modules.mkAliasIfDef option (wrap (final.mkMerge defsWithPrio));
            mkAliasIfDef = option: final.mkIf (final.isOption option && option.isDefined);
          };
        }
      );
      inherit (unwrapped._module) specialArgs;
    }
    // (builtins.removeAttrs unwrapped._module.specialArgs [ "lib" ])
  );

  wrappedPartitioned = builtins.partition (m: builtins.elem m.key configlessKeys) wrappedModules;

  wrappedNoConfig = map (
    m:
    builtins.removeAttrs m [
      "config"
      "imports"
    ]
  ) wrappedPartitioned.right;

  wrappedWithConfig = map (m: builtins.removeAttrs m [ "imports" ]) wrappedPartitioned.wrong;

  configuration = evaluator.evalWithBaseModules (
    wrappedNoConfig ++ wrappedWithConfig ++ [ { _module.check = lib.mkOverride 0 false; } ]
  );

  /**
    Taken from https://github.com/NixOS/nixpkgs/blob/8cc0451ead532078052ac7d3aa82e23572047acf/lib/modules.nix#L1751.
    Modified not to cause infinite recursion when collecting modules using `checked options` instead of `options`.

    It would cause an issue even with `_module.check = false` because it needs to check whether this module is setting `_module.check` for `checked options`, but it can't because the `optionalAttrs` is on the whole config.

    The bad part is the one for `warnings`, which we do not care about in here, so it's removed.
  */
  doRename =
    {
      from,
      to,
      visible,
      warn,
      use,
      withPriority ? true,
      condition ? true,
    }:
    {
      config,
      options,
      lib,
      ...
    }:
    let
      fromOpt = lib.getAttrFromPath from options;
      toOf = lib.attrByPath to (abort "Renaming error: option `${lib.showOption to}' does not exist.");
      toType =
        let
          opt = lib.attrByPath to { } options;
        in
        opt.type or (lib.types.submodule { });
    in
    if
      # Prevent infinite recursion from https://github.com/NixOS/nixpkgs/blob/5986042239867c636b06555196a49d1e2ee3b16a/nixos/modules/rename.nix#L21
      to == [
        "_module"
        "check"
      ]
    then
      { }
    else
      {
        options = lib.setAttrByPath from (
          lib.mkOption {
            inherit visible;
            description = "Alias of {option}`${lib.showOption to}`.";
            apply = x: use (toOf config);
          }
          // lib.optionalAttrs (toType != null) { type = toType; }
        );
        config = lib.mkIf condition (
          if withPriority then
            lib.modules.mkAliasAndWrapDefsWithPriority (lib.setAttrByPath to) fromOpt
          else
            lib.modules.mkAliasAndWrapDefinitions (lib.setAttrByPath to) fromOpt
        );
      };
in
evaluator.seqEvaluateOutputs configuration configlessKeys

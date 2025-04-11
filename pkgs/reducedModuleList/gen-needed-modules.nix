/**
  This file is evaluated in a derivation.
*/
{
  parameters,
  args,
  options,
  configless,
}:
let
  evaluator = parameters args;

  inherit (evaluator) lib;

  normal = evaluator.evalWithBaseModules (
    evaluator.baseModules ++ [ { _module.check = lib.mkOverride 0 false; } ]
  );

  configuration = evaluator.evalWithBaseModules (
    (map (m: (builtins.removeAttrs m [ "imports" ]) // { _file = m.key; }) collected)
    ++ [ { _module.check = lib.mkOverride 0 false; } ]
  );

  collected = lib.modules.collectModules evaluator.modulesPath evaluator.baseModules (
    {
      config = configuration.config // {
        inherit (configuration) _module;
      };
      inherit (normal) options;
      inherit lib;
      inherit (normal._module) specialArgs;
    }
    // normal._module.specialArgs
  );

  nonBaseModules = builtins.filter (m: builtins.all (c: m.key != c.key) collected) (
    lib.modules.collectModules evaluator.modulesPath configuration.type.functor.payload.modules (
      {
        config = configuration.config // {
          inherit (configuration) _module;
        };
        inherit (configuration) options;
        inherit lib;
        inherit (configuration._module) specialArgs;
      }
      // configuration._module.specialArgs
    )
  );

  getDefinitions =
    path: config:
    let
      pushed = lib.pushDownProperties config;
      mapFunc =
        n: v:
        let
          newPath = path ++ [ n ];
          opt =
            lib.attrByPath newPath (throw "Option ${lib.showOption newPath} doesn't seem to exist.")
              configuration.options;
        in
        if lib.isOption opt then [ newPath ] else getDefinitions newPath v;
    in
    builtins.concatMap (
      x: builtins.concatMap (name: mapFunc name x.${name}) (builtins.attrNames x)
    ) pushed;

  nonBaseDefinitions = builtins.concatMap (m: getDefinitions [ ] m.config) nonBaseModules;

  getToRemove =
    module:
    let
      getMissingAtPath =
        path: config:
        let
          pushed = lib.pushDownProperties config;
          mapFunc =
            n: v:
            let
              newPath = path ++ [ n ];
              option = lib.attrByPath newPath { } configuration.options;
              hasIt = builtins.all (lib.flip builtins.elem keys) option.declarations;
              value = if hasIt then false else true;
            in
            if lib.isOption option then value else getMissingAtPath newPath v;
          mapped = map (builtins.mapAttrs mapFunc) pushed;
        in
        builtins.foldl' lib.recursiveUpdate { } mapped;

      pushUp =
        arg:
        if builtins.isAttrs arg then
          builtins.mapAttrs (
            _: x:
            let
              pushed = pushUp x;
              values = builtins.attrValues pushed;
              value =
                if builtins.all (p: p == true) values then
                  true
                else if builtins.all (p: p == false) values then
                  false
                else
                  pushed;
            in
            if builtins.isAttrs pushed then value else pushed
          ) arg
        else
          arg;

      remove = pushUp (getMissingAtPath [ ] module.config);
    in
    if builtins.all (x: x == true) (builtins.attrValues remove) then
      true
    else
      lib.filterAttrsRecursive (_: v: builtins.isAttrs v || v) remove;

  /**
    Get the declarations and definitions (_file, which should be equal to key thanks to the rest of the code) of an option by its path.

    # Type
    mapOption :: [String] -> [String]
  */
  mapOption =
    optPath:
    let
      opt =
        lib.attrByPath optPath (throw "Option ${lib.showOption optPath} doesn't seem to exist.")
          configuration.options;
      files = opt.files ++ opt.declarations;
    in
    builtins.filter (x: builtins.any (m: m.key == x || x == "lib/modules.nix") collected) files;

  # Keys of baseModules that must be included
  keys = lib.unique (
    builtins.concatMap mapOption (options ++ nonBaseDefinitions) ++ evaluator.additionalKeys
  );

  partitionedKeys = builtins.partition (lib.hasInfix ":anon-") keys;
  subModules = partitionedKeys.right;
  mainModules = builtins.filter (x: x != "lib/modules.nix") partitionedKeys.wrong;

  mapKeys =
    key:
    let
      filtered = builtins.filter (m: m.key == key) collected;
      module = lib.throwIf (builtins.length filtered != 1) "No module found. Key: ${key}. Filtered: ${
        builtins.toJSON (map (m: m.key) filtered)
      }" (builtins.head filtered);

      # [ 0 4 5 ] for example means one must keep the first, fifth and sixth import (zero-indexed list).
      # This is a recursive list, it can for example be [ 0 [ 4 { assertions = true; } ] ], which means the first module should be kept and left unchanged, while the fourth module should also be kept, but the assertions definition should be removed.
      children = builtins.concatMap (
        x:
        let
          matched = builtins.match "${key}:anon-([0-9]+)" x;
          childKey = "${key}:anon-${builtins.head matched}";
          child = mapKeys childKey;
        in
        if matched == null then [ ] else [ child ]
      ) subModules;

      needToChangeImports =
        builtins.length children != builtins.length module.imports
        || !(builtins.all builtins.isInt children);
      isConfigless = (builtins.elem key configless) || toRemove == true;

      toRemove = getToRemove module;
      hasToRemove = builtins.length (builtins.attrNames toRemove) != 0;

      matchedKey = builtins.match ".*:anon-([0-9]+)" key;
      finalKey =
        if matchedKey != null then
          builtins.fromJSON (builtins.head matchedKey) - 1
        else
          lib.removePrefix evaluator.modulesPath key;
    in
    if !isConfigless && !needToChangeImports && !hasToRemove then
      finalKey
    else
      [ finalKey ]
      ++ (lib.optional (!isConfigless && hasToRemove) toRemove)
      ++ (lib.optional needToChangeImports children);
in
map mapKeys mainModules

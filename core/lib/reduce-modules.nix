{ lib, baseModulesPath }:

let
  inherit (lib)
    isPath
    isString
    isFunction
    isAttrs
    mirrorFunctionArgs
    mkIf
    mkOverride
    mkMerge
    nameValuePair
    ;

  inherit (lib.pers.reduce-modules)
    removeConfig
    removeAttributes
    removeAttributesAndMapImports
    mapImports
    applyToModule
    warninglessPushDownProperties
    removeModuleDefinitionsRecursive
    useReducedImports
    ;
in
{
  inherit baseModulesPath;

  /**
    Import a module (usually from a nixpkgs path) and apply some modification functions to it

    f modifies the imported attribute set
    g modifies the arguments passed to the module if the module is a function

    # Type
    applyToModule :: (Attrs -> Attrs) -> (Attrs -> Attrs) -> Module -> Attrs
  */
  applyToModule =
    f: g: modulePath:
    let
      module = if isPath modulePath || isString modulePath then import modulePath else modulePath;
      patchLoc =
        module:
        if isPath modulePath || isString modulePath then
          {
            _file = modulePath;
            # Prevent double importing:
            # When a path is used as a module, the key automatically becomes the path.
            # This can be seen here:
            # https://github.com/NixOS/nixpkgs/blob/934f0ec7395edd77fa5a727998705a48044d0aae/lib/modules.nix#L363
            #
            # In the documentation module, some modules are re-imported (https://github.com/NixOS/nixpkgs/blob/813be7e7158dbc1d59e7cae28400365813ce5083/nixos/modules/misc/documentation.nix#L183)
            # These modules are also present in module-list.nix, but usually it's not a problem because
            # they have the same key. We need to ensure that is still the case to prevent "this option is already declared in this other file".
            key = modulePath;
          }
          // module
        else
          module;
    in
    if isFunction module then
      # Propagate functionArgs up because of applyModuleArgs:
      # https://github.com/NixOS/nixpkgs/blob/1c8c4f744c62c744f3118d740fdabd719d1cac00/lib/modules.nix#L537
      mirrorFunctionArgs module (args: f (patchLoc (module (g args))))
    else if isAttrs modulePath then
      f modulePath
    else
      # It's an attribute set
      f module;

  /**
    Import a Module and remove its config output (it must be defined top-level).

    # Type
    removeConfig :: Module -> Attrs;
  */
  removeConfig = applyToModule (x: builtins.removeAttrs x [ "config" ]) (x: x);

  /**
    Nixpkgs exports `lib.pushDownProperties`, but it adds an evaluation warning, which we do not want.
    This function is taken from https://github.com/NixOS/nixpkgs/blob/aa1c4cad528d6e0d64cb7d9424eb7376bd4eb2dd/lib/modules.nix#L1172.
    Its usage is described there.
  */
  warninglessPushDownProperties =
    cfg:
    if cfg._type or "" == "merge" then
      builtins.concatMap warninglessPushDownProperties cfg.contents
    else if cfg._type or "" == "if" then
      map (builtins.mapAttrs (n: v: mkIf cfg.condition v)) (warninglessPushDownProperties cfg.content)
    else if cfg._type or "" == "override" then
      map (builtins.mapAttrs (n: v: mkOverride cfg.priority v)) (
        warninglessPushDownProperties cfg.content
      )
    else
      [ cfg ];

  /**
    Given a config, recursively push down the properties and remove the attributes specified in the attribute set.

    # Type
    removeModuleDefinitionsRecursive :: Attrs -> Attrs -> Attrs
  */
  removeModuleDefinitionsRecursive =
    config: attrs:
    let
      pushed = warninglessPushDownProperties config;
      # `right` is to recurse into, `wrong` is to remove
      inherit (builtins.partition builtins.isAttrs (builtins.attrNames attrs)) right wrong;
      makeUpdate =
        m:
        builtins.listToAttrs (
          builtins.concatMap (
            n:
            if m ? ${n} then [ (nameValuePair n (removeModuleDefinitionsRecursive m.${n} attrs.${n})) ] else [ ]
          ) right
        );
      toMerge = map (m: (builtins.removeAttrs m wrong) // (makeUpdate m)) pushed;
    in
    if builtins.length toMerge == 1 then builtins.head toMerge else mkMerge toMerge;

  /**
    Import a Module and recursively remove specific attributes from config (which must be defined top-level).

    # Type
    removeAttributes :: Attrs -> Module -> Attrs;
  */
  removeAttributes =
    mainAttrs:
    applyToModule (
      m:
      m
      // {
        config = removeModuleDefinitionsRecursive m.config mainAttrs;
      }
    ) (x: x);

  /**
    Import a Module and map its imports.

    # Type
    mapImports :: ([Module] -> [Module]) -> Module -> Attrs;
  */
  mapImports =
    f:
    applyToModule (
      m:
      m
      // {
        imports = f m.imports;
      }
    ) (x: x);

  /**
    Import a Module and recursively remove specific attributes from config (which must be defined top-level). In addition, map the imports using the provided map function.

    # Type
    removeAttributesAndMapImports :: Attrs -> ([Module] -> [Module]) -> Module -> Attrs;
  */
  removeAttributesAndMapImports =
    mainAttrs: f:
    applyToModule (
      m:
      m
      // {
        config = removeModuleDefinitionsRecursive m.config mainAttrs;
        imports = f m.imports;
      }
    ) (x: x);

  /**
    Import a reduced module list generated automatically by the derivation.

    # Type
    useReducedImports :: List -> String -> [Module] -> [Module]
  */
  useReducedImports =
    reduced: modulesPath: imports:
    let
      getPath =
        value: if builtins.isString value then modulesPath + value else builtins.elemAt imports value;

      mapEntry =
        entry:
        if builtins.isString entry || builtins.isInt entry then
          getPath entry
        else if builtins.length entry == 1 then
          removeConfig (getPath (builtins.head entry))
        else if builtins.length entry == 3 then
          removeAttributesAndMapImports (builtins.elemAt entry 1)
            (useReducedImports (builtins.elemAt entry 2) modulesPath)
            (getPath (builtins.head entry))
        else if builtins.isAttrs (builtins.elemAt entry 1) then
          removeAttributes (builtins.elemAt entry 1) (getPath (builtins.head entry))
        else
          mapImports (useReducedImports (builtins.elemAt entry 1) modulesPath) (
            getPath (builtins.head entry)
          );
    in
    map mapEntry reduced;

  /**
    Return a derivation to build the reduced module list for a NixOS configuration defined in this flake.

    # Type
    makeReducedNixos :: String -> String -> Derivation
  */
  makeReducedNixos =
    system: hostname:
    lib.pers.flake.packages.${system}.reducedModuleList {
      parameters = ../nixos/reduced.nix;
      args = {
        name = hostname;
        flakedata = lib.pers.import-flake.flakeArguments lib.pers.flake;
        ifd =
          (lib.pers.flake.nixosConfigurations.${hostname}.override {
            baseModules = import baseModulesPath;
          }).config.pers.info.ifd;
        importFlakePath = lib.pers.import-flake.selfPath;
      };
    };

  /**
    Return a derivation to build the reduced module list for a NixOS configuration defined in a file like configuration.nix.

    # Type
    makeReducedNixosFromFile :: String -> Path -> Derivation
  */
  makeReducedNixosFromFile =
    system: file:
    lib.pers.flake.packages.${system}.reducedModuleList {
      parameters = ../nixos/reduced-file.nix;
      args = {
        nixpkgs = toString lib.pers.flake.inputs.nixpkgs;
        inherit file;
      };
    };

  /**
    Return an attribute set containing how many base modules are normally collected and how many modules are collected with the reduced list.

    # Type
    benchmarkReducedNixos :: String -> { normal :: Int; reduced :: Int; }
  */
  benchmarkReducedNixos =
    hostname:
    let
      modulesPath = lib.pers.flake.inputs.nixpkgs + "/nixos/modules";
      configuration = lib.pers.flake.nixosConfigurations.${hostname};
      collect =
        modules:
        lib.modules.collectModules modulesPath modules (
          {
            config = configuration.config // {
              inherit (configuration) _module;
            };
            inherit (configuration) options lib;
            inherit (configuration._module) specialArgs;
          }
          // configuration._module.specialArgs
        );
    in
    {
      normal = builtins.length (collect (import baseModulesPath));
      reduced = builtins.length (
        collect (
          useReducedImports (import ../../hosts/${hostname}/reduced.nix) modulesPath (import baseModulesPath)
        )
      );
    };

  /**
    Return a derivation to build the reduced module list for a home-manager as a NixOS module configuration defined in this flake.

    # Type
    makeReducedHomeManager :: String -> String -> String -> Derivation
  */
  makeReducedHomeManager =
    system: hostname: user:
    lib.pers.flake.packages.${system}.reducedModuleList {
      parameters = ../hm/reduced.nix;
      args = {
        inherit user;
        name = hostname;
        flakedata = lib.pers.import-flake.flakeArguments lib.pers.flake;
        ifd =
          (lib.pers.flake.nixosConfigurations.${hostname}.override {
            baseModules = import baseModulesPath;
          }).config.pers.info.ifd;
        importFlakePath = lib.pers.import-flake.selfPath;
      };
    };
}

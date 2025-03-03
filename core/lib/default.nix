flake: lib: sharedInfo:

with lib;

let
  inherit (flake) inputs;
  inherit (inputs) nixpkgs;

  # nixpkgs with deploy-rs overlay but the nixpkgs package for cache.nixos.org
  deployPkgsForSystem =
    system:
    import nixpkgs {
      inherit system;
      overlays = [
        inputs.deploy-rs.overlay
        (self: super: {
          deploy-rs = {
            inherit (import nixpkgs { inherit system; }) deploy-rs;
            lib = super.deploy-rs.lib;
          };
        })
      ];
    };

  treefmtEval = pers.forEachSupportedSystem (
    pkgs: inputs.treefmt-nix.lib.evalModule pkgs ../../treefmt.nix
  );
in
rec {
  # Create a nixos configuration attribute set for nixosConfigurations
  makeConfig =
    {
      hostname,
      system,
      username ? sharedInfo.username,
      dotfilesDir ? "/home/${username}/teanyth",
      extra ? { },
      ...
    }:
    patchForTheme (nixosSystem {
      specialArgs = {
        inherit inputs sharedInfo flake;
        settings = {
          inherit hostname username dotfilesDir;
        } // extra;
      };
      modules =
        [
          ../../hosts/${hostname}/configuration.nix
          (inputs.sensitive + "/nixos.nix")
          {
            nixpkgs.overlays = singleton flake.overlays.default;
            nixpkgs.hostPlatform = system;
          }
        ]
        ++ (import ../../modules/nixos lib)
        ++ (import ../nixos);
    });

  # Create the content of nixosConfigurations
  makeNixosConfigurations =
    configs: mapAttrs (hostname: settings: makeConfig (settings // { inherit hostname; })) configs;

  # Create a single host's settings for deploying in deploy-rs
  makeDeploy =
    {
      hostname,
      username ? sharedInfo.username,
      system,
      ...
    }:
    {
      inherit hostname;
      sshUser = username;
      profiles.system = {
        user = "root";
        path =
          (deployPkgsForSystem system).deploy-rs.lib.activate.nixos
            flake.nixosConfigurations.${hostname};
      };
    };

  # Create the content of the deploy output for deploy-rs
  makeDeployConfig = configs: {
    nodes = mapAttrs (hostname: settings: makeDeploy (settings // { inherit hostname; })) (
      filterAttrs (_: value: value ? deployable && value.deployable) configs
    );
  };

  # Create deploy checks for the checks flake output
  makeDeployChecks =
    configs:
    let
      systems = unique (
        mapAttrsToList (_: value: value.system) (
          filterAttrs (_: value: value ? deployable && value.deployable) configs
        )
      );
      checkForSystem = system: (deployPkgsForSystem system).deploy-rs.lib.deployChecks flake.deploy;
    in
    genAttrs systems checkForSystem;

  # Patch for the home manager theme system in ./hm/theme.nix. Done here to avoid infinite recursion.
  patchForTheme =
    original:
    if original.config.pers.home-manager.enable then
      original.extendModules {
        modules = singleton (
          let
            mapUser =
              user: config:
              let
                originalMainFiles = original.config.home-manager.users.${user}.home.file;

                differentFromTheme =
                  _: theme:
                  (mapAttrs (name: value: originalMainFiles.${name} or { } != value) theme.configuration.home.file);

                themes = mapAttrsToList differentFromTheme config.pers.theme;
                merged = foldl' (acc: elem: acc // (mapAttrs (n: v: (acc.${n} or false) || v) elem)) { } themes;
              in
              {
                pers.theme = mapAttrs (_: theme: {
                  configuration.home.file = mapAttrs (_: v: { enable = mkOverride 0 v; }) (
                    filterAttrs (n: v: theme.configuration.home.file.${n}.enable or false) merged
                  );
                }) config.pers.theme;

                home.file = mapAttrs (_: _: { enable = mkOverride 1 false; }) (filterAttrs (n: v: v) merged);
              };
          in
          {
            home-manager.users = mapAttrs mapUser original.config.home-manager.users;
          }
        );
      }
    else
      original;

  # Get home-manager configs from nixosConfigurations
  extractHomeManagerConfigs =
    let
      # These are not all attributes provided by a normal home-manager configuration, but they should be enough.
      # Based on https://github.com/nix-community/home-manager/blob/83bd3a26ac0526ae04fa74df46738bb44b89dcdd/modules/default.nix#L49
      makeHmConfig = hmConfig: rec {
        inherit (hmConfig.home) activationPackage; # Used when switching
        activation-script = activationPackage; # Backwards compatibility

        config = hmConfig; # home-manager switch accesses config.news.json.output at the end

        newsDisplay = hmConfig.news.display;
        newsEntries = sort (a: b: a.time > b.time) (filter (a: a.condition) hmConfig.news.entries);
      };

      makeHmConfigs =
        hostname: nixos:
        let
          single = length (attrNames nixos.config.home-manager.users) == 1;
        in
        mapAttrs' (
          user: hmConfig:
          nameValuePair (if single then hostname else "${hostname}-${user}") (makeHmConfig hmConfig)
        ) nixos.config.home-manager.users;
    in
    concatMapAttrs makeHmConfigs flake.nixosConfigurations;

  supportedSystems = [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];

  forEachSupportedSystem =
    f:
    nixpkgs.lib.genAttrs supportedSystems (
      system:
      f (
        import nixpkgs {
          inherit system;
          overlays = [ flake.overlays.default ];
        }
      )
    );

  makeOverlays = list: additional: {
    default = (
      final: prev:
      recursiveUpdate {
        pers = listToAttrs (
          map ({ name, path }: nameValuePair name (final.callPackage path { })) (list lib)
        );
      } (additional prev)
    );
  };

  makePackages = genAttrs supportedSystems (
    system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = singleton flake.overlays.default;
      };
    in
    pkgs.pers
  );

  gtkCSSFromWallust = import ./gtk-wallust.nix lib;

  foldlRecursiveUpdate = foldl' recursiveUpdate { };

  mkRice =
    args: settings:
    let
      modules = map (x: if isPath x then import x args else x) settings.modules;
    in
    {
      options.pers.rice.rices.${settings.name}.enable = mkEnableOption "${settings.name} rice";

      config = mkIf args.config.pers.rice.rices.${settings.name}.enable (
        foldlRecursiveUpdate (
          (singleton {
            pers.rice.themesFromWallpapers = settings.themesFromWallpapers or false;
            pers.rice.wallpapers = settings.wallpapers or [ ];

            assertions = singleton {
              assertion = args.config.pers.${settings.wm}.enable;
              message = "pers.${settings.wm}.enable must be enabled for this rice to be enabled.";
            };
          })
          ++ modules
        )
      );
    };

  # This function takes a module path as input and returns the module. This might seem useless, but its objective is to ensure that pkgs is detected as a formal argument. It not being a formal argument was a problem for args: args.lib.pers.mkRice { modules that use args.pkgs }.
  #
  # pkgs here is required as an argument because home-manager adds the pkgs option using config._module.args.pkgs:
  # https://github.com/nix-community/home-manager/blob/f4a07823a298deff0efb0db30f9318511de7c232/modules/modules.nix#L460
  #
  # As can be seen in the source code of evalModules, the builtins function functionArgs is used to determine which arguments from config._module.args should be passed:
  # https://github.com/NixOS/nixpkgs/blob/1c8c4f744c62c744f3118d740fdabd719d1cac00/lib/modules.nix#L537
  #
  # I tried using functors with setFunctionArgs, but it seems home-manager.users.${settings.username} does not accept them.
  #
  # TLDR: Without including pkgs in the attribute set deconstruction, args won't contain pkgs.
  wrapModuleWithPkgs = module: { pkgs, ... }@args: import module args;

  mkIfElse =
    cond: yes: no:
    mkMerge [
      (mkIf cond yes)
      (mkIf (!cond) no)
    ];

  mkIfNotNull = a: mkIf (a != null) a;

  types = {
    filename = mkOptionType {
      name = "str";
      description = "A string not containing `/`";
      descriptionClass = "noun";
      check = x: isString x && !hasInfix "/" x;
      merge = mergeEqualOption;
    };
  };

  # Make the formatter for `nix fmt`
  makeFormatter = lib.pers.forEachSupportedSystem (
    pkgs: treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.wrapper
  );

  # Make the formatting checks for `nix flake check`
  makeFormatterChecks = lib.pers.forEachSupportedSystem (pkgs: {
    formatting = treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.check flake;
  });

  /**
    Get a list of nix files in a folder recursively.
    If a folder has a default.nix file, unless ignoreDefault is set,
    the path to the folder will be returned instead of its children.
    If ignoreDefault is set, then the children of a folder with default.nix will be returned, but not the default.nix file.
    The ignoreDefault argument only applies to the root folder, for everything else ignoreDefault is set to false.
  */
  getFolderModules =
    {
      folder,
      ignoreDefault ? false,
    }:
    let
      contents = builtins.readDir folder;
      hasDefault = contents ? "default.nix" && !ignoreDefault;
      mapFunc =
        name: type:
        if type == "directory" then
          getFolderModules { folder = folder + ("/" + name); }
        else if name == "default.nix" || !hasSuffix ".nix" name then
          [ ]
        else
          folder + ("/" + name);
      modules = flatten (mapAttrsToList mapFunc contents);
    in
    if hasDefault then folder else modules;
}

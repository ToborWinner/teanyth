{
  description = "NixOS Configuration";

  inputs = {
    # --- Dependency Management ---
    empty-flake.url = "github:ToborWinner/empty-flake";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "nix-systems";
    };
    nix-systems.url = "github:nix-systems/default";
    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- NixOS / Nixpkgs ---
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # --- Hardware ---
    apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      # inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "empty-flake";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-muvm-fex = {
      url = "github:nrabulinski/nixos-muvm-fex/native-build";
      inputs.nixos-apple-silicon.follows = "apple-silicon";
      inputs.nixpkgs-muvm.follows = "empty-flake";
      inputs.__flake-compat.follows = "empty-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- Core System ---
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sensitive = {
      url = "git+ssh://git@github.com/ToborWinner/sensitive?ref=main&shallow=1";
      flake = false;
    };

    # --- Servers ---
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
      inputs.flake-compat.follows = "empty-flake";
    };
    nixos-anywhere = {
      url = "github:nix-community/nixos-anywhere";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.disko.follows = "empty-flake";
      inputs.nixos-stable.follows = "empty-flake";
      inputs.nixos-images.follows = "empty-flake";
      inputs.treefmt-nix.follows = "empty-flake";
    };

    # --- Applications / Tools ---
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.systems.follows = "nix-systems";
      inputs.flake-compat.follows = "empty-flake";
      # mnw is not likely to be a dependency of another flake, so it's not overridden
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lobster-rs = {
      url = "github:eatmynerds/lobster-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "empty-flake";
      inputs.flake-parts.follows = "flake-parts";
    };
    wordtui = {
      url = "github:ToborWinner/wordtui";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    discord-counting-tools = {
      url = "github:ToborWinner/discord-counting-tools";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- Package source code ---
    # This is here in flake inputs, which is where it shouldn't be, because it's a pain to work with private repositories in fixed-output fetcher derivations.
    jollydashboard = {
      url = "git+ssh://git@github.com/ToborWinner/JollyDashboard?ref=main&shallow=1";
      flake = false;
    };
    jollybot = {
      url = "git+ssh://git@github.com/ToborWinner/Jolly?ref=main&shallow=1";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      discord-counting-tools,
      sensitive,
      ...
    }:
    let
      lib = nixpkgs.lib.extend (final: prev: { pers = import ./core/lib self final sharedInfo; });

      # Shared info passed to each configuration in specialArgs
      sharedInfo = {
        username = "tobor";
        inherit (import sensitive) sshpub;
      };

      # NixOS system configurations
      configs = {
        nixos-asahi = {
          system = "aarch64-linux";
          reduced = false; # Use a reduced base module list
        };
        rpi3 = {
          system = "aarch64-linux";
          deployable = true; # Allow deploying through deploy-rs
        };
        purity = {
          system = "x86_64-linux";
          deployable = true;
        };
        aegis.system = "x86_64-linux";
      };
    in
    {
      devShells = lib.pers.forEachSupportedSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell { packages = [ pkgs.deploy-rs ]; };
          secrets = pkgs.mkShell {
            shellHook = ''
              alias sops='sudo SOPS_AGE_KEY_FILE=/persist/secrets/master EDITOR=${lib.getExe pkgs.vim} ${lib.getExe pkgs.sops}'
            '';
          };
        }
      );
      nixosConfigurations = lib.pers.makeNixosConfigurations configs;
      homeConfigurations = lib.pers.extractHomeManagerConfigs;
      deploy = lib.pers.makeDeployConfig configs;
      overlays = lib.pers.makeOverlays (import ./pkgs/default.nix) (pkgs: {
        discord-counting-tools = discord-counting-tools.packages.${pkgs.stdenv.hostPlatform.system}.default;
        pers.neovim = import ./modules/neovim {
          inherit pkgs lib;
          inputs = self.inputs;
        };
      });
      packages = lib.pers.makePackages;
      legacyPackages = lib.pers.makeLegacyPackages;
      apps = lib.pers.makeApps;
      templates = import ./templates;
      formatter = lib.pers.makeFormatter;
      checks = lib.recursiveUpdate (lib.pers.makeDeployChecks configs) lib.pers.makeFormatterChecks;
      inherit lib;
    };
}

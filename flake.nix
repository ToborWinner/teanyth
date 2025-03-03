{
  description = "NixOS Configuration";

  inputs = {
    # --- NixOS / Nixpkgs ---
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # --- Hardware ---
    apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-aarch64-widevine.url = "github:epetousis/nixos-aarch64-widevine";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

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
      url = "git+ssh://git@github.com/ToborWinner/sensitive";
      flake = false;
    };

    # --- Servers ---
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- Graphical Environment ---
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- Applications / Tools ---
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    raspberry = {
      url = "github:ToborWinner/raspberry";
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
    };
    wordtui = {
      url = "github:ToborWinner/wordtui";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    discord-counting-tools = {
      url = "github:ToborWinner/discord-counting-tools";
      inputs.nixpkgs.follows = "nixpkgs";
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
        };
        rpi3 = {
          system = "aarch64-linux";
          deployable = true; # Allow deploying through deploy-rs
        };
      };
    in
    {
      devShells = lib.pers.forEachSupportedSystem (pkgs: {
        default = pkgs.mkShell { packages = [ pkgs.deploy-rs ]; };
        secrets = pkgs.mkShell {
          shellHook = ''
            alias sops='sudo SOPS_AGE_KEY_FILE=/persist/secrets/sops.txt EDITOR=${lib.getExe pkgs.vim} ${lib.getExe pkgs.sops}'
          '';
        };
      });
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
      templates = import ./templates;
      formatter = lib.pers.makeFormatter;
      checks = lib.recursiveUpdate (lib.pers.makeDeployChecks configs) lib.pers.makeFormatterChecks;
      inherit lib;
    };
}

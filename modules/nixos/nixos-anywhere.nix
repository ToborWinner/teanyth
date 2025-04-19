{
  lib,
  config,
  settings,
  inputs,
  ...
}:

{
  options.pers.nixos-anywhere.enable = lib.mkEnableOption "nixos-anywhere";

  config = lib.mkIf config.pers.nixos-anywhere.enable {
    assertions = lib.singleton {
      assertion = config.pers.info.getSecretFilePath != null && config.pers.impermanence.enable;
      message = "This remote installation script currently only supports secrets deployment when impermanence is also enabled.";
    };

    system.build.make-install-remote =
      pkgs:
      let
        secretsDeployment = ''
          # Create a temporary directory
          temp=$(mktemp -d)

          # Function to cleanup temporary directory on exit
          cleanup() {
            rm -rf "$temp"
          }
          trap cleanup EXIT

          dest_dir="$temp${config.pers.impermanence.persistFileSystem}/secrets/hosts"
          dest_path="$dest_dir/${settings.hostname}"

          install -d -m700 "$dest_dir"
          sudo cat /persist/secrets/hosts/${settings.hostname} > "$dest_path"
          chmod 600 "$dest_path"
        '';
        needsSecretsDeployment = config.pers.info.getSecretFilePath != null;
      in
      pkgs.writeShellScript "install-${settings.hostname}-remote" ''
        set -e

        if [[ -z "$1" ]]; then
          echo "This script must be called with the destination, such as root@<some_ip>."
          exit 1
        fi

        ${lib.optionalString needsSecretsDeployment secretsDeployment}

        ${inputs.nixos-anywhere.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/nixos-anywhere \
          ${lib.optionalString needsSecretsDeployment "--extra-files \"$temp\" \\"}
          --flake ${lib.escapeShellArg inputs.self}#${settings.hostname} \
          --target-host $@
      '';
  };
}

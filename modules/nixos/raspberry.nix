{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.pers.raspberry;
  voskModel = pkgs.fetchzip {
    url = "https://alphacephei.com/vosk/models/${cfg.voskModelName}.zip";
    hash = "sha256-CIoPZ/krX+UW2w7c84W3oc1n4zc9BBS/fc8rVYUthuY=";
  };
  embeddingModel = {
    "config.json" = pkgs.fetchurl {
      url = "https://huggingface.co/BAAI/bge-small-en-v1.5/resolve/main/config.json";
      hash = "sha256-CU+OiRuTLyAAySz8ZjusTGIGn12K9bUnjEMGrvMIR1A=";
    };
    "special_tokens_map.json" = pkgs.fetchurl {
      url = "https://huggingface.co/BAAI/bge-small-en-v1.5/resolve/main/special_tokens_map.json";
      hash = "sha256-ttNGvjZqfR1IMy28n987+JYLXYeVIrd5ndulnnYjfuM=";
    };
    "tokenizer_config.json" = pkgs.fetchurl {
      url = "https://huggingface.co/BAAI/bge-small-en-v1.5/resolve/main/tokenizer_config.json";
      hash = "sha256-kmHn15tEyBlcHK2itFPlWwCuuB6QemZkl0tNd3YXKrM=";
    };
    "tokenizer.json" = pkgs.fetchurl {
      url = "https://huggingface.co/BAAI/bge-small-en-v1.5/resolve/main/tokenizer.json";
      hash = "sha256-0kGmDV6PBMwbKz6e96SSGye/Um2fYFCrkPkmeh+eXGY=";
    };
    "model.onnx" = pkgs.fetchurl {
      url = "https://huggingface.co/BAAI/bge-small-en-v1.5/resolve/main/onnx/model.onnx";
      hash = "sha256-go4Ultf6u3nPpNzYT6OGJcDT0h2kdKAPCNsPVZlAzzU=";
    };
  };
  dataDir = "/etc/raspberry";
in
{
  options.pers.raspberry = {
    enable = lib.mkEnableOption "raspberry";

    user = lib.mkOption {
      default = "raspberry";
      type = lib.types.str;
      description = "Name of the user to run the service as.";
    };

    voskModelName = lib.mkOption {
      default = "vosk-model-small-en-us-0.15";
      type = lib.types.str;
      description = "The vosk model to install in the configuration. Downloaded from alphacephei.com.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.user} = {
      description = "Raspberry Assistant daemon user";
      isSystemUser = true;
      group = cfg.user;
      extraGroups = [
        "audio"
        "gpio"
        (lib.mkIf (config.services.pipewire.enable && config.services.pipewire.systemWide) "pipewire")
      ];
    };

    users.groups.${cfg.user} = { };

    # TODO: Wait for https://nixpk.gs/pr-tracker.html?pr=375043
    # Also submit a PR to somehow fix there probably being both the system and user services.
    services.speechd.enable = false;

    systemd.services.raspberry = {
      description = "Raspberry Assistant service";

      after = [ "network-online.target" ];
      requires = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.user;
        Type = "exec";
        ExecStart = "${lib.getExe pkgs.pers.raspberry} ${dataDir}";
        Restart = "no";
        # Restart = "always";
        # RestartSec = 10;
        # RestartSteps = 10;
        # RestartMaxDelaySec = 3600;

        ConfigurationDirectory = "raspberry";

        # Hardening
        # NoNewPrivileges = true;
        # ProtectSystem = "strict";
        # ProtectHome = true;
        # ProtectClock = true;
        # PrivateNetwork = true; # Network not needed yet
        # ProtectKernelTunables = true;
        # ProtectKernelModules = true;
        # ProtectKernelLogs = true;
        # LockPersonality = true;
        # RemoveIPC = true;
        # PrivateUsers = true;

        # NoNewPrivileges = true;
        # ProtectSystem = "strict";
        # ProtectHome = true;
        # PrivateDevices = true;
        # PrivateUsers = true;
        # ProtectHostname = true;
        # ProtectClock = true;
        # ProtectKernelTunables = true;
        # ProtectKernelModules = true;
        # ProtectKernelLogs = true;
        # ProtectControlGroups = "strict";
        # RestrictNamespaces = true;
        # LockPersonality = true;
        # RestrictRealtime = true;
        # RestrictSUIDSGID = true;
        # RemoveIPC = true;
      };

      # Add configuration
      preStart =
        ''
          ln -sfn ${voskModel} ${dataDir}/${cfg.voskModelName}
          mkdir -p /etc/raspberry/intents
        ''
        + (lib.concatMapAttrsStringSep "\n" (
          name: value: "ln -sfn ${value} ${dataDir}/intents/${name}"
        ) embeddingModel);
    };
  };
}

{ config, lib, pkgs, ... }:
let
  cfg = config.services.llama-cpp;
  inherit (lib) mkEnableOption mkIf mkOption types;
in {
  disabledModules = [ "services/misc/llama-cpp.nix" ];

  options.services.llama-cpp = {
    enable = mkEnableOption "llama.cpp OpenAI-compatible server";

    package = mkOption {
      type = types.package;
      default = pkgs.llama-cpp;
      description = "llama.cpp package providing llama-server";
    };

    host = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "Network address for llama-server";
    };

    port = mkOption {
      type = types.port;
      default = 8090;
      description = "TCP port for llama-server";
    };

    modelPath = mkOption {
      type = types.either types.path types.str;
      example = "/srv/models/gemma-4-e4b.gguf";
      description = "Path to the externally managed GGUF model file to serve";
    };

    contextSize = mkOption {
      type = types.int;
      default = 128000;
      description = "Context window passed to llama-server";
    };

    nGpuLayers = mkOption {
      type = types.int;
      default = 99;
      description = "Number of layers to offload to GPU when supported";
    };

    threads = mkOption {
      type = types.int;
      default = 8;
      description = "Thread count passed to llama-server";
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Extra command-line arguments for llama-server";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the firewall for the llama-server port";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.port;

    systemd.services.llama-cpp = {
      description = "llama.cpp OpenAI-compatible server";
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = lib.escapeShellArgs ([
          "${cfg.package}/bin/llama-server"
          "--host"
          cfg.host
          "--port"
          (toString cfg.port)
          "--model"
          (toString cfg.modelPath)
          "--ctx-size"
          (toString cfg.contextSize)
          "--n-gpu-layers"
          (toString cfg.nGpuLayers)
          "--threads"
          (toString cfg.threads)
          "--cont-batching"
          "--metrics"
        ] ++ cfg.extraArgs);
        Restart = "always";
        RestartSec = 5;
        StateDirectory = "llama-cpp";
        WorkingDirectory = "/var/lib/llama-cpp";
      };
    };
  };
}

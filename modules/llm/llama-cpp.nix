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
      default = pkgs.llama-cpp.override { cudaSupport = true; };
      description = "llama.cpp package providing llama-server (default: CUDA-enabled)";
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

    alias = mkOption {
      type = types.str;
      default = "llama.cpp/gemma4";
      description = "Model alias exposed in the OpenAI-compatible API";
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

    flashAttention = mkOption {
      type = types.bool;
      default = true;
      description = "Enable flash attention for efficient long-context inference";
    };

    cacheTypeK = mkOption {
      type = types.str;
      default = "q8_0";
      example = "f16";
      description = "KV cache data type for K (f16, q8_0, q4_0, etc.)";
    };

    cacheTypeV = mkOption {
      type = types.str;
      default = "q8_0";
      example = "f16";
      description = "KV cache data type for V (f16, q8_0, q4_0, etc.)";
    };

    mlock = mkOption {
      type = types.bool;
      default = true;
      description = "Lock model in RAM to prevent swapping";
    };

    numa = mkOption {
      type = types.nullOr (types.enum [ "distribute" "isolate" "numactl" ]);
      default = null;
      description = "NUMA optimizations for multi-socket systems";
    };

    chatTemplate = mkOption {
      type = types.str;
      default = "gemma";
      description = "Chat template (model-specific). Required for Gemma 4 to avoid garbled output";
    };

    jinja = mkOption {
      type = types.bool;
      default = true;
      description = "Use GGUF metadata's embedded Jinja chat template (preferred for Gemma 4)";
    };

    reasoning = mkOption {
      type = types.bool;
      default = false;
      description = "Enable thinking/reasoning traces in API responses (experimental, Gemma 4 support unknown)";
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
          "--alias"
          cfg.alias
          "--ctx-size"
          (toString cfg.contextSize)
          "--n-gpu-layers"
          (toString cfg.nGpuLayers)
          "--threads"
          (toString cfg.threads)
          "--cont-batching"
          "--metrics"
          "--flash-attn"
          (if cfg.flashAttention then "on" else "off")
          "-ctk"
          cfg.cacheTypeK
          "-ctv"
          cfg.cacheTypeV
        ] ++ lib.optionals cfg.jinja [ "--jinja" ]
          ++ [
            "--reasoning"
            (if cfg.reasoning then "on" else "off")
          ]
          ++ lib.optional cfg.mlock "--mlock"
          ++ lib.optional (cfg.numa != null) "--numa"
          ++ lib.optional (cfg.numa != null) cfg.numa
          ++ cfg.extraArgs);
        Restart = "always";
        RestartSec = 5;
        StateDirectory = "llama-cpp";
        WorkingDirectory = "/var/lib/llama-cpp";
      };
    };
  };
}

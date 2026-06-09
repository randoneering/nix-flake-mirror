{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.llama-cpp;
  inherit (lib) mkEnableOption mkIf mkOption types;
  selectedModel =
    if cfg.activeModel == null || ! lib.hasAttr cfg.activeModel cfg.models
    then null
    else cfg.models.${cfg.activeModel};
  activeModelPath =
    if selectedModel == null
    then cfg.modelPath
    else selectedModel.modelPath;
  activeAlias =
    if selectedModel == null
    then cfg.alias
    else selectedModel.alias;
  activeContextSize =
    if selectedModel == null || selectedModel.contextSize == null
    then cfg.contextSize
    else selectedModel.contextSize;
  activeExtraArgs =
    if selectedModel == null
    then cfg.extraArgs
    else cfg.extraArgs ++ selectedModel.extraArgs;

  templateContent =
    if cfg.chatTemplateFile != null
    then builtins.readFile cfg.chatTemplateFile
    else if cfg.chatTemplate != null
    then cfg.chatTemplate
    else null;

  serverPackage = cfg.package;

  llamaServerWrapper = pkgs.writeShellScript "llama-server-wrapper" ''
    exec "${serverPackage}/bin/llama-server" \
      --host "${cfg.host}" \
      --port "${toString cfg.port}" \
      --model "${toString activeModelPath}" \
      --alias "${activeAlias}" \
      --ctx-size "${toString activeContextSize}" \
      --n-gpu-layers "${toString cfg.nGpuLayers}" \
      --threads "${toString cfg.threads}" \
      --cont-batching \
      --metrics \
      --flash-attn "${if cfg.flashAttention then "on" else "off"}" \
      -ctk "${cfg.cacheTypeK}" \
      -ctv "${cfg.cacheTypeV}" \
      ${if cfg.jinja then "--jinja" else "--no-jinja"} \
      ${
      if templateContent != null
      then ''--chat-template "$(cat <<'LLAMA_TEMPLATE_EOF'
${templateContent}
LLAMA_TEMPLATE_EOF
)"''
      else ""
    } \
      --reasoning "${if cfg.reasoning then "on" else "off"}" \
      ${lib.optionalString cfg.mlock "--mlock"} \
      ${lib.optionalString (cfg.numa != null) "--numa ${cfg.numa}"} \
      ${toString activeExtraArgs}
  '';
in {
  disabledModules = ["services/misc/llama-cpp.nix"];

  options.services.llama-cpp = {
    enable = mkEnableOption "llama.cpp OpenAI-compatible server";

    package = mkOption {
      type = types.package;
      default = pkgs.llama-cpp.override {cudaSupport = true;};
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
      type = types.nullOr (types.either types.path types.str);
      default = null;
      example = "/srv/models/gemma-4-e4b.gguf";
      description = "Path to the externally managed GGUF model file to serve";
    };

    activeModel = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "gemma-4-e4b";
      description = "Name of the model preset from services.llama-cpp.models to serve. Null uses modelPath and alias directly.";
    };

    models = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          modelPath = mkOption {
            type = types.either types.path types.str;
            example = "/srv/models/gemma-4-e4b.gguf";
            description = "Path to this preset's externally managed GGUF model file.";
          };

          alias = mkOption {
            type = types.str;
            example = "google/gemma-4-e4b";
            description = "Model alias exposed in the OpenAI-compatible API when this preset is active.";
          };

          contextSize = mkOption {
            type = types.nullOr types.int;
            default = null;
            example = 128000;
            description = "Optional context window override for this preset. Null uses services.llama-cpp.contextSize.";
          };

          extraArgs = mkOption {
            type = types.listOf types.str;
            default = [];
            description = "Extra llama-server arguments appended when this preset is active.";
          };
        };
      });
      default = {};
      description = "Named GGUF model presets. Set activeModel to choose which preset llama-server serves.";
    };

    alias = mkOption {
      type = types.str;
      default = "google/gemma-4-e4b";
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
      type = types.nullOr (types.enum ["distribute" "isolate" "numactl"]);
      default = null;
      description = "NUMA optimizations for multi-socket systems";
    };

    chatTemplate = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "gemma";
      description = "Optional chat template (Jinja string). Null uses the template embedded in GGUF metadata";
    };

    chatTemplateFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = /srv/models/chat-template.jinja;
      description = "File containing a custom Jinja chat template. Takes precedence over chatTemplate when set.";
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
      default = [];
      description = "Extra command-line arguments for llama-server";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the firewall for the llama-server port";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.activeModel == null || lib.hasAttr cfg.activeModel cfg.models;
        message = "services.llama-cpp.activeModel must name an entry in services.llama-cpp.models.";
      }
      {
        assertion = activeModelPath != null;
        message = "services.llama-cpp.modelPath must be set unless services.llama-cpp.activeModel selects a model preset.";
      }
    ];

    networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.port;

    systemd.services.llama-cpp = {
      description = "llama.cpp OpenAI-compatible server";
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        ExecStart = "${llamaServerWrapper}";
        Restart = "always";
        RestartSec = 5;
        StateDirectory = "llama-cpp";
        WorkingDirectory = "/var/lib/llama-cpp";
      };
    };
  };
}

{
  lib,
  config,
  ...
}: let
  sopsFile = ../secrets/justin.yaml;
in
  lib.mkIf (builtins.pathExists sopsFile) {
    sops = {
      defaultSopsFile = sopsFile;
      defaultSopsFormat = "yaml";

      age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

      secrets = {
        digitalocean_api_token = {};
        mcp_nixos_token = {};
        postgres_mcp_token = {};
        context7_token = {};
        ollama_api_key = {};
      };

      templates."opencode.json" = {
        path = "${config.home.homeDirectory}/.config/opencode/opencode.json";
        content = builtins.toJSON {
          provider = {
            ollama = {
              options = {
                apiKey = config.sops.placeholder.ollama_api_key;
              };
            };
          };
        };
      };

      templates."pi-agent-models.json" = {
        path = "${config.home.homeDirectory}/.pi/agent/models.json";
        content = builtins.toJSON {
          providers = {
            lmstudio = {
              baseUrl = "https://lmstudio.randoneering.dev/v1";
              api = "openai-completions";
              apiKey = "lm-studio";
              models = [
                {id = "google/gemma-4-e4b";}
                {id = "qwen3.5-9b-claude-4.6-opus-reasoning-distilled-v2";}
              ];
            };
            ollama = {
              baseUrl = "https://ollama.randoneering.dev/v1";
              api = "openai-completions";
              apiKey = config.sops.placeholder.ollama_api_key;
              models = [
                {id = "qwen3.5:4b";}
                {id = "gemma4:e2b";}
              ];
            };
          };
        };
      };
    };
  }

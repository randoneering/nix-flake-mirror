{
  lib,
  config,
  ...
}: let
  sopsFile = ../secrets/justin.yaml;
  sopsFileContents =
    if builtins.pathExists sopsFile
    then builtins.readFile sopsFile
    else "";
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
      } // lib.optionalAttrs (lib.hasInfix "quackit_database_url:" sopsFileContents) {
        quackit_database_url = {};
      } // lib.optionalAttrs (lib.hasInfix "orchestra_api_key:" sopsFileContents) {
        orchestra_api_key = {};
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

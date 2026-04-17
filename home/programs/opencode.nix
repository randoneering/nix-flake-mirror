{
  config,
  lib,
  pkgs,
  agent-config,
  ...
}: let
  # Check if sops secrets are available
  toOpencodeEnvSyntax = value:
    if builtins.isAttrs value
    then lib.mapAttrs (_: toOpencodeEnvSyntax) value
    else if builtins.isList value
    then map toOpencodeEnvSyntax value
    else if builtins.isString value
    then builtins.replaceStrings ["\${"] ["{env:"] value
    else value;

  sharedMcpServers =
    lib.mapAttrs (
      _: server:
        {
          enabled = !(server.disabled or false);
        }
        // (
          if server ? url
          then
            {
              type = "remote";
              url = toOpencodeEnvSyntax server.url;
            }
            // lib.optionalAttrs (server ? headers) {
              headers = toOpencodeEnvSyntax server.headers;
            }
          else if server ? command
          then
            {
              type = "local";
              command = toOpencodeEnvSyntax ([server.command] ++ (server.args or []));
            }
            // lib.optionalAttrs (server ? env) {
              environment = toOpencodeEnvSyntax server.env;
            }
          else {}
        )
    )
    config.programs.mcp.servers;
in {
  home.sessionVariables = {
    OPENCODE_OLLAMA_BASE_URL = "https://ollama.randoneering.dev/v1";
  };

  xdg.configFile."opencode/skills" = {
    source = "${agent-config}/skills";
    recursive = true;
  };

  xdg.configFile."opencode/agents" = {
    source = "${agent-config}/agents";
    recursive = true;
  };

  programs.opencode = {
    enable = true;
    rules = "${agent-config}/AGENTS.md";
    package = pkgs.unstable.opencode;
    settings = {
      autoupdate = true;
      provider = {
        ollama = {
          npm = "@ai-sdk/openai-compatible";
          name = "Ollama (remote)";
          options = {
            baseURL = "https://ollama.randoneering.dev/v1";
          };
          models = {
            "qwen3.5:4b" = {
              name = "Qwen3.5 4B";
            };
            "gemma4:e2b" = {
              name = "gemma4:e2b";
            };
            "gemma4:e4b" = {
              name = "gemma4:e4b";
            };
          };
        };
      };
      mcp = sharedMcpServers;
    };
  };
}

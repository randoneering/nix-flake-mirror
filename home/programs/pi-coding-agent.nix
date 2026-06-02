{
  config,
  lib,
  pkgs,
  ...
}: let
  mcpNixosTokenPath = lib.attrByPath ["sops" "secrets" "mcp_nixos_token" "path"] null config;
  context7TokenPath = lib.attrByPath ["sops" "secrets" "context7_token" "path"] null config;
  lmstudioApiKeyPath = lib.attrByPath ["sops" "secrets" "lmstudio_api_key" "path"] null config;

  piPackage = pkgs.unstable.pi-coding-agent;

  toPiMcpServer = server:
    if server.disabled or false
    then null
    else if server ? url
    then
      {
        url = server.url;
        auth = false;
        directTools = true;
      }
      // lib.optionalAttrs (server ? headers) {
        headers = server.headers;
      }
    else if server ? command
    then
      {
        command = server.command;
        args = server.args or [];
      }
      // lib.optionalAttrs (server ? env) {
        env = server.env;
      }
    else null;

  piMcpServers = lib.filterAttrs (_: server: server != null) (lib.mapAttrs (_: toPiMcpServer) config.programs.mcp.servers);

  settingsJson = builtins.toJSON {
    enableInstallTelemetry = false;
    packages = [
      "npm:pi-subagents"
      "npm:pi-mcp-adapter"
      "npm:pi-web-access"
      "npm:pi-caveman"
      "npm:@samfp/pi-memory"
      "git:github.com/joelhooks/pi-theme-catppuccin-mocha"
    ];
    defaultProvider = "llama-cpp";
    defaultModel = "google/gemma-4-e4b";
    defaultThinkingLevel = "medium";
    theme = "catppuccin-mocha";
  };

  modelsJson = builtins.toJSON {
    providers = {
      llama-cpp = {
        baseUrl = "http://10.10.1.232:8090/v1";
        api = "openai-completions";
        models = [
          {id = "google/gemma-4-e4b";}
          {id = "qwen3.5-9b";}
          {id = "qwen2.5-coder-7b";}
          {id = "qwen2.5-vl-3b";}
        ];
      };
    };
  };

  mcpJson = builtins.toJSON {
    mcpServers = piMcpServers;
  };

  secretExports = lib.concatStringsSep " \\\n        " (
    lib.filter (value: value != "") [
      (lib.optionalString (mcpNixosTokenPath != null) "--run 'export MCP_NIXOS_TOKEN=\"$(read_secret MCP_NIXOS_TOKEN \"${mcpNixosTokenPath}\")\"'")
      (lib.optionalString (context7TokenPath != null) "--run 'export CONTEXT7_TOKEN=\"$(read_secret CONTEXT7_TOKEN \"${context7TokenPath}\")\"'")
      (lib.optionalString (lmstudioApiKeyPath != null) "--run 'export LMSTUDIO_API_KEY=\"$(read_secret LMSTUDIO_API_KEY \"${lmstudioApiKeyPath}\")\"'")
    ]
  );

  wrappedPiPackage = pkgs.symlinkJoin {
    name = "${piPackage.name}-with-runtime-secrets";
    paths = [piPackage];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      rm "$out/bin/pi"
      makeWrapper "${piPackage}/bin/pi" "$out/bin/pi" \
        --set-default PI_SKIP_VERSION_CHECK 1 \
        --run 'export NPM_CONFIG_PREFIX="$HOME/.pi/agent/npm-global"' \
        --run 'export PATH="$HOME/.pi/agent/npm-global/bin:$PATH"' \
        --run 'read_secret() {
          local secret_name="$1"
          local secret_path="$2"
          local value
          if [ ! -r "$secret_path" ]; then
            printf "pi: required secret %s is missing or unreadable: %s\n" "$secret_name" "$secret_path" >&2
            exit 1
          fi
          value="$(<"$secret_path")"
          if [ -z "$value" ]; then
            printf "pi: required secret %s is empty: %s\n" "$secret_name" "$secret_path" >&2
            exit 1
          fi
          printf "%s" "$value"
        }' \
        ${secretExports}
    '';
  };
in {
  home.packages = [wrappedPiPackage];
}

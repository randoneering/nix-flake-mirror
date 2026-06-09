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

  # Matches the llama-server instance on 10.10.1.232:11434
  llamaBaseUrl = "http://10.10.1.232:8090/v1";
  llamaApiKey = "llamacpp";

  modelsJson = builtins.toJSON {
    providers = {
      llama-cpp = {
        baseUrl = llamaBaseUrl;
        api = "openai-completions";
        apiKey = llamaApiKey;
        compat = {
          supportsDeveloperRole = false;
          supportsReasoningEffort = false;
          maxTokensField = "max_tokens";
          thinkingFormat = "qwen-chat-template";
        };
        models = [
          {
            id = "qwen2.5-coder-7b-awq";
            name = "Qwen 2.5 Coder 7B AWQ (llama.cpp remote)";
            contextWindow = 131072;
            maxTokens = 16384;
            input = ["text"];
            cost = {
              input = 0;
              output = 0;
              cacheRead = 0;
              cacheWrite = 0;
            };
          }
        ];
      };
    };
  };

  # Read MCP servers from opencode's config (which lives outside nix store)
  # and merge with the filesystem server. Servers shared across agents.
  extraMcpServers = {
    filesystem = {
      command = "npx";
      args = ["-y" "@modelcontextprotocol/server-filesystem" "/home/justin"];
    };
    context7 = {
      url = "https://context7.randoneering.dev/mcp";
      auth = false;
      directTools = true;
      headers = {
        Authorization = "Bearer \${CONTEXT7_TOKEN}";
      };
    };
    mcp-nixos = {
      url = "https://mcp01.randoneering.dev/nixos/mcp";
      auth = false;
      directTools = true;
      headers = {
        Authorization = "Bearer \${MCP_NIXOS_TOKEN}";
      };
    };
    quackit = {
      command = "uvx";
      args = ["--from" "git+https://github.com/randoneering/quackit-mcp@v0.1.4" "quackit" "serve" "--transport" "stdio"];
      env = {
        QUACKIT_DATABASE_URL = "\${QUACKIT_DATABASE_URL}";
      };
    };
  };

  mcpServersAll = piMcpServers // extraMcpServers;

  mcpJson = builtins.toJSON {
    mcpServers = mcpServersAll;
  };

  piPackages = [
    "npm:pi-subagents"
    "npm:pi-mcp-adapter"
    "npm:pi-web-access"
    "npm:pi-caveman"
    "npm:context-mode"
  ];

  settingsJson = builtins.toJSON {
    enableInstallTelemetry = false;
    packages = piPackages;
    defaultProvider = "llama-cpp";
    defaultModel = null;
    defaultThinkingLevel = "medium";
    theme = "catppuccin-mocha";
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
  home.file.".pi/agent/settings.json".text = settingsJson;
  home.file.".pi/agent/models.json".text = modelsJson;
  home.file.".pi/agent/mcp.json".text = mcpJson;
  home.file.".pi/agent/AGENTS.md".text = builtins.readFile ./pi-coding-agent-agents.md;
}

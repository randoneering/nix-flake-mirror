{
  config,
  lib,
  pkgs,
  agent-config,
  ...
}: let
  digitaloceanTokenPath = lib.attrByPath ["sops" "secrets" "digitalocean_api_token" "path"] null config;
  mcpNixosTokenPath = lib.attrByPath ["sops" "secrets" "mcp_nixos_token" "path"] null config;
  postgresMcpTokenPath = lib.attrByPath ["sops" "secrets" "postgres_mcp_token" "path"] null config;
  context7TokenPath = lib.attrByPath ["sops" "secrets" "context7_token" "path"] null config;
  ollamaApiKeyPath = lib.attrByPath ["sops" "secrets" "ollama_api_key" "path"] null config;

  piPackage = pkgs.unstable.pi-coding-agent;

  toPiMcpServer = server:
    if server.disabled or false
    then null
    else if server ? url
    then {
      url = server.url;
      auth = false;
      directTools = true;
    }
    // lib.optionalAttrs (server ? headers) {
      headers = server.headers;
    }
    else if server ? command
    then {
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
      "git:github.com/randoneering/popping-and-locking-pi-theme"
    ];
    defaultProvider = "ollama";
    defaultModel = "qwen3.5:4b";
    defaultThinkingLevel = "medium";
    theme = "popping-and-locking";
  };

  mcpJson = builtins.toJSON {
    mcpServers = piMcpServers;
  };

  secretExports = lib.concatStringsSep " \\\n        " (
    lib.filter (value: value != "") [
      (lib.optionalString (digitaloceanTokenPath != null) "--run 'export DIGITALOCEAN_API_TOKEN=\"$(read_secret DIGITALOCEAN_API_TOKEN \"${digitaloceanTokenPath}\")\"'")
      (lib.optionalString (mcpNixosTokenPath != null) "--run 'export MCP_NIXOS_TOKEN=\"$(read_secret MCP_NIXOS_TOKEN \"${mcpNixosTokenPath}\")\"'")
      (lib.optionalString (postgresMcpTokenPath != null) "--run 'export POSTGRES_MCP_TOKEN=\"$(read_secret POSTGRES_MCP_TOKEN \"${postgresMcpTokenPath}\")\"'")
      (lib.optionalString (context7TokenPath != null) "--run 'export CONTEXT7_TOKEN=\"$(read_secret CONTEXT7_TOKEN \"${context7TokenPath}\")\"'")
      (lib.optionalString (ollamaApiKeyPath != null) "--run 'export OLLAMA_API_KEY=\"$(read_secret OLLAMA_API_KEY \"${ollamaApiKeyPath}\")\"'")
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

  home.file = {
    ".pi/agent/AGENTS.md".source = "${agent-config}/AGENTS.md";
    ".pi/agent/skills" = {
      source = "${agent-config}/skills";
      recursive = true;
    };
    ".pi/agent/agents" = {
      source = "${agent-config}/pi-agent/agents";
      recursive = true;
    };
    ".pi/agent/settings.json".text = settingsJson;
    ".pi/agent/mcp.json".text = mcpJson;
  };
}

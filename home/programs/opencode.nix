{
  config,
  lib,
  pkgs,
  ...
}: let
  mcpNixosTokenPath = lib.attrByPath ["sops" "secrets" "mcp_nixos_token" "path"] null config;
  context7TokenPath = lib.attrByPath ["sops" "secrets" "context7_token" "path"] null config;
  lmstudioApiKeyPath = lib.attrByPath ["sops" "secrets" "lmstudio_api_key" "path"] null config;
  quackitDatabaseUrlPath = lib.attrByPath ["sops" "secrets" "quackit_database_url" "path"] null config;

  opencodePackage = pkgs.unstable.opencode;

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

  secretExports = lib.concatStringsSep " \\\n        " (
    lib.filter (value: value != "") [
      (lib.optionalString (mcpNixosTokenPath != null) "--run 'export MCP_NIXOS_TOKEN=\"$(read_secret MCP_NIXOS_TOKEN \"${mcpNixosTokenPath}\")\"'")
      (lib.optionalString (context7TokenPath != null) "--run 'export CONTEXT7_TOKEN=\"$(read_secret CONTEXT7_TOKEN \"${context7TokenPath}\")\"'")
      (lib.optionalString (lmstudioApiKeyPath != null) "--run 'export LMSTUDIO_API_KEY=\"$(read_secret LMSTUDIO_API_KEY \"${lmstudioApiKeyPath}\")\"'")
      (lib.optionalString (quackitDatabaseUrlPath != null) "--run 'export QUACKIT_DATABASE_URL=\"$(read_secret QUACKIT_DATABASE_URL \"${quackitDatabaseUrlPath}\")\"'")
    ]
  );

  wrappedOpencodePackage = pkgs.symlinkJoin {
    name = "${opencodePackage.name}-with-runtime-secrets";
    paths = [opencodePackage];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      rm "$out/bin/opencode"
      makeWrapper "${opencodePackage}/bin/opencode" "$out/bin/opencode" \
        --run 'read_secret() {
          local secret_name="$1"
          local secret_path="$2"
          local value
          if [ ! -r "$secret_path" ]; then
            printf "opencode: required secret %s is missing or unreadable: %s\n" "$secret_name" "$secret_path" >&2
            exit 1
          fi
          value="$(<"$secret_path")"
          if [ -z "$value" ]; then
            printf "opencode: required secret %s is empty: %s\n" "$secret_name" "$secret_path" >&2
            exit 1
          fi
          printf "%s" "$value"
        }' \
        ${secretExports}
    '';
  };
in {
  programs.opencode = {
    enable = true;
    package = wrappedOpencodePackage;
    settings = toOpencodeEnvSyntax {
      autoupdate = true;
      model = "llama.cpp/qwen3.5-9b";
      mcp = sharedMcpServers;
      provider.llama-cpp = {
        api = "openai";
        options = {
          baseURL = "http://10.10.1.232:8090/v1";
        };
        models = {
          "gemma-4-e4b".id = "google/gemma-4-e4b";
          "qwen3.5-9b".id = "qwen3.5-9b";
          "qwen2.5-coder-7b".id = "qwen2.5-coder-7b";
          "qwen2.5-coder-7b-awq".id = "qwen2.5-coder-7b-awq";
          "qwen2.5-vl-3b".id = "qwen2.5-vl-3b";
        };
      };
    };
  };
}

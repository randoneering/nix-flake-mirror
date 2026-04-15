{
  config,
  username,
  pkgs,
  lib,
  ...
}: let
  digitaloceanTokenPath = lib.attrByPath ["sops" "secrets" "digitalocean_api_token" "path"] null config;
  mcpNixosTokenPath = lib.attrByPath ["sops" "secrets" "mcp_nixos_token" "path"] null config;
  postgresMcpTokenPath = lib.attrByPath ["sops" "secrets" "postgres_mcp_token" "path"] null config;
  context7TokenPath = lib.attrByPath ["sops" "secrets" "context7_token" "path"] null config;
  ollamaApiKeyPath = lib.attrByPath ["sops" "secrets" "ollama_api_key" "path"] null config;
in {
  programs.bash = {
    enable = true;
    package = pkgs.unstable.bash;
    bashrcExtra =
      ''
        eval $(ssh-agent)
        export PATH="/home/justin/.local/bin:$PATH"
      ''
      + lib.optionalString (digitaloceanTokenPath != null) ''
        if [ -f "${digitaloceanTokenPath}" ]; then
          export DIGITALOCEAN_API_TOKEN="$(<"${digitaloceanTokenPath}")"
        fi
      ''
      + lib.optionalString (mcpNixosTokenPath != null) ''
        if [ -f "${mcpNixosTokenPath}" ]; then
          export MCP_NIXOS_TOKEN="$(<"${mcpNixosTokenPath}")"
        fi
      ''
      + lib.optionalString (postgresMcpTokenPath != null) ''
        if [ -f "${postgresMcpTokenPath}" ]; then
          export POSTGRES_MCP_TOKEN="$(<"${postgresMcpTokenPath}")"
        fi
      ''
      + lib.optionalString (context7TokenPath != null) ''
        if [ -f "${context7TokenPath}" ]; then
          export CONTEXT7_TOKEN="$(<"${context7TokenPath}")"
        fi
      ''
      + lib.optionalString (ollamaApiKeyPath != null) ''
        if [ -f "${ollamaApiKeyPath}" ]; then
          export OLLAMA_API_KEY="$(<"${ollamaApiKeyPath}")"
        fi
      '';
  };
}

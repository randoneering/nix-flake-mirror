{
  config,
  username,
  pkgs,
  lib,
  ...
}: let
  mcpNixosTokenPath = lib.attrByPath ["sops" "secrets" "mcp_nixos_token" "path"] null config;
  context7TokenPath = lib.attrByPath ["sops" "secrets" "context7_token" "path"] null config;
  lmstudioApiKeyPath = lib.attrByPath ["sops" "secrets" "lmstudio_api_key" "path"] null config;
  quackitDatabaseUrlPath = lib.attrByPath ["sops" "secrets" "quackit_database_url" "path"] null config;
in {
  programs.bash = {
    enable = true;
    package = pkgs.unstable.bash;
    bashrcExtra =
      ''
        eval $(ssh-agent)
        export PATH="/home/justin/.local/bin:$PATH"
      ''
      + lib.optionalString (mcpNixosTokenPath != null) ''
        if [ -f "${mcpNixosTokenPath}" ]; then
          export MCP_NIXOS_TOKEN="$(<"${mcpNixosTokenPath}")"
        fi
      ''
      + lib.optionalString (context7TokenPath != null) ''
        if [ -f "${context7TokenPath}" ]; then
          export CONTEXT7_TOKEN="$(<"${context7TokenPath}")"
        fi
      ''
      + lib.optionalString (lmstudioApiKeyPath != null) ''
        if [ -f "${lmstudioApiKeyPath}" ]; then
          export LMSTUDIO_API_KEY="$(<"${lmstudioApiKeyPath}")"
        fi
      ''
      + lib.optionalString (quackitDatabaseUrlPath != null) ''
        if [ -f "${quackitDatabaseUrlPath}" ]; then
          export QUACKIT_DATABASE_URL="$(<"${quackitDatabaseUrlPath}")"
        fi
      '';
};
}

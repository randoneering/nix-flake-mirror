{
  config,
  pkgs,
  lib,
  ...
}: let
  digitaloceanTokenPath = lib.attrByPath ["sops" "secrets" "digitalocean_api_token" "path"] null config;
  mcpNixosTokenPath = lib.attrByPath ["sops" "secrets" "mcp_nixos_token" "path"] null config;
  postgresMcpTokenPath = lib.attrByPath ["sops" "secrets" "postgres_mcp_token" "path"] null config;
  context7TokenPath = lib.attrByPath ["sops" "secrets" "context7_token" "path"] null config;
  lmstudioApiKeyPath = lib.attrByPath ["sops" "secrets" "lmstudio_api_key" "path"] null config;
  quackitDatabaseUrlPath = lib.attrByPath ["sops" "secrets" "quackit_database_url" "path"] null config;
  orchestraApiKeyPath = lib.attrByPath ["sops" "secrets" "orchestra_api_key" "path"] null config;
in {
  programs.fish = {
    enable = true;
    package = pkgs.unstable.fish;
    interactiveShellInit =
      ''
        eval ssh-agent
        export PATH="/home/justin/.local/bin:$PATH"
      ''
      + lib.optionalString (digitaloceanTokenPath != null) ''
        if test -f "${digitaloceanTokenPath}"
          set -gx DIGITALOCEAN_API_TOKEN (string trim (cat "${digitaloceanTokenPath}"))
        end
      ''
      + lib.optionalString (mcpNixosTokenPath != null) ''
        if test -f "${mcpNixosTokenPath}"
          set -gx MCP_NIXOS_TOKEN (string trim (cat "${mcpNixosTokenPath}"))
        end
      ''
      + lib.optionalString (postgresMcpTokenPath != null) ''
        if test -f "${postgresMcpTokenPath}"
          set -gx POSTGRES_MCP_TOKEN (string trim (cat "${postgresMcpTokenPath}"))
        end
      ''
      + lib.optionalString (context7TokenPath != null) ''
        if test -f "${context7TokenPath}"
          set -gx CONTEXT7_TOKEN (string trim (cat "${context7TokenPath}"))
        end
      ''
      + lib.optionalString (lmstudioApiKeyPath != null) ''
        if test -f "${lmstudioApiKeyPath}"
          set -gx LMSTUDIO_API_KEY (string trim (cat "${lmstudioApiKeyPath}"))
        end
      ''
      + lib.optionalString (quackitDatabaseUrlPath != null) ''
        if test -f "${quackitDatabaseUrlPath}"
          set -gx QUACKIT_DATABASE_URL (string trim (cat "${quackitDatabaseUrlPath}"))
        end
      ''
      + lib.optionalString (orchestraApiKeyPath != null) ''
        if test -f "${orchestraApiKeyPath}"
          set -gx ORCHESTRA_API_KEY (string trim (cat "${orchestraApiKeyPath}"))
        end
      '';
};
}

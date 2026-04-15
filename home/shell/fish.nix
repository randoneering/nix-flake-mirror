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
  ollamaApiKeyPath = lib.attrByPath ["sops" "secrets" "ollama_api_key" "path"] null config;
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
      + lib.optionalString (ollamaApiKeyPath != null) ''
        if test -f "${ollamaApiKeyPath}"
          set -gx OLLAMA_API_KEY (string trim (cat "${ollamaApiKeyPath}"))
        end
      '';
  };
}

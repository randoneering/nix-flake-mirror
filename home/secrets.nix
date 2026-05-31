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

      secrets =
        {
          digitalocean_api_token = {};
          mcp_nixos_token = {};
          postgres_mcp_token = {};
          context7_token = {};
          ollama_api_key = {};
        }
        // lib.optionalAttrs (lib.hasInfix "quackit_database_url:" sopsFileContents) {
          quackit_database_url = {};
        }
        // lib.optionalAttrs (lib.hasInfix "orchestra_api_key:" sopsFileContents) {
          orchestra_api_key = {};
        };
    };
  }

{
  lib,
  config,
  ...
}: let
  sopsFile = ../../secrets/justin.yaml;
in
  lib.mkIf (builtins.pathExists sopsFile) {
    sops = {
      defaultSopsFile = sopsFile;
      defaultSopsFormat = "yaml";

      age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

      secrets = {
        digitalocean_api_token = {};
        mcp_nixos_token = {};
        postgres_mcp_token = {};
        context7_token = {};
      };
    };
  }

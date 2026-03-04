{
  config,
  username,
  pkgs,
  lib,
  ...
}: let
  digitaloceanTokenPath = lib.attrByPath ["sops" "secrets" "digitalocean_api_token" "path"] null config;
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
      '';
  };
}

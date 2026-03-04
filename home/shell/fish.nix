{
  config,
  pkgs,
  lib,
  ...
}: let
  digitaloceanTokenPath = lib.attrByPath ["sops" "secrets" "digitalocean_api_token" "path"] null config;
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
      '';
  };
}

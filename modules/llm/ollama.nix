{
  pkgs,
  lib,
  username,
  ...
}: {
  # Ollama Setup
  services.ollama = {
    enable = true;
    package = pkgs.unstable.ollama;
    acceleration = "cuda";
    openFirewall = true;
    host = "0.0.0.0"; # Make Ollama accesible outside of localhost
  };
}

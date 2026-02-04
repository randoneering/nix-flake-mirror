{
  pkgs,
  lib,
  username,
  ...
}:{
  systemd.services.ollama.serviceConfig = {
    Environment = [ "OLLAMA_HOST=10.10.1.232:11434" ];
    };
   # Ollama Setup
  services.ollama = {
    enable = true;
    package = pkgs.unstable.ollama;
    acceleration = "cuda";
    loadModels = ["llama3.2:3b" "deepseek-r1:1.5b" "gemma3:12b" "qwen3:8b" "qwen3:14b" "qwen3-coder:latest"];
    openFirewall = true;
    host = "10.10.1.232"; # Make Ollama accesible outside of localhost
  };
}

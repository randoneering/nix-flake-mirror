{ pkgs, ... }:
{
  home.sessionVariables = {
    OPENCODE_OLLAMA_BASE_URL = "http://10.10.1.232:11434/v1";
  };

  programs.opencode = {
    enable = true;
    package = pkgs.unstable.opencode;
    settings = {
      autoupdate = false;
      model = "ollama/qwen3-coder:latest";
      small_model = "ollama/qwen3:8b";
      provider = {
        ollama = {
          npm = "@ai-sdk/openai-compatible";
          name = "Ollama (remote)";
          options = {
            baseURL = "{env:OPENCODE_OLLAMA_BASE_URL}";
          };
          models = {
            "gpt-oss:20b" = {
              name = "GPT OSS 20B";
            };
            "qwen3-coder:latest" = {
              name = "Qwen3 Coder";
            };
            "qwen3:8b" = {
              name = "Qwen3 8B";
            };
          };
        };
      };
    };
  };
}

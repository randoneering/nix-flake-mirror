{
  config,
  pkgs,
  opencode-config,
  ...
}: {
  home.sessionVariables = {
    OPENCODE_OLLAMA_BASE_URL = "https://ollama.randoneering.dev/v1";
  };

  programs.opencode = {
    enable = true;
    skills = "${opencode-config}/skills";
    rules = "./opencode/AGENTS.md";
    agents = "${opencode-config}/agents";
    package = pkgs.unstable.opencode;
    settings = {
      autoupdate = true;
      provider = {
        ollama = {
          npm = "@ai-sdk/openai-compatible";
          name = "Ollama (remote)";
          options = {
            baseURL = "https://ollama.randoneering.dev/v1";
          };
          models = {
            "qwen3:8b" = {
              name = "Qwen3 8B";
            };
            "qwen3.5:9b" = {
              name = "Qwen3 3.5 9B";
            };
            "gpt-oss:20b" = {
              name = "GPT OSS 20B";
            };
          };
        };
      };
      mcp = {
        flox = {
          type = "local";
          command = ["flox-mcp"];
          enabled = true;
        };
        neon = {
          type = "remote";
          url = "https://mcp.neon.tech/mcp";
          enabled = true;
        };
        nixos-mcp = {
          type = "remote";
          url = "https://mcp01.randoneering.dev/nixos/mcp";
          enabled = true;
        };
        do_apps = {
          type = "remote";
          url = "https://apps.mcp.digitalocean.com/mcp";
          enabled = true;
          headers = {
            Authorization = "{env:DIGITALOCEAN_API_TOKEN}";
          };
        };
        do_droplets = {
          type = "remote";
          url = "https://droplets.mcp.digitalocean.com/mcp";
          enabled = true;
          headers = {
            Authorization = "{env:DIGITALOCEAN_API_TOKEN}";
          };
        };
        do_databases = {
          type = "remote";
          url = "https://databases.mcp.digitalocean.com/mcp";
          enabled = true;
          headers = {
            Authorization = "{env:DIGITALOCEAN_API_TOKEN}";
          };
        };
        do_networking = {
          type = "remote";
          url = "https://networking.mcp.digitalocean.com/mcp";
          enabled = true;
          headers = {
            Authorization = "{env:DIGITALOCEAN_API_TOKEN}";
          };
        };
      };
    };
  };
}

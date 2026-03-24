{config, pkgs, ...}: {
  home.sessionVariables = {
    OPENCODE_OLLAMA_BASE_URL = "https://ollama.randoneering.dev/v1";
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
            baseURL = "https://ollama.randoneering.dev/v1";
          };
          models = {
            "qwen3-coder:latest" = {
              name = "Qwen3 Coder";
            };
            "qwen3:8b" = {
              name = "Qwen3 8B";
            };
            "qwen3:14b" = {
              name = "Qwen3 14B";
            };
            "qwen3.5:27b" = {
              name = "Qwen3.5 27B";
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


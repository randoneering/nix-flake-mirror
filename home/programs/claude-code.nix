{
  pkgs,
  opencode-config,
  ...
}: {
  programs.mcp = {
    enable = true;

    servers = {
      flox = {
        command = "flox-mcp";
      };
      neon = {
        url = "https://mcp.neon.tech/mcp";
      };
      mcp-nixos = {
        url = "https://mcp01.randoneering.dev/nixos/mcp";
        headers = {
          Authorization = "Bearer \${MCP_NIXOS_TOKEN}";
        };
      };
      postgres-mcp = {
        url = "https://postgres-mcp.randoneering.dev/mcp";
        headers = {
          Authorization = "Bearer \${POSTGRES_MCP_TOKEN}";
        };
      };
      context7 = {
        url = "https://context7.randoneering.dev/mcp";
        headers = {
          Authorization = "Bearer \${CONTEXT7_TOKEN}";
        };
      };
      do_apps = {
        url = "https://apps.mcp.digitalocean.com/mcp";
        headers = {
          Authorization = "\${DIGITALOCEAN_API_TOKEN}";
        };
      };
      do_droplets = {
        url = "https://droplets.mcp.digitalocean.com/mcp";
        headers = {
          Authorization = "\${DIGITALOCEAN_API_TOKEN}";
        };
      };
      do_databases = {
        url = "https://databases.mcp.digitalocean.com/mcp";
        headers = {
          Authorization = "\${DIGITALOCEAN_API_TOKEN}";
        };
      };
      do_networking = {
        url = "https://networking.mcp.digitalocean.com/mcp";
        headers = {
          Authorization = "\${DIGITALOCEAN_API_TOKEN}";
        };
      };
    };
  };

  programs.claude-code = {
    enable = true;
    package = pkgs.unstable.claude-code;
    enableMcpIntegration = true;

    memory.source = "${opencode-config}/AGENTS.md";
    agentsDir = "${opencode-config}/agents";
    skillsDir = "${opencode-config}/skills";
  };
}

{
  pkgs,
  agent-config,
  ...
}: {
  home.packages = [
    pkgs.unstable.pi-coding-agent
  ];

  home.file = {
    ".pi/agent/AGENTS.md".source = "${agent-config}/AGENTS.md";
    ".pi/agent/skills" = {
      source = "${agent-config}/skills";
      recursive = true;
    };
    ".pi/agent/agents" = {
      source = "${agent-config}/pi-agent/agents";
      recursive = true;
    };
    ".pi/agent/settings.json".text = builtins.toJSON {
      defaultProvider = "ollama";
      defaultModel = "qwen3.5:4b";
      defaultThinkingLevel = "medium";
    };
  };
}

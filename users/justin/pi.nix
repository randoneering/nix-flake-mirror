{agent-config, ...}: {
  home.file.".pi/agent/AGENTS.md".source = "${agent-config}/AGENTS.md";

  home.file.".pi/agent/skills" = {
    source = "${agent-config}/skills";
    recursive = true;
  };

  home.file.".pi/agent/agents" = {
    source = "${agent-config}/agents";
    recursive = true;
  };
}

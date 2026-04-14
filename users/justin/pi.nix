{agent-config, ...}: {
  home.file.".pi/agent/AGENTS.md".source = "${agent-config}/AGENTS.md";

  home.file.".pi/agent/settings.json".text = builtins.toJSON {
    skills = ["~/.claude/skills"];
  };

  home.file.".pi/agent/skills" = {
    source = "${agent-config}/skills";
    recursive = true;
  };

  home.file.".pi/agent/agents" = {
    source = "${agent-config}/agents";
    recursive = true;
  };
}

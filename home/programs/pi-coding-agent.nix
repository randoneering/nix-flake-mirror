{
  pkgs,
  agent-config,
  ...
}: let
  promptsDir = agent-config + "/prompts";
  extensionsDir = agent-config + "/extensions";
  themesDir = agent-config + "/themes";
in {
  home.packages = [
    pkgs.unstable."pi-coding-agent"
  ];

  home.file = {
    ".pi/agent/AGENTS.md".source = "${agent-config}/AGENTS.md";
    ".pi/agent/skills" = {
      source = "${agent-config}/skills";
      recursive = true;
    };
  }
    // (if builtins.pathExists promptsDir
    then {
      ".pi/agent/prompts" = {
        source = promptsDir;
        recursive = true;
      };
    }
    else {})
    // (if builtins.pathExists extensionsDir
    then {
      ".pi/agent/extensions" = {
        source = extensionsDir;
        recursive = true;
      };
    }
    else {})
    // (if builtins.pathExists themesDir
    then {
      ".pi/agent/themes" = {
        source = themesDir;
        recursive = true;
      };
    }
    else {});
}

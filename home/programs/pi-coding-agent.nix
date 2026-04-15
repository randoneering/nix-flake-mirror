{
  pkgs,
  agent-config,
  ...
}: let
  promptsDir = agent-config + "/prompts";
  themesDir = agent-config + "/themes";

  # Build pi-web-access extension with node_modules included
  # so that symlinked .ts files can resolve their dependencies.
  piWebAccess = pkgs.buildNpmPackage {
    pname = "pi-web-access";
    version = "0.10.6";
    src = agent-config + "/extensions/pi-web-access";
    npmDepsHash = "sha256-zwH9ba5M6wRtyTdpi/7To/ZzkQfNvgO8CxdpGCeB8Vo=";
    dontNpmBuild = true;
    installPhase = ''
      mkdir -p $out
      cp -r . $out/
    '';
  };

  extensionsDir = pkgs.runCommand "pi-agent-extensions" {} ''
    mkdir -p $out/pi-web-access
    cp -r ${piWebAccess}/* $out/pi-web-access/
  '';
in {
  home.packages = [
    pkgs.unstable."pi-coding-agent"
  ];

  home.file =
    {
      ".pi/agent/AGENTS.md".source = "${agent-config}/AGENTS.md";
      ".pi/agent/skills" = {
        source = "${agent-config}/skills";
        recursive = true;
      };
".pi/agent/settings.json".text = builtins.toJSON {
        defaultProvider = "ollama";
        model = "qwen3.5:4b";
      };
    }
    // (
      if builtins.pathExists promptsDir
      then {
        ".pi/agent/prompts" = {
          source = promptsDir;
          recursive = true;
        };
      }
      else {}
    )
    // (
      if builtins.pathExists extensionsDir
      then {
        ".pi/agent/extensions" = {
          source = extensionsDir;
          recursive = true;
        };
      }
      else {}
    )
    // (
      if builtins.pathExists themesDir
      then {
        ".pi/agent/themes" = {
          source = themesDir;
          recursive = true;
        };
      }
      else {}
    );
}

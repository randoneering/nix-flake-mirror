{
  lib,
  pkgs,
  agent-config,
  pi-theme,
  pi-subagents,
  pi-web-access,
  ...
}: let
  piWebAccess = pkgs.buildNpmPackage {
    pname = "pi-web-access";
    version = "0.10.6";
    src = pi-web-access;
    npmDepsHash = lib.fakeHash;
    dontNpmBuild = true;
    installPhase = ''
      mkdir -p $out
      cp -r . $out/
    '';
  };

  extensionsDir = pkgs.runCommand "pi-agent-extensions" {} ''
    mkdir -p $out/pi-web-access
    cp -r ${piWebAccess}/* $out/pi-web-access/
    mkdir -p $out/pi-subagents
    cp -r ${pi-subagents}/* $out/pi-subagents/
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
      ".pi/agent/themes".source = "${pi-theme}/themes";
      ".pi/agent/settings.json".text = builtins.toJSON {
        defaultProvider = "ollama";
        model = "qwen3.5:4b";
      };
    }
    // (
      if builtins.pathExists extensionsDir
      then {
        ".pi/agent/extensions" = {
          source = extensionsDir;
          recursive = true;
        };
      }
      else {}
      );
}

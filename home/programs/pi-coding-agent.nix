{
  lib,
  pkgs,
  agent-config,
  pi-theme,
  pi-subagents,
  pi-web-access,
  pi-mcp-adapter,
  ...
}: let
  piWebAccess = pkgs.buildNpmPackage {
    pname = "pi-web-access";
    version = "0.10.6";
    src = pi-web-access;
    npmDepsHash = "sha256-zau3eaJoa8pE3A5COXwyTLSesoePgYqrnRCg3SMSarw=";
    dontNpmBuild = true;
    installPhase = ''
      mkdir -p $out
      cp -r . $out/
    '';
  };

  piMcpAdapter = pkgs.buildNpmPackage {
    pname = "pi-mcp-adapter";
    version = "2.4.0";
    src = pi-mcp-adapter;
    npmDepsHash = "sha256-9P71EDq++Bmez3QDEbOL+PCtCFI2ajxy345stBOBp8k=";
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
    mkdir -p $out/pi-mcp-adapter
    cp -r ${piMcpAdapter}/* $out/pi-mcp-adapter/
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

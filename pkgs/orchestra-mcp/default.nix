{ lib, fetchFromGitHub, python312Packages, runtimeShell }:

let
  py = python312Packages.overrideScope (
    final: prev: {
      cfn-lint = prev.cfn-lint.overridePythonAttrs (_: {
        doCheck = false;
      });
      inquirer = prev.inquirer.overridePythonAttrs (_: {
        doCheck = false;
      });
    }
  );
in
py.buildPythonPackage rec {
  pname = "orchestramcp";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "orchestra-hq";
    repo = "orchestra-mcp";
    rev = "b2cd2e9a6ec00d712478ed451fd70a3bf9c29b46";
    hash = "sha256-JBG/wgMqRavQRJx+lH8NLpC7llLmlyJT8NmjiMK+7yY=";
  };

  pyproject = true;
  nativeBuildInputs = [ py.hatchling ];
  propagatedBuildInputs = with py; [ fastmcp httpx pydantic ];

  pythonImportsCheck = [ "orchestramcp" ];
  doCheck = false;

  postInstall = ''
    mkdir -p $out/bin
    cat > $out/bin/orchestra-mcp <<'EOF'
    #!${runtimeShell}
    exec ${py.python.interpreter}/bin/python -m orchestramcp "$@"
    EOF
    chmod +x $out/bin/orchestra-mcp
  '';

  meta = with lib; {
    description = "MCP server for Orchestra data platform";
    homepage = "https://docs.getorchestra.io/api/mcp";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}

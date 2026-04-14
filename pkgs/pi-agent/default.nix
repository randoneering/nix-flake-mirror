{
  lib,
  buildNpmPackage,
  fetchzip,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
buildNpmPackage (finalAttrs: {
  pname = "pi-agent";
  version = "0.66.1";

  src = fetchzip {
    url = "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-${finalAttrs.version}.tgz";
    hash = "sha256-zEHnHOQXvDzMvhUNXB0k6d5ivyncOapUQCXiXKeMSl8=";
  };

  npmDepsHash = "sha256-/5uGTADF5ce29/+DJJnLZP+EqZjJFh7XzWOyDREy2Uw=";

  strictDeps = true;

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "--version";
  versionCheckKeepEnvironment = ["HOME"];

  meta = {
    description = "Terminal coding agent CLI";
    homepage = "https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent";
    downloadPage = "https://www.npmjs.com/package/@mariozechner/pi-coding-agent";
    license = lib.licenses.mit;
    mainProgram = "pi";
    platforms = lib.platforms.unix;
  };
})

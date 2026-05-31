{pkgs, ...}: {
  imports = [
    ../../home/core.nix
    ../../home/secrets.nix
    ../../home/programs
    ../../home/shell
    ../../home/utils
    ../../home/languages
  ];
}

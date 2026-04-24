{pkgs, ...}: {
  imports = [
    ../../home/core.nix
    ../../home/programs/pi-coding-agent.nix
    ../../home/secrets.nix
    ../../home/programs
    ../../home/shell
    ../../home/utils
    ../../home/languages
  ];
}

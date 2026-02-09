{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./common.nix
    ./terminals.nix
    ./fish.nix
    ./atuin.nix
    ./bash.nix
    ./starship.nix
    ./helix.nix
    ./neovim.nix
  ];
}

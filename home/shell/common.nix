{pkgs, ...}:
# nix tooling
{
  home.packages = with pkgs.unstable; [
    alejandra
    age
    nixpkgs-vet
    nixpkgs-fmt
    nixpkgs-lint
    nixpkgs-pytools
    sops

  ];
}

{ pkgs, ... }:
{

  home.packages = with pkgs.unstable; [
    # utils
    dbeaver-bin
    obsidian
    claude-code
    codex
    opencode
    crush
    tmux
    packer

    # Security
    syft
    grype
    prowler

    # Static Site
    hugo

    # Desktop Customization
    gnome-tweaks
    gnome-extension-manager

    # Social
    discord
    slack
    signal-desktop

    # Office
    onlyoffice-desktopeditors

  ];
}

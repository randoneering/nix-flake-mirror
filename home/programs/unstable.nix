{ pkgs, ... }:
{

  home.packages = with pkgs.unstable; [
    # utils
    dbeaver-bin
    obsidian
    claude-code
<<<<<<< HEAD
    codex
    opencode
    crush
    tmux
    packer
=======
    opencode
    tmux
>>>>>>> f7f4126a54e0a16072183a69dabd64d5f0fda12d

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

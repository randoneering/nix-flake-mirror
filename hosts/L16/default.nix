{
  config,
  pkgs,
  lib,
  username,
  ...
}:
{
  imports = [
    ../../modules/system.nix
    ../../modules/desktop/gnome/gnome.nix
    ../../modules/networking
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Boot
  boot.initrd.luks.devices."luks-f9c32740-0c68-4913-9a0f-d26df56b3aa1".device =
    "/dev/disk/by-uuid/f9c32740-0c68-4913-9a0f-d26df56b3aa1";
  networking.hostName = "nix-l16";
  networking.networkmanager.enable = true;

  # Flox Settings
  nix.settings.trusted-substituters = [
    "https://cache.flox.dev"
  ];
  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "flox-signing:s1KtIMsNrdGeYeLPdzQXDTyXmMbBII1rPVvZgll6dqE="
    "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
  ];
  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Enable Docker Daemon
  virtualisation.docker.enable = true;
  # Enable 32bit
  hardware.graphics.enable32Bit = true;
  # Enable NFS
  boot.supportedFilesystems = [ "nfs" ];
  services.rpcbind.enable = true; # needed for NFS
  fileSystems."/mnt/jellyfin" = {
    device = "nas.randoneering.cloud:/mnt/randoneering_prod/Jellyfin";
    fsType = "nfs";
    options = [
      "x-systemd.automount"
      "noauto"
      "x-systemd.after=network-online.target"
      "x-systemd.mount-timeout=5s"
    ];
  };
  fileSystems."/mnt/nextcloud" = {
    device = "nas.randoneering.cloud:/mnt/randoneering_prod/NextCloud";
    fsType = "nfs";
    options = [
      "x-systemd.automount"
      "noauto"
      "x-systemd.after=network-online.target"
      "x-systemd.mount-timeout=5s"
    ];
  };
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  system.stateVersion = "25.11"; # Did you read the comment?
}

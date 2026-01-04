{
  config,
  pkgs,
  lib,
  username,
  ...
}: {
  imports = [
    ../../modules/system.nix
    ../../modules/desktop/gnome/gnome.nix
    ../../modules/networking
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-24151b73-5cda-4b95-a5b4-0be6cfc4fb42".device = "/dev/disk/by-uuid/24151b73-5cda-4b95-a5b4-0be6cfc4fb42";
  networking.hostName = "nix-l16";
  networking.networkmanager.enable = true;

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
  # Enable 32bit
  hardware.graphics.enable32Bit = true;
  # Enable NFS
  boot.supportedFilesystems = ["nfs"];
  services.rpcbind.enable = true; # needed for NFS
  fileSystems."/mnt/jellyfin" = {
    device = "nas.randoneering.cloud:/mnt/randoneering_prod/Jellyfin";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto" "x-systemd.after=network-online.target" "x-systemd.mount-timeout=5s"];
  };
  fileSystems."/mnt/nextcloud" = {
    device = "nas.randoneering.cloud:/mnt/randoneering_prod/NextCloud";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto" "x-systemd.after=network-online.target" "x-systemd.mount-timeout=5s"];
  };
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  system.stateVersion = "25.11"; # Did you read the comment?
}

{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/system.nix
    ../../modules/desktop/gnome/gnome.nix
    ../../modules/networking
    ../../modules/llm
    ./nvidia_gpu.nix
    ./hardware-configuration.nix
  ];

  # Flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  # Boot
  boot.initrd.luks.devices."luks-4db000c3-1115-45d2-9357-c6e83fdbd853".device = "/dev/disk/by-uuid/4db000c3-1115-45d2-9357-c6e83fdbd853";


 # SWAP
  boot.initrd.luks.devices."luks-1e0ef351-2fad-4271-a4e8-c8ab2a7a41ff".device = "/dev/disk/by-uuid/1e0ef351-2fad-4271-a4e8-c8ab2a7a41ff";


  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
  # Networking
  networking.hostName = "nix-wks";
  networking.networkmanager.enable = true;
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
  fileSystems."/mnt/steam" = {
    device = "/dev/disk/by-partuuid/adaea7d6-aa45-49ed-ba8c-4162bd3ea5e5";
    fsType = "ext4";
    options = ["nofail"];
  };
  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      {
        from = 22;
        to = 22;
      }
      {
        from = 80;
        to = 80;
      }
      {
        from = 443;
        to = 443;
      }
      {
        from = 8080;
        to = 8080;
      }
      {
        from = 11434;
        to = 11434;
      }
    ];
    allowedUDPPortRanges =[
      {
        from = 22;
        to = 22;
      }
      {
        from = 80;
        to = 80;
      }
      {
        from = 443;
        to = 443;
      }
      {
        from = 8080;
        to = 8080;
      }
      {
        from = 11434;
        to = 11434;
      }
    ];
  };

  # Enable Bluetooth
  hardware.bluetooth.enable = true;

  system.stateVersion = "25.05";
}

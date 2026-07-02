{
  config,
  pkgs,
  llama-cpp-src,
  ...
}: let
  llamaCppMaster = (pkgs.unstable.llama-cpp.override {cudaSupport = true;}).overrideAttrs (old: {
    src = llama-cpp-src;
    version = "9600";
    npmDepsHash = "sha256-X1DZgmhS/zHTqDT5zq0kywwntthcJ9vRXeqyO3zz6UU=";
  });
in {
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
  boot.initrd.luks.devices."luks-e795a919-6fdc-42e4-b35d-1ed2eb10e962".device = "/dev/disk/by-uuid/e795a919-6fdc-42e4-b35d-1ed2eb10e962";

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
  systemd.services.NetworkManager-wait-online.enable = false;
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

  services.llama-cpp = {
    enable = true;
    host = "10.10.1.232";
    activeModel = "gemma-4-12b";
    jinja = true;
    threads = 16;
    package = llamaCppMaster;
    models = {
      gemma-4-e4b = {
        alias = "google/gemma-4-e4b";
        modelPath = "/srv/models/gemma-4-E4B-it-UD-Q4_K_XL.gguf";
        contextSize = 128000;
      };
      "gemma-4-12b" = {
        alias = "google/gemma-4-12b";
        modelPath = "/srv/models/gemma-4-12b-it-UD-Q4_K_XL.gguf";
        contextSize = 256000;
      };
      "qwen2.5-coder-7b" = {
        alias = "qwen2.5-coder-7b";
        modelPath = "/srv/models/Qwen2.5-Coder-7B-Instruct-Q6_K.gguf";
        contextSize = 128000;
      };
      "qwen2.5-coder-7b-awq" = {
        alias = "qwen2.5-coder-7b-awq";
        modelPath = "/srv/models/qwen2.5-coder-7b-instruct-q4_k_m.gguf";
        contextSize = 128000;
      };
      "qwen3.5-9b" = {
        alias = "qwen3.5-9b";
        modelPath = "/srv/models/Qwen3.5-9B-UD-Q5_K_XL.gguf";
        contextSize = 131072;
      };
      "qwen2.5-vl-3b" = {
        alias = "qwen2.5-vl-3b";
        modelPath = "/srv/models/Qwen2.5-VL-3B-Instruct-Q8_0.gguf";
        contextSize = 128000;
        extraArgs = [
          "--mmproj"
          "/srv/models/Qwen2.5-VL-3B-mmproj-BF16.gguf"
        ];
      };
    };
    openFirewall = true;
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
      {
        from = 1234;
        to = 1234;
      }
    ];
    allowedUDPPortRanges = [
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
      {
        from = 1234;
        to = 1234;
      }
    ];
  };

  # Enable Bluetooth
  hardware.bluetooth.enable = true;

  system.stateVersion = "25.11";
}

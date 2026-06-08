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
    activeModel = "qwen2.5-coder-7b-awq";
    jinja = true;
    chatTemplate = ''
{%- if tools %}
    {{- '<|im_start|>system\n' }}
    {%- if messages[0]['role'] == 'system' %}
        {{- messages[0]['content'] }}
    {%- else %}
        {{- 'You are Qwen, created by Alibaba Cloud. You are a helpful assistant.' }}
    {%- endif %}
    {{- "\n\n# Tools\n\nYou may call one or more functions to assist with the user query.\n\nYou are provided with function signatures within <tools></tools> XML tags:\n<tools>" }}
    {%- for tool in tools %}
        {{- "\n" }}
        {{- tool | tojson }}
    {%- endfor %}
    {{- "\n</tools>\n\nFor each function call, return a json object with function name and arguments within <tool_call></tool_call> XML tags:\n<tool_call>\n{\"name\": <function-name>, \"arguments\": <args-json-object>}\n</tool_call><|im_end|>\n" }}
{%- else %}
    {%- if messages[0]['role'] == 'system' %}
        {{- '<|im_start|>system\n' + messages[0]['content'] + '<|im_end|>\n' }}
    {%- else %}
        {{- '<|im_start|>system\nYou are Qwen, created by Alibaba Cloud. You are a helpful assistant.<|im_end|>\n' }}
    {%- endif %}
{%- endif %}
{%- for message in messages %}
    {%- if (message.role == "user") or (message.role == "system" and not loop.first) or (message.role == "assistant" and not message.tool_calls) %}
        {{- '<|im_start|>' + message.role + '\n' + message.content + '<|im_end|>' + '\n' }}
    {%- elif message.role == "assistant" %}
        {{- '<|im_start|>' + message.role }}
        {%- if message.content %}
            {{- '\n' + message.content }}
        {%- endif %}
        {%- for tool_call in message.tool_calls %}
            {%- if tool_call.function is defined %}
                {%- set tool_call = tool_call.function %}
            {%- endif %}
            {{- '\n<tool_call>\n{"name": "' }}
            {{- tool_call.name }}
            {{- '", "arguments": ' }}
            {{- tool_call.arguments | tojson }}
            {{- '}\n</tool_call>' }}
        {%- endfor %}
        {{- '<|im_end|>\n' }}
    {%- elif message.role == "tool" %}
        {%- if (loop.index0 == 0) or (messages[loop.index0 - 1].role != "tool") %}
            {{- '<|im_start|>user' }}
        {%- endif %}
        {{- '\n<tool_response>\n' }}
        {{- message.content }}
        {{- '\n</tool_response>' }}
        {%- if loop.last or (messages[loop.index0 + 1].role != "tool") %}
            {{- '<|im_end|>\n' }}
        {%- endif %}
    {%- endif %}
{%- endfor %}
{%- if add_generation_prompt %}
    {{- '<|im_start|>assistant\n' }}
{%- endif %}
'';
    models = {
      gemma-4-e4b = {
        alias = "google/gemma-4-e4b";
        modelPath = "/srv/models/gemma-4-E4B-it-UD-Q4_K_XL.gguf";
        contextSize = 128000;
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

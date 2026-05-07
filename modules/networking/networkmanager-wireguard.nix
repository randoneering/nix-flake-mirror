{...}: {
  # Full-tunnel WireGuard via NetworkManager needs relaxed rpfilter on NixOS.
  networking.firewall.checkReversePath = "loose";

  systemd.services.NetworkManager-prepare-wg0-secret = {
    description = "Prepare runtime environment file for NetworkManager WireGuard secret";
    wantedBy = [ "multi-user.target" ];
    before = [ "NetworkManager-ensure-profiles.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      umask 077
      install -d -m 0700 /run/NetworkManager
      printf 'WG0_PRIVATE_KEY=%s\n' "$(tr -d '\n\r' < /etc/proton-vpn.key)" > /run/NetworkManager/wg0.env
      chmod 0600 /run/NetworkManager/wg0.env
    '';
  };

  networking.networkmanager.ensureProfiles = {
    environmentFiles = [ "/run/NetworkManager/wg0.env" ];

    profiles = {
      wg0 = {
        connection = {
          id = "wg0";
          interface-name = "wg0";
          type = "wireguard";
          autoconnect = false;
        };

        ipv4 = {
          method = "manual";
          address1 = "10.2.0.2/32";
        };

        ipv6 = {
          method = "disabled";
        };

        wireguard = {
          private-key = "$WG0_PRIVATE_KEY";
          private-key-flags = 0;
          listen-port = 51820;
          peer-routes = true;
        };

        "wireguard-peer.xRu4XSIeCCNh4wQqit2w0PwAqzAs7JVA4zQqxGOhSSY=" = {
          endpoint = "79.127.185.222:51820";
          allowed-ips = "0.0.0.0/0;";
          persistent-keepalive = 25;
        };
      };
    };
  };
}

{
  config,
  pkgs,
  ...
}: {
  # https://alberand.com/nixos-wireguard-vpn.html for future edits
  networking.wg-quick.interfaces = let
    server_ip = "79.127.185.222";
  in {
    wg0 = {
      # IP address of this machine in the *tunnel network*
      address = [
        "10.2.0.2/32"
      ];

      # To match firewall allowedUDPPorts (without this wg
      # uses random port numbers).
      listenPort = 51820;

      # Path to the private key file.
      privateKeyFile = "/etc/proton-vpn.key";

      peers = [
        {
          publicKey = "xRu4XSIeCCNh4wQqit2w0PwAqzAs7JVA4zQqxGOhSSY=";
          allowedIPs = ["0.0.0.0/0"];
          endpoint = "${server_ip}:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}

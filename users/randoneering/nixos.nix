{
  hostname,
  username,
  ...
}: {
  users.users.randoneering = {
    isNormalUser = true;
    description = "randoneering";
    extraGroups = ["networkmanager" "wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILNB6q2tqUGgBn8DPeuZZcYh0vV0ay0QdixS2yBMs7LZ justin@randoneering.tech"
    ];
  };
}

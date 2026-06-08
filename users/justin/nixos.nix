{
  hostname,
  username,
  ...
}:
{
  users.users.justin = {
    isNormalUser = true;
    description = "justin";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILNB6q2tqUGgBn8DPeuZZcYh0vV0ay0QdixS2yBMs7LZ justin@randoneering.tech"
    ];
  };
}

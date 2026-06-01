{
  pkgs,
  config,
  username,
  ...
}: {
  programs = {
    firefox = {
      enable = true;
      configPath = ".mozilla/firefox";
      profiles.${username} = {};
    };
    librewolf = {
      enable = true;
      profiles.${username} = {};
    };
  };
}

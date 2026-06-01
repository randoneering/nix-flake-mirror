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
      profiles.${username} = {
        extensions = {
          force = true;
        };
      };
    };
    librewolf = {
      enable = true;
      profiles.${username} = {
        extensions = {
          force = true;
        };
      };
    };
  };
}

{pkgs, ...}: {
  programs.kitty = {
    enable = true;
    package = pkgs.unstable.kitty;
    extraConfig = builtins.readFile "${pkgs.kitty-themes}/share/kitty-themes/themes/tokyo_night_night.conf";
  };
}

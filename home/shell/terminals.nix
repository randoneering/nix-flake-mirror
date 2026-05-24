{pkgs, ...}: {
  programs.ghostty = {
    enable = true;
    package = pkgs.unstable.ghostty;
    settings = {
      theme = "Catppuccin Mocha";
      shell-integration-features = "sudo";
    };
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  programs.kitty = {
    enable = true;
    package = pkgs.unstable.kitty;
    extraConfig = builtins.readFile "${pkgs.kitty-themes}/share/kitty-themes/themes/Catppuccin-Mocha.conf";
  };
}

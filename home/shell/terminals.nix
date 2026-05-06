{pkgs, ...}: {
  programs.ghostty = {
    enable = true;
    package = pkgs.unstable.ghostty;
    settings = {
      theme = "Popping And Locking";
      shell-integration-features = "sudo";
    };
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  programs.kitty = {
    enable = true;
    package = pkgs.unstable.kitty;
    extraConfig = builtins.readFile ./themes/popping-and-locking.conf;
  };
}

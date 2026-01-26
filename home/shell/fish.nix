{config, pkgs, ...}: {
  programs.fish = {
    enable = true;
    package = pkgs.unstable.fish;
    interactiveShellInit = ''
      eval ssh-agent
      export PATH="/home/justin/.local/bin:$PATH"
    '';
  };
}

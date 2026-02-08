{config, pkgs, ...}: {
  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim;
    extraConfig = ''
    '';
  };

  home.packages = with pkgs.unstable; [
    vimPlugins.LazyVim
    lua
  ];

}

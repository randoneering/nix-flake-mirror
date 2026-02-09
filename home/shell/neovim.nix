{config, pkgs, ...}: {


  programs.nvf = {
    enable = true;
    theme = "gruvbox";
    settings = {
      vim.viAlias = false;
      vim.vimAlias = true;
      vim.lsp = {
        enable = true;
      };
    };
  };
}

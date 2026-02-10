{config, pkgs, ...}: {


 programs.nvf = {
   enable = true;
     settings = {

 #Theme
 vim.theme.enable = true;
 vim.theme.name = "dracula";
 vim.theme.style = "dark";
 #
 vim.viAlias = false;
 vim.vimAlias = true;
 vim.lsp = {
  enable = true;
 };
 # Languages
 vim.languages.python.enable = true;
 vim.languages.nix.enable = true;
 vim.languages.sql.enable = true;
 vim.languages.hcl.enable = true;
 vim.languages.yaml.enable = true;
 vim.languages.json.enable = true;

 vim.comments.comment-nvim.enable = true;
 # Plugins
 vim.treesitter.enable = true;
 vim.statusline.lualine.enable = true;
 vim.telescope.enable = true;
 vim.autocomplete.nvim-cmp.enable = true;
 vim.binds.whichKey.enable = true;
   };
  };
}

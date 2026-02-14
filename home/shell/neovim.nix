{...}: {
  programs.nvf = {
    enable = true;
    settings = {
      vim.theme.enable = false;
      vim.additionalRuntimePaths = [./nvim];
      vim.luaConfigPost = ''
        vim.o.termguicolors = true
        vim.cmd.colorscheme("popping_and_locking")
      '';

      vim.viAlias = false;
      vim.vimAlias = true;
      vim.globals.mapleader = " ";

      vim.lsp.enable = true;
      vim.lsp.formatOnSave = true;

      vim.languages.python = {
        enable = true;
        lsp.enable = true;
        lsp.servers = ["basedpyright"];
        format.enable = true;
        format.type = ["ruff"];
      };

      vim.languages.nix = {
        enable = true;
        lsp.enable = true;
        lsp.servers = ["nixd"];
        format.enable = true;
        format.type = ["nixfmt"];
        extraDiagnostics.enable = true;
      };

      vim.languages.sql = {
        enable = true;
        dialect = "postgres";
        lsp.enable = true;
        format.enable = true;
        extraDiagnostics.enable = true;
      };

      vim.languages.hcl = {
        enable = true;
        lsp.enable = true;
        format.enable = true;
      };

      vim.languages.go = {
        enable = true;
        lsp.enable = true;
        format.enable = true;
        format.type = ["gofumpt"];
      };

      vim.languages.rust = {
        enable = true;
        lsp.enable = true;
        format.enable = true;
        format.type = ["rustfmt"];
      };

      vim.languages.yaml = {
        enable = true;
        lsp.enable = true;
      };

      vim.comments.comment-nvim.enable = true;
      vim.git.enable = true;

      vim.autocomplete.enableSharedCmpSources = true;
      vim.autocomplete.blink-cmp.enable = true;
      vim.autocomplete.blink-cmp.friendly-snippets.enable = true;
      vim.autocomplete.blink-cmp.sourcePlugins.emoji.enable = true;
      vim.autocomplete.blink-cmp.sourcePlugins.ripgrep.enable = true;
      vim.autocomplete.blink-cmp.sourcePlugins.spell.enable = true;
      vim.autocomplete.blink-cmp.setupOpts = {
        keymap.preset = "enter";
        completion.documentation.auto_show = true;
        completion.documentation.auto_show_delay_ms = 150;
        sources.default = ["lsp" "path" "snippets" "buffer" "emoji" "ripgrep" "spell"];
      };

      vim.treesitter.enable = true;
      vim.statusline.lualine.enable = true;
      vim.statusline.lualine.setupOpts.options.theme = {
        normal = {
          a = {
            fg = "#181921";
            bg = "#fabd2f";
            gui = "bold";
          };
          b = {
            fg = "#ebdbb2";
            bg = "#1d2021";
          };
          c = {
            fg = "#a89984";
            bg = "#181921";
          };
        };
        insert = {
          a = {
            fg = "#181921";
            bg = "#7ec16e";
            gui = "bold";
          };
        };
      };
      vim.telescope.enable = true;
      vim.binds.whichKey.enable = true;
      vim.utility.snacks-nvim.enable = true;
    };
  };
}

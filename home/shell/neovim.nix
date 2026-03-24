{ pkgs, ... }:
{
  programs.nvf = {
    enable = true;
    settings = {
      vim.theme.enable = false;
      vim.additionalRuntimePaths = [ ./nvim ];
      vim.luaConfigPost = ''
        vim.o.termguicolors = true
        vim.cmd.colorscheme("popping_and_locking")

        local palette = {
          bg = "#181921",
          bg_alt = "#1d2021",
          fg = "#ebdbb2",
          muted = "#a89984",
          gray = "#928374",
          red_bright = "#f42c3e",
          yellow_bright = "#fabd2f",
          blue = "#458588",
          blue_bright = "#99c6ca",
          cyan_bright = "#7ec16e",
        }

        local hl = function(group, opts)
          vim.api.nvim_set_hl(0, group, opts)
        end

        hl("SnacksDashboardNormal", { fg = palette.fg, bg = palette.bg })
        hl("SnacksDashboardHeader", { fg = palette.yellow_bright, bold = true })
        hl("SnacksDashboardTitle", { fg = palette.blue_bright, bold = true })
        hl("SnacksDashboardDesc", { fg = palette.muted })
        hl("SnacksDashboardIcon", { fg = palette.cyan_bright })
        hl("SnacksDashboardKey", { fg = palette.yellow_bright, bold = true })
        hl("SnacksDashboardFile", { fg = palette.fg })
        hl("SnacksDashboardDir", { fg = palette.gray })
        hl("SnacksDashboardFooter", { fg = palette.blue })
        hl("SnacksDashboardSpecial", { fg = palette.red_bright })
      '';

      vim.viAlias = false;
      vim.vimAlias = true;
      vim.globals.mapleader = " ";
      vim.extraPackages = with pkgs; [
        alejandra
        gofumpt
        nodePackages.prettier
        pgformatter
        ruff
        rustfmt
        terraform
      ];

      vim.spellcheck.enable = true;
      vim.lsp.enable = true;
      vim.lsp.formatOnSave = false;

      vim.formatter.conform-nvim = {
        enable = true;
        setupOpts = {
          format_on_save = {
            lsp_format = "fallback";
            timeout_ms = 500;
          };
          formatters_by_ft = {
            go = [ "gofumpt" ];
            hcl = [ "terraform_fmt" ];
            nix = [ "alejandra" ];
            python = [ "ruff_format" ];
            rust = [ "rustfmt" ];
            sql = [ "pg_format" ];
            terraform = [ "terraform_fmt" ];
            tfvars = [ "terraform_fmt" ];
            yaml = [ "prettier" ];
          };
        };
      };

      vim.languages.python = {
        enable = true;
        lsp.enable = true;
        lsp.servers = [ "basedpyright" ];
        format.enable = false;
      };

      vim.languages.nix = {
        enable = true;
        lsp.enable = true;
        lsp.servers = [ "nixd" ];
        format.enable = false;
        extraDiagnostics.enable = true;
      };

      vim.languages.sql = {
        enable = true;
        dialect = "postgres";
        lsp.enable = true;
        format.enable = false;
        extraDiagnostics.enable = true;
      };

      vim.languages.hcl = {
        enable = true;
        lsp.enable = true;
        format.enable = false;
      };

      vim.languages.go = {
        enable = true;
        lsp.enable = true;
        format.enable = false;
      };

      vim.languages.rust = {
        enable = true;
        lsp.enable = true;
        format.enable = false;
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
        sources.default = [
          "lsp"
          "path"
          "snippets"
          "buffer"
          "emoji"
          "ripgrep"
          "spell"
        ];
      };

      vim.snippets.luasnip = {
        enable = true;
        providers = [ "friendly-snippets" ];
        setupOpts.enable_autosnippets = true;
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
      vim.utility.snacks-nvim = {
        enable = true;
        setupOpts = {
          dashboard = {
            enabled = true;
            sections = [
              { section = "header"; }
              {
                section = "keys";
                gap = 1;
                padding = 1;
              }
            ];
          };
          notifier = {
            enabled = true;
            timeout = 3000;
          };
        };
      };
    };
  };
}

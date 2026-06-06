{ lib, pkgs, ... }:
{
  programs.nvf = {
    enable = true;
    settings = {
      vim.theme.enable = false;
      vim.additionalRuntimePaths = [ ./nvim ];
      vim.luaConfigPost = let
        headerContent = builtins.readFile ./nvim/dashboard-header.lua;
      in ''
        vim.o.termguicolors = true
        vim.cmd.colorscheme("tokyonight")

        local palette = {
          bg = "#1a1b26",
          bg_alt = "#16161e",
          fg = "#a9b1d6",
          muted = "#565f89",
          gray = "#565f89",
          red_bright = "#f7768e",
          yellow_bright = "#e0af68",
          blue = "#7aa2f7",
          blue_bright = "#bb9af7",
          cyan_bright = "#7dcfff",
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

        do
          local d = require("snacks").config.dashboard
          d.preset = d.preset or {}
          d.preset.header = ${headerContent}
        end
      '';

      vim.viAlias = false;
      vim.vimAlias = true;
      vim.globals.mapleader = " ";
      vim.extraPackages = with pkgs; [
        alejandra
        gofumpt
        prettier
        pgformatter
        ruff
        rustfmt
        terraform
      ];

      vim.spellcheck.enable = true;
      vim.lsp.enable = true;
      vim.lsp.formatOnSave = false;
      vim.lsp.servers.sqls.on_attach = lib.mkForce (lib.generators.mkLuaInline ''
        function(client, bufnr)
          client.server_capabilities.execute_command = true
        end
      '');

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
      vim.extraPlugins = {
        tokyonight = {
          package = pkgs.vimPlugins.tokyonight-nvim;
          setup = "require('tokyonight').setup({ style = 'night' })";
        };
        telescope-luasnip = {
          package = pkgs.vimUtils.buildVimPlugin {
            pname = "telescope-luasnip.nvim";
            version = "2022-09-18";
            src = pkgs.fetchFromGitHub {
              owner = "benfowler";
              repo = "telescope-luasnip.nvim";
              rev = "07a2a2936a7557404c782dba021ac0a03165b343";
              sha256 = "0wvp334pwrn5q81ynq6af37fg1b1r8k8ji9fzdm4xdz32gd1ayzm";
            };
          };
        };
      };

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
            fg = "#1a1b26";
            bg = "#7aa2f7";
            gui = "bold";
          };
          b = {
            fg = "#a9b1d6";
            bg = "#16161e";
          };
          c = {
            fg = "#565f89";
            bg = "#1a1b26";
          };
        };
        insert = {
          a = {
            fg = "#1a1b26";
            bg = "#9ece6a";
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

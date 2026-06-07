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
        pi-nvim = {
          package = pkgs.vimUtils.buildVimPlugin {
            pname = "pi-nvim";
            version = "2026-06-06";
            src = pkgs.fetchFromGitHub {
              owner = "pablopunk";
              repo = "pi.nvim";
              rev = "4ba6db0dd30406995a2e46e4f1ae39377e66e733";
              sha256 = "sha256-z1gN1TKQKrM8dMh8rQMaAtGgi4ELV21WgswJBVyXulE=";
            };
          };
        };
        smear-cursor = {
          package = pkgs.vimUtils.buildVimPlugin {
            pname = "smear-cursor.nvim";
            version = "2026-06-06";
            src = pkgs.fetchFromGitHub {
              owner = "sphamba";
              repo = "smear-cursor.nvim";
              rev = "9e9378d6ee34bb3782e0e8c63d9ec8ca618b479b";
              sha256 = "sha256-hL0lXzkFxR7qiXzStrmY+gR+ql/A6PR8eCV310gEaGs=";
            };
          };
          setup = "require('smear_cursor').setup {}";
        };
      };

      vim.treesitter.enable = true;

      vim.snippets.luasnip = {
        enable = true;
        providers = [ "friendly-snippets" ];
        setupOpts.enable_autosnippets = true;
      };

      vim.autocomplete.blink-cmp = {
        enable = true;
        friendly-snippets.enable = true;
      };

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
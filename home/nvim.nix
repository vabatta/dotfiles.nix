{ lib, pkgs, ... }:
let
  mini = import ./nvim/mini.nix { inherit lib; };
  events = import ./nvim/events.nix { inherit lib; };
  keymaps = import ./nvim/keymaps.nix { inherit lib; };
  options = import ./nvim/options.nix { inherit lib; };
  codecompanion = import ./nvim/codecompanion.nix { inherit lib; };
in
{
  programs.nvf = {
    enable = true;

    settings = {
      vim.extraPlugins = {
        catppuccin = {
          package = pkgs.vimPlugins.catppuccin-nvim;
          setup = ''
            require('catppuccin').setup {
              flavour = "auto", -- latte, frappe, macchiato, mocha
              background = { -- :h background
                light = "latte",
                dark = "mocha",
              },
              integrations = {
                native_lsp = true,
                treesitter = true,
                treesitter_context = true,
                mini = true,
              },
              highlight_overrides = {
                all = function(colors)
                  return {
                    MiniHipatternsFixme = { bg = colors.none, fg = colors.red, style = { "bold" } },
                    MiniHipatternsHack = { bg = colors.none, fg = colors.maroon, style = { "bold" } },
                    MiniHipatternsTodo = { bg = colors.none, fg = colors.sky, style = { "bold" } },
                    MiniHipatternsNote = { bg = colors.none, fg = colors.yellow, style = { "bold" } },
                    MiniHipatternsReview = { bg = colors.none, fg = colors.green, style = { "bold" } },
                    MiniHipatternsSection = { bg = colors.none, fg = colors.mauve, style = { "bold" } },
                  }
                end,
              },
            }
            vim.cmd.colorscheme "catppuccin"
          '';
        };
        render-markdown = {
          package = pkgs.vimPlugins.render-markdown-nvim;
          setup = ''
            require('render-markdown').setup {}
          '';
        };
        mini-input = {
          package = pkgs.vimPlugins.mini-nvim;
          setup = ''
            require('mini.input').setup {}
            -- route Neovim's vim.ui.input (SmartShift places, SPC f n / f s)
            -- through mini.input for a consistent styled prompt
            vim.ui.input = function(opts, on_confirm)
              opts = vim.tbl_deep_extend('force', { prompt = " " }, opts or {})
              opts.prompt = " ➤ " .. opts.prompt .. " "
              return MiniInput.input(opts, on_confirm)
            end
          '';
        };
      };

      # mini.nvim
      vim.mini = mini;

      vim.options = options;
      vim.augroups = events.augroups;
      vim.autocmds = events.autocmds;
      vim.keymaps = keymaps;

      vim.viAlias = false;
      vim.vimAlias = true;

      vim.assistant.codecompanion-nvim = codecompanion;

      vim.lsp.enable = true;
      vim.languages.enableFormat = true;
      vim.languages.enableTreesitter = true;
      vim.languages.enableExtraDiagnostics = true;

      vim.languages.html = {
        enable = true;
      };
      vim.languages.yaml = {
        enable = true;
      };
      vim.languages.markdown = {
        enable = true;
      };
      vim.languages.nix = {
        enable = true;
        format.type = [ "nixfmt" ];
      };
      vim.languages.bash = {
        enable = true;
      };
      vim.languages.lua = {
        enable = true;
      };
      vim.languages.go = {
        enable = true;
      };
      vim.languages.typescript = {
        enable = true;
        format.type = [ "biome" ];
        extensions.ts-error-translator.enable = true;
      };
    };
  };
}

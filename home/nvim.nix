{ pkgs, lib, ... }:
let
  events = import ./nvim/events.nix { inherit lib; };
in
{
  programs.nvf = {
    enable = true;

    settings = {
      vim.startPlugins = [
        "catppuccin"
      ];

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
      };

      # mini.nvim
      vim.mini = import ./nvim/mini.nix { };

      vim.options = import ./nvim/options.nix { };
      vim.augroups = events.augroups;
      vim.autocmds = events.autocmds;

      vim.viAlias = false;
      vim.vimAlias = true;

      vim.lsp.enable = true;
      vim.languages.enableFormat = true;
      vim.languages.enableTreesitter = true;
      vim.languages.enableExtraDiagnostics = true;

      vim.languages.nix = {
        enable = true;
        format.type = "nixfmt";
      };
      vim.languages.bash = {
        enable = true;
        format.type = "shfmt";
      };
      vim.languages.lua = {
        enable = true;
        format.type = "stylua";
      };
      vim.languages.go = {
        enable = true;
        format.type = "gofmt";
      };
      vim.languages.ts = {
        enable = true;
        format.type = "biome";
      };
    };
  };
}

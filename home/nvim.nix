{ pkgs, lib, ... }:
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
            }
            vim.cmd.colorscheme "catppuccin"
          '';
        };
      };

      vim.augroups = [
        {
          name = "LineNumbersToggle";
          clear = true;
        }
      ];

      vim.autocmds = [
        {
          desc = "Enable relative numbers in normal mode";
          group = "LineNumbersToggle";
          event = [
            "InsertLeave"
          ];
          pattern = [ "*" ];
          callback = lib.generators.mkLuaInline ''
            function()
              vim.wo.relativenumber = true
            end
          '';
        }

        {
          desc = "Enable absolute numbers in insert mode";
          group = "LineNumbersToggle";
          event = [
            "InsertEnter"
          ];
          pattern = [ "*" ];
          callback = lib.generators.mkLuaInline ''
            function()
              vim.wo.relativenumber = false
            end
          '';
        }
      ];

      vim.viAlias = false;
      vim.vimAlias = true;
      vim.lsp = {
        enable = true;
      };

      vim.languages.nix = {
        enable = true;
        format.enable = true;
        format.type = "nixfmt";
      };
    };
  };
}

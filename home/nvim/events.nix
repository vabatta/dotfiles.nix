{ lib, ... }:
{
  augroups = [
    {
      name = "LineNumbersToggle";
      clear = true;
    }
  ];

  autocmds = [
    {
      desc = "Enable relative numbers in normal mode";
      group = "LineNumbersToggle";
      event = [ "InsertLeave" ];
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
      event = [ "InsertEnter" ];
      pattern = [ "*" ];
      callback = lib.generators.mkLuaInline ''
        function()
          vim.wo.relativenumber = false
        end
      '';
    }
  ];
}

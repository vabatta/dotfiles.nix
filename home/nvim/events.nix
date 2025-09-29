{ lib, ... }:
{
  augroups = [
    {
      name = "ColorSchemeSync";
      clear = true;
    }

    {
      name = "LineNumbersToggle";
      clear = true;
    }
  ];

  autocmds = [
    {
      desc = "Synchronise HL groups to custom groups";
      group = "ColorSchemeSync";
      event = [ "ColorScheme" ];
      pattern = [ "*" ];
      callback = lib.generators.mkLuaInline ''
        function()
          vim.cmd [[hi! link Todo MiniHipatternsTodo]] -- Make HL Todo use MiniHipatternsTodo
        end
      '';
    }

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
